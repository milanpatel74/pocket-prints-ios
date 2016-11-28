//
//  SelectPhotoViewController.h
//  PocketPrint
//
//  Created by Quan Do on 12/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPhotoView.h"
#import "IGRequest.h"
#import "NumberSelectorView.h"
#import "SelectPhotoViewController.h"
#import "Product.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

typedef enum ALBUM_SECTION {
    SECTION_PHOTO,
    SECTION_FACEBOOK
} ALBUM_SECTION ;

@interface SelectPhotoAlbumViewController : AppViewController <UITableViewDelegate, UITableViewDataSource, SelectPhotoDelegate,IGSessionDelegate, NumberSelectorViewProtocol,UIScrollViewDelegate> {
    IBOutlet    UITableView *tblView;
    NSMutableArray  *arrPhotoGroups,*arrFacebookAlbums,*arrPhotoAlbums;
    ALBUM_SECTION   albumSection;
    NumberSelectorView  *numberSelector;
    SelectPhotoView *currPhotoView;
    BOOL isShowNumberSelector;
    
    IBOutlet    UIButton    *btnFacebook, *btnAlbum;
    
    NSMutableDictionary  *dictPhotosScreen;

}
@property (nonatomic) int page;
@property (nonatomic, strong) Product *mainProduct;
-(IBAction) touchFacebook;
-(IBAction) touchInstagram;
-(IBAction) touchCamera;

-(NSMutableArray*) getAllSelectedPhotos:(Product*) aProduct;
@end
