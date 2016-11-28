//
//  ShippingAddressManagerViewController.h
//  PocketPrint
//
//  Created by Quan Do on 27/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingAddrCell.h"

@protocol ShippingAddressManagerViewControllerDelegate <NSObject>

-(void) showPaymentMedthod;

@end

@interface ShippingAddressManagerViewController : AppViewController <UITableViewDataSource, UITableViewDataSource, ShippingAddrCellDelegate> {
    IBOutlet    UITableView *tblView;
    NSMutableArray  *arrAddrs;
}

@property   (nonatomic) BOOL    enableOrder;
@property   (nonatomic,weak)    NSMutableArray  *arrPhotoGroups;
@property   (nonatomic,weak)    id<ShippingAddressManagerViewControllerDelegate> delegate;
@property (nonatomic)   BOOL    noCoachmark;


@end
