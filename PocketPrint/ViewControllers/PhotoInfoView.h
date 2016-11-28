//
//  PhotoInfoController.h
//  PocketPrint
//
//  Created by Quan Do on 11/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomizePageControl.h"
#import "Product.h"

@interface PhotoInfoView : UIView <UIScrollViewDelegate> {
    NSUInteger kNumberOfPages, kAction, kCurrentPage;
    NSMutableArray *viewControllers;
    IBOutlet    CustomizePageControl   *pageControl;
    IBOutlet    UILabel *lbSize, *lbPrice;
    IBOutlet    UITextView  *tvDesc;
    Product     *product;
}

@property   (nonatomic, strong) IBOutlet UIScrollView    *scrollView;
@property   (nonatomic, strong) NSMutableArray  *arrPhotos;


- (void)loadScrollViewWithPage:(int)page;
-(void) goToPage:(int) page;
-(void) loadDataForProduct:(Product*) aProduct;
@end
