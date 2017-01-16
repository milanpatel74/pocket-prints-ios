//
//  Define.h
//  UrbanDrum
//
//  Created by Quan Do on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

static NSString* const CreativeSDKClientId = @"4a13644edc5141a79260fa99129261c1"; // Pro mode
static NSString* const CreativeSDKClientSecret = @"8aaa7e3b-b63a-4535-9863-e7a9e6522ef8";

// user pref
#define PREF_USER_INFO  @"PREF_USER_INFO"
#define PREF_SKIP       @"PREF_SKIP"

// global reference to the appdelegate
#define appDelegate (AppDelegate *) [[UIApplication sharedApplication] delegate]

#define IS_4INCHES                      ([UIScreen mainScreen].bounds.size.height==568)

#define     PATH_DOCUMENT_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define     PATH_TEMP_FOLDER     [NSTemporaryDirectory() substringToIndex:NSTemporaryDirectory().length-1]

#define     PATH_CACHE_PHOTO    ([[PATH_DOCUMENT_FOLDER stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tmp"])

#define     PATH_PROFILE_PHOTO  [PATH_CACHE_PHOTO stringByAppendingString:@"/profile.jpg"]

#define     DATABASE_USER_VERSION 1
//#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//#else
//#	define DLog(...)

//#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

// server info + APIs
//Old
//#define PushURL @"http://pusher.appiphany.com.au/devices.json"
//#define SERVER_URL  @"http://pp.appiphany.com.au/api"
//Latest Modified Sep10th
#define PushURL @"http://push.pocketprints.com.au/devices.json"
#define SERVER_URL  @"http://api.pocketprints.com.au/api"
//#define SERVER_URL  @"http://172.16.2.19:3000/api"

#define API_TOKEN               @"token.json"
#define API_PRDUCTS             @"products.json"
#define API_UPLOAD_PHOTO        @"photo.json"
#define API_PREFLIGHT           @"preflight.json"
#define API_ORDER               @"order.json"
#define API_STRIPE_PAYMENT      @"stripe_payment.json"
#define API_ADD_CUSTOMER        @"update_customer.json"

#define SERVER_URL_WITH_API(aAPI) ([NSString stringWithFormat:@"%@/%@",SERVER_URL,aAPI])
#define     GOOLE_ANALYTIC_ID            @"UA-44709019-1"

// Convenient RGB macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define     NotificationPostFBSuccessful        @"NotificationPostFBSuccessful"

#define     NotificationGetAppToken      @"NotificationGetAppToken"

#define     NotificationReloadData              @"NotificationReloadData"

// block and queue
#define RUN_ON_MAIN_QUEUE(BLOCK_CODE)           dispatch_async(dispatch_get_main_queue(),(BLOCK_CODE))
#define RUN_ON_BACKGROUND_QUEUE(BLOCK_CODE)      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),(BLOCK_CODE))
#define IS_SIMULATOR                            ([[[UIDevice currentDevice].model lowercaseString] rangeOfString:@"simulator"].location != NSNotFound)

// instagram
//#define INSTAGRAM_APP_ID @"fd725621c5e44198a5b8ad3f7a0ffa09"
#define INSTAGRAM_APP_ID @"1aebc237ab124c3badb1ca35f842464e"
#define INSTAGRAM_REDIRECT_URI @"http://www.pocketprints.com.au/wp-admin/admin-ajax.php?action=register_instagram"

// facebook
// facebook stuff
//#define FacebookApplicationId @"756323087734081"
//#define FacebookSecret        @"cfa2f0169a7e30ad24c46a5ad6189ac7"

#define kAllowCropping     @"allowCropping"

#define     NotificationFavouriteChange         @"NotificationFavouriteChange"
#define     NotificationPostFBSuccessful        @"NotificationPostFBSuccessful"
#define     NotificationPostFBFail              @"NotificationPostFBFail"
#define     NotificationFBNotLogin              @"NotificationFBNotLogin"
#define     NotificationFB_Get_User_Info        @"NotificationFB_Get_User_Info"
#define     NotificationFB_Get_Profile_Photo    @"NotificationFB_Get_Profile_Photo"
#define     NotificationFbLogin               @"NotificationFbLogin"
#define     NotificationFbAlbum                 @"NotificationFbAlbum"
#define     NotificationGetLocation             @"NotificationGetLocation"

#define     NotificationResetQuantity           @"NotificationResetQuantity"

#define     NotificationUploaderDidCreateOrder  @"NotificationUploaderDidCreateOrder"
#define     NotificationFinishedFlyingImages    @"NotificationFinishedFlyingImages"
#define     NotificationUpdateUploadingPhoto    @"NotificationUpdateUploadingPhoto"

#define FB_GetAllFriends            @"FB_GetAllFriends"
#define FB_GetAllFriendLists        @"FB_GetAllFriendLists"

#define     IS_IOS_7    (([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."]objectAtIndex:0]intValue] == 7)?YES:NO)
#define     IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define     PREF_USER_INFO          @"PREF_USER_INFO"
#define     PREF_INSTAGRAM_TOKEN    @"PREF_INSTAGRAM_TOKEN"
#define     PREF_PUSH_TOKEN         @"PREF_PUSH_TOKEN"
#define     PREF_APP_TOKEN          @"PREF_APP_TOKEN"
#define     PREF_ENABLE_PUSH        @"PREF_ENABLE_PUSH"

#define IS_4INCHES                      ([UIScreen mainScreen].bounds.size.height==568)

#define ACCESS_TOKEN_DEVELOPMENT        @"0e4a3250-be50-0131-bd83-12313d1c7815"
#define ACCESS_TOKEN_PRODUCTION         @"0e4a3250-be50-0131-bd83-12313d1c7815"

#define STRIPE_API_TEST                 @"pk_test_Tzx20khQDTlUA8CokvqU3cDK"
#define STRIPE_API_LIVE                 @"pk_live_E1I1gjifP1eE1b4XOurFK3ST"
