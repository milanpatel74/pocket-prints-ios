//
//  UIButtonWithData.h
//  PocketPrint
//
//  Created by Quan Do on 10/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum {
    BUTTON_HEADER,
    BUTTON_RIGHT,
    BUTTON_NORMAL
} BUTTON_TAG;

@interface UIButtonWithData : UIButton

@property   (nonatomic,strong)  NSMutableDictionary *data;
@property   (nonatomic,strong)  NSMutableDictionary *dataContainer;
@property   (nonatomic,strong)  id object;
@property   (nonatomic) BUTTON_TAG buttonTag;

@property   (nonatomic,strong)  UIButton *croppingIcon;

@property   (nonatomic,strong) NSIndexPath *indexPath;

@property   (nonatomic, assign) NSInteger indexColumn;
@property   (nonatomic,strong) NSDictionary *photoDict;

@end
