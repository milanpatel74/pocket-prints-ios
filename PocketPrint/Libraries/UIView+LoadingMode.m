//
//  UIView+LoadingMode.m
//  Socialite
//
//  Created by Quan Do on 28/07/2014.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import "UIView+LoadingMode.h"

@implementation UIView(LoadingMode)

#define VIEW_TAG    99999

-(void) enableLoadingModeWithOpacity:(float) opacityLevel{
    if ([self viewWithTag:VIEW_TAG]) {
        // do nothing
        return;
    }
    
    // make it opacity 50%
    UIView *viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    viewMask.tag = VIEW_TAG;
    viewMask.backgroundColor = [UIColor whiteColor];
    viewMask.userInteractionEnabled = YES;
    viewMask.alpha = opacityLevel;
    [self addSubview:viewMask];
    
    // add spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //size is 20x20
    spinner.frame = CGRectMake(viewMask.frame.size.width / 2 - 10, viewMask.frame.size.height / 2 - 10, 20, 20);
    [spinner startAnimating];
    [viewMask addSubview:spinner];
}

-(void) disableLoadingMode {
    UIView *view = [self viewWithTag:VIEW_TAG];
    if (view) {
        view.hidden = YES;
        [view removeFromSuperview];
    }
}
@end
