//
//  PhotoPreviewViewController.h
//  PocketPrint
//
//  Created by Quan Do on 18/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFCropInterface.h"
#import "MBProgressHUD.h"
#import "SelectPhotoViewController.h"
#import "protocolTransfersView.h"

@class AppViewController;

@interface PhotoPreviewViewController : AppViewController<UIAlertViewDelegate,coachmarkClickedDelegate> {
    IBOutlet    UIBarButtonItem *btnSetFrame;
    IBOutlet    UIBarButtonItem *cropButton;
    IBOutlet UIBarButtonItem *originalImageButton;
    BOOL    isFrameApplied;
    IBOutlet    UIImageView *imgViewPhoto;
    UIImage     *imgFramePhoto, *imgPhoto, *finalPhoto;
    NSString    *fieldName;
    UIActivityIndicatorView *spinner;
    float frameWidth,frameHeight;
    
    BOOL isCropped;
    UIImage *croppedImage;
//    UIImage * tempImgPhoto;
    
}
@property(nonatomic,retain) id <protocolTransfersView> protocolDatas;
// need parameter to get an image here
//@property   (nonatomic,strong)  UIImage *imgPhoto;
@property   (nonatomic,weak)  NSMutableDictionary *photoDict;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewPhoto;

@property (nonatomic, strong) IBOutlet UIImageView *displayImage;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) BFCropInterface *cropper;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic) MBProgressHUD *HUD;
@property (nonatomic,retain) NSString *type;
-(IBAction)cropButtonTapped:(UIBarButtonItem *)sender;
-(IBAction)originalImageButtonTapped:(id)sender;





@end
