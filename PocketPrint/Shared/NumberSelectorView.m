//
//  NumberSelectorView.m
//  PocketPrint
//
//  Created by Quan Do on 21/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "NumberSelectorView.h"

@implementation NumberSelectorView


- (id) initWithFrame:(CGRect)frame andStyle:(SELECTOR_STYLE) aSelectorStyle {
    self = [super initWithFrame:frame];
    if (self) {
        //reset
        _value = -1;
        // Initialization code
        [self initGUI:aSelectorStyle];
    }
    return self;
}

#define MAX_NUMBER  100

-(void) initGUI:(SELECTOR_STYLE) aSelectorStyle {
    self.autoresizesSubviews = NO;
    _selectorStyle = aSelectorStyle;
    imgViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 101, 157)];
    if (aSelectorStyle == SELECTOR_BIG) {
        imgViewBackground.image = [UIImage imageNamed:@"frame_w_right_arrow.png"];
        
    }
    else
        imgViewBackground.image = [UIImage imageNamed:@"frame_w_center_arrow.png"];
    
    [self addSubview:imgViewBackground];
    // data
    arrNumbers = [[NSMutableArray alloc] init];
    for (int i=0; i<MAX_NUMBER; i++) {
        [arrNumbers addObject:[NSString stringWithFormat:@"%d",i]];
    }
    // table view
    tblView = [[UITableView alloc] initWithFrame:CGRectMake(7, 14, 88, 136)];
    tblView.backgroundColor = [UIColor clearColor];
    tblView.delegate = self;
    tblView.dataSource = self;
    tblView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tblView.showsVerticalScrollIndicator = NO;
    [tblView reloadData];
    [self addSubview:tblView];
}

#pragma mark collection view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate selectedNumber:[[arrNumbers objectAtIndex:indexPath.row] intValue]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *aView in cell.contentView.subviews) {
        if ([aView isKindOfClass:[UILabel class]]) {
            [aView removeFromSuperview];
        }
        
    }
    
    UILabel *lbNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 88, 45)];
    lbNumber.text = [arrNumbers objectAtIndex:indexPath.row];
    lbNumber.backgroundColor = [UIColor clearColor];
    lbNumber.textColor = (_value == [lbNumber.text intValue])?[UIColor redColor]:[UIColor lightGrayColor];
    lbNumber.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lbNumber];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView  *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 68)];
//    containerView.backgroundColor = self.view.backgroundColor;
//
//    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, tblView.frame.size.width, 50)];
//    headerView.backgroundColor = [UIColor whiteColor];
//
//    [containerView addSubview:headerView];
//
//    return containerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 68;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return arrPhotoGroups.count;
//}


#pragma mark delegate

#pragma mark utilities
-(void) setSelectorStyle:(SELECTOR_STYLE )selectorStyle {
    _selectorStyle = selectorStyle;
    if (selectorStyle == SELECTOR_BIG) {
        imgViewBackground.image = [UIImage imageNamed:@"frame_w_right_arrow.png"];
        
    }
    else
        imgViewBackground.image = [UIImage imageNamed:@"frame_w_center_arrow.png"];
    
}

-(void) setValue:(int) value {
    _value = value;
    // reset
    [tblView reloadData];
    
    // move to the right one
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:value inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
@end
