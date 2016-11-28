//
//  LightBlueView.m
//  AuSkill
//
//  Created by Minh Quan on 9/10/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import "LightBlueView.h"

@implementation LightBlueView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect  frame = self.frame;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imgView.image = [[UIImage imageNamed:@"blue_bar.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:25];
    [self addSubview:imgView];
    [self sendSubviewToBack:imgView];
}


@end
