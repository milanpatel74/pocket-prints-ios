//
//  CheckoutViewController.m
//  PocketPrint
//
//  Created by Quan Do on 25/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "CheckoutViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIImageViewWithData.h"
#import "PayPalMobile.h"
#import "OrderViewController.h"
#import "Product.h"
#import "HomeViewController.h"
#import "ShippingAddressViewController.h"
#import "MoreViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+LoadingMode.h"
#import "STPView.h"
#import "StripeViewController.h"
#import "UIImage+Resize.h"

@interface CheckoutViewController ()

@end

#define kPayPalEnvironment  PayPalEnvironmentProduction


@implementation CheckoutViewController

static CheckoutViewController *shared;

+(CheckoutViewController*) getShared {
    return shared;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HomeViewController getShared] showTabBar];
    
//    [self.tabBarController.tabBar setTranslucent:NO];
//    [self.tabBarController.tabBar setHidden:NO];
    // Preconnect to PayPal early
    [PayPalMobile preconnectWithEnvironment:_environment];
    
    if (arrPhotoGroups.count > 0 || arrGiftCert.count >0) {
        UIButton *btnCard = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCard.frame = CGRectMake(0, 0, 68, 16);
        [btnCard setBackgroundImage:[UIImage imageNamed:@"pay_icon.png"] forState:UIControlStateNormal];
        [btnCard addTarget:self action:@selector(touchInvoice) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCard];
    }
    else
        self.navigationItem.rightBarButtonItem = nil;
    
    // show coach mark
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"coach3"]) {
//        UIImage *imgCoach = [UIImage imageNamed:(IS_4INCHES)?@"coach_mark03-568h.png":@"coach_mark03.png"];
//        UIButton    *btnCoach = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnCoach setImage:imgCoach forState:UIControlStateNormal];
//        btnCoach.frame = CGRectMake(0, 0, imgCoach.size.width, imgCoach.size.height);
//        [btnCoach addTarget:self action:@selector(removeCoachmark:) forControlEvents:UIControlEventTouchUpInside];
//        [(appDelegate).window addSubview:btnCoach];
//    }
}

- (void)viewDidLoad
{
    shared = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setScreenTitle:@"Shopping Cart"];
    
    // add navigation button
    self.navigationItem.hidesBackButton = YES;
//    UIButton    *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnEdit.frame = CGRectMake(-20, 0, 50, 30);
//    [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
//    [btnEdit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btnEdit addTarget:self action:@selector(touchEdit) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
//    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(touchEdit)];
//    [btnEdit setTintColor:[UIColor redColor]];
//    [btnEdit setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil]  forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = btnEdit;
    

    
    //lbSubTotal.font = lbCoupon.font = [UIFont fontWithName:@"MuseoSans-500" size:16];
    lbCoupon.font = lbTotalPrice.font = [UIFont fontWithName:@"MuseoSans-500" size:16];
    if (!arrPhotoGroups) {
        arrPhotoGroups = [[NSMutableArray alloc] init];
    }
    

    // paypal
    [self setupPaypal];
    
//    if (!IS_4INCHES) {
//        CGRect frame = tblView.frame;
//        frame.size.height -= 98;
//        tblView.frame = frame;
//    }
    
    lastPrice = @"Total: $0";
    //[self addPromotionCode:[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"promotion_code",@"",@"voucher_email", nil]]];
    //[self alertMessage];
    
}


-(void) pushToShippingAdress
{
    ShippingAddressManagerViewController    *shippingManager = [[ShippingAddressManagerViewController alloc] initWithNibName:@"ShippingAddressManagerViewController" bundle:[NSBundle mainBundle]];
    shippingManager.enableOrder= YES;
    shippingManager.arrPhotoGroups = arrPhotoGroups;
    shippingManager.delegate = self;
    [self.navigationController pushViewController:shippingManager animated:YES];
}
-(void) alertMessage
{
    alertSquare = [[UIAlertView alloc] initWithTitle:nil message:@"For the best results we recommend cropping your image square using our crop function." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Go to FAQ",@"OK", nil];
    
    _isAlertSquare = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeCoachmark:(UIButton*) aBtn {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"coach3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.75 animations:^{
        aBtn.alpha = 0;
    } completion:^(BOOL finished) {
        aBtn.hidden = YES;
        [aBtn removeFromSuperview];
    }];
}

#pragma mark select photo delegate
-(void) dataUpdated {
    [tblView reloadData];
    NSMutableArray *arrAllObjs = [NSMutableArray new];
    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
    [arrAllObjs addObjectsFromArray:arrGiftCert];
    [self preflight:arrAllObjs andPromoteCode:nil finishBlock:nil];
}

#pragma mark utilities
-(void) preflight:(NSArray*)aArray andPromoteCode:(NSArray*) aArrayPromoteCode finishBlock:(void (^)(BOOL finished)) finishBlock{
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityIndicator startAnimating];
//    UIBarButtonItem *btnLoading = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
//    self.navigationItem.leftBarButtonItem = btnLoading;
//    self.navigationItem.hidesBackButton = YES;
    NSString *oldPrice = lbTotalPrice.text;
    lbTotalPrice.text = @"Total: Updating";
    // flight here
    NSMutableArray  *arrTmp = [NSMutableArray new];
    for (NSDictionary *dictGroup in aArray) {
        Product *product = [dictGroup objectForKey:@"product"];
        
        if (![product.type isEqualToString:@"Gift Certificates"]) {
            int count = 0;
            for (NSDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
                count += [[dictPhoto objectForKey:@"count"] intValue];
            }
            //set back
            NSMutableDictionary *dictTmp = [NSMutableDictionary dictionaryWithObjectsAndKeys:product.uid,@"id",[NSNumber numberWithInt:count],@"quantity", nil];
            // add
            [arrTmp addObject:dictTmp];
        }
        else {
            // certificate
            NSMutableDictionary *dictTmp = [NSMutableDictionary new];
            [dictTmp setObject:product.uid forKey:@"id"];
            [dictTmp setObject:[dictGroup objectForKey:@"name"] forKey:@"recipient_name"];
            [dictTmp setObject:[dictGroup objectForKey:@"email"] forKey:@"recipient_email"];
            [dictTmp setObject:[dictGroup objectForKey:@"message"] forKey:@"message"];
            [dictTmp setObject:[NSString stringWithFormat:@"%d",[[dictGroup objectForKey:@"gift_value"] intValue]] forKey:@"gift_value"];
            [dictTmp setObject:@"1" forKey:@"quantity"];
            
            [arrTmp addObject:dictTmp];
        }

    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrTmp options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // send to preflight

    // compose arrray promotion
    NSMutableArray  *arrPromotion = [NSMutableArray new];
    
//    for (NSDictionary *dict in arrCode) {
//        if ([[dict objectForKey:@"isCoupon"] boolValue]) {
//            // coupon
//            [arrPromotion addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"code"],@"promotion_code",@"",@"voucher_email", nil]];
//        }
//        else
//            [arrPromotion addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"code"],@"promotion_code",[dict objectForKey:@"email"],@"voucher_email", nil]];
//    }
//    
//    if (aArrayPromoteCode) {
//        [arrPromotion addObjectsFromArray:aArrayPromoteCode];
//    }
    [arrPromotion addObjectsFromArray:aArrayPromoteCode];
    
    [[APIServices sharedAPIServices] preflightWithPromotionArray:arrPromotion andProductId:jsonString onFail:^(NSError *error) {
        DLog(@"Fail to send preflight for prodcut %@",error.debugDescription);
        //self.navigationItem.leftBarButtonItem = nil;
        [arrPromotion removeAllObjects];
    } onDone:^(NSError *error, id obj) {
        //self.navigationItem.leftBarButtonItem = nil;
        [arrPromotion removeAllObjects];
        DLog("preflgith okie %@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
        NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
        
//        NSLog(@"%@",dict);
        
        if ([dict objectForKey:@"error"]) {
            int error_code = [[dict objectForKey:@"error_code"] intValue];
            if ([[dict objectForKey:@"error"] isEqualToString:@"Voucher Email is invalid."]) {
                lbTotalPrice.text = lastPrice;
                UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                //if ([[dict objectForKey:@"error"] isEqualToString:@"Voucher Email is invalid."]) {
                    alertViewWrongEmail = alertView;
                    alertViewWrongEmail.delegate = self;
                //}
                
            }
            else
                if (error_code == 3) {
                    // voucher expiry
                    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                    // remove voucher now
                    for (int i=arrCode.count-1; i>-1; i--) {
                        NSDictionary *dictCurrCode = [arrCode objectAtIndex:i];
                        for (NSDictionary *dictCode in [dict objectForKey:@"used_expired_promotions"]) {
                            if ([[dictCurrCode objectForKey:@"code"] isEqualToString:[dictCode objectForKey:@"promotion_code"]]) {
                                [arrCode removeObjectAtIndex:i];
                            }
                        }

                    }
                    
                    // reload
                    [tblView reloadData];
                    
                    // preflight again
                    NSMutableArray *arrAllObjs = [NSMutableArray new];
                    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
                    [arrAllObjs addObjectsFromArray:arrGiftCert];
                    // no need to update new code
                    [self preflight:arrAllObjs andPromoteCode:nil finishBlock:nil];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                    lbTotalPrice.text = oldPrice;
                }
            if (finishBlock) {
                finishBlock(NO);
            }
            

            DLog(@"Error found");

            
            return;
        }
        else {
            float shippingCost = [[dict objectForKey:@"shipping_cost"] floatValue];

            
            if ([dict objectForKey:@"shipping_cost"]) {
                // add
                [arrShippingCost removeAllObjects];
                
                [arrShippingCost addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Postage Cost",@"desc",(shippingCost == 0)?@"Free":[NSString stringWithFormat:@"$%.2f",shippingCost],@"price", nil]];
                NSLog(@"%@",arrShippingCost);
            }
            
            if (!arrCode) {
                arrCode = [NSMutableArray new];
            }
            
            // reset
            [arrCode removeAllObjects];
            
            // process dict
            if ([dict objectForKey:@"coupon"]) {
                // looking for any coupon and remove it
                for (NSDictionary *dictCoupon in arrCode) {
                    if ([[dictCoupon objectForKey:@"isCoupon"] boolValue]) {
                        // remove
                        [arrCode removeObject:dictCoupon];
                        break;
                    }
                }
                // coupon
                
                NSDictionary    *dictCoupon = [dict objectForKey:@"coupon"];
                NSString    *discountPercent = [[NSString alloc] init];
                
                NSLog(@"%@",[dictCoupon objectForKey:@"discount_percentage"]);
                
                if([NSNull null] != [dictCoupon objectForKey:@"discount_percentage"])
                {
                    discountPercent = [NSString stringWithFormat:@"%d%% OFF",[[dictCoupon objectForKey:@"discount_percentage"] intValue]];
                }
                else
                {
                    discountPercent = [NSString stringWithFormat:@"$%.2f",[[dict objectForKey:@"total"] floatValue]];
                }
                [arrCode addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Coupon Code: %@",[dictCoupon objectForKey:@"code"]],@"desc",
                                    discountPercent, @"price",
                                    [NSNumber numberWithBool:YES],@"isCoupon",[dictCoupon objectForKey:@"code"],@"code", nil]];
                

                NSLog(@"%@, %@",arrCode,discountPercent);
                
                
               
                
                               //[tblView reloadData];
            }
            
            float voucherPrice = 0;
            
            if ([dict objectForKey:@"vouchers"]) {
                NSArray *arrVouchers = [dict objectForKey:@"vouchers"];
                // assume we have only 1 voucher
                //NSDictionary    *dictVoucher = [arrVouchers objectAtIndex:0];
                for (NSDictionary    *dictVoucher in arrVouchers) {
                    float price = [[dictVoucher objectForKey:@"purchase_price"] floatValue] - [[dictVoucher objectForKey:@"redeemed"] floatValue] ;
                    voucherPrice += price;
                    if (price == 0) {
                        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@" Voucher code %@ was fully redeemed.",[dictVoucher objectForKey:@"code"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                        break;
                    }
                    // voucher
                    [arrCode addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Voucher Code: %@",[dictVoucher objectForKey:@"code"]],@"desc",[NSString stringWithFormat:@"-$%.2f",price],@"price",
                                        [NSNumber numberWithBool:NO],@"isCoupon",[dictVoucher objectForKey:@"code"],@"code",[dictVoucher objectForKey:@"email_address"],@"email", nil]];
                    NSLog(@"%@, %@",arrCode,dictVoucher);
                }

                
                //[tblView reloadData];
            }
            
            totalCheckout = [[dict objectForKey:@"total"] floatValue];//  + shippingCost + (voucherPrice * -1);
            NSLog(@"%f",totalCheckout);
            lbTotalPrice.text = [NSString stringWithFormat:@"Total: $%.2f",totalCheckout];
            lastPrice = lbTotalPrice.text;
            NSLog(@"%@",lastPrice);
            [tblView reloadData];
        }
        if (finishBlock) {
            finishBlock(YES);
        }
        
    }];
}

-(void) addPromotionCode:(NSArray*) aPromoteArrayCode{
    if (arrCode) {
        // verify code
        NSString    *codeStr = [[aPromoteArrayCode objectAtIndex:0] objectForKey:@"promotion_code"];
        for (NSDictionary   *codeDict in arrCode) {
            if ([[codeDict objectForKey:@"code"] isEqualToString:codeStr]) {
                NSString    *codeType = ([[codeDict objectForKey:@"isCoupon"] boolValue])?@"coupon":@"voucher";
                [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"The %@ was already added",codeType] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                return;
            }
        }
    }
    if (arrPhotoGroups.count == 0 && arrGiftCert.count == 0) {
        // test preflight
        [[APIServices sharedAPIServices] preflightWithPromotionArray:aPromoteArrayCode andProductId:@"" onFail:^(NSError *error) {
            DLog(@"Eorr= %@",error);
        } onDone:^(NSError *error, id obj) {
            DLog(@"Result = %@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
            NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
            if ([dict objectForKey:@"error"]) {
                UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[dict objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                if ([[dict objectForKey:@"error"] isEqualToString:@"Voucher Email is invalid."]) {
                    alertViewWrongEmail = alertView;
                    alertViewWrongEmail.delegate = self;
                }
                [alertView show];
            }
            else {
                if (!arrCode) {
                    arrCode = [NSMutableArray new];
                }
                // process dict
                if ([dict objectForKey:@"coupon"]) {
                    // looking for any coupon and remove it
                    for (NSDictionary *dictCoupon in arrCode) {
                        if ([[dictCoupon objectForKey:@"isCoupon"] boolValue]) {
                            // remove
                            [arrCode removeObject:dictCoupon];
                            break;
                        }
                    }
                    // coupon
                    
                    NSDictionary    *dictCoupon = [dict objectForKey:@"coupon"];
                    NSString    *discountPercent = [NSString stringWithFormat:@"%d%% OFF",[[dictCoupon objectForKey:@"discount_percentage"] intValue]];
                    [arrCode addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Coupon Code: %@",[dictCoupon objectForKey:@"code"]],@"desc",
                                        discountPercent, @"price",
                                        [NSNumber numberWithBool:YES],@"isCoupon",[dictCoupon objectForKey:@"code"],@"code", nil]];
                    
                    //[tblView reloadData];
                }
                else {
                    NSArray *arrVouchers = [dict objectForKey:@"vouchers"];
                    // assume we have only 1 voucher
                    NSDictionary    *dictVoucher = [arrVouchers objectAtIndex:0];
                    float price = [[dictVoucher objectForKey:@"purchase_price"] floatValue] - [[dictVoucher objectForKey:@"redeemed"] floatValue];
                    if (price == 0) {
                        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@" Voucher code %@ was fully redeemed.",[dictVoucher objectForKey:@"code"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                        return;
                    }
                    // voucher
                    [arrCode addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Voucher Code: %@",[dictVoucher objectForKey:@"code"]],@"desc",[NSString stringWithFormat:@"-$%.2f",price],@"price",
                                        [NSNumber numberWithBool:NO],@"isCoupon",[dictVoucher objectForKey:@"code"],@"code",[dictVoucher objectForKey:@"email_address"],@"email", nil]];
                    
                    //[tblView reloadData];
                }
                [tblView reloadData];
            }
        }];
        // end
        return;
    }
    
    NSMutableArray *arrAllObjs = [NSMutableArray new];
    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
    [arrAllObjs addObjectsFromArray:arrGiftCert];
    [self preflight:arrAllObjs andPromoteCode:aPromoteArrayCode finishBlock:nil];

}
#pragma mark data
-(void) setData:(NSArray *) arrData {
    if (arrData.count > 0) {
        UIButton *btnCard = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCard.frame = CGRectMake(0, 0, 68, 16);
        [btnCard setBackgroundImage:[UIImage imageNamed:@"pay_icon.png"] forState:UIControlStateNormal];
        [btnCard addTarget:self action:@selector(touchInvoice) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCard];
    }
    else
        self.navigationItem.rightBarButtonItem = nil;
    
    if (!arrPhotoGroups) {
        arrPhotoGroups = [[NSMutableArray alloc] init];
    }
    
    if (!arrShippingCost) {
        arrShippingCost = [[NSMutableArray alloc] init];
        //[arrShippingCost addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shipping",@"desc",@"$100",@"price", nil]];
    }
    
    if (!arrGiftCert) {
        arrGiftCert = [NSMutableArray new];
    }
//    if (!arrCode) {
//        arrCode = [[NSMutableArray alloc] init];
//        //[arrCode addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Coupon code",@"desc",@"-$100",@"price", nil]];
//    }
    
    if (!arrData || arrData.count == 0) {
        arrData = [NSArray new];
        [arrShippingCost removeAllObjects];
        [arrCode removeAllObjects];
        lbTotalPrice.text = @"$0";
    }
    else
        [self preflight:arrData andPromoteCode:nil finishBlock:nil];
    

    
    // clean
    [arrPhotoGroups removeAllObjects];
    [arrGiftCert removeAllObjects];
    
    // suppose the data was composed by photo screen
    for (NSMutableDictionary *dict in arrData) {
        if ([dict objectForKey:@"type"] && [[dict objectForKey:@"type"] isEqualToString:@"certificate"]) {
            [arrGiftCert addObject:dict];
        }
        else
            [arrPhotoGroups addObject:dict];
    }
    
    // reload
    [tblView reloadData];
}
-(void) removeCouponData
{
    dictPromote = nil;
}
-(void) addData:(NSDictionary*) aGroupDict {
    if (!aGroupDict) {
        return;
    }
    
    if (!arrPhotoGroups) {
        arrPhotoGroups = [[NSMutableArray alloc] init];
    }
    
    if (!arrGiftCert) {
        arrGiftCert = [NSMutableArray new];
    }
    
    if (!arrShippingCost) {
        arrShippingCost = [[NSMutableArray alloc] init];
        //[arrShippingCost addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shipping",@"desc",@"$100",@"price", nil]];
    }
    
    // add
    if ([aGroupDict objectForKey:@"type"] && [[aGroupDict objectForKey:@"type"] isEqualToString:@"certificate"]) {
        [arrGiftCert addObject:aGroupDict];
    }
    else {
        //[arrPhotoGroups addObject:aGroupDict];
        BOOL isExist = NO;
        for (NSMutableDictionary *dict in arrPhotoGroups) {
            if ([dict objectForKey:@"product"] == [aGroupDict objectForKey:@"product"]) {
                // update
//                NSMutableArray *arr = [dict objectForKey:@"photos"];
//                [arr addObjectsFromArray:[aGroupDict objectForKey:@"photos"]];
                [arrPhotoGroups removeObject:dict];
                [arrPhotoGroups addObject:aGroupDict];
                isExist = YES;
                break;
            }
        }
        
        if (!isExist) {
            // add
            [arrPhotoGroups addObject:aGroupDict];
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationResetQuantity object:[aGroupDict objectForKey:@"product"] userInfo:nil];
    }
    
    
    NSMutableArray  *arrTotal = [NSMutableArray new];
    [arrTotal addObjectsFromArray:arrPhotoGroups];
    [arrTotal addObjectsFromArray:arrGiftCert];
    if (arrTotal.count >0) {
        [self preflight:arrTotal andPromoteCode:nil finishBlock:nil];
    }
    [tblView reloadData];
    
    if (arrPhotoGroups.count > 0 || arrGiftCert.count > 0) {
        UIButton *btnCard = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCard.frame = CGRectMake(0, 0, 68, 16);
        [btnCard setBackgroundImage:[UIImage imageNamed:@"pay_icon.png"] forState:UIControlStateNormal];
        [btnCard addTarget:self action:@selector(touchInvoice) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCard];
    }
    else
        self.navigationItem.rightBarButtonItem = nil;
    
    [self validatePhoto:NO];
}


#pragma mark validate photo size 

-(void) validatePhoto:(BOOL) isSquared{
    //[self alertMessage];
    if (_isAlertSquare) {
        for (NSDictionary *dictGroup in arrPhotoGroups) {
            // check for square
//            NSString *sizeStr = [[[dictGroup objectForKey:@"desc"] componentsSeparatedByString:@" "] objectAtIndex:0];
//            sizeStr = [sizeStr stringByReplacingOccurrencesOfString:@"cm" withString:@""];
//            NSArray *arrTmp = [sizeStr componentsSeparatedByString:@"x"];
            
//            NSArray *arrTmp = [[dictGroup objectForKey:@"desc"] componentsSeparatedByString:@"x"];
//            NSString    *width = [[arrTmp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"cm" withString:@""];
//            width = [width stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSString    *height = [[arrTmp objectAtIndex:1] stringByReplacingOccurrencesOfString:@"cm" withString:@""];
//            height = [height stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            int width = [[dictGroup objectForKey:@"width"] floatValue];
            int height = [[dictGroup objectForKey:@"height"] floatValue];
            
            if (width == height) {
                
                // validate size
                BOOL    isSquare = YES;
                for (NSDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
                    CGSize size = CGSizeFromString([dictPhoto objectForKey:@"size"]);
                    if (size.width != size.height) {
                        isSquare = NO;
                        break;
                    }
                }
                
                if (!isSquare) {
                    if (!alertSquare) {
                            alertSquare = [[UIAlertView alloc] initWithTitle:nil message:@"Some images selected will be cropped into squares. Checkout the FAQ's for more info." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Go to FAQ",@"OK", nil];
                    }
                    [alertSquare show];
                    _isAlertSquare = NO;
                    return;
                }
                else
                {
                    for (NSMutableDictionary *dictPhoto in [dictGroup objectForKey:@"photos"])
                    {
                        [dictPhoto removeObjectForKey:@"size"];
                        
                    }

                }
            }
            else 
            {
                for (NSDictionary *dictPhoto in [dictGroup objectForKey:@"photos"])
                {
                    CGSize size = CGSizeFromString([dictPhoto objectForKey:@"size"]);
                    if (size.width == size.height)
                    {
                        alertSquare = [[UIAlertView alloc] initWithTitle:nil message:@"Square images are not suitable to be printed into a rectangular print" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Go to FAQ",@"OK", nil];
                        [alertSquare show];
                        _isAlertSquare = NO;
                        return;

                    }
                    
                    
                }
            }
            
        }
    }

}

#pragma mark paypal

-(void) setupPaypal {
    // Set up payPalConfig
    payPalConfig = [[PayPalConfiguration alloc] init];
    payPalConfig.acceptCreditCards = YES;
    payPalConfig.languageOrLocale = @"en";
    payPalConfig.merchantName = @"Pocket Print, Inc.";
    payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.successView.hidden = YES;
//    
//    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}

#pragma mark stripe

-(void) processWithStripeToken:(NSString*) transactionToken {
    OrderViewController *orderController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
    NSMutableArray *arrAllObjs = [NSMutableArray new];
    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
    [arrAllObjs addObjectsFromArray:arrGiftCert];
    orderController.paypal_token = @"";
    orderController.stripe_token = transactionToken;
    orderController.arrPhotoGroups = arrAllObjs;
    orderController.arrPromotions = arrCode;
    orderController.shippingCost = [[arrShippingCost objectAtIndex:0] objectForKey:@"price"];
    orderController.totalCost = [NSString stringWithFormat:@"%.2f",totalCheckout];
    [self.navigationController pushViewController:orderController animated:YES];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSDictionary *dictPay = completedPayment.confirmation;
    NSLog(@"PayPal Payment Success! wiht code %@",dictPay);
    _isAlertSquare = YES;
    //[[[UIAlertView alloc] initWithTitle:nil message:@"Payment success!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    RUN_ON_MAIN_QUEUE(^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                OrderViewController *orderController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
                NSMutableArray *arrAllObjs = [NSMutableArray new];
                [arrAllObjs addObjectsFromArray:arrPhotoGroups];
                [arrAllObjs addObjectsFromArray:arrGiftCert];
                orderController.paypal_token = [[dictPay objectForKey:@"response"] objectForKey:@"id"];
                orderController.stripe_token = @"";
                orderController.arrPhotoGroups = arrAllObjs;
                orderController.arrPromotions = arrCode;
                orderController.shippingCost = [[arrShippingCost objectAtIndex:0] objectForKey:@"price"];
                orderController.totalCost = [NSString stringWithFormat:@"%.2f",totalCheckout];
                [self.navigationController pushViewController:orderController animated:YES];
            }];
        });

    });


}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    //[[[UIAlertView alloc] initWithTitle:nil message:@"Payment cancel!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//    self.resultText = nil;
//    self.successView.hidden = YES;
//    [self dismissViewControllerAnimated:YES completion:nil];
    RUN_ON_MAIN_QUEUE(^{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    });

}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorization:(id)sender {
    
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:payPalConfig delegate:self];
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}

#pragma mark collection view delegate

#define CELL_WIDTH      300
#define CELL_HEIGHT     110
#define PHOTO_WIDTH     60
#define PHOTO_HEIGHT    60
//#define MAX_PHOTO_PER_LINE  7
#define LEFT_MARGIN     7

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 1) {
        return 40;
    }
    return 110;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // remove in database
    
    if (indexPath.section == 0) {
        NSMutableDictionary *dict = [arrPhotoGroups objectAtIndex:indexPath.row];
        [arrPhotoGroups removeObjectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationResetQuantity object:[dict objectForKey:@"product"] userInfo:nil];
    }
    else
    if (indexPath.section == 1) {
        [arrGiftCert removeObjectAtIndex:indexPath.row];
    }
    else
        [arrCode removeObjectAtIndex:indexPath.row];
    
    [tblView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableArray  *arrPromotion = [NSMutableArray new];
    
//    for (NSDictionary *dict in arrCode) {
//        if ([[dict objectForKey:@"isCoupon"] boolValue]) {
//            // coupon
//            [arrPromotion addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"code"],@"promotion_code",@"",@"voucher_email", nil]];
//        }
//        else
//            [arrPromotion addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"code"],@"promotion_code",[dict objectForKey:@"email"],@"voucher_email", nil]];
//    }
    
    NSMutableArray *arrAllObjs = [NSMutableArray new];
    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
    [arrAllObjs addObjectsFromArray:arrGiftCert];
    // preflight will update coupong it self
    [self preflight:arrAllObjs andPromoteCode:nil finishBlock:nil];
    
    if (arrPhotoGroups.count == 0 && arrGiftCert.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // update arrAlbums in Home
    //[[HomeViewController getShared] removeProductForRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return;
    }
    
    NSDictionary    *dict = [arrPhotoGroups objectAtIndex:indexPath.row];
    
    NSMutableArray  *arrPhotos = [dict objectForKey:@"photos"];
    
    // now we get the current possition
    UITableViewCell *cell = [tblView cellForRowAtIndexPath:indexPath];
    
    __block NSMutableArray  *arrMovingPhoto = [NSMutableArray array];
    
    int bigSize = 97;
    
    int topMargin = 64;
    int headerHeight =  60;
    
    for (UIImageViewWithData *aView in cell.contentView.subviews) {
        if ([aView isKindOfClass:[UIImageViewWithData class]]) {
            // process
            CGRect aRect= [cell.contentView convertRect:aView.frame toView:self.view];
            // create a rectangble

            UIImageView  *newView = [[UIImageView alloc] initWithFrame:aRect];
            newView.contentMode = UIViewContentModeScaleAspectFill;
            newView.clipsToBounds = YES;
            newView.backgroundColor = [UIColor redColor];
            newView.image = aView.image;
            // add
            [arrMovingPhoto addObject:newView];
            [(appDelegate).window addSubview:newView];
        }
    }
    
    // see if there are still image around ?
    // max is 12
    int maxPhoto =12;
    
    if (IS_IPHONE_6P) {
        maxPhoto = 24;
    }
    else if (IS_IPHONE_6) {
        maxPhoto = 15;
    }
    if (arrPhotos.count > arrMovingPhoto.count && arrMovingPhoto.count < maxPhoto) {
        int max = (maxPhoto > arrPhotos.count)?arrPhotos.count:maxPhoto;
        // copy 1st point
        UIView  *aView = [arrMovingPhoto objectAtIndex:0];
        int y = aView.frame.origin.y;
        for (int i = arrMovingPhoto.count; i < max; i++) {
            __block UIImageView  *newView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 10 +i*30, y, PHOTO_WIDTH, PHOTO_HEIGHT)];
            newView.contentMode = UIViewContentModeScaleAspectFill;
            newView.clipsToBounds = YES;
            newView.backgroundColor = [UIColor redColor];
            
            __block NSMutableDictionary *dictNewView = [arrPhotos objectAtIndex:i];
            UIImage *img = [dictNewView objectForKey:@"image"];
            if ([img isKindOfClass:[NSNull class]]) {
                newView.image = [UIImage imageNamed:@"default_img_small.png"];
                // add spinner
                __block UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                CGRect frame = spinner.frame;
                frame.origin.x = (newView.frame.size.width - frame.size.width ) /2;
                frame.origin.y = (newView.frame.size.height - frame.size.height ) /2;
                spinner.frame = frame;
                spinner.hidden = YES;
                [newView addSubview:spinner];
                [spinner startAnimating];
                [[Downloader sharedDownloader] downloadWithCacheURL:[dictNewView objectForKey:@"url"] allowThumb:NO andCompletionBlock:^(NSData *data) {
                    UIImage *imgTmp = [[UIImage alloc] initWithData:data];
                    
                    [dictNewView setObject:imgTmp forKey:@"image"];
                    RUN_ON_MAIN_QUEUE(^{
                        [UIView transitionWithView:newView
                                          duration:0.7f
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            newView.image = imgTmp;
                                        } completion:nil];
                        [spinner stopAnimating];
                    });
                    
                } andFailureBlock:^(NSError *error) {
                    DLog(@"fail to download image %@ %@",[dictNewView objectForKey:@"url"],error);
                    RUN_ON_MAIN_QUEUE(^{
                        [spinner stopAnimating];
                    });
                }];
            }
            else
                newView.image = img;
            
            // add
            [arrMovingPhoto addObject:newView];
            [(appDelegate).window addSubview:newView];
        }
    }
    
    int ITEMS_PER_ROW = 3;
    if (IS_IPHONE_6P) {
        ITEMS_PER_ROW = 4;
    }
    
    int bigGap = ((SCREEN_WIDTH - 20 - bigSize*ITEMS_PER_ROW) / (ITEMS_PER_ROW+1));;
    
    // now we caculate how the images fly around
    [UIView animateWithDuration:0.35 animations:^{
        for (UIView *aView in arrMovingPhoto) {
            int pos = (aView.frame.origin.x - LEFT_MARGIN - 10) / (PHOTO_WIDTH /2);
            //DLog(@"Post = %d",pos);
            CGRect rect = CGRectMake(10 + bigGap + (pos % ITEMS_PER_ROW)*(bigSize + bigGap), headerHeight + topMargin +1 + (pos / ITEMS_PER_ROW)*(bigSize+ bigGap), bigSize, bigSize);
            aView.frame = rect;
        }
    } completion:^(BOOL finished) {
        // notifiy now
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationFinishedFlyingImages object:nil];
        [UIView animateWithDuration:1 animations:^{
            for (UIView *aView in arrMovingPhoto) {
                aView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            for (UIView *aView in arrMovingPhoto) {
                [aView removeFromSuperview];
            }
            [arrMovingPhoto removeAllObjects];
        }];
    }];

    //return;
    SelectPhotoViewController   *selectPhotoController = [[SelectPhotoViewController alloc] initWithNibName:@"SelectPhotoViewController" bundle:[NSBundle mainBundle]];
    selectPhotoController.albumType = ALBUM_PHOTO;
    selectPhotoController.arrPhotos = [NSArray arrayWithObject:[arrPhotoGroups objectAtIndex:indexPath.row]];
    selectPhotoController.arrCart = arrPhotoGroups;

    selectPhotoController.sectionToMove = indexPath.row;
    selectPhotoController.isOrderPreview = YES;
    selectPhotoController.delegate = self;
    [self.navigationController pushViewController:selectPhotoController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return arrPhotoGroups.count;
            break;
        case 1:
            return arrGiftCert.count;
            break;
            
        case 2:
            return arrShippingCost.count;
            break;
            
        case 3:
            return arrCode.count;
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    
    
    // remove all contents
    for (UIView *aView in cell.contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    //config cell
    cell.backgroundColor = [UIColor clearColor] ;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // check for shipping and voucher
    if (indexPath.section >1) {
        // add background
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, tblView.frame.size.width , 30)];
        bgImgView.image = [UIImage imageNamed:@"white_frame_bg.png"];
        [cell.contentView addSubview:bgImgView];

        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 15, 240, 20)];
        
        lbTitle.textColor = UIColorFromRGB(0xe8320b);
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.font = [UIFont fontWithName:@"MuseoSans-300" size:14.0f];
        [cell.contentView addSubview:lbTitle];
        
        UILabel *lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(tblView.frame.size.width - 90, 15, 90-LEFT_MARGIN, 20)];
        
        lbPrice.textAlignment = NSTextAlignmentRight;
        lbPrice.textColor = [UIColor blackColor];
        lbPrice.font = [UIFont fontWithName:@"MuseoSans-300" size:14.0f];
        [cell.contentView addSubview:lbPrice];
        
        if (indexPath.section ==2) {
            NSDictionary    *dictShipping = [arrShippingCost objectAtIndex:indexPath.row];
            // shipping
            lbTitle.text = [dictShipping objectForKey:@"desc"];
            lbPrice.text = [dictShipping objectForKey:@"price"];
        }
        else {
            NSDictionary    *dictCode = [arrCode objectAtIndex:indexPath.row];
            // voucher
            lbTitle.text = [dictCode objectForKey:@"desc"];
            lbPrice.text = [dictCode objectForKey:@"price"];
        }
        
        return cell;
    };
    
    NSMutableArray  *arrObjs = (indexPath.section == 0)?arrPhotoGroups:arrGiftCert;
    
    NSMutableDictionary *dict = [arrObjs objectAtIndex:indexPath.row];
    Product *aProduct = [dict objectForKey:@"product"];
    
    // add background
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, tblView.frame.size.width , 100)];
    bgImgView.image = [UIImage imageNamed:@"white_frame_bg.png"];
    [cell.contentView addSubview:bgImgView];
    
    // add header now
    UILabel *lbSize = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, 20, 200, 12)];
    lbSize.text = [NSString stringWithFormat:@"%@ %@",aProduct.type,aProduct.size];//[dict objectForKey:@"desc"];
    if ([dict objectForKey:@"type"] && [[dict objectForKey:@"type"] isEqualToString:@"certificate"]) {
        lbSize.text = [NSString stringWithFormat:@"%@",aProduct.type];
    }
    lbSize.textColor = UIColorFromRGB(0xe8320b);
    lbSize.textAlignment = NSTextAlignmentLeft;
    lbSize.font = [UIFont fontWithName:@"MuseoSans-300" size:14.0f];
    [cell.contentView addSubview:lbSize];
    
    // add photo
    NSMutableArray *arrPhotos = [dict objectForKey:@"photos"];
    int counter = 0;
    for (NSDictionary *dictCounter in arrPhotos) {
        counter += [[dictCounter objectForKey:@"count"] intValue];
    }
    
    int quantity_set = [aProduct.quantity_set intValue];
    int leftQuantity = counter % quantity_set;
    int devide = counter / quantity_set + ((leftQuantity > 0)?1:0);
//
//    if (leftQuantity > 0) {
//        NSString *str = [NSString stringWithFormat:@"You've chose %d photos, and you can select %d more photos for the same price!",counter,leftQuantity];
//        [[[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//    }
    
    
    float price = [[[dict objectForKey:@"price"] substringFromIndex:1] floatValue];
    UILabel *lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(tblView.frame.size.width - 90, 20, 90-LEFT_MARGIN, 12)];
    float totalPrice = price * devide;
    if ([dict objectForKey:@"type"] && [[dict objectForKey:@"type"] isEqualToString:@"certificate"]) {
        lbPrice.text = [NSString stringWithFormat:@"$%.2f",[[dict objectForKey:@"gift_value"] floatValue]];
    }
    else
    lbPrice.text = [NSString stringWithFormat:@"$%.2f",totalPrice];
    lbPrice.textAlignment = NSTextAlignmentRight;
    lbPrice.textColor = [UIColor blackColor];
    lbPrice.font = [UIFont fontWithName:@"MuseoSans-300" size:14.0f];
    [cell.contentView addSubview:lbPrice];
    
    int MAX_PHOTO_PER_LINE = 7;
    
    if (IS_IPHONE_6P) {
        MAX_PHOTO_PER_LINE = 10;
    }
    else
        if (IS_IPHONE_6) {
            MAX_PHOTO_PER_LINE = 8;
        }
    int photoCount = (arrPhotos.count < MAX_PHOTO_PER_LINE)? arrPhotos.count:MAX_PHOTO_PER_LINE;
    for (int i=photoCount-1; i>=0; i--) {
//        if (i<arrPhotos.count) {
            __block NSMutableDictionary *dictImg = [arrPhotos objectAtIndex:i];
            // create image view
            __block UIImageViewWithData *photoView = [[UIImageViewWithData alloc] initWithFrame:CGRectMake(LEFT_MARGIN + i*(PHOTO_WIDTH/2), CELL_HEIGHT - LEFT_MARGIN - PHOTO_HEIGHT, PHOTO_WIDTH, PHOTO_HEIGHT)];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
        
        NSString *imgPath = [dictImg objectForKey:@"cropped_image"];
        UIImage *img = nil;
        
        if (imgPath == nil)
        {
            img = [dictImg objectForKey:@"image"];
        }
        else
        {
            img = [UIImage imageWithContentsOfFile:imgPath];
        }
        
        photoView.image = img;
        
        /*if ([img isKindOfClass:[NSNull class]]) {
            photoView.image = [UIImage imageNamed:@"default_img_small.png"];
            [photoView showSpiner:YES];
            [[Downloader sharedDownloader] downloadWithCacheURL:[dictImg objectForKey:@"url"] allowThumb:NO andCompletionBlock:^(NSData *data) {
                UIImage *imgTmp = [[UIImage alloc] initWithData:data];
                RUN_ON_MAIN_QUEUE(^{
                    [UIView transitionWithView:photoView
                                      duration:0.7f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        photoView.image = imgTmp;
                                    } completion:nil];
                    [photoView showSpiner:NO];
                });
                [dictImg setObject:imgTmp forKey:@"image"];
            } andFailureBlock:^(NSError *error) {
                DLog(@"error = %@",error);
                RUN_ON_MAIN_QUEUE(^{
                    [photoView showSpiner:NO];
                });
            }];
        }
        else {
            photoView.image = img;
        }*/
         
            // add
            [cell.contentView addSubview:photoView];
//        }
//        else
//        {
//            // insert bar
//            UIView  *topLineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_MARGIN + i*(PHOTO_WIDTH/2), CELL_HEIGHT - LEFT_MARGIN - PHOTO_HEIGHT, PHOTO_WIDTH, 1)];
//            topLineView.backgroundColor = UIColorFromRGB(0x929292);
//            
//            [cell.contentView addSubview:topLineView];
//            
//            UIView  *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_MARGIN + i*(PHOTO_WIDTH/2), CELL_HEIGHT - LEFT_MARGIN -1, PHOTO_WIDTH, 1)];
//            bottomLineView.backgroundColor = UIColorFromRGB(0x929292);
//            
//            [cell.contentView addSubview:bottomLineView];
//        }
    }
    
    // add tail
    //if (arrPhotos.count > photoCount) {
    if (![[dict objectForKey:@"type"] isEqualToString:@"certificate"]) {
        int photoMaxCount = (photoCount > MAX_PHOTO_PER_LINE)?MAX_PHOTO_PER_LINE:photoCount;
        UIImageView *tailView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN + (photoMaxCount+1)*(PHOTO_WIDTH/2), CELL_HEIGHT - LEFT_MARGIN - PHOTO_HEIGHT, 47, 60)];
        tailView.image = [[UIImage imageNamed:@"grey_frame.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        [cell.contentView addSubview:tailView];
        
        int photoCounter = 0;

        for (NSMutableDictionary *dictPhoto in arrPhotos) {
            
            if ([[dictPhoto objectForKey:@"count"] intValue] > 0) {
                photoCounter += [[dictPhoto objectForKey:@"count"] intValue];
            }
        }
        
        UILabel *lbMorePhotos = [[UILabel alloc] initWithFrame:CGRectMake(2+LEFT_MARGIN + (photoMaxCount+1)*(PHOTO_WIDTH/2), CELL_HEIGHT - LEFT_MARGIN - PHOTO_HEIGHT, 43, 60)];
        //lbMorePhotos.backgroundColor = [UIColor clearColor];
        lbMorePhotos.font = [UIFont fontWithName:@"MuseoSans-300" size:10];
        lbMorePhotos.textColor = [UIColor lightGrayColor];
        lbMorePhotos.textAlignment = NSTextAlignmentCenter;
        lbMorePhotos.numberOfLines = 0;
        //lbMorePhotos.text = [NSString stringWithFormat:@"%d More Photos",arrPhotos.count - photoCount];
        lbMorePhotos.text = [NSString stringWithFormat:@"%d Photo%@ Total \rTap to review",photoCounter,(photoCounter>1)?@"s":@""];
        [cell.contentView addSubview:lbMorePhotos];
    }

    
    [cell sendSubviewToBack:cell.backgroundView];
    return cell;
}

#pragma mark actions
-(void) touchEdit {
    //tblView.editing = YES;
    [tblView setEditing:!tblView.editing animated:YES];
    if (tblView.editing) {
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchEdit)];
        [btnDone setTintColor:[UIColor redColor]];
        [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil]  forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = btnDone;
    }
    else {
        
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(touchEdit)];
        [btnEdit setTintColor:[UIColor redColor]];
        [btnEdit setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil]  forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = btnEdit;
    }
}

-(void) touchInvoice {
    // block
    UIBarButtonItem *btnItem = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;
    [self.view enableLoadingModeWithOpacity:0.8f];
    // preflight again
    NSMutableArray *arrAllObjs = [NSMutableArray new];
    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
    [arrAllObjs addObjectsFromArray:arrGiftCert];
    
     // no need to update new code
    NSLog(@"%@",dictPromote);
    if (dictPromote)
    {
        [self preflight:arrAllObjs andPromoteCode:[NSArray arrayWithObject:dictPromote] finishBlock:^(BOOL finished) {
            [self.view disableLoadingMode];
            self.navigationItem.rightBarButtonItem = btnItem;
            if (finished) {
                
                [self processPayment];
            }
        }];

    }
    else
    {
        [self preflight:arrAllObjs andPromoteCode:nil finishBlock:^(BOOL finished) {
            [self.view disableLoadingMode];
            self.navigationItem.rightBarButtonItem = btnItem;
            if (finished) {
                
                [self processPayment];
            }
        }];
 
    }
   
    
    

    
    //return;
    // Remove our last completed payment, just for demo purposes.
    //self.resultText = nil;
    
//    PayPalPayment *payment = [[PayPalPayment alloc] init];
//    payment.amount = [[NSDecimalNumber alloc] initWithString:@"9.95"];
//    payment.currencyCode = @"USD";
//    payment.shortDescription = @"Pocket print 25 photos";
//    
//    if (!payment.processable) {
//        // This particular payment will always be processable. If, for
//        // example, the amount was negative or the shortDescription was
//        // empty, this payment wouldn't be processable, and you'd want
//        // to handle that here.
//    }
//    
//    // Update payPalConfig re accepting credit cards.
//    payPalConfig.acceptCreditCards = YES;
//    
//    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
//                                                                                                configuration:payPalConfig
//                                                                                                     delegate:self];
//    [self presentViewController:paymentViewController animated:YES completion:nil];
}

-(void) processPayment {
    RUN_ON_MAIN_QUEUE(^{
        // cehck for address
        NSString    *sql = @"SELECT * FROM shipping_addr";
        NSArray *arr = [[SqlManager defaultShare] doQueryAndGetArray:sql];
        if (arr.count == 0) {
            // go direct to address
            ShippingAddressViewController   *shippingAddrController = [[ShippingAddressViewController alloc] initWithNibName:@"ShippingAddressViewController" bundle:[NSBundle mainBundle]];
            shippingAddrController.delegate = self;
            [self.navigationController pushViewController:shippingAddrController animated:YES];
            return;
        }
        // call Shipping
        ShippingAddressManagerViewController    *shippingManager = [[ShippingAddressManagerViewController alloc] initWithNibName:@"ShippingAddressManagerViewController" bundle:[NSBundle mainBundle]];
        shippingManager.enableOrder= YES;
        shippingManager.arrPhotoGroups = arrPhotoGroups;
        shippingManager.delegate = self;
        [self.navigationController pushViewController:shippingManager animated:YES];
    });
    
    // for testing order placed only
    /*OrderViewController *orderController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
    NSMutableArray *arrAllObjs = [NSMutableArray new];
    [arrAllObjs addObjectsFromArray:arrPhotoGroups];
    [arrAllObjs addObjectsFromArray:arrGiftCert];
    orderController.paypal_token = @"";
    orderController.arrPhotoGroups = arrAllObjs;
    orderController.arrPromotions = arrCode;
    orderController.shippingCost = [[arrShippingCost objectAtIndex:0] objectForKey:@"price"];
    orderController.totalCost = [NSString stringWithFormat:@"%.2f",totalCheckout];
    [self.navigationController pushViewController:orderController animated:YES];*/

}

-(IBAction) touchCoupon {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your Coupon or Voucher code" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    tfCoupon = [alertView textFieldAtIndex:0];
    tfCoupon.text = @"";
    [alertView show];
}

#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertSquare) {
        if (buttonIndex == 0) {
            // go to FAQ
            [appDelegate goToTab:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MoreViewController *moreController = [MoreViewController getShared];
                [moreController touchFAQ];
            });

        }
        else if (buttonIndex == 1)
        {
           
        }
        return;
    }
    
    if (alertView == alertViewWrongEmail) {
        alertViewEmail = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Please enter your voucher email for voucher %@",lastCheckCoupon] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertViewEmail.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertViewEmail show];
        
        return;
    }
    
    if (alertView == alertViewEmail) {
        dictPromote = [NSDictionary dictionaryWithObjectsAndKeys:lastCheckCoupon,@"promotion_code",[alertViewEmail textFieldAtIndex:0].text,@"voucher_email", nil];
        if (arrPhotoGroups.count == 0 && arrGiftCert.count == 0) {
            [self addPromotionCode:[NSArray arrayWithObject:dictPromote] ];
            return;
        }
        
        NSMutableArray *arrAllObjs = [NSMutableArray new];
        [arrAllObjs addObjectsFromArray:arrPhotoGroups];
        [arrAllObjs addObjectsFromArray:arrGiftCert];
        [self preflight:arrAllObjs andPromoteCode:[NSArray arrayWithObject:dictPromote] finishBlock:nil];
        return;
    }
    
    if (buttonIndex ==1) {
        if (tfCoupon.text != nil && tfCoupon.text.length !=0) {
            lastCheckCoupon = tfCoupon.text;
            dictPromote = [NSDictionary dictionaryWithObjectsAndKeys:tfCoupon.text,@"promotion_code",@"",@"voucher_email", nil];
            if (arrPhotoGroups.count == 0 && arrGiftCert.count == 0) {
                // no order items
                
                [self addPromotionCode:[NSArray arrayWithObject:dictPromote] ];
                return;
            }
            // process coupon here
            NSMutableArray *arrAllObjs = [NSMutableArray new];
            [arrAllObjs addObjectsFromArray:arrPhotoGroups];
            [arrAllObjs addObjectsFromArray:arrGiftCert];
            [self preflight:arrAllObjs andPromoteCode:[NSArray arrayWithObject:dictPromote] finishBlock:nil];
        }
    }

   
    
}

#pragma mark shipping address delegate
-(void) showPaymentMedthod {
//    [self.navigationController popViewControllerAnimated:YES];
    if (totalCheckout == 0) {
        // no need to make any payment
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            OrderViewController *orderController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
            NSMutableArray *arrAllObjs = [NSMutableArray new];
            [arrAllObjs addObjectsFromArray:arrPhotoGroups];
            [arrAllObjs addObjectsFromArray:arrGiftCert];
            orderController.paypal_token = @"NO PAYMENT";
            orderController.stripe_token = @"";
            orderController.arrPhotoGroups = arrAllObjs;
            orderController.arrPromotions = arrCode;
            orderController.shippingCost = [[arrShippingCost objectAtIndex:0] objectForKey:@"price"];
            orderController.totalCost = [NSString stringWithFormat:@"%.2f",totalCheckout];
            [self.navigationController pushViewController:orderController animated:YES];

        });
        return;
    }
    
    [UIAlertView showWithTitle:@"Pay Now" message:@"Would you like to pay by Credit Card or PayPal?" style:UIAlertViewStyleDefault cancelButtonTitle:nil otherButtonTitles:@[@"Credit Card",@"Paypal",@"Cancel"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            StripeViewController    *stripeController = [[StripeViewController alloc] initWithNibName:@"StripeViewController" bundle:[NSBundle mainBundle]];
            stripeController.delegate = self;
            stripeController.price = [NSString stringWithFormat:@"%.2f",totalCheckout];
            [self.navigationController pushViewController:stripeController animated:YES];
            
        }
        else
            if (buttonIndex == 1) {
                //paypal
                [self showPaypal];
            }
    }];
}

- (void) showPaypal {
    if (totalCheckout <= 0) {
        // move direct to done
        RUN_ON_MAIN_QUEUE((^{
            OrderViewController *orderController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
            NSMutableArray *arrAllObjs = [NSMutableArray new];
            [arrAllObjs addObjectsFromArray:arrPhotoGroups];
            [arrAllObjs addObjectsFromArray:arrGiftCert];
            orderController.arrPhotoGroups = arrAllObjs;
            orderController.arrPromotions = arrCode;
            orderController.shippingCost = [[arrShippingCost objectAtIndex:0] objectForKey:@"price"];
            orderController.totalCost = [NSString stringWithFormat:@"%.2f",totalCheckout];
            [self.navigationController pushViewController:orderController animated:YES];
        }));
        return;
    }
    
    // get data
//    NSError *error = nil;
//    NSString *currencyConversion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://download.finance.yahoo.com/d/quotes.csv?s=AUDUSD=X&f=nl1d1t1"] encoding:NSUTF8StringEncoding error:&error];
//    float currRatio = [[currencyConversion componentsSeparatedByString:@","][1] floatValue];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%.2f",totalCheckout]];
    payment.currencyCode = @"AUD";
    payment.shortDescription = @"Pocket Prints Total";//[NSString stringWithFormat:@"Pocket Print $%.2f AUS",totalCheckout];
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    payPalConfig.acceptCreditCards = NO;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:payPalConfig
                                                                                                     delegate:self];
    [self.navigationController presentViewController:paymentViewController animated:YES completion:^{
        //UIViewController *controller = paymentViewController.visibleViewController;
        //[self iterateSubViewsForView:controller.view andPriceStr:[NSString stringWithFormat:@"$%.2f",currRatio*totalCheckout]];
    }];
    //[self.navigationController pushViewController:paymentViewController.visibleViewController animated:YES];
    
    // search for controller
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIViewController *controller = paymentViewController.visibleViewController;
//        [self iterateSubViewsForView:controller.view andPriceStr:[NSString stringWithFormat:@"$%.2f",totalCheckout]];
//    });
    
}


-(void) iterateSubViewsForView:(UIView*) aView andPriceStr:(NSString*) priceStr{
    for (UIView *view in aView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            // print it
            UILabel *lb = (UILabel*) view;
            //DLog(@"==>>%@",lb);
            if ([lb.text isEqualToString:priceStr]) {
                lb.text = [lb.text stringByAppendingString:@" USD"];
                // terminate
                return;
            }
        }
        else
            [self iterateSubViewsForView:view andPriceStr:priceStr];
    }
    DLog(@"==> end iterate");
}

@end
