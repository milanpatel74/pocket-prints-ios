//
//  ACStatusBarOverlayWindow.m
//  Notr
//
//  Created by Minh Quan on 6/09/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import "ACStatusBarOverlayWindow.h"

@implementation ACStatusBarOverlayWindow

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar+1.0f;
        //self.frame = [[UIApplication sharedApplication] statusBarFrame];
        
        // Create an image view with an image to make it look like a status bar.
        msgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        msgView.backgroundColor = [UIColor blackColor];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont boldSystemFontOfSize:10];
        lb.textColor = [UIColor whiteColor];
        lb.text = @"Sending";
        lb.textAlignment = NSTextAlignmentCenter;
        [msgView addSubview:lb];
        
        UIActivityIndicatorView *actvityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [actvityView startAnimating];
        actvityView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        CGRect activityFrame = actvityView.frame;
        activityFrame.origin.x = 185;
        actvityView.frame = activityFrame;
        
        [msgView addSubview:actvityView];
        msgView.hidden = YES;
        [self addSubview:msgView];
        
        // TODO: Insert subviews (labels, imageViews, etc...)
    }
    return self;
}

-(void) enableMsg:(BOOL) enable {
    msgView.hidden = !enable;
}
@end