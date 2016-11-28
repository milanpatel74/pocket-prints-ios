//
//  OrderViewController.h
//  PocketPrint
//
//  Created by Quan Do on 8/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : AppViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet    UITableView *tblView;
    NSMutableArray  *arrPhotos;
    IBOutlet    UILabel *lbShip, *lbName, *lbSuburb,*lbAddr, *lbInfo, *lbCompany;
    IBOutlet    UIScrollView    *scrollView;
    BOOL cropped;
}

@property (nonatomic,strong) NSArray   *arrPhotoGroups;
@property  (nonatomic,strong) NSArray  *arrAddrs;
@property   (nonatomic,strong) NSArray *arrPromotions;
@property   (nonatomic,strong) NSString *shippingCost;
@property   (nonatomic,strong) NSString *totalCost;
@property   (nonatomic,strong) NSString *paypal_token;
@property   (nonatomic,strong) NSString *stripe_token;
@end
