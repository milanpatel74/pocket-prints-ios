//
//  UIButtonWithData.m
//  PocketPrint
//
//  Created by Quan Do on 10/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "UIButtonWithData.h"

@implementation UIButtonWithData

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.indexColumn = -1;
        self.indexPath = nil;
        
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

@end
