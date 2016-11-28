//
//  HomeViewController.h
//  PocketPrint
//
//  Created by Quan Do on 3/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizePageControl.h"
#import "SquarePrintView.h"
#import "PhotoInfoView.h"
#import "Product.h"
#import "Constants.h"
#import "SelectPhotoAlbumViewController.h"
#import "GiftCertificateInfoViewController.h"
#import "MoreViewController.h"

@interface HomeViewController : AppViewController <UIScrollViewDelegate, SquarePrintProtocol,GiftCertificateInfoViewControllerProtocol> {
    IBOutlet    UIScrollView    *scrollView;
    NSUInteger kNumberOfPages, kAction, kCurrentPage;
    NSMutableArray *viewControllers,*arrEmails;
    IBOutlet    CustomizePageControl   *pageControl;
    IBOutlet PhotoInfoView  *flipView;
    IBOutlet    UIView  *containerView;
    
    // info view
    IBOutlet    UILabel *lbSize, *lbPrice;
    IBOutlet    UIImageView *imgPhoto;
    IBOutlet    UITextView  *tvDesc;
    NSMutableArray *arrAlbums;
    NSMutableArray     *arrGiftCerts;
        BOOL isByPassMorePhotos;
    NSMutableArray  *arrProductPermission;
    int lastKey;
    NSMutableArray *hashTagDataArray;
    NSMutableArray *hashTagSquares, * hashTagBigSquares, *hashTagMiniSquares, * hashTagRectagles ,*hashTagMetalPrints, * hashTagPhotoBlocks;
    int   currentPage;
    UIAlertView *alertSquare;
}

@property   (nonatomic,strong) NSMutableArray   *arrProducts;
@property   (nonatomic,readonly) Product    *currentProduct,*lastProduct;

+(HomeViewController*) getShared;

-(void) doCheckOut;
-(void) clearAllOrders;
-(int) countAllSelectedPhotos:(Product*) aProduct;
- (void)showTabBar;
-(void) uploadCacheImages:(NSArray*) aArrImgs;
-(void) removeProductForRow:(int)row;
-(void) addToCart:(Product*) aProduct;
-(CGSize) getPhotoSizeFromProductId:(NSString*) productID;
-(void) reloadCoachmark;
-(void) loadProductList;
@end
