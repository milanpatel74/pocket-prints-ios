//
//  ShippingAddrCell.h
//  PocketPrint
//
//  Created by Quan Do on 3/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShippingAddrCell;

@protocol ShippingAddrCellDelegate <NSObject>

-(void) editShippingCellForCell:(ShippingAddrCell*) aCell;
-(void) setDefaultAddr:(ShippingAddrCell*) aCell enable:(BOOL) aEnable ;
@end

@interface ShippingAddrCell : UITableViewCell {
    IBOutlet    UILabel *lbShip;
    
}

@property   (nonatomic) IBOutlet UILabel *lbName, *lbAddr, *lbSuburb, *lbCompany;
@property   (nonatomic,weak) IBOutlet UIImageView    *bgView;
@property   (nonatomic) IBOutlet    UIButton    *btnEdit;
@property   (nonatomic,weak) id<ShippingAddrCellDelegate> delegate;
@property   (nonatomic) IBOutlet    UIView  *defaultView;
@property   (nonatomic,strong) id data;
@property   (nonatomic) IBOutlet    UIButton    *btnDefaultAddr;

-(void) setEnable:(BOOL) enabled;
-(IBAction) touchEdit;
//-(IBAction) touchDefault:(UIButton*) aButton;
@end
