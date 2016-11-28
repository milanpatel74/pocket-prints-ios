//
//  MoreViewController.h
//  PocketPrint
//
//  Created by Quan Do on 7/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "IGConnect.h"
#import <StoreKit/StoreKit.h>

typedef enum {
    EMAIL_CONTACT,
    EMAIL_SHARE
}EMAIL_TYPE;

@interface MoreViewController : AppViewController <MFMailComposeViewControllerDelegate,IGRequestDelegate,SKStoreProductViewControllerDelegate>{
    IBOutlet    UISwitch    *switchPush;
    IBOutlet    UILabel     *lbPush, *lbShipping, *lbContact, *lbFree, *lbRate, *lbFacebook, *lbInstagram,*lbPinterest, *lbEmail, *lbFAQ, *lbResetCoachmark;
    EMAIL_TYPE  mailType;
    IBOutlet    UIScrollView *scrollView;
    IBOutlet    UIImageView *imgViewRowShort, *imgViewRowLong;
}

+(MoreViewController*) getShared;
-(IBAction) touchPush;
-(IBAction) touchShippingAddr;
-(IBAction) touchContact;
-(IBAction) touchRateApp;
-(IBAction) touchFacebook;
-(IBAction) touchInstagram;
-(IBAction) touchPinterest;
-(IBAction) touchEmail;
-(IBAction) touchFAQ ;

-(IBAction) updateSwitch:(UISwitch*) aSwitch;
-(void) setSwitch:(BOOL) isAllowed;
@end
