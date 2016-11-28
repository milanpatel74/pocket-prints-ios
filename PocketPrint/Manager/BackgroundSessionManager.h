//
//  BackgroundSessionManager.h
//  PocketPrint
//
//  Created by Quan Do on 1/12/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^FailBlock)(NSError* error) ;
typedef void(^DoneBlock)(NSError* error, id obj);

@interface BackgroundSessionManager : AFHTTPSessionManager {
    NSMutableArray *arrTasks;

}
//+ (instancetype)sharedManager;

@property (nonatomic, copy) void (^savedCompletionHandler)(void);

+(void) uploadURL:(NSURLRequest*) urlRequest onFail:(void (^)(NSError* error)) aFailBlock onDone:(void (^)(NSError* error, id obj)) aDoneBlock;
@end
