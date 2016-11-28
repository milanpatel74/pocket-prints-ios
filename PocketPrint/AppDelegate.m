//
//  AppDelegate.m
//  PocketPrint
//
//  Created by Quan Do on 3/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckoutViewController.h"
#import "MoreViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "BackgroundSessionManager.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    
   // [Fabric with:@[[Crashlytics class]]];
    

    
    //[Crashlytics startWithAPIKey:@"322c7ea920153930810bddd3d07cce1682eedb90"];
//    [FBSDKLoginButton class];
//    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    [loginManager logInWithReadPermissions:@[@"public_profile",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        //[appDelegate getFacebookUserInfo];
//        NSLog(@"Granted Perm: %@ Declined Perm: %@",[result grantedPermissions],[result declinedPermissions]);
//    }];

//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
////        if (error) {
////            // Process error
////        } else if (result.isCancelled) {
////            // Handle cancellations
////        } else {
////            // If you ask for multiple permissions at once, you
////            // should check if specific permissions missing
////            if ([result.grantedPermissions containsObject:@"email"]) {
////                // Do work
////            }
////        }
//         NSLog(@"Granted Perm: %@ Declined Perm: %@",[result grantedPermissions],[result declinedPermissions]);
//    }];
    
    
    // database
    [self loadDatabase];
    
    /// MUST DO IT FIRST
    //register token
    NSString    *appToken = [[APIServices sharedAPIServices] getApiToken];
    if (!appToken) {
        // request token
        [[APIServices sharedAPIServices] registerTokenOnFail:^(NSError *error) {
            DLog(@"Register fail");
            //[[[UIAlertView alloc] initWithTitle:nil message:@"Can not communicate with server. Please check your network" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        } onDone:^(NSError *error, id obj) {
            DLog(@"Toekn test=>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
            NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
            [APIServices sharedAPIServices].token = [dict objectForKey:@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[APIServices sharedAPIServices].token forKey:PREF_APP_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            DLog(@"App token = %@",[APIServices sharedAPIServices].token);
            
            //notify
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGetAppToken object:nil];
        }];
    }
    else
    {
        // test
        //
        //[self test];
    }
    
    // uploader
    [[Uploader shared] start];
    
    //paypal
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"Ac1IUxBKRLj3K28b8YD3cnGSsRBZpv3-oqDY-_6Ce4DfWxssMYqdRgFB4iVm",
                                                           PayPalEnvironmentSandbox : @"AeUrbxDQLiQw4hU9rHJCd8qUKU6zwDM72KoNnpyfhQvl6MVP0fmzN2ZKUzNy"}];
    

    
    if (![self isNetworkAvailable]) {
        DLog(@"Network is unvaialble");
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Can not connect to network" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//        [_window makeKeyAndVisible];
        //return YES;
    }
    // register facebook stuffs
    if ([[FacebookServices sharedFacebookServices] isLogin]) {
        [[FacebookServices sharedFacebookServices] login];
    }
    // available fonts listed in xcode output
//    for (id familyName in [UIFont familyNames]) {
//        NSLog(@"%@", familyName);
//        for (id fontName in [UIFont fontNamesForFamilyName:familyName]) NSLog(@"  %@", fontName);
//    }
    
    // init instagram
    _instagram = [[Instagram alloc] initWithClientId:INSTAGRAM_APP_ID
                                                delegate:nil];
    
    //set tab bar property
    if (IS_IOS_7)
    {
        [[UITabBar appearance] setTintColor:[UIColor redColor]];
    }
    else
    {
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
    }
    
    
    // set selected and unselected icons
    UITabBarItem *item = [_tabBarController.tabBar.items objectAtIndex:0];
    
    item.image = [[UIImage imageNamed:@"prints_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item.selectedImage = [UIImage imageNamed:@"prints_btn_hover.png"];

    item = [_tabBarController.tabBar.items objectAtIndex:1];
    
    item.image = [[UIImage imageNamed:@"check_out_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item.selectedImage = [UIImage imageNamed:@"check_out_btn_hover.png"];
    
    item = [_tabBarController.tabBar.items objectAtIndex:2];
    
    item.image = [[UIImage imageNamed:@"more_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item.selectedImage = [UIImage imageNamed:@"more_btn_hover.png"];
    

    //id nn = [NSNull null];
    //[nn objectForKey: @"ss"];

    
    [_window makeKeyAndVisible];
    
    [self test];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // check for order
    SqlManager  *sqlMan = [SqlManager defaultShare];
    // get all order
    NSString    *sql = @"SELECT * FROM order_list";
    NSArray *arrOrders = [sqlMan doQueryAndGetArray:sql];
    
    if (arrOrders.count >0) {
        DLog("Registered alarm");
        // clean all
        [self scheduleAlarmForDate:nil];
        [self scheduleAlarmForDate:[NSDate dateWithTimeIntervalSinceNow:15*60]];
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [FBSDKAppEvents activateApp];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBSDKAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
  //22ndJulyStart
  //[FBAppCall handleDidBecomeActive];
  //end
    
    [appDelegate scheduleAlarmForDate:nil];
    [[Uploader shared] start];
    
//    if ([HomeViewController getShared]) {
//        [[HomeViewController getShared] loadProductList];
//    }
    
//    id ss = [NSNull null];
//    [ss objectForKey: @"ss"];
//    int x=3;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //22ndJulyStart
    //[FBSession.activeSession close];
    //end

}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    //NSAssert([[BackgroundSessionManager sharedManager].session.configuration.identifier isEqualToString:identifier], @"Identifiers didn't match");
    DLog(@"===========================================================");
    DLog(@"==========SORRY MATE SOMETHING MUST BE END HERE ===========%@",identifier);
    //[BackgroundSessionManager sharedManager].savedCompletionHandler = completionHandler;
}

#pragma mark init database

-(void) test {
//    [[APIServices sharedAPIServices] stripePaymentWithToken:@"" andAmount:@"" onFail:^(NSError *error) {
//        
//    } onDone:^(NSError *error, id obj) {
//        
//    }];
//    UIDevice *device = [UIDevice currentDevice];
//    DLog(@"=> device %@ - %@ - %@ - %@",device.model,device.localizedModel,device.systemVersion,device.systemName);
//    NSString *deviceInfo = [NSString stringWithFormat:@"Model: %@ \n Local info: %@ \n System name%@",device.model,device.localizedModelo,device.systemName];
    
//    DLog(@"START DOWNLOADING IN BACKGROUND");
//    //NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/97917862/Notr%201.0b1.1.ipa"];
//    NSURL *URL = [NSURL URLWithString:@"http://pp.appiphany.com.au/api/photo.json?token=ZIm3J03ljfEjSC9L7M34Cw"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
//    NSURLSessionDownloadTask *downloadTask = [[BackgroundSessionManager sharedManager] downloadTaskWithRequest:request progress:nil destination:nil completionHandler:nil];
//    [downloadTask resume];
    
//    [[APIServices sharedAPIServices] uploadPhotoURL:@"(null)" onFail:^(NSError *error) {
//        DLog(@"Erro =>%@",error);
//    } onDone:^(NSError *error, id obj) {
//        DLog(@"=>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
//    }];
//    [[APIServices sharedAPIServices] getVoucherInfoWithVoucherId:@"voucher_thuylc" andProductId:@"[{\"id\": \"5359d72169702d56d4060000\", \"quantity\": \"1\"}]" onFail:^(NSError *error) {
//        DLog(@"voucher fail");
//    } onDone:^(NSError *error, id obj) {
//        DLog(@"voucher  =>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
//    }];
    
//    [[APIServices sharedAPIServices] getCouponInfoWithCouponId:@"123" andProductId:@"[{\"id\": \"5359d72169702d56d4060000\", \"quantity\": \"1\"}]" onFail:^(NSError *error) {
//        DLog(@"Coupon fail");
//    } onDone:^(NSError *error, id obj) {
//        DLog(@"Coupon =>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
//    }];
    
//    [[APIServices sharedAPIServices] uploadPhotoURL:@"https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-ash3/t31.0-8/1267805_10151921997873304_1178915312_o.jpg" onFail:^(NSError *error) {
//        DLog(@"upload image URL fail");
//    } onDone:^(NSError *error, id obj) {
//        DLog(@"upload image URL=>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
//    }];
    
//    [[APIServices sharedAPIServices] uploadPhoto:[UIImage imageNamed:@"5.jpg"] onFail:^(NSError *error) {
//        DLog(@"upload image = %@",error.debugDescription);
//    } onDone:^(NSError *error, id obj) {
//        DLog(@"upload image=>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
//    }];
    
//    [[APIServices sharedAPIServices] getProductsOnFail:^(NSError *error) {
//        DLog(@"%@",error.debugDescription);
//    } onDone:^(NSError *error, id obj) {
//        DLog(@"=>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
//    }];
}

-(void) loadDatabase {
    /// copy
    NSFileManager   *fileMan = [NSFileManager defaultManager];
    NSString    *newPath = [PATH_DOCUMENT_FOLDER stringByAppendingPathComponent:@"pocketprint.sqlite"];
    NSString    *oldPath = [[NSBundle mainBundle] pathForResource:@"pocketprint.sqlite" ofType:@""];
    //if (![fileMan fileExistsAtPath:newPath]) {
        [fileMan copyItemAtPath:oldPath toPath:newPath error:nil];
    //}
    
    
    return;
    
/*    //-->
    SqlManager  *sqlman = [SqlManager defaultShare];
    // import from CSV
    NSString    *dataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"query_result.csv" ofType:@""]];
    NSArray *arrLines = [dataStr componentsSeparatedByString:[NSString stringWithFormat:@"\n"]];
    
    for (NSString   *lineStr in arrLines) {
        NSArray *arrElems = [lineStr componentsSeparatedByString:@","];
        NSString    *postCodeStr = [arrElems objectAtIndex:2];
        if (postCodeStr.length == 0) {
            continue;
        }
        // process
        int postCode = [postCodeStr intValue];
        NSString    *stateId = @"";
        // NSW
        if ((1000 <= postCode && postCode <= 1999) ||
            (2000 <= postCode && postCode <= 2599) ||
            (2619 <= postCode && postCode <= 2898) ||
            (2921 <= postCode && postCode <= 2999)) {
            stateId = @"220";
        }
        
        // ACT
        if ((200 <= postCode && postCode <= 299) ||
            (2600 <= postCode && postCode <= 2618) ||
            (2900 <= postCode && postCode <= 2920)) {
            stateId = @"227";
        }
        
        // VIC
        if ((3000 <= postCode && postCode <= 3999) ||
            (8000 <= postCode && postCode <= 8999)) {
            stateId = @"225";
        }
        
        // QLD
        if ((4000 <= postCode && postCode <= 4999) ||
            (9000 <= postCode && postCode <= 9999)) {
            stateId = @"222";
        }
        
        // SA
        if ((5000 <= postCode && postCode <= 5799) ||
            (5800 <= postCode && postCode <= 5999)) {
            stateId = @"223";
        }
        
        // WA
        if ((6000 <= postCode && postCode <= 6797) ||
            (6800 <= postCode && postCode <= 6999)) {
            stateId = @"226";
        }
        
        // TAS
        if ((7000 <= postCode && postCode <= 7799) ||
            (7800 <= postCode && postCode <= 7999)) {
            stateId = @"224";
        }
        
        // NT
        if ((800 <= postCode && postCode <= 899) ||
            (900 <= postCode && postCode <= 999)) {
            stateId = @"221";
        }
        
        // write to database
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO suburbs ('state_id','suburb_id','suburb_post_code','suburb_name') VALUES ('%@','%@','%@','%@')",
                            stateId,
                            [arrElems objectAtIndex:0],
                            postCodeStr,
                            [[arrElems objectAtIndex:1] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
        //DLog(@"=>%@",sqlStr)
        [sqlman doInsertQuery:sqlStr];
    }
    
    return;
    // import
    NSData  *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"suburbs.json" ofType:@""]];
    NSError *error = nil;
    NSArray *arrState = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    for (int i=0; i < arrState.count; i++) {
        NSDictionary    *state = [arrState objectAtIndex:i];
        // insert state to database
        NSString    *strId= [NSString stringWithFormat:@"%d",[[state objectForKey:@"id"] intValue]];
        NSString    *sql = [NSString stringWithFormat:@"INSERT INTO states ('state_id','state_name','state_short_name') VALUES ('%@','%@','%@')",
                            strId,
                            [state objectForKey:@"statename"],
                            [state objectForKey:@"state"]];
        [sqlman doInsertQuery:sql];
        
        DLog(@"id = %@",strId);
        // insert suburbs
        NSArray    *arrSuburbs = [state objectForKey:@"suburbs"];
        for (NSDictionary *dictSuburb in arrSuburbs) {
            NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO suburbs ('state_id','suburb_id','suburb_post_code','suburb_name') VALUES ('%@','%@','%@','%@')",
                   strId,
                                [dictSuburb objectForKey:@"id"],
                   [dictSuburb objectForKey:@"postcode"],
                   [[dictSuburb objectForKey:@"suburb"] stringByReplacingOccurrencesOfString:@"'" withString:@"''"] ];
            //DLog(@"=>%@",sqlStr)
            [sqlman doInsertQuery:sqlStr];
        }
    }*/
    DLog(@"done");
}

#pragma mark facebook
// FBSample logic
// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    /*if ([[url scheme] isEqualToString:@"ig1aebc237ab124c3badb1ca35f842464e"]) {
        return [self.instagram handleOpenURL:url];
    }*/
    
    if ([[url scheme] isEqualToString:@"http"]) {
        return [self.instagram handleOpenURL:url];
    }
    
    
    // gift
    // pocketprints://pocket/code=123&email=quan@gmail.com
    if ([[url scheme] isEqualToString:@"pocketprints"]) {
        // go to Checkout tab
        [self goToTab:1];
        
        NSString *absolutePath = [url absoluteString];
        NSRange range = [absolutePath rangeOfString:@"?" options:NSBackwardsSearch];
        NSString    *path = [absolutePath substringFromIndex:range.location];
        NSArray *arrParams = [path componentsSeparatedByString:@"&"];
        NSString    *code = [[arrParams objectAtIndex:0] substringFromIndex:6];
        NSString    *email =@"";
        if (arrParams.count > 1) {
            email = [[arrParams objectAtIndex:1] substringFromIndex:6];
        }
        
        [self goToTab:1];
        
        // process coupon
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CheckoutViewController  *checkoutController = [CheckoutViewController getShared];
            [checkoutController addPromotionCode:[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:email,@"voucher_email",code,@"promotion_code", nil]]];
        });
           }
    
    DLog(@"URL RECEIVE  =%@",url);
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
    
    
//    return [FBAppCall handleOpenURL:url
//                  sourceApplication:sourceApplication
//                    fallbackHandler:^(FBAppCall *call) {
//                        NSLog(@"In fallback handler");
//                    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    DLog(@"URL RECEIVE  =%@",url);
    if ([[url scheme] isEqualToString:@"pocketprints"]) {
        NSString    *str = [url absoluteString];
        str = [str substringFromIndex:20];
        DLog(@"found coupon form email %@",str);
        
        // go to Checkout tab
        [self goToTab:1];
        // process coupon
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CheckoutViewController  *checkoutController = [CheckoutViewController getShared];
            //[checkoutController addPromotionCode:<#(NSString *)#> withVoucherEmail:<#(NSString *)#>]
        });
        return YES;
    }
    return [self.instagram handleOpenURL:url];
}

#pragma mark Push Notification
#pragma mark - RemoteNotification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)aDeviceToken
{
    DLog(@"deviceToken: %@", aDeviceToken);
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device Token" message:[deviceToken description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];œ
    //    [alert show];
    //    [alert release];
    
    //[UserDefaultsServices sharedUserDefaultsServices].canSendRemoteNotifications = TRUE;
    
    NSString *deviceToken = [[[[aDeviceToken description]
                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                    stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    DLog(@"device token found = %@",deviceToken);
    
    NSLog(@"TOKEN = %@",deviceToken);
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push msg" message:deviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    //    [alert release];
    //    [[APIServices sharedAPIServices] registerProfile];
    //4    [self showHUDWithMessage:@"Authorising..."];
    //    [[APIServices sharedAPIServices]registerWithAuthority:@"ios"
    //                                              deviceToken:deviceToken
    //                                              accessToken:nil
    //                                                      key:nil
    //                                                   secret:nil];
    NSUserDefaults  *userPref = [NSUserDefaults standardUserDefaults];
    [userPref setObject:deviceToken forKey:PREF_PUSH_TOKEN];
    [userPref synchronize];
    
    MoreViewController  *moreController = [MoreViewController getShared];
    [[APIServices sharedAPIServices] enablePush:YES onFail:^(NSError *error) {
        DLog(@"Fail => %@",error.debugDescription);
        [moreController setSwitch:NO];
    } onDone:^(NSError *error, id obj) {
        DLog(@"Ok => %@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
        [moreController setSwitch:YES];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"Error in registration. Error: %@", error);
    NSUserDefaults  *userPref = [NSUserDefaults standardUserDefaults];
    [userPref removeObjectForKey:@"remoteEnable"];
    [userPref synchronize];
    //[UserDefaultsServices sharedUserDefaultsServices].canSendRemoteNotifications = FALSE;
    MoreViewController  *moreController = [MoreViewController getShared];
    [moreController setSwitch:NO];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push msg" message:[userInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    //    [alert release];
    [self handleRemoteNotification:userInfo];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"handleRemoteNotification: %@", userInfo);
    
    // refresh now
//    [[APIServices sharedAPIServices] getDataFromServer];
//    [self showNotificationViewWithDict:userInfo];
}

#pragma mark utility
-(NSString*) getVersion {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [[infoDict objectForKey:@"CFBundleShortVersionString"] stringByAppendingFormat:@" b%@",[infoDict objectForKey:@"CFBundleVersion"]];
    return version;
}

-(void) goToTab:(int) tabIndex {
    [_tabBarController setSelectedIndex:tabIndex];
}

- (BOOL)isNetworkAvailable
{
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.pocketprints.com.au"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
        NSLog (@"Connection is down");
        return NO;
    }
}

#pragma mark alarm
- (void)scheduleAlarmForDate:(NSDate*)theDate
{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    if ([def boolForKey:@"DID_NOTIFY"]) {
//        return;
//    }
//    //    if ([def boolForKey:@"DID_NOTIFY"]) {
//    [def setBool:YES forKey:@"DID_NOTIFY"];
//    [def synchronize];
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    if (theDate) {
        DLog(@"====> REGISTER ALARM");
        UILocalNotification* alarm = [[UILocalNotification alloc] init];
        if (alarm)
        {
            alarm.fireDate = theDate;
            alarm.timeZone = [NSTimeZone defaultTimeZone];
            alarm.repeatInterval = 0;
            alarm.soundName = @"alarmsound.caf";
            alarm.alertBody = @"Please open Pocket Prints to finish uploading your photos";
            
            [app scheduleLocalNotification:alarm];
        }
    }
    else
        DLog(@"===>> REMOVE ALARM");
}
@end
