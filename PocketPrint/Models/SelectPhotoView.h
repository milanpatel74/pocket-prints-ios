//
//  SelectPhotoView.h
//  PocketPrint
//
//  Created by Quan Do on 12/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectPhotoView;

@protocol SelectPhotoDelegate <NSObject>

-(void) touchPhoto:(id) aPhotoView;
-(void) touchNumber:(SelectPhotoView*) aPhotoView;
-(void) touchFrame:(SelectPhotoView*) aPhotoView;
@end

@interface SelectPhotoView : UIView {
    IBOutlet    UIImageView *frameView;
    UIActivityIndicatorView *spinner;
}

@property   (nonatomic,strong) IBOutlet UILabel *lbGroupName, *lbNumberOfPhotos;
@property   (nonatomic,strong) IBOutlet UIImageView *imgView;
@property   (nonatomic, weak)  id<SelectPhotoDelegate> delegate;
@property   (nonatomic,strong)  NSDictionary    *data;
@property   (nonatomic,weak) IBOutlet   UIButton    *btnNumber;
@property   (nonatomic) BOOL    isLeftCell;
@property   (nonatomic,weak)    IBOutlet UIImageView *imgViewCircle;
@property   (nonatomic,weak)    IBOutlet UIButton   *btnFrame;

-(void) applyFrame:(BOOL) allowFrame;
-(IBAction) touchPhoto;
-(IBAction) touchNumber;
-(IBAction) touchFrame;
-(void) showSpiner:(BOOL) isShow;
@end
