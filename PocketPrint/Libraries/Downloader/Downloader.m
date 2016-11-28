//
//  Downloader.m
//  UrbanDrum
//
//  Created by Minh Quan on 17/11/12.
//
//

#import "Downloader.h"
#import "MD5.h"

@interface Downloader ()

@property   (strong) NSMutableArray  *arrRequests, *arrQueues, *arrData;

@end

@implementation Downloader

@synthesize arrData;
@synthesize arrQueues;
@synthesize arrRequests;

SYNTHESIZE_SINGLETON_FOR_CLASS(Downloader)

#define MAX_CONCURRENT_DOWNLOAD     1
#define STORAGE_PATH    PATH_CACHE_PHOTO //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define PATH_CONCAT(folder, file)    [folder stringByAppendingFormat:@"/%@",file]

-(id) init {
    self = [super init];
    if (self) {
        self.self.arrRequests = [[NSMutableArray alloc] init];
        // allow 10 queues
        self.self.arrQueues = [[NSMutableArray alloc] init];
        self.self.arrData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) go {
    @synchronized(self.arrQueues) {
        @synchronized(self.arrRequests) {
            for (int i = 0; i <self.arrRequests.count ; i++) {
                //DLog(@"verify on queue %d",dispatch_get_current_queue());
                DownloadRequest *aRequest = [self.arrRequests objectAtIndex:i];
                //verify if there is a connection handling this request
                BOOL isProcessing = NO;
                for (int j=0; j < self.arrQueues.count; j++) {
                    NSURLConnection *connection = [self.arrQueues objectAtIndex:j];
                    if ([aRequest.url isEqualToString:[connection.originalRequest.URL absoluteString]]) {
                        isProcessing = YES;
                        break;
                    }
                }
                
                // processing ?
                if (isProcessing) {
                    continue;
                }
                
                // not yet being processed ?
                
                // verify priority
                
                if (self.arrQueues.count >= MAX_CONCURRENT_DOWNLOAD && aRequest.priority < DOWNLOAD_PRIORITY_AS_SOON_AS_POSSIBLE) {
                    // next one
                    continue;
                }
                
                // okie now you are free to go
                
                // check if cache
                if (!aRequest.allowForceRedownload) {
                    // check cache now
                    NSFileManager   *fileMan = [NSFileManager defaultManager];
                    NSString    *fileURL = PATH_CONCAT(STORAGE_PATH, [aRequest.url md5]);
                    if ([fileMan fileExistsAtPath:fileURL]) {
                        aRequest.completed = YES;
                        aRequest.completedPath = fileURL;
                        //call block now
                        if (aRequest.completionBlock) {
                            
                            if ([fileMan fileExistsAtPath:[fileURL stringByAppendingString:@"_thumb"]] && aRequest.getThumbOnly) {
                                aRequest.completionBlock([NSData dataWithContentsOfFile:[fileURL stringByAppendingString:@"_thumb"]]);
                            }
                            else
                                aRequest.completionBlock([NSData dataWithContentsOfFile:fileURL]);
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderFinishedDownloadURL object:aRequest.completedPath];
                        //remove request
                        //[self.arrRequests removeObjectAtIndex:i];
                        [self.arrRequests removeObject:aRequest];
                        // next request ?
                        continue;
                    }
                }
                
                if (!aRequest.url || [aRequest.url isKindOfClass:[NSNull class]]) {
                    aRequest.completed = YES;
                    aRequest.completedPath = nil;
                    //call block now
                    if (aRequest.failureBlock) {
                        NSError *error;
                        aRequest.failureBlock(error);
                    }
                    //remove request
                    [self.arrRequests removeObjectAtIndex:i];
                    // next request ?
                    continue;
                }
                
                // now we start to download
                
                //open new queue
                DLog(@"=====>>>>> start connection for %@ at point %d",aRequest.url,self.arrQueues.count);
                //NSURLRequest    *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:aRequest.url]];
                NSURLRequest    *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:aRequest.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:aRequest.timeout];
                DLog(@"time out = %.1f",[urlRequest timeoutInterval]);
                __block NSURLConnection *urlConection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                                        delegate:self startImmediately:NO];;
                
                [self.arrQueues addObject:urlConection];
                RUN_ON_MAIN_QUEUE(^{
                    [urlConection start];
                });
            }

        }
    }
}

#pragma mark methods
-(void) downloadURL:(NSString*) aURL
 andCompletionBlock:(DownloaderCompletionBlock)
aCompletionBlock andFailureBlock:(DownloaderFailureBlock) aFailureBlock {
    if (!aURL || [aURL isKindOfClass:[NSNull class]]) {
        DLog(@"NULL url found => dont donwload");
        return;
    }
    DownloadRequest *request = [DownloadRequest requestWithURL:aURL andCompletionBlock:aCompletionBlock andFailureBlock:aFailureBlock];
    request.priority = DOWNLOAD_PRIORITY_HIGH;
    [request go];
}

-(void) downloadWithCacheURL:(NSString*) aURL allowThumb:(BOOL) allowThumb
          andCompletionBlock:(DownloaderCompletionBlock)
aCompletionBlock andFailureBlock:(DownloaderFailureBlock) aFailureBlock {
    if (!aURL || [aURL isKindOfClass:[NSNull class]]) {
        DLog(@"NULL url found => dont donwload");
        return;
    }
     DownloadRequest *request = [DownloadRequest requestWithURL:aURL andCompletionBlock:aCompletionBlock andFailureBlock:aFailureBlock];
    request.priority = DOWNLOAD_PRIORITY_HIGH;
    request.allowCached = YES;
    request.getThumbOnly = allowThumb;
    [request go];
    
}

+(NSString*) storagePathForURL:(NSString*) aURL {
    return PATH_CONCAT(STORAGE_PATH, [aURL md5]);
}

-(void) addRequest:(DownloadRequest*) aRequest {

    BOOL isExisted = NO;
    @synchronized (self.arrRequests) {
        for (int i=0; i < self.arrRequests.count; i++) {
            DownloadRequest *mRequest = [self.arrRequests objectAtIndex:i];
            if ([mRequest.requestId isEqualToString:aRequest.requestId]) {
                isExisted = YES;
                break;
            }
        }
        
        if (isExisted) {
            DLog(@"THE REQUEST WITH INFO %@ IS ALREADY IN QUEUE",aRequest.description);
            return;
        }
        
        [self.arrRequests addObject:aRequest];
    }
    // go!
    [self go];

}


-(void) removeRequest:(DownloadRequest*) aRequest {
    @synchronized(self.arrQueues) {
        // force close connection
        for (int i = 0; i< self.arrQueues.count; i++) {
            NSURLConnection *connection = [self.arrQueues objectAtIndex:i];
            if ([[connection.originalRequest.URL absoluteString] isEqualToString:aRequest.url]) {
                // remove
                [connection cancel];
                [self.arrQueues removeObjectAtIndex:i];
                break;
            }
        }
    }

}

-(void) removeCacheForURL:(NSString*)aURL {
    NSString *cachePath = [STORAGE_PATH stringByAppendingFormat:@"/%@",[aURL md5]];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
    if (error) {
        DLog(@"Fail to remove cache for %@",error.debugDescription);
    }
}
#pragma mark url connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     
    NSMutableData   *receivedData;
    BOOL isExisted = NO;
    @synchronized (self.arrData) {
        for (int i =0; i < self.arrData.count; i++) {
            NSDictionary    *dict = [self.arrData objectAtIndex:i];
            if ([[dict objectForKey:@"url"] isEqualToString:[connection.originalRequest.URL absoluteString]]) {
                receivedData = [dict objectForKey:@"data"];
                isExisted = YES;
                break;
            }
        }
        if (!isExisted) {
            receivedData = [[NSMutableData alloc] init];
            NSDictionary    *dict = [NSDictionary dictionaryWithObjectsAndKeys:[connection.originalRequest.URL absoluteString],@"url",receivedData,@"data", nil];
            [self.arrData addObject:dict];
            
        }
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData   *receivedData;
    // seek for URL
    @synchronized(self.arrData) {
        for (int i =0; i < self.arrData.count; i++) {
            NSDictionary    *dict = [self.arrData objectAtIndex:i];
            if ([[dict objectForKey:@"url"] isEqualToString:[connection.originalRequest.URL absoluteString]]) {
                receivedData = [dict objectForKey:@"data"];
                break;
            }
        }
        
        [receivedData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"Downloader FAIL => %@",error.debugDescription);
    // seek for URL
    @synchronized (self.arrRequests) {
        @synchronized (self.arrData) {
            @synchronized (self.arrRequests) {
                for (int i =self.arrQueues.count-1; i >=0 ; i--) {
                    NSURLConnection *conn = [self.arrQueues objectAtIndex:i];
                    //NSDictionary    *dict = [self.arrData objectAtIndex:i];
                    if ([[conn.originalRequest.URL absoluteString] isEqualToString:[connection.originalRequest.URL absoluteString]]) {
                        //receivedData = [dict objectForKey:@"data"];
                        
                        // notify completion block call for all requests
                        
                        for (int j = self.arrRequests.count-1; j >=1; j--) {
                            DownloadRequest     *request = [self.arrRequests objectAtIndex:j];
                            if ([request.url isEqualToString:[conn.originalRequest.URL absoluteString]]) {
                                // config return request
                                request.completed = YES;
                                
                                // invoke
                                if (request.failureBlock) {
                                    request.failureBlock(error);
                                }
                                
                                // remove this download request
                                [self.arrRequests removeObjectAtIndex:j];
                            }
                        }
                        //remove connection
                        [self.arrQueues removeObject:connection];
                        // remove data
                        //[self.arrData removeObjectAtIndex:i];
                        break;
                    }
                }
            }
        }
    }


    DLog(@"F==> CURRENT QUEUE = %d Reuqest = %d data = %d",self.arrQueues.count,self.arrRequests.count,self.arrData.count);
    
    // go for next request
    [self go];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSMutableData   *receivedData;
    // seek for URL

    @synchronized(self.arrRequests) {
        @synchronized(self.arrData) {
            for (int i =self.arrData.count-1; i >=0 ; i--) {
                __block NSDictionary    *dict = [self.arrData objectAtIndex:i];
                if ([[dict objectForKey:@"url"] isEqualToString:[connection.originalRequest.URL absoluteString]]) {
                    receivedData = [dict objectForKey:@"data"];
                    //DLog("==>URL = %@",[dict objectForKey:@"url"]);
                    // notify completion block call for all requests
                    
                    for (int j = self.arrRequests.count-1; j >=0; j--) {
                        DownloadRequest     *request = [self.arrRequests objectAtIndex:j];
                        //DLog(@"Request URL =%@",request.url);
                        if ([request.url isEqualToString:[dict objectForKey:@"url"]]) {
                            // config return request
                            request.completed = YES;
                            
                            if (request.allowCached) {
                                // cached now
                                __block DownloadRequest *cRequest = request;
                                __block NSMutableData *cReceivedData = receivedData;
                                dispatch_async(dispatch_get_global_queue([self convertPriority:request.priority], 0), ^{
                                    cRequest.completedPath = [STORAGE_PATH stringByAppendingFormat:@"/%@",[cRequest.url md5]];
                                    [cReceivedData writeToFile:cRequest.completedPath atomically:YES];
                                    if (dict) {
                                        @try {
                                            [self.arrData removeObject:dict];
                                        }
                                        @catch (NSException *exception) {
                                            NSLog(@"Exception => %@",exception.debugDescription);
                                        }
                                        @finally {
                                            NSLog(@"Downloader encounted a problem with data %@ ",[dict objectForKey:@"url"]);
                                        }
                                        
                                    }
                                    
                                    DLog(@"Dowloader remain data count %d and WRITE FILE successful at Path %@",self.arrData.count,cRequest.completedPath);
                                    // notify finish via notification
                                    [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderFinishedDownloadURL object:cRequest.completedPath];
                                });
                                
                            }
                            
                            // invoke
                            if (request.completionBlock) {
                                request.completionBlock(receivedData);
                            }
                            
                            // remove this download request
                            [self.arrRequests removeObjectAtIndex:j];
                        }
                    }
                    //remove connection
                    [self.arrQueues removeObject:connection];
                    // remove data
                    //[self.arrData removeObjectAtIndex:i];
                    
                    break;
                }
            }
        }
    }

    DLog(@"S==> CURRENT QUEUE = %d Reuqest = %d data =%d",self.arrQueues.count,self.arrRequests.count,self.arrData.count);
    
    [self go];

}

#pragma mark utility
-(dispatch_queue_priority_t) convertPriority:(DOWNLOAD_PRIORITY) aPriorty {
    switch (aPriorty) {
        case DOWNLOAD_PRIORITY_NONE:
            return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
            break;
        case DOWNLOAD_PRIORITY_LOW:
            return DISPATCH_QUEUE_PRIORITY_LOW;
            break;
        case DOWNLOAD_PRIORITY_HIGH:
            return DISPATCH_QUEUE_PRIORITY_DEFAULT;
            break;
        case DOWNLOAD_PRIORITY_AS_SOON_AS_POSSIBLE:
            return DISPATCH_QUEUE_PRIORITY_HIGH;
            break;
    }
}
@end
