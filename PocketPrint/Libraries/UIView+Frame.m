//
//  UIView+Frame.m
//  SHOK
//
//  Created by Quan Do on 25/06/2014.
//  Copyright (c) 2014 Appiphany. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView(Frame)

-(void) setXPos:(float) xPos {
    CGRect frame = self.frame;
    frame.origin.x = xPos;
    self.frame = frame;
}

-(void) setYPos:(float) yPos {
    CGRect frame = self.frame;
    frame.origin.y = yPos;
    self.frame = frame;
}

-(void) setFrameWidth:(float) aWidth {
    CGRect frame = self.frame;
    frame.size.width = aWidth;
    self.frame = frame;
}

-(void) setFrameHeight:(float) aHeight {
    CGRect frame = self.frame;
    frame.size.height = aHeight;
    self.frame = frame;
}

-(void) setFrameSize:(CGSize) aSize {
    [self setFrameWidth:aSize.width];
    [self setFrameHeight:aSize.height];
}
@end
