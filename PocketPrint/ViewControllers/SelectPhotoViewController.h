//
//  SelectPhotoViewController.h
//  PocketPrint
//
//  Created by Quan Do on 17/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"
#import "NumberSelectorView.h"
#import "UIButtonWithData.h"
#import "Product.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "POPTagTextField.h"
#import "POPInstagramNetworkingClient.h"
#import "POPMediaItem.h"
#import "protocolTransfersView.h"

typedef enum    ALBUM_TYPE {
    ALBUM_CAMERA,
    ALBUM_FACEBOOK,
    ALBUM_INSTAGRAM,
    ALBUM_PHOTO
} ALBUM_TYPE;

@protocol SelectPhotoViewControllerDelegate <NSObject>

-(void) dataUpdated;

@end
@protocol coachmarkClickedDelegate <NSObject>
@required
-(void) removeCoachmarkDone;

@end

@interface SelectPhotoViewController : AppViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate,IGRequestDelegate,NumberSelectorViewProtocol,UIScrollViewDelegate,UITextFieldDelegate,protocolTransfersView> {
    IBOutlet    UITableView *tblView;
   
    //NSMutableArray  *arrNumber;
    //UIPickerView    *pickerNumber;
    UIButton *getBackButton;
    // owner
    UIView  *currPhotoView;
    UIButtonWithData    *currPhotoBtn;
    UIImageView *imgViewPhotoShadow;
    UILabel *currLbCount,*currLbAlbumCount;
    NSMutableDictionary *currDict,*currContainer;
    
    NumberSelectorView  *numberSelector;
    BOOL isShowNumberSelector;
    BOOL    isFullLoaded;
    BOOL    isUpdated;
    BOOL cropCoach;
    BOOL isCroppedDone;
    
    NSMutableArray * hashTagImagesArray;
    NSMutableDictionary *tmpDict;
}

@property   (strong)  NSMutableArray  *arrPhotoGroups;
@property (nonatomic,assign) NSString *fbAlbumId;
@property (nonatomic,assign) ALBUM_TYPE albumType;
@property  (nonatomic, assign) NSString *albumName;
@property   (strong) NSMutableArray   *arrPhotos,*arrCart;
@property   (nonatomic,assign) int  sectionToMove;
@property (nonatomic) BOOL isOrderPreview;
@property (nonatomic) id refData;
@property   (nonatomic,weak) id<SelectPhotoViewControllerDelegate> delegate;
@property   (nonatomic,weak) id<coachmarkClickedDelegate> coachDelegate;
@property (nonatomic, strong) Product *mainProduct;

@property (nonatomic) POPInstagramNetworkingClient *sharedPOPInstagramNetworkingClient;
@property (nonatomic) POPTagTextField *tagTextField;

@property (nonatomic) MBProgressHUD *HUD;
@property (nonatomic) int page;

-(IBAction) touchFacebook;
-(IBAction) touchInstagram;
-(IBAction) touchCamera;

// composer
-(NSMutableArray*) getAllSelectedPhotos:(NSDictionary*)aDictGroup andProduct:(Product*) aProduct;
@end
