//
//  FacebookServices.m
//  AuSkill
//
//  Created by Minh Quan on 28/10/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import "FacebookServices.h"
#import <CoreLocation/CoreLocation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


//#import "GAIDictionaryBuilder.h"

@implementation FacebookServices 

SYNTHESIZE_SINGLETON_FOR_CLASS(FacebookServices)

-(void) login {

//    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        [self sessionStateChanged:session state:status error:error];
//    }];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    // Process error
                } else if (result.isCancelled) {
                    // Handle cancellations
                } else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
//                    if ([result.grantedPermissions containsObject:@"email"]) {
//                        // Do work
//                    }
                    
                    
                    if ([result grantedPermissions])
                    {
                       [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFbLogin object:nil userInfo:nil];
                    }
                }
        
        NSLog(@"Granted Perm: %@ Declined Perm: %@",[result grantedPermissions],[result declinedPermissions]);
        NSLog(@"%@",result);
       NSLog(@"%@",[FBSDKAccessToken currentAccessToken]);
        
    }];

    
//    [FBSession openActiveSessionWithReadPermissions:@[@"email",@"publish_stream",@"user_photos"]
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session,
//       FBSessionState state, NSError *error) {
//         [self sessionStateChanged:session state:state error:error];
//     }];
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
            //[self.delegate facebookLoginSuccess];
            // post notification
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFbLogin object:nil userInfo:nil];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"We have a problem accessing your Facebook account. Try the Settings App > Facebook and allow Pocket Prints to use your account"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        //[self.delegate facebookLoginFailed];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFBNotLogin object:[NSError new] userInfo:nil];
    }
}

#pragma mark action


- (void)closeSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)isLogin
{
//    FBSession *activeSession = [FBSession activeSession];
//    FBSessionState state = activeSession.state;
//    BOOL isLoggedIn = activeSession && [self isSessionStateEffectivelyLoggedIn:state];
//    
//    DLog(@"Facebook active session state: %d; logged in conclusion: %@", state, (isLoggedIn ? @"YES" : @"NO"));
    BOOL isLoggedIn = NO;
    if ([FBSDKAccessToken currentAccessToken].tokenString){
        //proceed to auto login since Facebook is still logged in
//        NSLog(@"Facebook user id: %@",[FBSDKProfile currentProfile].userID);

        isLoggedIn = YES;
    }
    
    return isLoggedIn;
}

- (BOOL)isSessionStateEffectivelyLoggedIn:(FBSessionState)state {
    BOOL effectivelyLoggedIn;
    
    switch (state) {
        case FBSessionStateOpen:
            DLog(@"Facebook session state: FBSessionStateOpen");
            effectivelyLoggedIn = YES;
            break;
        case FBSessionStateCreatedTokenLoaded:
            DLog(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
            effectivelyLoggedIn = YES;
            break;
        case FBSessionStateOpenTokenExtended:
            DLog(@"Facebook session state: FBSessionStateOpenTokenExtended");
            effectivelyLoggedIn = YES;
            break;
        default:
            DLog(@"Facebook session state: not of one of the open or openable types.");
            effectivelyLoggedIn = NO;
            break;
    }
    
    return effectivelyLoggedIn;
}

#pragma mark - ultilities

-(void) shareFacebookWithMessage:(NSString*) aMessage
                          onFail:(void (^)(NSError* error)) aFailBlock
                          onDone:(void (^)(id obj)) aDoneBlock {
    
    NSMutableDictionary *postParams =  [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"https://www.facebook.com/pages/Pocketprints/244847619027735", @"link",
                                        aMessage,@"message",nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (error) {
                                  aFailBlock(error);
                              }
                              else
                                  aDoneBlock(result);
                          }];
}

-(void) getPhotoAlbumsOnFail:(void (^)(NSError* error)) aFailBlock
                      onDone:(void (^)(id obj)) aDoneBlock {
//    [FBRequestConnection startWithGraphPath:@"/me/albums"
//                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"cover_photo,name,id,count",@"fields", nil]
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              if (!error) {
//                                  // ok
//                                  aDoneBlock(result);
//                              }
//                              else
//                                  aFailBlock(error);
//                          }];
    
    
    
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/albums"
                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"cover_photo,name,id,count",@"fields", nil]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error)
     {
         // Handle the result
         NSLog(@"===>>>result is:%@",result);
         NSLog(@"===>>>error is:%@",error);
         if (!error) {
             aDoneBlock(result);
         }
         else
             aFailBlock(error);
         
     }];
    
}

-(void) getAlbumCoverWithAlbumId:(NSString*) albumId
                          onFail:(void (^)(NSError* error)) aFailBlock
                          onDone:(void (^)(id obj)) aDoneBlock {
    
//    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@",albumId]
//                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"source,picture",@"fields", nil]
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              if (!error) {
//                                  // ok
//                                  aDoneBlock(result);
//                              }
//                              else
//                                  aFailBlock(error);
//                          }];
    
    
    NSLog(@"albumId =====> %@",albumId);
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@",albumId]
                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"source,picture",@"fields", nil]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error)
     {
         // Handle the result
         NSLog(@"===>>>result is:%@",result);
         NSLog(@"===>>>error is:%@",error);
         if (!error) {
             aDoneBlock(result);
                    }
                else
                    aFailBlock(error);
         

         
     }];

    
    
    
    
    
    
    
}

-(NSDictionary*) getAlbumCoverSyncWithAlbumId:(NSString *)albumId {
    NSString    *access_token = [FBSDKAccessToken currentAccessToken].tokenString;
    //[FBSession activeSession].accessTokenData.accessToken;
    
    
    NSString    *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=source,picture&sdk=ios&format=json&access_token=%@",albumId,access_token];
    ASIHTTPRequest  *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"];

    [request startSynchronous];
    NSDictionary    *dict = nil;
    NSError *error = [request error];
    NSLog(@"%@",request.responseData);
    if (!error) {
        dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    }
    
    return dict;
}

-(void) getPhotosOfAlbumWithAlbumId:(NSString*) albumId
                      onFail:(void (^)(NSError* error)) aFailBlock
                      onDone:(void (^)(id obj)) aDoneBlock {
//    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/photos",albumId]
//                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"source,picture",@"fields",@"1000",@"limit", nil]
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              if (!error) {
//                                  // ok
//                                  aDoneBlock(result);
//                              }
//                              else
//                                  aFailBlock(error);
//                          }];
    
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/photos",albumId]
                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"source,picture",@"fields",@"1000",@"limit", nil]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error)
     {
         // Handle the result
         NSLog(@"===>>>result is:%@",result);
         NSLog(@"===>>>error is:%@",error);
         
         if (!error)
         {
            aDoneBlock(result);
        }
        else
        aFailBlock(error);
         
     }];

    
}
@end
