//
//  SelectPhotoViewController.m
//  PocketPrint
//
//  Created by Quan Do on 17/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "SelectPhotoViewController.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "PhotoPreviewViewController.h"
#import "UIImageViewWithData.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HomeViewController.h"
#import "ImageIO/ImageIO.h"
#import <AdobeCreativeSDKCore/AdobeUXAuthManager.h>



@interface SelectPhotoViewController ()<AdobeUXImageEditorViewControllerDelegate>


@property (nonatomic, strong) UIButtonWithData *currentSelectedThumb;
@property (nonatomic, strong) NSIndexPath *cropIndexPath;
@property (nonatomic, assign) NSInteger indexColumn;

@property (nonatomic, strong) NSMutableDictionary *photoDict;
@property (nonatomic, strong) UIImage *imageToCrop;

@end

@implementation SelectPhotoViewController
@synthesize page,coachDelegate;

#define PHOTO_HEIGHT  97
float PHOTO_GAP;
#define HEADER_HEIGHT 50
#define HEADER_GAP    10

#define TAG_PHOTO      9999

int ITEMS_PER_ROW;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:CreativeSDKClientId
                                                                       clientSecret:CreativeSDKClientSecret
                                                                       enableSignUp:NO];
        
        self.cropIndexPath = nil;
        self.indexColumn = -1;
        

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //reset
    isUpdated = NO;
    NSLog(@"%d----pagevalue..",page);
    // check for loaded
    if (isFullLoaded) {
        // preset all data
        if (_refData) {
            if (![[_refData objectForKey:@"count_applied"] boolValue] || ![[_refData objectForKey:@"frame_applied"] boolValue]) {
                int count = [[_refData objectForKey:@"count"] intValue];
                for (int i =0;i< _arrPhotoGroups.count;i++) {
                    NSMutableDictionary *dictContainer = [_arrPhotoGroups objectAtIndex:i];
                    if (![[_refData objectForKey:@"count_applied"] boolValue]) {
                        [dictContainer setObject:[NSNumber numberWithInt:count] forKey:@"count"];
                    }
                    if (![[_refData objectForKey:@"frame_applied"] boolValue]) {
                        [dictContainer setObject:[_refData objectForKey:@"frame"] forKey:@"framed"];
                    }
                    
                    NSMutableArray  *arrPhotos = [dictContainer objectForKey:@"photos"];
                    for (int j=0; j< arrPhotos.count; j++) {
                        NSMutableDictionary *dict = [arrPhotos objectAtIndex:j];
                        if (![[_refData objectForKey:@"count_applied"] boolValue]) {
                            [dict setObject:[NSNumber numberWithInt:count] forKey:@"count"];
                        }
                        if (![[_refData objectForKey:@"frame_applied"] boolValue]) {
                            [dict setObject:[_refData objectForKey:@"frame"] forKey:@"framed"];
                        }
                    }
                }
                // set back
                [_refData setObject:[NSNumber numberWithBool:YES] forKey:@"count_applied"];
                // set back
                [_refData setObject:[NSNumber numberWithBool:YES] forKey:@"frame_applied"];
            }
        }
    }
    [tblView reloadData];
    //[self showTabBar];
    
    // show coach mark
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"coach4"]) {
        UIImage *imgCoach = [UIImage imageNamed:(IS_4INCHES)?@"coach_mark04-568h.png":@"coach_mark04.png"];
        if (IS_IPHONE_6P) {
            imgCoach = [UIImage imageNamed:@"coach_mark04-736h@3x.png"];
        }
        else
            if (IS_IPHONE_6) {
                imgCoach = [UIImage imageNamed:@"coach_mark04-667h@2x.png"];
            }
        UIButton    *btnCoach = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCoach setImage:imgCoach forState:UIControlStateNormal];
        btnCoach.frame = CGRectMake(0, 0, imgCoach.size.width, imgCoach.size.height);
        [btnCoach addTarget:self action:@selector(removeCoachmark:) forControlEvents:UIControlEventTouchUpInside];
        [(appDelegate).window addSubview:btnCoach];
    }
    
    [self updateCartInfo];
    [self hideTabBar];
    
    if (_albumType == ALBUM_INSTAGRAM )
    {
        [self setupTagTextField];
        [tblView setFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-130)];
        if (hashTagImagesArray.count)
        {
           [tblView setFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-130)];
        }
    }

    if (isCroppedDone == YES)
    {
        UIAlertView *cropMessage = [[UIAlertView alloc]initWithTitle:@"The Cropped Image has been added to Cart" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cropMessage show];
    }
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isCroppedDone = NO;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    isCroppedDone = NO;
    
    // Do any additional setup after loading the view from its nib.
    ITEMS_PER_ROW = 3;
    if (IS_IPHONE_6P) {
        ITEMS_PER_ROW = 4;
    }

    PHOTO_GAP = ((tblView.frame.size.width - PHOTO_HEIGHT*ITEMS_PER_ROW) / (ITEMS_PER_ROW+1));
    
    if (_isOrderPreview) {
        [self setScreenTitle:@"Order Preview"];
    }
    else {
        [self setScreenTitle:@"Select Photos"];
        // add navigation buttons
//        UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnCart.frame = CGRectMake(0, 0, 21, 16);
//        [btnCart setBackgroundImage:[UIImage imageNamed:@"card_btn.png"] forState:UIControlStateNormal];
//        [btnCart addTarget:self action:@selector(touchCart) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
         [self updateCartInfo];
    }
    
    //self.hidesBottomBarWhenPushed = YES;
   

    
    self.navigationItem.hidesBackButton = YES;
//    self.navigationController.navigationBar.translucent=NO;
    
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBack.frame = CGRectMake(0, 0, 30, 21);
//    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//    [btnBack addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    _arrPhotoGroups = [NSMutableArray new];
    

    tblView.backgroundColor = [UIColor clearColor];
    
    // shadow
    // add dark background
    UIImage *imgBG = [UIImage imageNamed:@"black_shadow.png"];
    //imgViewPhotoShadow= [[UIImageView alloc] initWithFrame:CGRectMake(58, 9, 39, 88)];
    imgViewPhotoShadow= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT)];
    imgViewPhotoShadow.image = imgBG;
    
 /*   // initialize number
    arrNumber = [NSMutableArray new];
    for (int i=0; i<100; i++) {
        NSString    *s;
//        if (i<10) {
//            s = [NSString  stringWithFormat:@"0%d",i];
//        }
//        else
            s = [NSString stringWithFormat:@"%d",i];
        [arrNumber addObject:s];
    }
    
    // initilize picker 65
    pickerNumber = [[UIPickerView alloc] initWithFrame:CGRectMake(65, -64, 30, 162)];
    pickerNumber.delegate = self;
    pickerNumber.dataSource = self;
    pickerNumber.showsSelectionIndicator = NO;
*/
    switch (_albumType) {
        case ALBUM_CAMERA:
            [self loadPhotoFromPhotoAlbum];
            break;
            
        case ALBUM_FACEBOOK:
            if (_fbAlbumId) {
                [self loadFacebookAlbum];
            }
            break;
            
        case ALBUM_INSTAGRAM:
            // process load data now
            [self requestRecentPhotosFromInstagram];
            

            break;
        
        case ALBUM_PHOTO:
            // process load data now
            [self preparePhotoFromSource];
            break;
    }

    //DLog(@"gap =%d", PHOTO_GAP);
    
    //number selector
    numberSelector = [[NumberSelectorView alloc] initWithFrame:CGRectZero andStyle:SELECTOR_SMALL];
    numberSelector.hidden = YES;
    numberSelector.delegate = self;
    [self.view addSubview:numberSelector];
    isShowNumberSelector = NO;

    CGRect frame = self.tabBarController.tabBar.frame;
//    frame.origin.y = 519 -((IS_4INCHES)?0:88);
//    self.tabBarController.tabBar.frame = frame;
    
//    if (frame.origin.y > 519 -((IS_4INCHES)?0:88)) {
//        // expand
//        CGRect frame = tblView.frame;
//        frame.size.height +=44;
//        tblView.frame  =frame;
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetQuantity:) name:NotificationResetQuantity object:nil];
    
//    [self setupNavigationElements];
    [self setupSharedPOPInstagramNetworkingClient];
    [tblView setTag:1];
}

-(void) viewDidLayoutSubviews {
    PHOTO_GAP = ((tblView.frame.size.width - PHOTO_HEIGHT*ITEMS_PER_ROW) / (ITEMS_PER_ROW+1));
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 21);
    //[btnBack setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_IPHONE_6P) {
        UIBarButtonItem* sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        sp.width = -10;
        
        self.navigationItem.leftBarButtonItems = @[sp,[[UIBarButtonItem alloc] initWithCustomView:btnBack]];
    }
    else
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupActivityIndicator
{
    //Setup and show activity indicator
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDAnimationFade;
    [self.HUD show:YES];

}


-(void) cropMessageDataTransfer:(BOOL)data
{
    isCroppedDone = data;
}

#pragma mark - Setup Methods
- (void)setupTagTextField
{
    self.tagTextField = [[POPTagTextField alloc] initWithFrame:CGRectMake(10.0f, 75.0f, [UIScreen mainScreen].bounds.size.width - 20, 60.0f)];
    self.tagTextField.delegate = self;
    [self.view addSubview:self.tagTextField];
}

- (void)setupNavigationElements
{
    //Set nav bar's title text and text color
    self.navigationItem.title = @"Search by Hashtag";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.169 green:0.353 blue:0.514 alpha:1]};
}
- (void)setupSharedPOPInstagramNetworkingClient
{
    //Setup shared networking client for Instagram
    self.sharedPOPInstagramNetworkingClient = [POPInstagramNetworkingClient sharedPOPInstagramNetworkingClient];
}
#pragma mark - Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setupActivityIndicator];


    //Give up responder status
    [textField resignFirstResponder];
    
    //Check for empty text field text
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    
    //Setup and run the activity indicator
    
    //Will run until ready to reload collection view
    //[self setupActivityIndicator];
    
    //Create new string after removing pound,
    //then a final string after removing any blank space
    NSString *tagTextWithoutPound = [textField.text stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSString *finalTagText2 = [tagTextWithoutPound stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //Pass our final tag
    [self requestTaggedMediaFromInstagramWithTag:finalTagText2];
    
    return NO;
}
#pragma mark - Networking Methods
- (void)requestTaggedMediaFromInstagramWithTag:(NSString *)tag
{
    //Request popular media from Instagram with the passed tag
   
    [self.sharedPOPInstagramNetworkingClient requestMediaWithTag:tag success:^(NSURLSessionDataTask *task, NSArray *taggedMedia) {
        
        //Set taggedMediaItems property to returned tagged media,
        //hide progress HUD and reload collection view data
       // POPMediaItem * mediaItem=[[POPMediaItem alloc]init];
        
        
        NSLog(@"~~~~~~~~~~~~~~~~~~~~%@",taggedMedia);
        
        hashTagImagesArray = [[NSMutableArray alloc]init];
        for (POPMediaItem *itm in taggedMedia)
        {
            
             NSMutableDictionary *hashDict = [[NSMutableDictionary alloc]init];;
            [hashDict setObject:itm.thumbnailImageUrl forKey:@"thumbnail_url"];
            [hashDict setObject:itm.lowResolutionImageUrl forKey:@"url"];
            [hashDict setObject:itm.standardResolutionImageUrl forKey:@"url_high"];
            [hashDict setObject:itm.thumbnailImage forKey:@"thumbnail_image"];
            [hashDict setObject:itm.lowResolutionImage forKey:@"image"];
            [hashDict setObject:itm.standardResolutionImage forKey:@"image_high"];
            [hashDict setObject:@"0" forKey:@"count"];
            [hashDict setObject:@"0" forKey:@"framed"];
            [hashDict setObject:itm.username forKey:@"user_name"];
            [hashTagImagesArray addObject:hashDict];
        }
        [self.HUD hide:YES];
        [self toGetHashTagAndInstagram];
        [tblView setTag:2];
        
        [tblView reloadData];
//   _arrPhotoGroups
       // [self.HUD hide:YES];
       // [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        //Display the alert view with error
        NSLog(@"Failure error=%@",error);
        //[self displayAlertViewForUnsuccessfulRequestForMediaWithTagError:error];
        
    }];
    
    NSLog(@"testing......");
}

-(void) toGetHashTagAndInstagram
{
    
    [tblView setFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-130)];
    getBackButton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.tagTextField.frame.size.height+self.tagTextField.frame.origin.y+5, 180, 30)];
    [getBackButton setTitle:@"Back to instagram" forState:UIControlStateNormal];
    [getBackButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [getBackButton setBackgroundColor:[UIColor redColor]];
    [getBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getBackButton.layer setCornerRadius:5.0];
    [self.view addSubview:getBackButton];
    [getBackButton addTarget:self action:@selector(getBackActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) getBackActionHandler:(UIButton *) sender
{
    [tblView setFrame:CGRectMake(0, 180, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-130)];
    if ([getBackButton.titleLabel.text isEqualToString:@"Back to instagram"])
    {
        [getBackButton setTitle:@"Back to hashtag printer" forState:UIControlStateNormal];
        [tblView setTag:1];
    }
    else
    {
        
        [getBackButton setTitle:@"Back to instagram" forState:UIControlStateNormal];
        [tblView setTag:2];
    }
    [tblView reloadData];
    
    
}


-(void) removeCoachmark:(UIButton*) aBtn {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"coach4"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.75 animations:^{
        aBtn.alpha = 0;
    } completion:^(BOOL finished) {
        aBtn.hidden = YES;
        [aBtn removeFromSuperview];
    }];
}

-(void) removeCoachmark2:(UIButton*) aBtn {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"coach2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.75 animations:^{
        aBtn.alpha = 0;
    } completion:^(BOOL finished) {
        aBtn.hidden = YES;
        [aBtn removeFromSuperview];
    }];
}

-(void) removeCoachmark6:(UIButton*) aBtn {
    static int count = 2;
   
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"coach6"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.75 animations:^{
        aBtn.alpha = 0;
    } completion:^(BOOL finished) {
         count = count - 1;
        aBtn.hidden = YES;
        [aBtn removeFromSuperview];
        if (count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeCoach" object:nil];
        }
        
        
    }];
   
}
#pragma mark scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self showNumberSelector:NO];
}

#pragma mark number selector

-(void) selectedNumber:(int) aNumber {
    if (currPhotoBtn.buttonTag == BUTTON_HEADER) {
        currLbAlbumCount.text = [NSString stringWithFormat:@"%d",aNumber];
        currLbAlbumCount.hidden = NO;
        currLbAlbumCount.textColor = [UIColor whiteColor];
//        [currDict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
//        [ tblView reloadData];
        
        // now we set all
        NSMutableDictionary *dictContainer = [currPhotoBtn.object objectForKey:@"container"];
        [dictContainer setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
        NSMutableArray  *arr = [dictContainer objectForKey:@"photos"];
        for (NSMutableDictionary *dict in arr) {
            [dict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
            //refresh
            
        }
        [tblView reloadData];
        [self updateCartInfo];
    }
    else {
        if (_isOrderPreview) {
            if (aNumber == 0) {
                // remove the image
                NSMutableArray  *arrDictPhotos = [currContainer objectForKey:@"photos"];
                for (int i=0;i<arrDictPhotos.count;i++) {
                    NSMutableDictionary *dict = [arrDictPhotos objectAtIndex:i];
                    if ([dict isEqual:currDict]) {
                        // remove
                        [arrDictPhotos removeObjectAtIndex:i];
                        break;
                    }
                }
                [self showNumberSelector:NO];
                // reload now
                [tblView reloadData];
                [self updateCartInfo];
                //
                return;
            }
        }
        currLbCount.text = [NSString stringWithFormat:@"%d",aNumber];
        //set
        [imgViewPhotoShadow removeFromSuperview];
        imgViewPhotoShadow.alpha = 0;
        currLbCount.hidden = NO;
        currLbCount.textColor = [UIColor whiteColor];
        [currDict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
        [ tblView reloadData];
        [self updateCartInfo];
    }
    // hide
    [self showNumberSelector:NO];
    

}

-(void) showNumberSelector:(BOOL) isShow {

    isShowNumberSelector = isShow;
    if (isShow) {
        
        numberSelector.alpha = 0;
        numberSelector.hidden = NO;
        [UIView animateWithDuration:0.75 animations:^{
            numberSelector.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        // show coach mark
        if (cropCoach == NO)
        {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"coach2"] ) {
                
                UIImage *imgCoach = [UIImage imageNamed:(IS_4INCHES)?@"coach_mark02-568h.png":@"coach_mark02.png"];
                if (IS_IPHONE_6P) {
                    imgCoach = [UIImage imageNamed:@"coach_mark02-736h@3x.png"];
                }
                else
                    if (IS_IPHONE_6) {
                        imgCoach = [UIImage imageNamed:@"coach_mark02-667h@2x.png"];
                    }
                
                
                UIButton    *btnCoach = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnCoach setImage:imgCoach forState:UIControlStateNormal];
                btnCoach.frame = CGRectMake(0, 0, imgCoach.size.width, imgCoach.size.height);
                [btnCoach addTarget:self action:@selector(removeCoachmark2:) forControlEvents:UIControlEventTouchUpInside];
                [(appDelegate).window addSubview:btnCoach];
            }
            
        }
        else
        {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"coach6"] ) {
                UIImage *imgCoach = [UIImage imageNamed:(IS_4INCHES)?@"coach_mark06-568h.png":@"coach_mark06.png"];
                if (IS_IPHONE_6P) {
                    imgCoach = [UIImage imageNamed:@"coach_mark06-736h@3x.png"];
                }
                else
                    if (IS_IPHONE_6) {
                        imgCoach = [UIImage imageNamed:@"coach_mark06-667h@2x.png"];
                    }
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"showalert"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIButton    *btnCoach = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnCoach setImage:imgCoach forState:UIControlStateNormal];
                btnCoach.frame = CGRectMake(0, 0, imgCoach.size.width, imgCoach.size.height);
                [btnCoach addTarget:self action:@selector(removeCoachmark6:) forControlEvents:UIControlEventTouchUpInside];
                [(appDelegate).window addSubview:btnCoach];
                
            }
            
        }
        // clear current photoview
        if (currPhotoBtn.buttonTag == BUTTON_HEADER) {
            //currLbAlbumCount.text = [NSString stringWithFormat:@"%d",aNumber];
            currLbAlbumCount.hidden = NO;
            currLbAlbumCount.textColor = [UIColor whiteColor];
            //        [currDict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
            //        [ tblView reloadData];
            
            // now we set all
            //NSMutableDictionary *dictContainer = [currPhotoBtn.object objectForKey:@"container"];
            //[dictContainer setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
            //NSMutableArray  *arr = [dictContainer objectForKey:@"photos"];
//            for (NSMutableDictionary *dict in arr) {
//                [dict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
//                //refresh
//                
//            }
            [tblView reloadData];
        }
        else {
            
            //currLbCount.text = [NSString stringWithFormat:@"%d",aNumber];
            //set
            [imgViewPhotoShadow removeFromSuperview];
            imgViewPhotoShadow.alpha = 0;
            currLbCount.hidden = NO;
            currLbCount.textColor = [UIColor whiteColor];
            //[currDict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
            [ tblView reloadData];
        }
        // reset
        
        [UIView animateWithDuration:0.75 animations:^{
            numberSelector.alpha = 0;
        } completion:^(BOOL finished) {
            numberSelector.hidden = YES;
            
        }];
    }
}

#pragma mark load photo from source
-(void) preparePhotoFromSource {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeInTableView) name:NotificationFinishedFlyingImages object:nil];
    [_arrPhotoGroups addObjectsFromArray:_arrPhotos];
    tblView.alpha = 0;
    [tblView reloadData];
    // move

//    CGRect oldRect = [tblView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:_sectionToMove inSection:0]];
//    
//    //scroll
//    [tblView setContentOffset:oldRect.origin];
}

-(void) fadeInTableView {
    [UIView animateWithDuration:0.5 animations:^{
        tblView.alpha = 1;
    }];
}

#pragma mark load photo from photo album

-(void) loadPhotoFromPhotoAlbum {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    RUN_ON_BACKGROUND_QUEUE((^{
        [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group && [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:_albumName]) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                //[group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                    if (asset){
                        //                    NSNumber *width = [[[asset defaultRepresentation] metadata] objectForKey:@"PixelWidth"]; //find the key with "PixelWidth" name
                        //                    NSString *widthString = [NSString stringWithFormat:@"%@", width]; //take the value of the key
                        
                        //NSString *assetAlbumName = [group valueForProperty:ALAssetsGroupPropertyName]; //it return to me an ALErrorInvalidProperty
                        //DLog(@"found %d phot in %@",index,assetAlbumName);
                        
//                        NSMutableDictionary    *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                             //[dict objectForKey:@"source"],@"url",
//                                                             [[UIImage alloc] initWithCGImage:asset.thumbnail],@"image",
//                                                             assetAlbumName,@"name",
//                                                             assetAlbumName,@"id", nil];
                        
                        // firstly , get the image
                        //                    DLog(@"location = %@",);
                        //                    DLog(@"Date = %@",);
                        __block CLLocation  *location = [asset valueForProperty:ALAssetPropertyLocation];
                        
                        __block NSString    *locationStr = @"No Location";
                        if (location) {
                            //locationStr = [NSString stringWithFormat:@"%@",location];
                        }
                        

                        
                        // check if there is a dictionary can contain this kind of image
                        // creat new dict or update it
                        // add the dict to arrray
                        NSDateFormatter *dateFormatter = [NSDateFormatter new];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *date = [asset valueForProperty:ALAssetPropertyDate];
                        NSString    *strDate = [dateFormatter stringFromDate:date];
                        BOOL isExisted = NO;
                        
                        // container
                        __block NSMutableDictionary *dictContainer = nil;
                        
                        for (NSMutableDictionary *tmpContainer in _arrPhotoGroups) {
                            NSString    *tmpStrDate = [tmpContainer objectForKey:@"date"];
                            //tmpStrDate = [tmpStrDate substringToIndex:10];
                            if ([tmpStrDate isEqualToString:strDate]) {
                                // already existed
                                dictContainer = tmpContainer;
                                isExisted = YES;
                                break;
                            }
                        }
                        
                        int count = 0;
                        BOOL frameApplied = NO;
                        if (_refData) {
                            if (![[_refData objectForKey:@"count_applied"] boolValue]) {
                                //set now
                                count = [[_refData objectForKey:@"count"] intValue];
                                // setback
                                
                            }
                            
                            //if (![[_refData objectForKey:@"frame"] boolValue]) {
                            //set now
                            if (![[_refData objectForKey:@"frame_applied"] boolValue])
                                frameApplied = [[_refData objectForKey:@"frame"] boolValue];
                            // setback
                            
                            //}
                        }
                        
                        // check existed
                        if (!isExisted) {
                            // create new and add to array
                            //            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            //            NSDate  *date = [dateFormatter dateFromString:strDate];
                            [dateFormatter setDateFormat:@"MMMM d yyyy"];
//                            int count = 0;
//                            
//                            if (_refData) {
//                                if (![[_refData objectForKey:@"count_applied"] boolValue]) {
//                                    //set now
//                                    count = [[_refData objectForKey:@"count"] intValue];
//                                    // setback
//                                    
//                                }
//                                
//
//                            }
                            
                            dictContainer = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"date",[NSMutableArray new],@"photos",[dateFormatter stringFromDate:date],@"fullDate", locationStr,@"location",[NSNumber numberWithInt:count],@"count",[NSNumber numberWithBool:frameApplied],@"framed",nil];
                            
                            [_arrPhotoGroups addObject:dictContainer];
                        }
                        
                        // set back location to dict
                        if (location) {
                            //location = [[CLLocation alloc] initWithLatitude:-37.814107 longitude:144.96327999999994];
                            CLGeocoder  *geoCode = [[CLGeocoder alloc] init];
                            [geoCode reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                                //DLog(@"check GPS : %@",locationStr);
                                if (placemarks) {
                                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                    [self testPlaceMark:placemark];
                                    locationStr = [NSString stringWithFormat:@"%@, %@",[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"State"]];
                                    //DLog(@"");
                                }
                                    //DLog(@"Location = =>%@<=",locationStr);
//                                    DLog(@"Erro %@",error);
//                                    DLog(@"========");
                                //DLog(@"Locatio = %@",location);
                                
                                if (error) {
                                    // check out
                                    //[self testPlaceMark:placemarks location:location andError:error];
                                    locationStr = @"No Location";
                                }
                                [dictContainer setObject:locationStr forKey:@"location"];
                            }];

                        }

                        CGSize imageSize  = asset.defaultRepresentation.dimensions;
                        
//                        NSURL *fileURL = [NSURL fileURLWithPath:asset.defaultRepresentation.filename];
//                        DLog(@"file = %@",asset.defaultRepresentation.filename);
//                        imageSize = [self sizeOfImageAtURL:fileURL];
                        
                        // get array
                        NSMutableArray  *tmpPhotos = [dictContainer objectForKey:@"photos"];
                        // check for reference data
                        //UIImage *imgTmp = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullResolutionImage];
                        //DLog(@"thumnail size = %@",NSStringFromCGSize(imageSize));
                        __block NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInt:count],@"count",
                                                             @"",@"id",
                                                             [[UIImage alloc] initWithCGImage:asset.thumbnail],@"image",
                                                             [NSNull null],@"image_high",
                                                             [NSNull null],@"url",
                                                             NSStringFromCGSize(imageSize),@"size",
                                                             [NSNumber numberWithBool:frameApplied],@"framed",
                                                             asset.defaultRepresentation.url,@"url_high",nil];
                        [tmpPhotos addObject:dict];
                        
                    }
                    
                    if (index >0 && index % 30 == 0) {
                        RUN_ON_MAIN_QUEUE(^{
                            [tblView reloadData];
                        });
                    }
                }];
                //DLog(@"group name = %@",[group valueForProperty:ALAssetsGroupPropertyName]);
            }
            else
            {
                RUN_ON_MAIN_QUEUE(^{
                    // DLog(@"======");
                    // reload
                    //[arrPhotoGroups removeAllObjects];
                    //[arrPhotoGroups addObjectsFromArray:arrPhotoAlbums];
                    if (_refData) {
                        [_refData setObject:[NSNumber numberWithBool:YES] forKey:@"count_applied"];
                        [_refData setObject:[NSNumber numberWithBool:YES] forKey:@"frame_applied"];
                    }
                    [tblView reloadData];
                    isFullLoaded = YES;
                });
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }));


}


-(void) testPlaceMark:(CLPlacemark*) placmark {
    //DLog(@"");
}
#pragma mark load photo from Instagram

-(void) requestRecentPhotosFromInstagram {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/media/recent", @"method", nil];
    [(appDelegate).instagram requestWithParams:params
                                      delegate:self];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    DLog(@"Request photos from Instagram successfully");
    // load images here
    
    [_arrPhotoGroups removeAllObjects];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // process
    NSArray *tmpArr = [result objectForKey:@"data"];
    for (NSDictionary   *tmpDict in tmpArr) {
        // get the date
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate  *date = [NSDate dateWithTimeIntervalSince1970:[[tmpDict objectForKey:@"created_time"] longLongValue]];
        NSString    *strDate = [dateFormatter stringFromDate:date];
        BOOL isExisted = NO;
        NSMutableDictionary *dictContainer = nil;
        
        for (NSMutableDictionary *tmpContainer in _arrPhotoGroups) {
            NSString    *tmpStrDate = [tmpContainer objectForKey:@"date"];
            //tmpStrDate = [tmpStrDate substringToIndex:10];
            if ([tmpStrDate isEqualToString:strDate]) {
                // already existed
                dictContainer = tmpContainer;
                isExisted = YES;
                break;
            }
        }
        
        // check existed
        if (!isExisted) {
            // create new and add to array
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate  *date = [dateFormatter dateFromString:strDate];
            [dateFormatter setDateFormat:@"MMMM d yyyy"];
            
            dictContainer = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"date",[NSMutableArray new],@"photos",[dateFormatter stringFromDate:date],@"fullDate", nil];
            [_arrPhotoGroups addObject:dictContainer];
        }
        
        // get array
        NSMutableArray  *tmpPhotos = [dictContainer objectForKey:@"photos"];
        
        int count = 0;
        BOOL frameApplied = NO;
        if (_refData) {
            if (![[_refData objectForKey:@"count_applied"] boolValue]) {
                //set now
                count = [[_refData objectForKey:@"count"] intValue];
                // setback
                
            }
            
            //if (![[_refData objectForKey:@"frame"] boolValue]) {
                //set now
            if (![[_refData objectForKey:@"frame_applied"] boolValue])
                frameApplied = [[_refData objectForKey:@"frame"] boolValue];
                // setback
                
            //}
        }
        
        NSURL    *fullImgUrl = [NSURL URLWithString:[[[tmpDict objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:count],@"count",
                                     [tmpDict objectForKey:@"id"],@"id",
                                     [NSNull null],@"image",
                                     [NSNull null],@"image_high",
                                     [[[tmpDict objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"],@"url",
                                     [NSNumber numberWithBool:frameApplied],@"framed",
                                     fullImgUrl,@"url_high",nil];
        
        [tmpPhotos addObject:dict];
    }
    
    RUN_ON_MAIN_QUEUE(^{
        [tblView reloadData];
        isFullLoaded = YES;
    });
    /// load paging here
    
    NSDictionary    *dict = [result objectForKey:@"pagination"];
    [self loadPaging:[dict objectForKey:@"next_url"]];
}

-(void) loadPaging:(NSString*) pagingURL {
    NSLog(@"==> fetching from %@",pagingURL);
    if (!pagingURL) {
        return;
    }
    

    
    NSURLRequest    *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pagingURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               //NSLog(@"responne = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                               
                               /// load image to table
                               
                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                               
                               // process
                               NSArray *tmpArr = [result objectForKey:@"data"];
                               for (NSDictionary   *tmpDict in tmpArr) {
                                   // get the date
                                   [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                   NSDate  *date = [NSDate dateWithTimeIntervalSince1970:[[tmpDict objectForKey:@"created_time"] longLongValue]];
                                   NSString    *strDate = [dateFormatter stringFromDate:date];
                                   BOOL isExisted = NO;
                                   NSMutableDictionary *dictContainer = nil;
                                   
                                   for (NSMutableDictionary *tmpContainer in _arrPhotoGroups) {
                                       NSString    *tmpStrDate = [tmpContainer objectForKey:@"date"];
                                       //tmpStrDate = [tmpStrDate substringToIndex:10];
                                       if ([tmpStrDate isEqualToString:strDate]) {
                                           // already existed
                                           dictContainer = tmpContainer;
                                           isExisted = YES;
                                           break;
                                       }
                                   }
 
                                   int count = 0;
                                   BOOL frameApplied = NO;
                                   if (_refData) {
                                       if (![[_refData objectForKey:@"count_applied"] boolValue]) {
                                           //set now
                                           count = [[_refData objectForKey:@"count"] intValue];
                                           // setback
                                           
                                       }
                                       
                                       //if (![[_refData objectForKey:@"frame"] boolValue]) {
                                       //set now
                                       if (![[_refData objectForKey:@"frame_applied"] boolValue])
                                            frameApplied = [[_refData objectForKey:@"frame"] boolValue];
                                       // setback
                                       
                                       //}
                                   }
                                   
                                   // check existed
                                   if (!isExisted) {
                                       // create new and add to array
                                       //            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                       //            NSDate  *date = [dateFormatter dateFromString:strDate];
                                       [dateFormatter setDateFormat:@"MMMM d yyyy"];
                                       
                                       dictContainer = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"date",[NSMutableArray new],@"photos",[dateFormatter stringFromDate:date],@"fullDate", [NSNumber numberWithBool:frameApplied],@"framed",nil];
                                       [_arrPhotoGroups addObject:dictContainer];
                                   }
                                   

                                   
                                   // get array
                                   NSMutableArray  *tmpPhotos = [dictContainer objectForKey:@"photos"];
                                   NSURL    *fullImgUrl = [NSURL URLWithString:[[[tmpDict objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
                                   NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInt:count],@"count",
                                                                [tmpDict objectForKey:@"id"],@"id",
                                                                [NSNull null],@"image",
                                                                [NSNull null],@"image_high",
                                                                [[[tmpDict objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"],@"url",
                                                                [NSNumber numberWithBool:frameApplied],@"framed",
                                                                fullImgUrl,@"url_high",nil];
                                   [tmpPhotos addObject:dict];
                               }
                               
                               RUN_ON_MAIN_QUEUE(^{
                                   [tblView reloadData];
                                   //isFullLoaded = YES;
                               });
                               
                               if ([result objectForKey:@"pagination"]) {
                                   NSDictionary *dict = [result objectForKey:@"pagination"];
                                   [self loadPaging:[dict objectForKey:@"next_url"]];
                               }
                           }];
}


#pragma mark initialize album stuffs
-(void) loadFacebookAlbum {
    // in case there is facebook album id
    
    
    
    
    
    
    [[FacebookServices sharedFacebookServices] getPhotosOfAlbumWithAlbumId:_fbAlbumId onFail:^(NSError *error) {
        DLog(@"Load albums photo fail %@",error.debugDescription);
    } onDone:^(id obj) {
        DLog(@"=> %@",obj);
        // clean
        [_arrPhotoGroups removeAllObjects];
        
        // process
        NSArray *tmpArr = [obj objectForKey:@"data"];
        for (NSDictionary   *tmpDict in tmpArr) {
            // get the date
            NSString    *strDate = [tmpDict objectForKey:@"created_time"];
            strDate = [strDate substringToIndex:10];
            
            BOOL isExisted = NO;
            NSMutableDictionary *dictContainer = nil;
            
            for (NSMutableDictionary *tmpContainer in _arrPhotoGroups) {
                NSString    *tmpStrDate = [tmpContainer objectForKey:@"date"];
                tmpStrDate = [tmpStrDate substringToIndex:10];
                if ([tmpStrDate isEqualToString:strDate]) {
                    // already existed
                    dictContainer = tmpContainer;
                    isExisted = YES;
                    break;
                }
            }
            
            int count = 0;
            BOOL frameApplied = NO;
            if (_refData) {
                if (![[_refData objectForKey:@"count_applied"] boolValue]) {
                    //set now
                    count = [[_refData objectForKey:@"count"] intValue];
                    // setback
                    //if (![[_refData objectForKey:@"frame"] boolValue]) {
                        //set now
                    
                    
                        // setback
                        
                    //}
                }
                
                if (![[_refData objectForKey:@"frame_applied"] boolValue])
                    frameApplied = [[_refData objectForKey:@"frame"] boolValue];
            }
            
            // check existed
            if (!isExisted) {
                // create new and add to array
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate  *date = [dateFormatter dateFromString:strDate];
                [dateFormatter setDateFormat:@"MMMM d yyyy"];
                

//                dictContainer = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"date",[NSMutableArray new],@"photos",[dateFormatter stringFromDate:date],@"fullDate",[NSNumber numberWithInt:count],@"count",[NSNumber numberWithBool:frameApplied],@"framed", nil];
                 dictContainer = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray new],@"photos",[NSNumber numberWithInt:count],@"count",[NSNumber numberWithBool:frameApplied],@"framed", nil];
                [_arrPhotoGroups addObject:dictContainer];
            }
            
            // get array
            NSMutableArray  *tmpPhotos = [dictContainer objectForKey:@"photos"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInt:count],@"count",
                                         [tmpDict objectForKey:@"id"],@"id",
                                         [NSNull null],@"image",
                                         [tmpDict objectForKey:@"picture"],@"url",
                                         [NSNull null],@"image_high",
                                         [NSNumber numberWithBool:frameApplied],@"framed",
                                         [NSURL URLWithString:[tmpDict objectForKey:@"source"]],@"url_high",nil];
            [tmpPhotos addObject:dict];
        }
        
        RUN_ON_MAIN_QUEUE(^{
            [tblView reloadData];
            isFullLoaded = YES;
        });
    }];
}

#pragma mark collection view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        NSDictionary    *dict = [_arrPhotoGroups objectAtIndex:indexPath.row];
        NSMutableArray  *arrPhotos = [dict objectForKey:@"photos"];
        // now we calculate row
        
        NSInteger countInlineRows = (arrPhotos.count + ITEMS_PER_ROW-1) / ITEMS_PER_ROW;
        
        return countInlineRows*(PHOTO_GAP + PHOTO_HEIGHT) + HEADER_HEIGHT + HEADER_GAP;
    }
    else
    {
        //        POPMediaItem *itm = [taggedMedia objectAtIndex:indexPath.row];
        //    NSDictionary    *dict = [_arrPhotoGroups objectAtIndex:indexPath.row];
        //    NSMutableArray  *arrPhotos = [dict objectForKey:@"photos"];
        // now we calculate row
        
//        NSInteger countInlineRows = (1 + ITEMS_PER_ROW-1) / ITEMS_PER_ROW;
//        
//        return countInlineRows*(PHOTO_GAP + PHOTO_HEIGHT) + HEADER_HEIGHT + HEADER_GAP;
        return 173.0;
    }
   

    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag == 1)
//    {
         [self showNumberSelector:NO];
//    }
//    else
//    {
//        
//    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        NSLog(@"%@",_arrPhotoGroups);
        return _arrPhotoGroups.count;

    }
    else
    {
         return   hashTagImagesArray.count;
  
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //cell.frame = CGRectMake(0, 0, tblView.frame.size.width, CELL_HEIGHT);
    
    UIView  *headerView;
    UIView  *photoContainerView;
    // remove all contents
    if (tableView.tag == 1)
    {
        for (UIView *aView in cell.contentView.subviews) {
            aView.hidden = YES;
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [aView removeFromSuperview];
            //});
            
        }
        
        // add header now
        NSMutableDictionary *dictContainer = [_arrPhotoGroups objectAtIndex:indexPath.row];
        NSMutableArray  *arrPhotos = [dictContainer objectForKey:@"photos"];
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, HEADER_HEIGHT)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lbDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 240, 22)];
        lbDate.font = [UIFont fontWithName:@"MuseoSans-300" size:14];
        lbDate.text = (_albumType != ALBUM_PHOTO)?[[dictContainer objectForKey:@"fullDate"] uppercaseString]:[dictContainer objectForKey:@"desc"];
        lbDate.textColor = UIColorFromRGB(0xeb310b);
        
        [headerView addSubview:lbDate];
        
        UILabel *lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 240, 22)];
        lbLocation.font = [UIFont fontWithName:@"MuseoSans-300" size:14];
        lbLocation.text = (_albumType != ALBUM_PHOTO)?[dictContainer objectForKey:@"location"]:[dictContainer objectForKey:@"price"];//@"Melbourne, Blackburn North";
        lbLocation.textColor = [UIColor lightGrayColor];
        if (![dictContainer objectForKey:@"location"] || ((NSString*)[dictContainer objectForKey:@"location"]).length == 0) {
            lbLocation.text = @"No Location";
        }
        
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
//        {
            //older than iOS 8 code here
            if ([lbLocation.text rangeOfString:@"No Location"].location != NSNotFound)
            {
                lbLocation.text = @"";
            }
//        }
//        else
//        {
//             //iOS 8 specific code here
//            if ([lbLocation.text containsString:@"No Location"])
//            {
//                lbLocation.text = @"";
//            }
//            
//            
//        }
        [headerView addSubview:lbLocation];
        
        
        // circle
        UIImage *albumCircleImg = [UIImage imageNamed:@"grey_ring.png"];
        UIButtonWithData    *btnAlbumCircle = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
        btnAlbumCircle.frame = CGRectMake(tblView.frame.size.width - 43, 8, albumCircleImg.size.width, albumCircleImg.size.height);
        [btnAlbumCircle setImage:albumCircleImg forState:UIControlStateNormal];
        [btnAlbumCircle addTarget:self action:@selector(touchAlbumCircle:) forControlEvents:UIControlEventTouchUpInside];
        btnAlbumCircle.buttonTag = BUTTON_HEADER;
        
        [headerView addSubview:btnAlbumCircle];
        
        
        
        // add counter
        UILabel *lbCountHeader = [[UILabel alloc] initWithFrame:btnAlbumCircle.frame];
        lbCountHeader.backgroundColor = [UIColor clearColor];
        lbCountHeader.font = [UIFont systemFontOfSize:20];
        lbCountHeader.textAlignment = NSTextAlignmentCenter;
        lbCountHeader.textColor = UIColorFromRGB(0xeb310b);
        lbCountHeader.minimumFontSize = 8;
        lbCountHeader.adjustsFontSizeToFitWidth = YES;
        lbCountHeader.numberOfLines = 1;
        lbCountHeader.preferredMaxLayoutWidth = lbCountHeader.frame.size.width - 6;
        btnAlbumCircle.object = [NSMutableDictionary dictionaryWithObjectsAndKeys:lbCountHeader,@"label",dictContainer,@"container", nil];
        
        int counter = [[dictContainer objectForKey:@"count"] intValue];
        //    for (int i = 0; i< arrPhotos.count; i++) {
        //        NSMutableDictionary *dictTmp = [arrPhotos objectAtIndex:i];
        //        counter+= [[dictTmp objectForKey:@"count"] intValue];
        //    }
        // se back
        lbCountHeader.text = (counter == 0)?@"":[NSString stringWithFormat:@"%d",counter];
        //-> end header
        [headerView addSubview:lbCountHeader];
        
        [cell.contentView addSubview:headerView];
        
        // add new data
        /// get 2 cells
        //int ITEMS_PER_ROW = 2;
        
        photoContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, tblView.frame.size.width, ((arrPhotos.count + ITEMS_PER_ROW-1) / ITEMS_PER_ROW)*(PHOTO_HEIGHT + PHOTO_GAP))];
        
        photoContainerView.backgroundColor = [UIColor whiteColor];
        
        
        // scan the row
        for (int i = 0; i< arrPhotos.count; i++) {
            
            __block NSMutableDictionary *photoDict = [arrPhotos objectAtIndex:i];
            
            UIView  *aView = [[UIView alloc] initWithFrame:CGRectMake(PHOTO_GAP + (i % ITEMS_PER_ROW)*(PHOTO_HEIGHT + PHOTO_GAP),  (i / ITEMS_PER_ROW)*(PHOTO_HEIGHT+ PHOTO_GAP), PHOTO_HEIGHT, PHOTO_HEIGHT)];
            aView.backgroundColor = [UIColor clearColor];
            aView.clipsToBounds = NO;
            // add image
            __block UIImageViewWithData *imgView = [[UIImageViewWithData alloc] initWithFrame:CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.tag = TAG_PHOTO;
            // set container
            imgView.data = photoDict;
            
            
            // get image from cropped image URL first then from small thumbnail
            NSString *imgPath = [photoDict objectForKey:@"cropped_image"];
            
            UIImage *img =  nil;
            
            if (imgPath == nil)
            {
                img = [photoDict objectForKey:@"image"];
                
                if ([img isKindOfClass:[NSNull class]]) {
                    imgView.image = [UIImage imageNamed:@"default_img_small.png"];
                    [imgView showSpiner:YES];
                    // download now
                    [[Downloader sharedDownloader] downloadWithCacheURL:[photoDict objectForKey:@"url"]
                                                             allowThumb:NO
                                                     andCompletionBlock:^(NSData *data) {
                                                         UIImage *img = [UIImage imageWithData:data];
                                                         
                                                         if (!img) {
                                                             DLog(@"==>%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                             // remove cache now
                                                             [[Downloader sharedDownloader] removeCacheForURL:[photoDict objectForKey:@"url"]];
                                                         }
                                                         else {
                                                             [photoDict setObject:img forKey:@"image"];
                                                             if (_albumType!=ALBUM_PHOTO) {
                                                                 [photoDict setObject:NSStringFromCGSize(img.size) forKey:@"size"];
                                                             }
                                                             
                                                         }
                                                         
                                                         RUN_ON_MAIN_QUEUE(^{
                                                             [imgView showSpiner:NO];
                                                             [UIView transitionWithView:imgView
                                                                               duration:0.7f
                                                                                options:UIViewAnimationOptionTransitionCrossDissolve
                                                                             animations:^{
                                                                                 imgView.image = img;
                                                                             } completion:nil];
                                                         });
                                                     }
                                                        andFailureBlock:^(NSError *error) {
                                                            DLog(@"Download error %@",error.debugDescription);
                                                            RUN_ON_MAIN_QUEUE(^{
                                                                [imgView showSpiner:NO];
                                                            });
                                                        }];
                    
                    //            // downlaod high resolution photo
                    //            [[Downloader sharedDownloader] downloadWithCacheURL:[photoDict objectForKey:@"url_high"]
                    //                                                     allowThumb:NO
                    //                                             andCompletionBlock:^(NSData *data) {
                    //                                                 UIImage *img = [UIImage imageWithData:data];
                    //                                                 imgView.image = img;
                    //                                                 [photoDict setObject:img forKey:@"image_high"];
                    //                                             }
                    //                                                andFailureBlock:^(NSError *error) {
                    //                                                    DLog(@"Download error %@",error.debugDescription);
                    //                                                }];
                }
                else
                {
                    imgView.image = img;
                }
            }
            else
            {
                img = [UIImage imageWithContentsOfFile:imgPath];
                imgView.image = img;
            }
            
            
            /*if ([[photoDict objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
                imgView.image = [UIImage imageNamed:@"default_img_small.png"];
                [imgView showSpiner:YES];
                // download now
                [[Downloader sharedDownloader] downloadWithCacheURL:[photoDict objectForKey:@"url"]
                                                         allowThumb:NO
                                                 andCompletionBlock:^(NSData *data) {
                                                     UIImage *img = [UIImage imageWithData:data];
                                                     
                                                     if (!img) {
                                                         DLog(@"==>%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                         // remove cache now
                                                         [[Downloader sharedDownloader] removeCacheForURL:[photoDict objectForKey:@"url"]];
                                                     }
                                                     else {
                                                         [photoDict setObject:img forKey:@"image"];
                                                         if (_albumType!=ALBUM_PHOTO) {
                                                             [photoDict setObject:NSStringFromCGSize(img.size) forKey:@"size"];
                                                         }
                                                         
                                                     }
                                                     
                                                     RUN_ON_MAIN_QUEUE(^{
                                                         [imgView showSpiner:NO];
                                                         [UIView transitionWithView:imgView
                                                                           duration:0.7f
                                                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                                                         animations:^{
                                                                             imgView.image = img;
                                                                         } completion:nil];
                                                     });
                                                 }
                                                    andFailureBlock:^(NSError *error) {
                                                        DLog(@"Download error %@",error.debugDescription);
                                                        RUN_ON_MAIN_QUEUE(^{
                                                            [imgView showSpiner:NO];
                                                        });
                                                    }];
                
                //            // downlaod high resolution photo
                //            [[Downloader sharedDownloader] downloadWithCacheURL:[photoDict objectForKey:@"url_high"]
                //                                                     allowThumb:NO
                //                                             andCompletionBlock:^(NSData *data) {
                //                                                 UIImage *img = [UIImage imageWithData:data];
                //                                                 imgView.image = img;
                //                                                 [photoDict setObject:img forKey:@"image_high"];
                //                                             }
                //                                                andFailureBlock:^(NSError *error) {
                //                                                    DLog(@"Download error %@",error.debugDescription);
                //                                                }];
            }
            else
                imgView.image = [photoDict objectForKey:@"image"];*/
            
            
            
            //imgView.image=[self.taggedMediaItems[indexPath.row]thumbnailImage];
            
            
            
            [aView addSubview:imgView];
            
            
            // add button photo
            UIButtonWithData    *btnPhoto = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            btnPhoto.frame = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
            [btnPhoto addTarget:self action:@selector(touchPhoto:) forControlEvents:UIControlEventTouchUpInside];
            //btnPhoto.object = lbCount;
            btnPhoto.data = photoDict;
            btnPhoto.dataContainer = dictContainer ;
            [aView addSubview:btnPhoto];
            //btnPhoto.backgroundColor = [UIColor redColor];
            
            // circle
            UIImage *photoCircleImg = [UIImage imageNamed:@"small_circle_number.png"];
            UIButtonWithData    *btnCircle = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            btnCircle.frame = CGRectMake(65, 2, photoCircleImg.size.width, photoCircleImg.size.height);
            [btnCircle setImage:photoCircleImg forState:UIControlStateNormal];
            [btnCircle addTarget:self action:@selector(touchPhotoCircle:) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:btnCircle];
            
            
            BOOL allowCropping = [[[NSUserDefaults standardUserDefaults] objectForKey: kAllowCropping] boolValue];
            if (allowCropping) {
                // square
                UIImage *photoSquareImg = [UIImage imageNamed:@"crop_icon.png"];
                UIButtonWithData    *btnSquare = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
                btnSquare.hidden = NO;
                btnSquare.frame = CGRectMake(2, 2, photoSquareImg.size.width, photoSquareImg.size.height);
                [btnSquare setImage:photoSquareImg forState:UIControlStateNormal];
                [btnSquare addTarget:self action:@selector(touchPhotoSquare:) forControlEvents:UIControlEventTouchUpInside];
                btnSquare.data = photoDict;
                [aView addSubview:btnSquare];
                
                btnPhoto.croppingIcon = btnSquare;
                btnPhoto.indexPath = indexPath;
                btnPhoto.indexColumn = i;
                btnPhoto.photoDict = photoDict;
                
                btnSquare.indexPath = indexPath;
                btnSquare.indexColumn = i;
                btnSquare.photoDict = photoDict;
                
//                if ((indexPath.row == self.cropIndexPath.row) && (i == self.indexColumn)) {
//                    btnSquare.hidden = NO;
//                    self.currentSelectedThumb = btnPhoto;
//                }
            }
            
            
            
            
            // photo frame
            //        NSString    *photoFrameName = @"";
            //        if ([[photoDict objectForKey:@"framed"] boolValue]) {
            //            photoFrameName = @"small_frame_hover.png";
            //            //[imgView activateBorder:YES];
            //
            //            CGRect imgFrame = imgView.frame;
            //            UIImageView *imgViewBorder   = [[UIImageView alloc] initWithFrame:CGRectMake(imgFrame.origin.x-1, imgFrame.origin.y-1, 99, 99)];
            //            imgViewBorder.image = [UIImage imageNamed:@"border_w_shadow.png"];
            //            [aView addSubview:imgViewBorder];
            //        }
            //        else {
            //            photoFrameName = @"small_frame.png";
            //            // no need to activate;
            //            //[imgView activateBorder:NO];
            //        }
            //
            //        UIImage *photoFrameImg = [UIImage imageNamed:photoFrameName];
            //        UIButtonWithData    *btnFrame = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            //        btnFrame.frame = CGRectMake(3, 2, photoFrameImg.size.width, photoFrameImg.size.height);
            //        [btnFrame setImage:photoFrameImg forState:UIControlStateNormal];
            //        [btnFrame addTarget:self action:@selector(touchPhotoFrame:) forControlEvents:UIControlEventTouchUpInside];
            //        btnFrame.data = photoDict;
            //        [aView addSubview:btnFrame];
            
            //        UIButtonWithData    *btnThumb = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            //        btnThumb.frame = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
            //        btnThumb.backgroundColor = [UIColor clearColor];
            //        [btnThumb addTarget:self action:@selector(touchPhotoThumb:) forControlEvents:UIControlEventTouchUpInside];
            //        btnThumb.data = photoDict;
            //        [aView addSubview:btnThumb];
            
            // config button
            if ((i % ITEMS_PER_ROW == 0) || (i % ITEMS_PER_ROW == 1)) {
                btnCircle.buttonTag = BUTTON_NORMAL;
            }
            else
                btnCircle.buttonTag = BUTTON_RIGHT;
            
            // add counter
            UILabel *lbCount = [[UILabel alloc] initWithFrame:btnCircle.frame];
            lbCount.backgroundColor = [UIColor clearColor];
            lbCount.font = [UIFont systemFontOfSize:20];
            lbCount.textAlignment = NSTextAlignmentCenter;
            lbCount.textColor = UIColorFromRGB(0xeb310b);
            
            int counter = [[photoDict objectForKey:@"count"] intValue];
            lbCount.text = (counter == 0)?@"":[NSString stringWithFormat:@"%d",counter];
            btnCircle.object = lbCount;
            btnCircle.data = photoDict;
            btnCircle.dataContainer = dictContainer ;
            [aView addSubview:lbCount];
            
            // copy to btnphoto
            btnPhoto.object = lbCount;
            
            [photoContainerView addSubview:aView];
            //DLog(@"cell = %@ => i=%d",NSStringFromCGRect(aView.frame),i);
        }
        
        [cell.contentView addSubview:photoContainerView];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        [headerView removeFromSuperview];
        [photoContainerView removeFromSuperview];
    
        NSMutableDictionary *hashDict = [[NSMutableDictionary alloc]init];
        hashDict = [hashTagImagesArray objectAtIndex:indexPath.row];
        

        UIView  *hashHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, HEADER_HEIGHT)];
        hashHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, 240, 22)];
        nameLabel.font = [UIFont fontWithName:@"MuseoSans-300" size:14];
        nameLabel.text = [hashDict objectForKey:@"username"];
        nameLabel.textColor = UIColorFromRGB(0xeb310b);
        [hashHeaderView addSubview:nameLabel];
        
        // circle
        UIImage *albumCircleImg = [UIImage imageNamed:@"grey_ring.png"];
        UIButtonWithData    *btnAlbumCircle = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
        btnAlbumCircle.frame = CGRectMake(tblView.frame.size.width - 43, 8, albumCircleImg.size.width, albumCircleImg.size.height);
        [btnAlbumCircle setImage:albumCircleImg forState:UIControlStateNormal];
        [btnAlbumCircle addTarget:self action:@selector(touchAlbumCircle:) forControlEvents:UIControlEventTouchUpInside];
        btnAlbumCircle.buttonTag = BUTTON_HEADER;
        [hashHeaderView addSubview:btnAlbumCircle];
        
        
        
        // add counter
        UILabel *lbCountHeader = [[UILabel alloc] initWithFrame:btnAlbumCircle.frame];
        lbCountHeader.backgroundColor = [UIColor clearColor];
        lbCountHeader.font = [UIFont systemFontOfSize:20];
        lbCountHeader.textAlignment = NSTextAlignmentCenter;
        lbCountHeader.textColor = UIColorFromRGB(0xeb310b);
        lbCountHeader.minimumFontSize = 8;
        lbCountHeader.adjustsFontSizeToFitWidth = YES;
        lbCountHeader.numberOfLines = 1;
        lbCountHeader.preferredMaxLayoutWidth = lbCountHeader.frame.size.width - 6;
        btnAlbumCircle.object = [NSMutableDictionary dictionaryWithObjectsAndKeys:lbCountHeader,@"label",hashDict,@"container", nil];
        
        int counter = [[hashDict objectForKey:@"count"] intValue];
//        int counter = 1;
        //    for (int i = 0; i< arrPhotos.count; i++) {
        //        NSMutableDictionary *dictTmp = [arrPhotos objectAtIndex:i];
        //        counter+= [[dictTmp objectForKey:@"count"] intValue];
        //    }
        // se back
        lbCountHeader.text = (counter == 0)?@"":[NSString stringWithFormat:@"%d",counter];
        //-> end header
        [hashHeaderView addSubview:lbCountHeader];
        
        [cell.contentView addSubview:hashHeaderView];
        
        // add new data
        /// get 2 cells
        //int ITEMS_PER_ROW = 2;
        
        UIView  *hashPhotoContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT, tblView.frame.size.width, 100)];
        
        hashPhotoContainerView.backgroundColor = [UIColor whiteColor];
        
        
        // scan the row
        
//            __block NSMutableDictionary *photoDict = [arrPhotos objectAtIndex:i];
            
//            UIView  *aView = [[UIView alloc] initWithFrame:CGRectMake(PHOTO_GAP + (indexPath.row % ITEMS_PER_ROW)*(PHOTO_HEIGHT + PHOTO_GAP),  (indexPath.row / ITEMS_PER_ROW)*(PHOTO_HEIGHT+ PHOTO_GAP), PHOTO_HEIGHT, PHOTO_HEIGHT)];
        UIView  *aView = [[UIView alloc] initWithFrame:CGRectMake(10, 3, PHOTO_HEIGHT, PHOTO_HEIGHT)];
            aView.backgroundColor = [UIColor clearColor];
            aView.clipsToBounds = NO;
            // add image
            __block UIImageViewWithData *imgView = [[UIImageViewWithData alloc] initWithFrame:CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.tag = TAG_PHOTO;
            // set container
            imgView.data = hashDict;
            
            imgView.image = [hashDict objectForKey:@"thumbnail_image"];
            
            //imgView.image=[self.taggedMediaItems[indexPath.row]thumbnailImage];
            
            
            
            [aView addSubview:imgView];
            
            
            // add button photo
            UIButtonWithData  *btnPhoto = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            btnPhoto.frame = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
            [btnPhoto addTarget:self action:@selector(touchPhoto:) forControlEvents:UIControlEventTouchUpInside];
            //btnPhoto.object = lbCount;
            btnPhoto.data = hashDict;
            btnPhoto.dataContainer = hashDict ;
            [aView addSubview:btnPhoto];
            
            // circle
            UIImage *photoCircleImg = [UIImage imageNamed:@"small_circle_number.png"];
            UIButtonWithData    *btnCircle = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            btnCircle.frame = CGRectMake(65, 2, photoCircleImg.size.width, photoCircleImg.size.height);
            [btnCircle setImage:photoCircleImg forState:UIControlStateNormal];
            [btnCircle addTarget:self action:@selector(touchPhotoCircle:) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:btnCircle];
        
            BOOL allowCropping = [[[NSUserDefaults standardUserDefaults] objectForKey: kAllowCropping] boolValue];
            if (allowCropping) {
                // square
                UIImage *photoSquareImg = [UIImage imageNamed:@"crop_icon.png"];
                UIButtonWithData    *btnSquare = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
                btnSquare.hidden = NO;
                btnSquare.frame = CGRectMake(2, 2, photoSquareImg.size.width, photoSquareImg.size.height);
                [btnSquare setImage:photoSquareImg forState:UIControlStateNormal];
                [btnSquare addTarget:self action:@selector(touchPhotoSquare:) forControlEvents:UIControlEventTouchUpInside];
                btnSquare.data = hashDict;
                [aView addSubview:btnSquare];
                
                btnPhoto.croppingIcon = btnSquare;
                btnPhoto.indexPath = indexPath;
                btnPhoto.indexColumn = 0;
                btnPhoto.photoDict = hashDict;
                
                btnSquare.indexPath = indexPath;
                btnSquare.indexColumn = 0;
                btnSquare.photoDict = hashDict;
                
//                if ((indexPath.row == self.cropIndexPath.row) && (0 == self.indexColumn)) {
//                    btnSquare.hidden = NO;
//                    self.currentSelectedThumb = btnPhoto;
//                }
                
            }
        
        
        
            // photo frame
            //        NSString    *photoFrameName = @"";
            //        if ([[photoDict objectForKey:@"framed"] boolValue]) {
            //            photoFrameName = @"small_frame_hover.png";
            //            //[imgView activateBorder:YES];
            //
            //            CGRect imgFrame = imgView.frame;
            //            UIImageView *imgViewBorder   = [[UIImageView alloc] initWithFrame:CGRectMake(imgFrame.origin.x-1, imgFrame.origin.y-1, 99, 99)];
            //            imgViewBorder.image = [UIImage imageNamed:@"border_w_shadow.png"];
            //            [aView addSubview:imgViewBorder];
            //        }
            //        else {
            //            photoFrameName = @"small_frame.png";
            //            // no need to activate;
            //            //[imgView activateBorder:NO];
            //        }
            //
            //        UIImage *photoFrameImg = [UIImage imageNamed:photoFrameName];
            //        UIButtonWithData    *btnFrame = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            //        btnFrame.frame = CGRectMake(3, 2, photoFrameImg.size.width, photoFrameImg.size.height);
            //        [btnFrame setImage:photoFrameImg forState:UIControlStateNormal];
            //        [btnFrame addTarget:self action:@selector(touchPhotoFrame:) forControlEvents:UIControlEventTouchUpInside];
            //        btnFrame.data = photoDict;
            //        [aView addSubview:btnFrame];
            
            //        UIButtonWithData    *btnThumb = [UIButtonWithData buttonWithType:UIButtonTypeCustom];
            //        btnThumb.frame = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
            //        btnThumb.backgroundColor = [UIColor clearColor];
            //        [btnThumb addTarget:self action:@selector(touchPhotoThumb:) forControlEvents:UIControlEventTouchUpInside];
            //        btnThumb.data = photoDict;
            //        [aView addSubview:btnThumb];
            
            // config button
            if ((indexPath.row % ITEMS_PER_ROW == 0) || (indexPath.row % ITEMS_PER_ROW == 1)) {
                btnCircle.buttonTag = BUTTON_NORMAL;
            }
            else
                btnCircle.buttonTag = BUTTON_RIGHT;
            
            // add counter
            UILabel *lbCount = [[UILabel alloc] initWithFrame:btnCircle.frame];
            lbCount.backgroundColor = [UIColor clearColor];
            lbCount.font = [UIFont systemFontOfSize:20];
            lbCount.textAlignment = NSTextAlignmentCenter;
            lbCount.textColor = UIColorFromRGB(0xeb310b);
            
            int counters = [[hashDict objectForKey:@"count"] intValue];
            lbCount.text = (counters == 0)?@"":[NSString stringWithFormat:@"%d",counters];
            btnCircle.object = lbCount;
            btnCircle.data = hashDict;
            btnCircle.dataContainer = hashDict ;
            [aView addSubview:lbCount];
            
//             copy to btnphoto
            btnPhoto.object = lbCount;
        
            [hashPhotoContainerView addSubview:aView];
            //DLog(@"cell = %@ => i=%d",NSStringFromCGRect(aView.frame),i);
        
        
        [cell.contentView addSubview:hashPhotoContainerView];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
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


#pragma mark utilities
- (void)hideTabBar {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y += 48;
        self.tabBarController.tabBar.frame = frame;
    } completion:^(BOOL finished) {
        DLog(@"frmae = %@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
    }];
    
}

- (CGSize)sizeOfImageAtURL:(NSURL *)imageURL
{
    // With CGImageSource we avoid loading the whole image into memory
    CGSize imageSize = CGSizeZero;
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    if (source) {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCGImageSourceShouldCache];
        //CFDictionaryRef properties = (__bridge CFDictionaryRef)CGImageSourceCopyPropertiesAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(source, 0, (__bridge CFDictionaryRef)options);
        if (properties) {
            NSNumber *width = [(__bridge NSDictionary *)properties objectForKey:(NSString *)kCGImagePropertyPixelWidth];
            NSNumber *height = [(__bridge NSDictionary *)properties objectForKey:(NSString *)kCGImagePropertyPixelHeight];
            if ((width != nil) && (height != nil))
                imageSize = CGSizeMake(width.floatValue, height.floatValue);
            CFRelease(properties);
        }
        CFRelease(source);
    }
    return imageSize;
}

-(void) resetQuantity:(NSNotification*) notification {
    
    if (notification.object != _mainProduct) {
        return;
    }
    
    for (NSMutableDictionary *groupDict in _arrPhotoGroups) {
        [groupDict setObject:[NSNumber numberWithInt:0] forKey:@"count"];
        NSMutableArray  *arr = [groupDict objectForKey:@"photos"];
        for (NSMutableDictionary *photoDict in arr) {
            [photoDict setObject:[NSNumber numberWithInt:0] forKey:@"count"];
        }
    }
    
    [tblView reloadData];
}

-(NSMutableArray*) getAllSelectedPhotos:(NSDictionary*)aDictGroup andProduct:(Product *)aProduct{
    NSMutableArray  *rtnArr = [NSMutableArray new];
    @synchronized (_arrPhotoGroups) {
       
        for (NSDictionary *dictGroup in _arrPhotoGroups) {
            for (NSMutableDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
                if (aDictGroup) {
                    if (![[aDictGroup  objectForKey:@"count_applied"] boolValue]) {
                        [dictPhoto setObject:[aDictGroup objectForKey:@"count"] forKey:@"count"];
                    }
                    if (![[aDictGroup  objectForKey:@"frame_applied"] boolValue]) {
                        [dictPhoto setObject:[aDictGroup objectForKey:@"frame"] forKey:@"framed"];
                    }
                }
                
                if ([[dictPhoto objectForKey:@"count"] intValue] > 0) {
                    [rtnArr addObject:dictPhoto];
                }
            }
        }
    }

    
    return rtnArr;
}

-(int) countSelectedPhotos {
    int count = 0;

    for (NSDictionary *dictGroup in _arrCart) {
        for (NSMutableDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
            
            if ([[dictPhoto objectForKey:@"count"] intValue] > 0) {
                count += [[dictPhoto objectForKey:@"count"] intValue];
            }
        }
    }
    
    return count;
}

-(int) countSelectedPhotosWithinCart {
    int count = 0;
    @synchronized(_arrPhotos) {
        for (NSDictionary *dictGroup in _arrPhotos) {
            for (NSMutableDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
                
                if ([[dictPhoto objectForKey:@"count"] intValue] > 0) {
                    count += [[dictPhoto objectForKey:@"count"] intValue];
                }
            }
        }
    }
    return count;
}

#pragma mark actions
-(void) touchPhoto:(UIButtonWithData*)btn {
    
    isUpdated = YES;
    cropCoach = YES;
    [self setupActivityIndicator];

    tmpDict = (NSMutableDictionary*)btn.data;

    int photoCount = [[tmpDict objectForKey:@"count"] intValue];

    
    //[aView addSubview:pickerNumber];
    UILabel *lbTmp = (UILabel*)btn.object;
    

    if (photoCount == 0) {
        lbTmp.text = @"1";
        lbTmp.hidden = NO;
        lbTmp.textColor = UIColorFromRGB(0xeb310b);
        [tmpDict setObject:[NSNumber numberWithInt:1] forKey:@"count"];
    }
    else {
//        lbTmp.text = @"0";
//        lbTmp.hidden = YES;
//        [tmpDict setObject:[NSNumber numberWithInt:0] forKey:@"count"];
    }
   
    [self showNumberSelector:NO];
    
    [self toAddHashtagData];
    // TEMPORARY DISABLE
   [self showNumberSelector:NO];
    UIView  *viewContainer = [btn superview];
    UIImage *imgPhoto = nil;
    NSMutableDictionary *dict = nil;
    for (UIView *aView in viewContainer.subviews) {
        if (aView.tag == TAG_PHOTO) {
            UIImageViewWithData *imgView= (UIImageViewWithData*)aView;
            imgPhoto = imgView.image;
            dict = imgView.data;
            break;
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SqlManager  *sqlMan = [SqlManager defaultShare];
    NSLog(@"%@",[defaults objectForKey:PRODUCTID]);
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE original_imgpath = '%@' and product_id='%@'",[dict objectForKey:@"url_high"],[defaults objectForKey:PRODUCTID]];
    NSMutableArray *tmpArr = [sqlMan doQueryAndGetArray:sql];
    
    PhotoPreviewViewController  *photoController = [[PhotoPreviewViewController alloc] initWithNibName:@"PhotoPreviewViewController" bundle:[NSBundle mainBundle]];
    photoController.protocolDatas =(id)self;
    
    // Show cropping icon on thumbnail
    self.currentSelectedThumb = btn;
    self.indexColumn = btn.indexColumn;
    self.cropIndexPath = btn.indexPath;
    
//    if ([btn isEqual: self.currentSelectedThumb]) {
//        self.currentSelectedThumb.croppingIcon.hidden = YES;
//        self.currentSelectedThumb = nil;
//        self.cropIndexPath = nil;
//        self.indexColumn = -1;
//        
//    } else {
//        
//        if (self.currentSelectedThumb) {
//            self.currentSelectedThumb.croppingIcon.hidden = YES;
//            //self.currentSelectedThumb.backgroundColor = [UIColor redColor];
//            self.currentSelectedThumb = nil;
//            self.cropIndexPath = nil;
//            self.indexColumn = -1;
//            
//        }
//        
//        self.currentSelectedThumb = btn;
//        self.indexColumn = btn.indexColumn;
//        self.cropIndexPath = btn.indexPath;
//        
//        btn.croppingIcon.hidden = NO;
//        
//    }
    
    
    self.photoDict = dict;
    photoController.photoDict = dict;
    photoController.dataArray = tmpArr;
    if (_albumType == ALBUM_INSTAGRAM )
    {
        if (tblView.tag == 1)
        {
            photoController.type = @"instagram";
        }
        else
        {
            photoController.type = @"hashtag";
        }
    }
    else
    {
        photoController.type = @"others";
    }
    //[self.navigationController pushViewController:photoController animated:YES];

    [self updateCartInfo];
    [self.HUD hide:YES];

}


- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    // Set the tools to Stickers, Frames, Enhance, and Crop (to be displayed in that order).
    [AdobeImageEditorCustomization setToolOrder:@[kAFCrop]];//kAFOrientation
    
    // Disable the Custom and Original crop options, and do not allow the user to invert the settings.
    [AdobeImageEditorCustomization setCropToolCustomEnabled:NO];
    [AdobeImageEditorCustomization setCropToolInvertEnabled:NO];
    [AdobeImageEditorCustomization setCropToolOriginalEnabled:NO];
    
    // Create two custom presets displayed to the user as "Option1" and "Option2" with 3:7 and 4:11 aspect ratios, respectively.
    [AdobeImageEditorCustomization setCropToolPresets:@[@{kAFCropPresetName:@"Square", kAFCropPresetWidth:@1, kAFCropPresetHeight:@1}]];
    
    
    UIView *vBottom = [[UIView alloc] initWithFrame: CGRectMake(0, editorController.view.frame.size.height-25, editorController.view.frame.size.width, 25)];
    vBottom.backgroundColor = [self colorWithRed:36 green:36 blue:36];
    [editorController.view addSubview: vBottom];
    [self presentViewController:editorController animated:YES completion:^{
        
        
    }];
}

- (UIColor *) colorWithRed:(float)red green:(float)green blue:(float)blue {
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

-(void) touchPhotoSquare:(UIButtonWithData*) btn {
    
    self.currentSelectedThumb = btn;
    
    NSLog(@"Did tap on Crop icon at column: %d  Row: %d", btn.indexColumn, btn.indexPath.row);
    
    //url_high
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        
        // First, write orientation to UIImage, i.e., EXIF message.
        UIImage *image = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        // Second, fix orientation, and drop out EXIF
        if (image.imageOrientation != UIImageOrientationUp) {
            UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
            [image drawInRect:(CGRect){0, 0, image.size}];
            UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            image = normalizedImage;
        }
        
        self.imageToCrop = image;//[UIImage imageWithCGImage: iref];
        [self displayEditorForImage: self.imageToCrop];//[UIImage imageNamed: @"Default.png"]
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"hi, cant get image - %@",[myerror localizedDescription]);
    };
    
    NSURL *url = [btn.photoDict objectForKey:@"url_high"];
    _photoDict = [NSMutableDictionary dictionaryWithDictionary: btn.data];
    
    if ([url isKindOfClass: [NSString class]]) {
        url = [NSURL URLWithString: url];
    }
    
    if ([[url absoluteString] rangeOfString:@"assets-library://"].location != NSNotFound) {
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:url resultBlock:resultblock failureBlock:failureblock];
        
        
        NSLog(@"%@",resultblock);
        
    } else if(IS_NOT_NULL(url)) {
        
        [self setupActivityIndicator];
        NSData *data = [NSData dataWithContentsOfURL: url];
        [self.HUD hide: NO];
        
        if (IS_NOT_NULL(data)) {
            
            self.imageToCrop = [UIImage imageWithData: data];
            [self displayEditorForImage: self.imageToCrop];
        }
        
    }
    
}


-(void) touchPhotoCircle:(UIButtonWithData*) btn {
    isUpdated = YES;
    cropCoach = NO;
    
   
    if (currPhotoBtn.buttonTag == BUTTON_HEADER) {
        [currPhotoBtn setImage:[UIImage imageNamed:@"grey_ring.png"] forState:UIControlStateNormal];
        currLbAlbumCount.textColor = UIColorFromRGB(0xeb310b);
    }
    else
    [currPhotoBtn setImage:[UIImage imageNamed:@"small_circle_number.png"] forState:UIControlStateNormal];
    currLbCount.textColor = UIColorFromRGB(0xeb310b);
    
    // setback
    currLbCount.hidden = NO;
    
    // hide counter
    currLbCount = btn.object;
    currDict = btn.data;
    currContainer = btn.dataContainer;
    
    int photoCount = [[currDict objectForKey:@"count"] intValue];
    //[pickerNumber selectRow:row inComponent:0 animated:NO];
    
    currLbCount.textColor = [UIColor whiteColor];
    //pickerNumber.hidden = NO;

    //currLbCount.hidden = YES;
    [imgViewPhotoShadow removeFromSuperview];
    imgViewPhotoShadow.alpha = 0;
    //pickerNumber.alpha = 0;
    UIView  *aView = btn.superview;
    currPhotoBtn = btn;
    currPhotoView = aView;
    [btn setImage:[UIImage imageNamed:@"red_circle_small.png"] forState:UIControlStateNormal];

    [aView addSubview:imgViewPhotoShadow];
    //[aView addSubview:pickerNumber];
    
    //show counter
    CGPoint point = [btn.superview convertPoint:btn.frame.origin toView:self.view];
    if (btn.buttonTag == BUTTON_NORMAL) {
        [numberSelector setSelectorStyle:SELECTOR_SMALL];
        numberSelector.frame = CGRectMake(point.x - 101/2 + btn.frame.size.width/2, point.y + btn.frame.size.height+2, 101, 157);
    }
    else {
        // default or right
        [numberSelector setSelectorStyle:SELECTOR_BIG];
        numberSelector.frame = CGRectMake(point.x - 55, point.y + btn.frame.size.height+2, 101, 157);
    }
    
    
    [numberSelector setValue:(photoCount == 0)?1:photoCount];
    if (photoCount == 0) {
        currLbCount.text = @"1";
        [currDict setObject:[NSNumber numberWithInt:1] forKey:@"count"];
    }
    
    [self showNumberSelector:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        imgViewPhotoShadow.alpha = 1;
        //pickerNumber.alpha = 1;
    }];
    [self toAddHashtagData];
    [self updateCartInfo];
}

-(void) touchAlbumCircle:(UIButtonWithData*) btn {
    isUpdated = YES;
    
    if (currPhotoBtn.buttonTag == BUTTON_HEADER) {
        [currPhotoBtn setImage:[UIImage imageNamed:@"grey_ring.png"] forState:UIControlStateNormal];
    }
    else {
        [currPhotoBtn setImage:[UIImage imageNamed:@"white_circle_small.png"] forState:UIControlStateNormal];
        currLbCount.textColor = UIColorFromRGB(0xeb310b);
    }
    // setback
    currLbAlbumCount.hidden = NO;
    currLbAlbumCount.textColor = UIColorFromRGB(0xeb310b);
    // hide counter
    NSMutableDictionary    *dictCircle = btn.object;
    currLbAlbumCount = [dictCircle objectForKey:@"label"];
    //currDict = btn.data;
    
    int photoCount = [currLbAlbumCount.text intValue];
    //[pickerNumber selectRow:row inComponent:0 animated:NO];
    
    currLbAlbumCount.textColor = [UIColor whiteColor];
    //pickerNumber.hidden = NO;
    
    //currLbAlbumCount.hidden = YES;
    //pickerNumber.alpha = 0;

    currPhotoBtn = btn;
    [btn setImage:[UIImage imageNamed:@"red_circle_small.png"] forState:UIControlStateNormal];

    //[aView addSubview:pickerNumber];
    
    //show counter
    CGPoint point = [btn.superview convertPoint:btn.frame.origin toView:self.view];
    if (btn.buttonTag == BUTTON_NORMAL) {
        [numberSelector setSelectorStyle:SELECTOR_SMALL];
        numberSelector.frame = CGRectMake(point.x - 101/2 + btn.frame.size.width/2, point.y + btn.frame.size.height+2, 101, 157);
    }
    else {
        // default or right
        [numberSelector setSelectorStyle:SELECTOR_BIG];
        numberSelector.frame = CGRectMake(point.x - 55, point.y + btn.frame.size.height+2, 101, 157);
    }
    
    
    [numberSelector setValue:(photoCount==0)?1:photoCount];
    
    if (photoCount == 0) {
        [[dictCircle objectForKey:@"container"] setObject:[NSNumber numberWithInt:1] forKey:@"count"];
        NSArray *arrTmp = [[dictCircle objectForKey:@"container"] objectForKey:@"photos"];
        for (NSMutableDictionary *dictTmp in arrTmp) {
            [dictTmp setObject:[NSNumber numberWithInt:1] forKey:@"count"];
        }
        currLbAlbumCount.text = @"1";
        [tblView reloadData];
    }
    [self showNumberSelector:YES];
    
    [self updateCartInfo];
}

//-(void) touchPhotoFrame:(UIButtonWithData*) aFrameBtn {
//    NSMutableDictionary *dict = (NSMutableDictionary*)aFrameBtn.data;
//    if ([[dict objectForKey:@"framed"] boolValue]) {
//        // set to false
//        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"framed"];
//        [aFrameBtn setImage:[UIImage imageNamed:@"small_frame.png"] forState:UIControlStateNormal];
//    }
//    else {
//        // set to true
//        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"framed"];
//        [aFrameBtn setImage:[UIImage imageNamed:@"small_frame_hover.png"] forState:UIControlStateNormal];
//    }
//    [tblView reloadData];
//}
//
//-(void) touchAlbumFrame:(UIButtonWithData*) aFrameBtn {
//    NSMutableDictionary *dict = (NSMutableDictionary*)aFrameBtn.data;
//    BOOL applyFrame = !([[dict objectForKey:@"framed"] boolValue]);
//    NSString    *albumFrameImage = (applyFrame)?@"frame_of_album_hover.png":@"frame_of_album.png";
//    UIImage *albumFrameImg = [UIImage imageNamed:albumFrameImage];
//    [aFrameBtn setImage:albumFrameImg forState:UIControlStateNormal];
//    [dict setObject:[NSNumber numberWithBool:applyFrame] forKey:@"framed"];
//    NSMutableArray  *arr = [dict objectForKey:@"photos"];
//    for (NSMutableDictionary *dict in arr) {
//        [dict setObject:[NSNumber numberWithBool:applyFrame] forKey:@"framed"];
//        //refresh
//    }
//    
//    [tblView reloadData];
//}

-(void) touchBack {
    if (isUpdated && _isOrderPreview) {
        [_delegate dataUpdated];
    }
    //[self showNumberSelector:NO];
    [UIView animateWithDuration:0.75 animations:^{
        numberSelector.alpha = 0;
    } completion:^(BOOL finished) {
        numberSelector.hidden = YES;
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) touchCart {
    
    [self toAddHashtagData];
    /// go to cart
    /// go to cart
    //[self showNumberSelector:NO];
    [UIView animateWithDuration:0.75 animations:^{
        numberSelector.alpha = 0;
    } completion:^(BOOL finished) {
        numberSelector.hidden = YES;
        
    }];
    [[HomeViewController getShared] addToCart:_mainProduct];
    
}

-(void) toAddHashtagData
{
    if (tblView.tag ==2 || tblView.tag == 1)
    {
        if (hashTagImagesArray.count)
        {
            NSMutableDictionary *hashImagesDict = [[NSMutableDictionary alloc]init];
            NSString *pageString = [NSString stringWithFormat:@"%d",page];
            [hashImagesDict setObject:hashTagImagesArray forKey:@"hashTagImages"];
            [hashImagesDict setObject:pageString forKey:@"page"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HashTagData" object:self userInfo:hashImagesDict];
            NSLog(@"%@",hashTagImagesArray);
        }
        
    }

}

//-(IBAction) touchFacebook {
//    // show facebook album
//}
//
//-(IBAction) touchInstagram {
//    // go to instagram album
//}
//
//-(IBAction) touchCamera {
//    // show camera & photolibrary
//}

-(void) updateCartInfo {
    
    int count  = 0 ;
    if (_isOrderPreview) {
        // count
        count = [self countSelectedPhotosWithinCart];
    }
    else
        count = [[HomeViewController getShared] countAllSelectedPhotos:_mainProduct];
    

    
//    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
//    lbText.text =[NSString stringWithFormat:@"%d",count];
//    lbText.font = [UIFont systemFontOfSize:13];
//    lbText.backgroundColor = [UIColor clearColor];
//    lbText.textColor = [UIColor whiteColor];
//    //lbText.backgroundColor = [UIColor blueColor];
//    lbText.textAlignment = NSTextAlignmentCenter;
//    [lbText sizeToFit];
//    CGSize size = [lbText.text sizeWithFont:lbText.font];
//    CGFloat imgWidth, imgHeight;
//    imgWidth = 8.5 * 2 + size.width/2;
//    imgHeight = 17;
//    lbText.frame = CGRectMake(0, 0, imgWidth, 17);
//    //UIImage *imgBg = [[UIImage imageNamed:@"notification_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:0];
//    
//    UIView *imgViewNotification = [[UIView alloc] initWithFrame:CGRectMake(10, 0, imgWidth, imgHeight)];
//    imgViewNotification.backgroundColor = [UIColor clearColor];
//    //imgViewNotification.image =imgBg;
//    // add label
//    [imgViewNotification addSubview:lbText];
    UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCart.frame = CGRectMake(0, 0, 31, 28);
    [btnCart setImage:[UIImage imageNamed:@"card_btn"] forState:UIControlStateNormal];
    Product *aProduct = _mainProduct;
    if (_isOrderPreview) {
        NSDictionary *dict = [_arrPhotos objectAtIndex:0];
        aProduct = [dict objectForKey:@"product"];
    }
    
//    if (!_isOrderPreview) {
        int quantitySet  =[aProduct.quantity_set intValue];
        int multiply = count / quantitySet;
        if (count % quantitySet != 0) {
            multiply++;
        }
        if (multiply == 0) {
            multiply = 1;
        }
        [btnCart addTarget:self action:@selector(touchCart) forControlEvents:UIControlEventTouchUpInside];
        [self setScreenTitle:[NSString stringWithFormat:@"%d/%d",count,quantitySet*multiply]];
//    }
//    else
//        [self setScreenTitle:[NSString stringWithFormat:@"%d/%d",[self countSelectedPhotosWithinCart],count]];
    if (_isOrderPreview)
    {
        [btnCart removeFromSuperview];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
    }
    
    // draw on button
    //[btnCart addSubview:imgViewNotification];
        

    //}

}

#pragma mark - AdobeUXImageEditorViewControllerDelegate

- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    [self dismissViewControllerAnimated: NO completion:^{
        
//        CGSize oldSize = self.imageToCrop.size;
//        CGSize cropSize = image.size;
        
        if ((self.imageToCrop.size.width == image.size.width) && (self.imageToCrop.size.height == image.size.height)) {
            return;
        }
        
        [self setupActivityIndicator];
        
        [self touchPhoto: self.currentSelectedThumb];
        
        
        [self performSelector: @selector(processAfterCropping:) withObject: image afterDelay: 4.0];//8
    }];

}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    // Handle cancellation here
    [self dismissViewControllerAnimated: YES completion: nil];
}


- (void)processAfterCropping:(UIImage *)croppedImage {
    
    _photoDict = [NSMutableDictionary dictionaryWithDictionary: self.currentSelectedThumb.data];
    
    [_photoDict setObject:NSStringFromCGSize(croppedImage.size) forKey:@"size"];
    [_photoDict setObject:[NSNumber numberWithBool:NO] forKey:@"framed"];
    
    [self updateImage: croppedImage];
    
    [self.HUD hide:YES];
    [MBProgressHUD hideAllHUDsForView: self.view animated: NO];
    
    UIAlertView *cropMessage = [[UIAlertView alloc]initWithTitle:@"The Cropped Image has been added to Cart" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [cropMessage show];
}

-(void) updateImage:(UIImage *)croppedImage
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathWithFolderName = [documentsDirectory stringByAppendingPathComponent:@"images"];
    
    NSError *createError;
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathWithFolderName])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathWithFolderName withIntermediateDirectories:NO attributes:nil error:&createError];
    }
    NSString *savedImagePath = [pathWithFolderName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",dateString]];
    UIImage *image = croppedImage;
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sql = [NSString stringWithFormat:@"update upload_image set  img_path='%@' WHERE original_imgpath='%@' AND product_id='%@'",dateString,[self.photoDict objectForKey:@"url_high"],[defaults objectForKey:PRODUCTID]];
    [[SqlManager defaultShare] doUpdateQuery:sql];
    [_photoDict setObject:savedImagePath forKey:@"cropped_image"];
    [_photoDict setObject:dateString forKey:@"cropImage"];
    
    
    // add cropped image path into arrPhotoGroups
    for (NSDictionary *dictGroup in _arrPhotoGroups) {
        for (NSMutableDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
            if ([dictPhoto objectForKey:@"url_high"] == [_photoDict objectForKey:@"url_high"]) {
                [dictPhoto setValue:[_photoDict objectForKey:@"cropped_image"] forKey:@"cropped_image"];
            }
        }
    }

    
    [self uploadcroppedImage:image];
    
    if (_isOrderPreview)
    {
        [tblView reloadData];
    }
}


// to upload cropped Image to server
-(void) uploadcroppedImage:(UIImage *)image
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE original_imgpath = '%@'",[_photoDict objectForKey:@"url_high"]];
    // update
    NSArray *arr = [[SqlManager defaultShare] doQueryAndGetArray:sqlQuery];
    for (NSDictionary *dictImage in arr)
    {
        [[APIServices
          sharedAPIServices] uploadPhoto:image
         onFail:^(NSError *error) {
             DLog(@"fail to upload image ");
             // restart
             [self uploadcroppedImage:image];
             //             [[Uploader shared] start];
         } onDone:^(NSError *error, id obj) {
             DLog(@"upload image  and get ID=%@",obj);
             NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
             
             if (!error) {
                 if ([dict objectForKey:@"error"]) {
                     DLog(@"Upload iamge error => %@",dict);
                 }
                 else {
                     NSString *rtnImgId = [dict objectForKey:@"uid"];
                     if (rtnImgId && rtnImgId.length > 0) {
                         // update id
                         NSString *sql = [NSString stringWithFormat:@"UPDATE upload_image SET uploaded = 'true' , uploaded_id ='%@' WHERE id = '%@'",rtnImgId,[dictImage objectForKey:@"id"]];
                         // update
                         [[SqlManager defaultShare] doUpdateQuery:sql];
                     }
                     else
                         DLog(@"UID of upload photo is wrong! check again  %@",dict);
                 }
             }
             else
                 DLog(@"Fail to upload photo with error %@",error.debugDescription);
             // start again
             //             [self uploadcroppedImage:image];
             //             [[Uploader shared] start];
         }];
        
    }
}

@end
