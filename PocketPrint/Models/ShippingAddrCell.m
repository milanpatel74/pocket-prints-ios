//
//  ShippingAddrCell.m
//  PocketPrint
//
//  Created by Quan Do on 3/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "ShippingAddrCell.h"

@implementation ShippingAddrCell

- (void)awakeFromNib
{
    // Initialization code
    _lbAddr.font = _lbName.font = _lbSuburb.font = [UIFont fontWithName:@"MuseoSans-300" size:17];
    lbShip.font = [UIFont fontWithName:@"MuseoSans-500" size:16];
    _lbAddr.autoresizingMask = _lbName.autoresizingMask = _lbSuburb.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setEnable:(BOOL) enabled {
//    if (enabled) {
//        //_bgView.image = [UIImage imageNamed:@"red_bg_content.png"];
//        _bgView.image = [UIImage imageNamed:@"white_bg_content.png"];
//        //defaultView.hidden = NO;
//        lbShip.hidden = NO;
//        // color
//        _lbAddr.textColor = _lbName.textColor = _lbSuburb.textColor = [UIColor whiteColor];
//        [_btnEdit setImage:[UIImage imageNamed:@"edit_icon_white.png"] forState:UIControlStateNormal];
//    }
//    else {
        _bgView.image = [UIImage imageNamed:@"white_bg_content.png"];
        //defaultView.hidden = YES;
        _lbName.textColor = UIColorFromRGB(0xe8320b);
        _lbAddr.textColor = _lbCompany.textColor = _lbSuburb.textColor = [UIColor blackColor];
        [_btnEdit setImage:[UIImage imageNamed:@"edit_icon_red.png"] forState:UIControlStateNormal];
        lbShip.hidden = YES;
//    }
    
}

-(IBAction) touchEdit {
    [_delegate editShippingCellForCell:self];
}

-(IBAction) touchDefault: (UIButton*) aButton {
    [_btnDefaultAddr setImage:[UIImage imageNamed:@"star_icon_new_solid.png"] forState:UIControlStateNormal];
    [_delegate setDefaultAddr:self enable:!lbShip.hidden];
}
@end
