//
//  UIImageViewWithData.h
//  PocketPrint
//
//  Created by Quan Do on 20/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewWithData : UIImageView {
    UIActivityIndicatorView *spinner;
    UIImageView *imgViewBorder;
}

// need to keep reference
@property (nonatomic,strong)    id data;
-(void) showSpiner:(BOOL) isShow;
//-(void) activateBorder:(BOOL) allowBorder;

@end
