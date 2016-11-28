//
//  DarkBlueView.m
//  AuSkill
//
//  Created by Minh Quan on 9/10/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import "DarkBlueView.h"

@implementation DarkBlueView

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
    imgView.image = [[UIImage imageNamed:@"dark_blue_title_bar.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:15];
    [self addSubview:imgView];
    [self sendSubviewToBack:imgView];
}


@end
