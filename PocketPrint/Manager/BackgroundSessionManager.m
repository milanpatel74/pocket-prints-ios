//
//  BackgroundSessionManager.m
//  PocketPrint
//
//  Created by Quan Do on 1/12/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "BackgroundSessionManager.h"

static FailBlock onFailBlock;
static DoneBlock onDoneBlock;

static NSString * const kBackgroundSessionIdentifier = @"com.domain.backgroundsession";

@implementation BackgroundSessionManager

//+ (instancetype)sharedManager
//{
//    static id sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//    });
//    return sharedMyManager;
//}

- (instancetype)init
{
    NSDateFormatter *formater = [NSDateFormatter new];
    [formater setDateFormat:@"hhmmssSSS"];
    NSString *sessionId = [NSString stringWithFormat:@"%@%@",kBackgroundSessionIdentifier,[formater stringFromDate:[NSDate date]]];
    NSURLSessionConfiguration *configuration;
    if ([NSURLSessionConfiguration respondsToSelector:@selector(backgroundSessionConfigurationWithIdentifier:)]) {
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionId];
    }
    else
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:sessionId];
    
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        [self configureDownloadFinished];            // when download done, save file
        [self configureBackgroundSessionFinished];   // when entire background session done, call completion handler
        [self configureAuthentication];              // my server uses authentication, so let's handle that; if you don't use authentication challenges, you can remove this
    }
    return self;
}

- (void)configureDownloadFinished
{
    // just save the downloaded file to documents folder using filename from URL
    [self setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
//        NSString *filename      = [downloadTask.originalRequest.URL lastPathComponent];
//        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        
//        
//        NSDateFormatter *dateFormater = [NSDateFormatter new];
//        [dateFormater setDateFormat:@"dd-MM-yyyy-hh-mm-ss-SSS"];
//        NSString *path          = [documentsPath stringByAppendingPathComponent:[dateFormater stringFromDate:[NSDate date]]];
        DLog(@"THE FILE HAS BEEN SAVE TO %@",location);
        onDoneBlock(nil,[NSData dataWithContentsOfURL:location]);
        return nil;
    }];
    
}

- (void)configureBackgroundSessionFinished
{
    typeof(self) __weak weakSelf = self;
    
    [self setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        if (weakSelf.savedCompletionHandler) {
            weakSelf.savedCompletionHandler();
            weakSelf.savedCompletionHandler = nil;
            DLog(@"END OF BACKGRUOND SESSSION");
            
            //[[Uploader shared] start];
        }
    }];
}

- (void)configureAuthentication
{
    //[self set]
}

+(void) uploadURL:(NSURLRequest*) urlRequest onFail:(void (^)(NSError* error)) aFailBlock onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    NSURLSessionDownloadTask *downloadTask = [[[BackgroundSessionManager alloc] init] downloadTaskWithRequest:urlRequest progress:nil destination:nil completionHandler:nil];
    [downloadTask resume];
    
    // add to array
    onDoneBlock = aDoneBlock;
    onFailBlock = aFailBlock;
}
@end
