//
//  SquarePrintView.h
//  PocketPrint
//
//  Created by Quan Do on 11/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SquarePrintProtocol <NSObject>

-(void) touchPhotoInfo:(id) aPhoto ;
-(void) touchPhoto:(id) aPhoto;
@end

@interface SquarePrintView : UIView {
    UIImageView *imgView;
    UIActivityIndicatorView *spinner;
    UIView  *viewContainer;
}

@property   (nonatomic,strong,setter = setImage:) UIImage  *image;
@property   (nonatomic,strong,readonly) UILabel *lbTitle, *lbSize, *lbPrice;
@property   (nonatomic,weak) id<SquarePrintProtocol> delegate;
@property   (nonatomic) int pageIndex;

-(SquarePrintView*)standardInit;
-(void) touchShowInfo;
-(void) showSpiner:(BOOL) isShow;
-(void) activateGiftCertificate;
@end
