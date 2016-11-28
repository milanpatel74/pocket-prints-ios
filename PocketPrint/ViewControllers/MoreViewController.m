//
//  MoreViewController.m
//  PocketPrint
//
//  Created by Quan Do on 7/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "MoreViewController.h"
#import "ShippingAddressManagerViewController.h"
#import "WebViewController.h"
#import "HomeViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

static MoreViewController *singleton;

+(MoreViewController*) getShared {
    return singleton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    singleton= self;
    
    // Do any additional setup after loading the view from its nib.
    [self setScreenTitle:@"More"];
    self.view.backgroundColor = UIColorFromRGB(0xe7e7e7);
    lbContact.font = lbEmail.font = lbFacebook.font = lbFree.font = lbPush.font = lbRate.font = lbShipping.font = lbInstagram.font = lbPinterest.font = lbResetCoachmark.font = lbFAQ.font = [UIFont fontWithName:@"MuseoSans-300" size:15];
    lbFree.textColor = UIColorFromRGB(0xe8320b);
    
//    if (!IS_4INCHES) {
//        CGRect frame = scrollView.frame;
//        frame.origin.y = 64;
//        frame.size.height = 366;
//        scrollView.frame = frame;
//        
//        //scrollView.contentSize = CGSizeMake(320, 498);
//    }
    
    scrollView.contentSize = CGSizeMake(320, 498);

    if ([[NSUserDefaults standardUserDefaults] objectForKey:PREF_ENABLE_PUSH]) {
        switchPush.on = YES;
    }
    
}

-(void) viewDidLayoutSubviews {
    if (IS_IPHONE_6P) {
//        imgViewRowLong.image = [UIImage imageNamed:@"5_rows@3x.png"];
    }
    else
    if (IS_IPHONE_6)
    {
        imgViewRowShort.image = [UIImage imageNamed:@"5_rows-667h@2x.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action
-(void) setSwitch:(BOOL) isAllowed {
    [switchPush setOn:isAllowed];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (isAllowed) {
        [userDefault setObject:@"" forKey:PREF_ENABLE_PUSH];
    }
    else
        [userDefault removeObjectForKey:PREF_ENABLE_PUSH];
    [userDefault synchronize];
    
    
}
-(IBAction) touchPush {
    
}

-(IBAction) touchShippingAddr {
    ShippingAddressManagerViewController    *shippingAddr = [[ShippingAddressManagerViewController alloc] initWithNibName:@"ShippingAddressManagerViewController" bundle:[NSBundle mainBundle]];
    shippingAddr.noCoachmark = YES;
    [self.navigationController pushViewController:shippingAddr animated:YES];
}

-(IBAction) touchContact {
    mailType = EMAIL_CONTACT;

    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    NSArray *arrEmail = [NSArray arrayWithObject:@"hello@pocketprints.com.au"];
    [mailController setToRecipients:arrEmail];
    [mailController setSubject:[@"Pocket Prints Feedback v" stringByAppendingString:[appDelegate getVersion]]];
    if (!mailController) {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please setup an email account to send email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else
    [self.navigationController presentViewController:mailController animated:YES completion:^{
        
    }];
}

-(IBAction) touchRateApp {
    //[[iRate sharedInstance] promptForRating];
    SKStoreProductViewController    *storeController = [[SKStoreProductViewController alloc] init];
    storeController.delegate = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [storeController loadProductWithParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:900757823],SKStoreProductParameterITunesItemIdentifier, nil] completionBlock:^(BOOL result, NSError *error) {
        DLog(@"=>%@",error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [self.navigationController presentViewController:storeController animated:YES completion:^{
        
    }];
    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/au/app/pocket-prints-photo-printing/id900757823?mt=8"]];
    
}

-(IBAction) touchFacebook {
    if (![[FacebookServices sharedFacebookServices] isLogin]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFacebookLogin:) name:NotificationFbLogin object:nil];
        [[FacebookServices sharedFacebookServices] login];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Pocketprintsapp/271786759663850"]];
//        [[FacebookServices sharedFacebookServices] shareFacebookWithMessage:@"test share on facebook" onFail:^(NSError *error) {
//            DLog(@"Fail");
//        } onDone:^(id obj) {
//            DLog(@"share facebook ok => cell reward now");
////            [[[UIAlertView alloc] initWithTitle:nil message:@"Facebook share and got reward from Pocket Print" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//        }];
    }
}

-(IBAction) touchInstagram {
    // go to instagram album
    // here i can set accessToken received on previous login
    (appDelegate).instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PREF_INSTAGRAM_TOKEN"];
    (appDelegate).instagram.sessionDelegate = self;
    if ([(appDelegate).instagram isSessionValid]) {
        DLog(@"session valid");
        // switch to select photo view
        [self requestFollowInstagram];

    } else {
        [(appDelegate).instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    }
}

-(IBAction) touchPinterest {
    NSURL   *url = [NSURL URLWithString:@"pinterest://user/pocketprintsapp/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
    else {
        // execel
        url = [NSURL URLWithString:@"http://www.pinterest.com/pocketprintsapp"];
        [[UIApplication sharedApplication]openURL:url];
    }
}

-(IBAction) touchEmail {
    mailType = EMAIL_SHARE;
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    NSArray *arrEmail = [NSArray array];
    [mailController setToRecipients:arrEmail];
    [mailController setSubject:@"Check this out!"];
    [mailController setMessageBody:@"Hey,<br><br>I thought you would be interested in this App: https://itunes.apple.com/AU/app/id900757823<br><br>Pocket Prints is simple to use. <br><br>Just select your photos in a few taps and pay, then all you have to do is wait for your prints to arrive.<br><br>It's pretty cool." isHTML:YES];
    if (!mailController) {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Please setup an email account to send email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else
    [self.navigationController presentViewController:mailController animated:YES completion:^{
        
    }];
}

-(IBAction) touchFAQ {
    WebViewController *webController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:webController animated:YES];
}

-(IBAction) touchResetCoachmark {
    for (int i=1;i<6;i++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"coach%d",i]];
    }
    [[[UIAlertView alloc] initWithTitle:nil message:@"Coach Marks have now been reset" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    [[HomeViewController getShared] reloadCoachmark];
}

-(IBAction) updateSwitch:(UISwitch*) aSwitch {
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    if (aSwitch.on) {
        [userDefault setObject:@"" forKey:PREF_ENABLE_PUSH];
        if (!TARGET_IPHONE_SIMULATOR) {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
            {
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
            else
            {
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
            }
        }
    }
    else {
        [userDefault removeObjectForKey:PREF_ENABLE_PUSH];
        [[APIServices sharedAPIServices] enablePush:NO onFail:^(NSError *error) {
            DLog(@"Fail => %@",error.debugDescription);
        } onDone:^(NSError *error, id obj) {
            DLog(@"Ok => %@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
        }];
    }
    [userDefault synchronize];
    

}

#pragma mark mail
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (mailType == EMAIL_SHARE) {
        switch (result) {
            case MFMailComposeResultCancelled:
                break;

            case MFMailComposeResultSaved:
                break;

            case MFMailComposeResultSent:
                // call reward web service here
                break;

            case MFMailComposeResultFailed:
                //[self playAudio:soundMailFail];
                //AudioServicesPlaySystemSound(soundMailFail);
                break;
                
            default:
                break;
        }
    }
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark instagram delegate

-(void) requestFollowInstagram {

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/565120/relationship", @"method",@"follow",@"action", nil];
    [(appDelegate).instagram requestWithParams:params
                                      delegate:self];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    DLog(@"Follow from Instagram successfully");
    // load images here
//    [[[UIAlertView alloc] initWithTitle:nil message:@"Followed and got reward from Pocket Print" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

#pragma mark instagram
#pragma - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    [[NSUserDefaults standardUserDefaults] setObject:(appDelegate).instagram.accessToken forKey:@"PREF_INSTAGRAM_TOKEN"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self requestFollowInstagram];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PREF_INSTAGRAM_TOKEN"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

#pragma mark notification

-(void) notificationFacebookLogin:(NSNotification*) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationFbLogin object:nil];
    [self touchFacebook];
}

#pragma mark store view
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
