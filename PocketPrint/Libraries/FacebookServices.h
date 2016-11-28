//
//  FacebookServices.h
//  AuSkill
//
//  Created by Minh Quan on 28/10/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookServices : NSObject <FBLoginViewDelegate> {
    FBLoginView *loginview;
}

+(FacebookServices*) sharedFacebookServices;

-(void) login;
-(BOOL) isLogin;
-(void) getPhotoAlbumsOnFail:(void (^)(NSError* error)) aFailBlock
                      onDone:(void (^)(id obj)) aDoneBlock;;
-(void) getAlbumCoverWithAlbumId:(NSString*) albumId
                          onFail:(void (^)(NSError* error)) aFailBlock
                          onDone:(void (^)(id obj)) aDoneBlock;

-(void) getPhotosOfAlbumWithAlbumId:(NSString*) albumId
                          onFail:(void (^)(NSError* error)) aFailBlock
                          onDone:(void (^)(id obj)) aDoneBlock;;

-(void) shareFacebookWithMessage:(NSString*) aMessage
                             onFail:(void (^)(NSError* error)) aFailBlock
                             onDone:(void (^)(id obj)) aDoneBlock;;
-(NSDictionary*) getAlbumCoverSyncWithAlbumId:(NSString *)albumId;



@end
