//
//  STPViewExt.m
//  PocketPrint
//
//  Created by Quan Do on 30/08/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "STPViewExt.h"

@implementation STPViewExt

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// over ride
- (void)setupViews;
{
    self.paymentView = [[PKViewExt alloc] initWithFrame:CGRectMake(15, 0, 290, 55)];
    self.paymentView.delegate = self;
    [self addSubview:self.paymentView];
    
    // add background
    UIImageView *imgViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stripe_info_bar.png"]];
    [imgViewBackground setFrameWidth:self.frame.size.width];
    [self.paymentView setXPos:(self.frame.size.width - self.paymentView.frame.size.width)/2];
    [self addSubview:imgViewBackground];
    [self sendSubviewToBack:imgViewBackground];
    CGRect frame= imgViewBackground.frame;
    frame.origin.y = -2;
    imgViewBackground.frame = frame;
}

@end
