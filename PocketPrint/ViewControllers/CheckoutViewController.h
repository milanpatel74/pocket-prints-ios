//
//  CheckoutViewController.h
//  PocketPrint
//
//  Created by Quan Do on 25/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingAddressManagerViewController.h"
#import "SelectPhotoViewController.h"
#import "ShippingAddressViewController.h"
#import "STPView.h"
#import "PayPalMobile.h"

@interface CheckoutViewController : AppViewController <UITableViewDataSource, UITableViewDelegate,PayPalPaymentDelegate,ShippingAddressManagerViewControllerDelegate,SelectPhotoViewControllerDelegate,ShippingAddressViewControllerDelegate> {
    IBOutlet    UITableView *tblView;
    NSMutableArray  *arrPhotoGroups,*arrCode,*arrShippingCost,*arrGiftCert;
    IBOutlet  UILabel   *lbSubTotal, *lbCoupon, *lbTotalPrice;
    PayPalConfiguration *payPalConfig;
    UITextField *tfCoupon;
    float totalCheckout;
    NSString    *lastCheckCoupon;
    UIAlertView *alertViewWrongEmail, *alertViewEmail,*alertSquare;
    NSString    *lastPrice;
    STPView *cardView;
    UIView  *maskView;
    
    NSDictionary    *dictPromote;
}

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property   (nonatomic) BOOL    isAlertSquare;
+(CheckoutViewController*) getShared;

-(void) setData:(NSArray *) arrData;

-(IBAction) touchCoupon;

-(void) removeCouponData;
-(void) addPromotionCode:(NSArray*) aPromoteArrayCode;
-(void) addData:(NSDictionary*) aGroupDict;
@end
