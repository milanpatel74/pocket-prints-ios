//
//  Downloader.h
//  UrbanDrum
//
//  Created by Minh Quan on 17/11/12.
//
//

#import <Foundation/Foundation.h>
#import "DownloadRequest.h"

@interface Downloader : NSObject <NSURLConnectionDelegate>{

}



#define DownloaderFinishedDownloadURL     @"DownloaderFinishDownloadURL"

-(void) addRequest:(DownloadRequest*) aRequest;
-(void) removeRequest:(DownloadRequest*) aRequest;

+(Downloader*) sharedDownloader;

-(void) downloadURL:(NSString*) aURL
 andCompletionBlock:(DownloaderCompletionBlock)
aCompletionBlock andFailureBlock:(DownloaderFailureBlock) aFailureBlock;

-(void) downloadWithCacheURL:(NSString*) aURL allowThumb:(BOOL) allowThumb
          andCompletionBlock:(DownloaderCompletionBlock)
aCompletionBlock andFailureBlock:(DownloaderFailureBlock) aFailureBlock;

+(NSString*) storagePathForURL:(NSString*) aURL;
-(void) removeCacheForURL:(NSString*)aURL;
@end
