//
//  AppDelegate.h
//  PocketPrint
//
//  Created by Quan Do on 3/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property   (strong,nonatomic) IBOutlet UITabBarController  *tabBarController;
@property   (nonatomic,strong) Instagram    *instagram;

-(void) goToTab:(int) tabIndex;
- (void)scheduleAlarmForDate:(NSDate*)theDate;
-(NSString*) getVersion;
@end
