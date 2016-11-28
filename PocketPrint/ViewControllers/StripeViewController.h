//
//  StripeViewController.h
//  PocketPrint
//
//  Created by Quan Do on 30/08/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPViewExt.h"

@protocol StripeViewControllerDelegate <NSObject>

-(void) processWithStripeToken:(STPToken*) token;

@end

@interface StripeViewController : AppViewController <STPViewDelegate>{
    IBOutlet    UIScrollView *masterView;
    STPViewExt *cardView;
    IBOutlet    UILabel *lbInfo, *lbPrice, *lbPayment;
    IBOutlet    UIButton    *btnProgress;
    BOOL    isLoadedCard;
    IBOutlet    UILabel *lbCardNumber,*lbOtherCard;
    IBOutlet    UIView *viewLastCard;
}

@property UIViewController<StripeViewControllerDelegate> *delegate;
@property NSString *price;
@end
