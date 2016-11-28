//
//  ACStatusBarOverlayWindow.h
//  Notr
//
//  Created by Minh Quan on 6/09/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACStatusBarOverlayWindow : UIWindow {
    UIView  *msgView;
}

-(void) enableMsg:(BOOL) enable;
@end
