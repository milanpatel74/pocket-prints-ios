//
//  AppViewController.h
//  Bootylicious
//
//  Created by luongnguyen on 9/27/12.
//  Copyright (c) 2012 luongnguyen. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppViewController : UIViewController
{
    UIBarButtonItem *_backBarBtnItem, *_doneBarBtnItem;
    NSMutableDictionary * _handlers;
    
    NSString *_navTitle;
    UIImageView *bgLogoImgView;
    UILabel *lbBgLogo;

}

//--------------------------------------------------
//  MAIN
//--------------------------------------------------
//- (void) setNavigationTitle:(NSString*)title;
//- (void) setNavigationImage:(UIImage *)image;
-(void) setScreenTitle:(NSString *)aTitle;
-(void) setScreenTitle:(NSString *)aTitle withColor:(UIColor*) aColor;
- (void) setHandlerOnBack:(void(^)(void))onBack andOnDone:(void(^)(void))onDone;

- (UIBarButtonItem *) setCustomButtonWithImageNormalState:(UIImage*) imgNormalState
                                  withImageHighlightState:(UIImage*) imgHighlightState
                                          withButtonWidth:(NSNumber*) btnWidth
                                               withTarget:(id) target
                                              forSelector:(SEL) aSelector;

- (UIBarButtonItem *) setCustomButtonWithImageNormalState:(UIImage*) imgNormalState
                                  withImageHighlightState:(UIImage*) imgHighlightState
                                          withButtonWidth:(NSNumber*) btnWidth
                                                withTitle:(NSString *) title
                                               withTarget:(id) target
                                              forSelector:(SEL) aSelector;
-(void) doGoBack;
-(void) touchListBtn;
-(void) addBackButton;
-(void) addBackButtonWithWidth:(int) width;
-(void) addListButton;
-(void) enableKeyboardListerner;
@end
