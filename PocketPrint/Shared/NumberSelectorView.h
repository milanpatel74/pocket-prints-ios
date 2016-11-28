//
//  NumberSelectorView.h
//  PocketPrint
//
//  Created by Quan Do on 21/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberSelectorViewProtocol <NSObject>

-(void) selectedNumber:(int) aNumber;

@end

typedef enum SELECTOR_STYLE   {
    SELECTOR_SMALL,
    SELECTOR_BIG
} SELECTOR_STYLE;

@interface NumberSelectorView : UIView <UITableViewDataSource, UITableViewDelegate>{
    UIImageView *imgViewBackground;
    UITableView *tblView;
    NSMutableArray *arrNumbers;
}

@property   (nonatomic,weak) UIViewController <NumberSelectorViewProtocol> *delegate;
@property   (nonatomic) SELECTOR_STYLE  selectorStyle;
@property   (nonatomic) int     value;

- (id) initWithFrame:(CGRect)frame andStyle:(SELECTOR_STYLE) aSelectorStyle;
@end
