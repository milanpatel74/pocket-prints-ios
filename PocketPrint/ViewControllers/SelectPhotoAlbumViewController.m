//
//  SelectPhotoViewController.m
//  PocketPrint
//
//  Created by Quan Do on 12/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "HomeViewController.h"


#import "SelectPhotoAlbumViewController.h"
#import "InstagramOAuthViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "CheckoutViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SelectPhotoAlbumViewController ()

@end

@implementation SelectPhotoAlbumViewController
@synthesize page;

#define CELL_HEIGHT 208
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTabBar];
    

    
    [self updateCartInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    

    
    [self setScreenTitle:@"Select Albums"];
    
    // add navigation buttons
//    UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCart.frame = CGRectMake(0, 0, 21, 16);
//    [btnCart setBackgroundImage:[UIImage imageNamed:@"card_btn.png"] forState:UIControlStateNormal];
//    [btnCart addTarget:self action:@selector(touchCart) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCart];

    [self updateCartInfo];
    
    self.navigationItem.hidesBackButton = YES;
    

    
    arrPhotoGroups = [NSMutableArray new];
    tblView.backgroundColor = [UIColor clearColor];
    
    // get default album
    
    [self getDefaultPhotoAlbum];
    
    //number selector
    numberSelector = [[NumberSelectorView alloc] initWithFrame:CGRectZero andStyle:SELECTOR_SMALL];
    numberSelector.hidden = YES;
    numberSelector.delegate = self;
    [self.view addSubview:numberSelector];
    isShowNumberSelector = NO;
    
    dictPhotosScreen = [NSMutableDictionary new];
  
    
}

-(void) viewDidLayoutSubviews {
    DLog(@"height -=%.1f",self.view.frame.size.height);
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



#pragma mark scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self showNumberSelector:NO];
}

#pragma mark collection view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showNumberSelector:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (arrPhotoGroups.count + 1) / 2;

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.frame = CGRectMake(0, 0, tblView.frame.size.width, CELL_HEIGHT);
    
    // remove all contents
    for (UIView *aView in cell.contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    // add new data
    /// get 2 cells
    __block NSMutableDictionary    *dict1 = [arrPhotoGroups objectAtIndex:indexPath.row*2];
    __block NSMutableDictionary    *dict2;
    // check if over flow
    if (indexPath.row*2+1 < arrPhotoGroups.count) {
        dict2 = [arrPhotoGroups objectAtIndex:indexPath.row*2+1];
    }
    
    // add view now
    __block SelectPhotoView *viewLeft = (SelectPhotoView*)[[UIViewController alloc] initWithNibName:@"SelectPhotoView" bundle:[NSBundle mainBundle]].view;
    viewLeft.lbGroupName.text = [[dict1 objectForKey:@"name"] uppercaseString];
    viewLeft.delegate = self;
    viewLeft.data = dict1;
    viewLeft.isLeftCell = YES;
    viewLeft.btnFrame.hidden = YES;
    viewLeft.imgViewCircle.hidden = YES;
    viewLeft.btnNumber.hidden = YES;
    viewLeft.btnFrame.hidden = YES;
    
    cell.contentView.autoresizesSubviews = NO;
    
    if ([[dict1 objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
        viewLeft.imgView.image = [UIImage imageNamed:@"default_img_big.png"];
        // download now
        [viewLeft showSpiner:YES];
        [[Downloader sharedDownloader] downloadWithCacheURL:[dict1 objectForKey:@"url"]
                                                 allowThumb:NO
                                         andCompletionBlock:^(NSData *data) {
                                             UIImage *img = [UIImage imageWithData:data];
                                             
                                             [dict1 setObject:img forKey:@"image"];
                                             RUN_ON_MAIN_QUEUE(^{
                                                 [UIView transitionWithView:viewLeft.imgView
                                                                   duration:0.7f
                                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                                                 animations:^{
                                                                     viewLeft.imgView.image = img;
                                                                 } completion:nil];
                                                 [viewLeft showSpiner:NO];
                                             });
                                         }
                                            andFailureBlock:^(NSError *error) {
                                                DLog(@"Download error %@",error.debugDescription);
                                                RUN_ON_MAIN_QUEUE(^{
                                                    [viewLeft showSpiner:NO];
                                                });
                                            }];
    }
    else
    {
        viewLeft.imgView.image = [dict1 objectForKey:@"image"];
    }
    
    // check for count
    int count = [[dict1 objectForKey:@"count"] intValue];
    if (count == 0) {
        [viewLeft.imgViewCircle setImage:[UIImage imageNamed:@"circle_bg.png"]];
        viewLeft.lbNumberOfPhotos.textColor = UIColorFromRGB(0xcb776c);
    }
    else {
        [viewLeft.imgViewCircle setImage:[UIImage imageNamed:@"red_circle_big.png"] ];
        viewLeft.lbNumberOfPhotos.text = [NSString stringWithFormat:@"%d",count];
        viewLeft.lbNumberOfPhotos.textColor = [UIColor whiteColor];
    }
    
    // check for frame
    [viewLeft applyFrame:[[dict1 objectForKey:@"frame"] boolValue]];
    if ([[dict1 objectForKey:@"frame"] boolValue]) {
        [viewLeft.btnFrame setImage:[UIImage imageNamed:@"frame_btn_hover.png"] forState:UIControlStateNormal];
    }
    else
        [viewLeft.btnFrame setImage:[UIImage imageNamed:@"frame_btn.png"] forState:UIControlStateNormal];

    [cell.contentView addSubview:viewLeft];
    
    float gap = (tblView.frame.size.width - viewLeft.frame.size.width*2)/3;
    
    // set view left x post
    [viewLeft setXPos:gap ];
    if (dict2) {
        // add second view
        __block SelectPhotoView *viewRight = (SelectPhotoView*)[[UIViewController alloc] initWithNibName:@"SelectPhotoView" bundle:[NSBundle mainBundle]].view;
        viewRight.lbGroupName.text = [[dict2 objectForKey:@"name"] uppercaseString];
        CGRect frame = viewRight.frame;
        frame.origin.x +=  viewLeft.frame.size.width + gap*2;
        viewRight.frame = frame;
        viewRight.data = dict2;
        viewRight.isLeftCell = NO;
        [cell.contentView addSubview:viewRight];
        viewRight.delegate = self;
        //hide
        viewRight.btnFrame.hidden = YES;
        viewRight.imgViewCircle.hidden = YES;
        viewRight.btnNumber.hidden = YES;
        
        if ([[dict2 objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
            viewRight.imgView.image = [UIImage imageNamed:@"default_img_big.png"];
            [viewRight showSpiner:YES];
            // download now
            [[Downloader sharedDownloader] downloadWithCacheURL:[dict2 objectForKey:@"url"]
                                                     allowThumb:NO
                                             andCompletionBlock:^(NSData *data) {
                                                 UIImage *img = [UIImage imageWithData:data];
                                                 
                                                 [dict2 setObject:img forKey:@"image"];
                                                 RUN_ON_MAIN_QUEUE(^{
                                                     [UIView transitionWithView:viewRight.imgView
                                                                       duration:0.7f
                                                                        options:UIViewAnimationOptionTransitionCrossDissolve
                                                                     animations:^{
                                                                         viewRight.imgView.image = img;
                                                                     } completion:nil];
                                                    [viewRight showSpiner:NO];
                                                 });
                                             }
                                                andFailureBlock:^(NSError *error) {
                                                    DLog(@"Download error %@",error.debugDescription);
                                                    RUN_ON_MAIN_QUEUE(^{
                                                        [viewRight showSpiner:NO];
                                                    });
                                                }];
        }
        else {
            viewRight.imgView.image = [dict2 objectForKey:@"image"];
        }
        
        // check for count
        int count = [[dict2 objectForKey:@"count"] intValue];
        if (count == 0) {
            [viewRight.imgViewCircle setImage:[UIImage imageNamed:@"circle_bg.png"]];
            viewRight.lbNumberOfPhotos.textColor = UIColorFromRGB(0xcb776c);
        }
        else {
            [viewRight.imgViewCircle setImage:[UIImage imageNamed:@"red_circle_big.png"]];
            viewRight.lbNumberOfPhotos.textColor = [UIColor whiteColor];
            viewRight.lbNumberOfPhotos.text = [NSString stringWithFormat:@"%d",count];
        }
        
        // check for frame
        [viewRight applyFrame:[[dict2 objectForKey:@"frame"] boolValue]];
        if ([[dict2 objectForKey:@"frame"] boolValue]) {
            [viewRight.btnFrame setImage:[UIImage imageNamed:@"frame_btn_hover.png"] forState:UIControlStateNormal];
        }
        else
            [viewRight.btnFrame setImage:[UIImage imageNamed:@"frame_btn.png"] forState:UIControlStateNormal];
    }
  
    
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark select view delegate
-(void) touchPhoto:(id)aPhotoView {
    if (isShowNumberSelector) {
        [self showNumberSelector:NO];
        return;
    }
    
    SelectPhotoView *photoView = (SelectPhotoView*) aPhotoView;
    SelectPhotoViewController   *selectPhotoController = nil;
    if (albumSection == SECTION_FACEBOOK) {
        selectPhotoController = [[dictPhotosScreen objectForKey:[photoView.data objectForKey:@"id"]] objectForKey:@"controller"];
    }
    else
    {
        selectPhotoController = [[dictPhotosScreen objectForKey:[photoView.data objectForKey:@"name"]] objectForKey:@"controller"];
    }
    
    if (!selectPhotoController) {
        selectPhotoController = [[SelectPhotoViewController alloc] initWithNibName:@"SelectPhotoViewController" bundle:[NSBundle mainBundle]];
        selectPhotoController.page = page;
        selectPhotoController.mainProduct = _mainProduct;
        if (albumSection == SECTION_FACEBOOK) {
            selectPhotoController.albumType = ALBUM_FACEBOOK;
            if (photoView.data) {
                selectPhotoController.fbAlbumId = [photoView.data objectForKey:@"id"];
            }
            [dictPhotosScreen setObject:[NSDictionary dictionaryWithObjectsAndKeys:selectPhotoController,@"controller",photoView.data,@"data", nil] forKey:selectPhotoController.fbAlbumId];
        }
        else {
            // section photo
            selectPhotoController.albumType = ALBUM_CAMERA;
            selectPhotoController.albumName = [photoView.data objectForKey:@"name"];
            [dictPhotosScreen setObject:[NSDictionary dictionaryWithObjectsAndKeys:selectPhotoController,@"controller",photoView.data,@"data", nil] forKey:selectPhotoController.albumName];
        }
        
        
        // add to dict
        
    }
    selectPhotoController.refData = photoView.data;

    [self.navigationController pushViewController:selectPhotoController animated:YES];
}

-(void) touchNumber:(SelectPhotoView*)aPhotoView {
    // clear last view
    [currPhotoView.imgViewCircle setImage:[UIImage imageNamed:@"circle_bg.png"]];
    currPhotoView.lbNumberOfPhotos.textColor = UIColorFromRGB(0xcb776c);
    
    //new view
    currPhotoView = aPhotoView;
//    [aPhotoView.btnNumber setImage:[UIImage imageNamed:@"red_circle_big.png"] forState:UIControlStateNormal];
//    aPhotoView.lbNumberOfPhotos.textColor = [UIColor whiteColor];
    
    CGPoint point = [aPhotoView convertPoint:aPhotoView.btnNumber.frame.origin toView:self.view];
    // check for left right to caculate center point
    if (aPhotoView.isLeftCell) {
        // left
        [numberSelector setSelectorStyle:SELECTOR_SMALL];
        numberSelector.frame = CGRectMake(point.x - 101/2 + aPhotoView.btnNumber.frame.size.width/2, point.y+aPhotoView.btnNumber.frame.size.height+2, 101, 157);
    }
    else {
        [numberSelector setSelectorStyle:SELECTOR_BIG];
        numberSelector.frame = CGRectMake(point.x - 55, point.y+aPhotoView.btnNumber.frame.size.height+2, 101, 157);
    }
    
    if (aPhotoView.lbNumberOfPhotos.text.length == 0) {
        [numberSelector setValue:1];
    }
    else
    {
        [numberSelector setValue:[aPhotoView.lbNumberOfPhotos.text intValue]];
    }
    [self showNumberSelector:YES];
}


-(void) touchFrame:(SelectPhotoView *)aPhotoView {
    NSMutableDictionary *dict = (NSMutableDictionary*) aPhotoView.data;
    if ([[dict objectForKey:@"frame"] boolValue]) {
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"frame"];
        [aPhotoView.btnFrame setImage:[UIImage imageNamed:@"frame_btn.png"] forState:UIControlStateNormal];
    }
    else {
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"frame"];
        [aPhotoView.btnFrame setImage:[UIImage imageNamed:@"frame_btn_hover.png"] forState:UIControlStateNormal];
    }
    [aPhotoView applyFrame:[[dict objectForKey:@"frame"] boolValue]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"frame_applied"];
}
#pragma mark number selector

-(void) selectedNumber:(int) aNumber {
    // hide
    [self showNumberSelector:NO];
    //set
    currPhotoView.lbNumberOfPhotos.text = [NSString stringWithFormat:@"%d",aNumber];
    currPhotoView.lbNumberOfPhotos.textColor = UIColorFromRGB(0xcb776c);
    
    //set back to dict
    NSMutableDictionary *dict = (NSMutableDictionary*) currPhotoView.data;
    [dict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"count_applied"];
    // set all children
}

-(void) showNumberSelector:(BOOL) isShow {
    isShowNumberSelector = isShow;
    if (isShow) {

        numberSelector.alpha = 0;
        numberSelector.hidden = NO;
        [UIView animateWithDuration:0.75 animations:^{
            numberSelector.alpha = 1;
            currPhotoView.imgViewCircle.image = [UIImage imageNamed:@"red_circle_big.png"];
            currPhotoView.lbNumberOfPhotos.textColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {

        }];
    }
    else {
        //clear
        //currPhotoView.lbNumberOfPhotos.text = [NSString stringWithFormat:@"%d",aNumber];
        currPhotoView.lbNumberOfPhotos.textColor = UIColorFromRGB(0xcb776c);
        
        //set back to dict
//        NSMutableDictionary *dict = (NSMutableDictionary*) currPhotoView.data;
//        [dict setObject:[NSNumber numberWithInt:aNumber] forKey:@"count"];
//        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"count_applied"];
        // reset

        [UIView animateWithDuration:0.75 animations:^{
            numberSelector.alpha = 0;
        currPhotoView.imgViewCircle.image = [UIImage imageNamed:@"circle_bg.png"];
        currPhotoView.lbNumberOfPhotos.textColor = UIColorFromRGB(0xcb776c);
        } completion:^(BOOL finished) {
            numberSelector.hidden = YES;

        }];
    }
}
#pragma mark actions

-(void) touchBack {
    [self showNumberSelector:NO];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) touchCart {
    [self showNumberSelector:NO];
    //[[HomeViewController getShared] doCheckOut];
    [[HomeViewController getShared] addToCart:_mainProduct];

//    CheckoutViewController  *checkOutController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:checkOutController animated:YES];
}
-(void)myMethod
{
    
//    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    [loginManager logInWithReadPermissions:@[@"public_profile",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        //[appDelegate getFacebookUserInfo];
//        NSLog(@"Granted Perm: %@ Declined Perm: %@",[result grantedPermissions],[result declinedPermissions]);
//    }];

    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
        
        NSLog(@"tokenString is: %@",[FBSDKAccessToken currentAccessToken].tokenString);
        NSLog(@"userID is: %@",[FBSDKAccessToken currentAccessToken].userID);
        
    }
    
    
    
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/albums"
                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"cover_photo,name,id,count",@"fields", nil]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error)
     {
         // Handle the result
         NSLog(@"===>>>result is:%@",result);
         NSLog(@">>>error is:%@",error);
         
         
         
     }];

}
-(void) login {
    
    //    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
    //        [self sessionStateChanged:session state:status error:error];
    //    }];
    
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//            // Process error
//        } else if (result.isCancelled) {
//            // Handle cancellations
//        } else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if ([result.grantedPermissions containsObject:@"email"]) {
//                // Do work
//            }
//        }
        
        NSLog(@"Granted Perm: %@ Declined Perm: %@",[result grantedPermissions],[result declinedPermissions]);
        NSLog(@"%@",result);

    }];
    
    //    [FBSession openActiveSessionWithReadPermissions:@[@"email",@"publish_stream",@"user_photos"]
    //                                       allowLoginUI:YES
    //                                  completionHandler:
    //     ^(FBSession *session,
    //       FBSessionState state, NSError *error) {
    //         [self sessionStateChanged:session state:state error:error];
    //     }];
    
}
-(IBAction) touchFacebook {
    
//    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    [loginManager logInWithReadPermissions:@[@"public_profile",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        //[appDelegate getFacebookUserInfo];
//        NSLog(@"Granted Perm: %@ Declined Perm: %@",[result grantedPermissions],[result declinedPermissions]);
//    }];

//    [self myMethod];
//    [self login];
    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSLog(@"fetched user:%@", result);
//             }
//         }];
//        
//        NSLog(@"tokenString is: %@",[FBSDKAccessToken currentAccessToken].tokenString);
//        NSLog(@"userID is: %@",[FBSDKAccessToken currentAccessToken].userID);
//        
//    }
    
    
    
    
    
    ////////
    
    [self showNumberSelector:NO];
    [btnFacebook setImage:[UIImage imageNamed:@"facebook_tab_hover.png"] forState:UIControlStateNormal];
    [btnAlbum    setImage:[UIImage imageNamed:@"camera_roll_tab.png"] forState:UIControlStateNormal];
    albumSection = SECTION_FACEBOOK;
    
    // show facebook album
    if (![[FacebookServices sharedFacebookServices] isLogin]) {
        // register
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFacebookLogin:) name:NotificationFbLogin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationFacebookNotLogin:) name:NotificationFBNotLogin object:nil];
        [[FacebookServices sharedFacebookServices] login];
    }
    else {
        if (arrFacebookAlbums) {
            [arrPhotoGroups removeAllObjects];
            [arrPhotoGroups addObjectsFromArray:arrFacebookAlbums];
            [tblView reloadData];
            return;
        }
        
        // load directly from facebook
    
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    
    
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/albums"
                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"cover_photo,name,id,count",@"fields", nil]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error)
     {
         // Handle the result
         DLog(@"FB Error = %@",error.debugDescription);

         NSLog(@"===>>>result is:%@",result);
         NSLog(@">>>error is:%@",error);
          DLog(@"FB Result = >%@",result);
         
         if (result)
         {
              NSArray *tmpFirstArr = (NSArray*)[result objectForKey:@"data"];
             
             // filter blank album
             __block NSMutableArray  *tmpArr = [NSMutableArray new];
             for (NSDictionary *tDict in tmpFirstArr) {
                 if ([tDict objectForKey:@"cover_photo"]) {
                     [tmpArr addObject:tDict];
                 }
             }
             // remove all objects and insert cache data
             [arrPhotoGroups removeAllObjects];
             for (NSDictionary   *tmpDict in tmpArr) {
                 // create temp
                 NSMutableDictionary    *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNull null],@"url",
                                                      [NSNull null ],@"image",
                                                      [tmpDict objectForKey:@"name"],@"name",
                                                      [tmpDict objectForKey:@"id"],@"id",
                                                      [NSNumber numberWithInt:0],@"count",
                                                      [NSNumber numberWithBool:NO],@"frame",
                                                      [NSNumber numberWithBool:YES],@"frame_applied",
                                                      [NSNumber numberWithBool:YES],@"count_applied",nil];
                 [arrPhotoGroups addObject:groupDict];
             }
             
             // reload cache
             RUN_ON_MAIN_QUEUE(^{
                 [tblView reloadData];
             });
             
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                 arrFacebookAlbums = [NSMutableArray new];
                 for (NSDictionary   *tmpDict in tmpArr) {
                     
                     NSDictionary *albumDict = [tmpDict objectForKey:@"cover_photo"];
                     NSString * albumId = [NSString stringWithFormat:@"%@",[albumDict objectForKey:@"id"]];
                     
                     NSDictionary *dict = [[FacebookServices sharedFacebookServices] getAlbumCoverSyncWithAlbumId:albumId];
                     NSMutableDictionary    *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                          [dict objectForKey:@"picture"],@"url",
                                                          [NSNull null ],@"image",
                                                          [tmpDict objectForKey:@"name"],@"name",
                                                          [tmpDict objectForKey:@"id"],@"id",
                                                          [NSNumber numberWithInt:0],@"count",
                                                          [NSNumber numberWithBool:NO],@"frame",
                                                          [NSNumber numberWithBool:YES],@"frame_applied",
                                                          [NSNumber numberWithBool:YES],@"count_applied",nil];
                     
                     [arrFacebookAlbums addObject:groupDict];
                     // modify group
                     
                 }
                 
                 // remove and fill data
                 [arrPhotoGroups removeAllObjects];
                 [arrPhotoGroups addObjectsFromArray:arrFacebookAlbums];
                 
                 // reload ?
                 RUN_ON_MAIN_QUEUE(^{
                     [tblView reloadData];
                 });
             });


         }
         else
         {
             UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:nil message:error.debugDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertMsg show];
         }
         
     }];

//    
//        [[FacebookServices sharedFacebookServices] getPhotoAlbumsOnFail:^(NSError *error) {
//            DLog(@"FB Error = %@",error.debugDescription);
//        } onDone:^(id obj) {
//            DLog(@"FB Result = >%@",obj);
//            // clean current arr
//            //
//            // now we show it on the app
//            NSArray *tmpFirstArr = (NSArray*)[obj objectForKey:@"data"];
//            
//            // filter blank album
//            __block NSMutableArray  *tmpArr = [NSMutableArray new];
//            for (NSDictionary *tDict in tmpFirstArr) {
//                if ([tDict objectForKey:@"cover_photo"]) {
//                    [tmpArr addObject:tDict];
//                }
//            }
//            // remove all objects and insert cache data
//            [arrPhotoGroups removeAllObjects];
//            for (NSDictionary   *tmpDict in tmpArr) {
//                // create temp
//                NSMutableDictionary    *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                     [NSNull null],@"url",
//                                                     [NSNull null ],@"image",
//                                                     [tmpDict objectForKey:@"name"],@"name",
//                                                     [tmpDict objectForKey:@"id"],@"id",
//                                                     [NSNumber numberWithInt:0],@"count",
//                                                     [NSNumber numberWithBool:NO],@"frame",
//                                                     [NSNumber numberWithBool:YES],@"frame_applied",
//                                                     [NSNumber numberWithBool:YES],@"count_applied",nil];
//                [arrPhotoGroups addObject:groupDict];
//            }
//            
//            // reload cache
//            RUN_ON_MAIN_QUEUE(^{
//                [tblView reloadData];
//            });
    
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
//                arrFacebookAlbums = [NSMutableArray new];
//                for (NSDictionary   *tmpDict in tmpArr) {
//                    NSDictionary *dict = [[FacebookServices sharedFacebookServices] getAlbumCoverSyncWithAlbumId:[tmpDict objectForKey:@"cover_photo"]];
//                    NSMutableDictionary    *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                         [dict objectForKey:@"picture"],@"url",
//                                                         [NSNull null ],@"image",
//                                                         [tmpDict objectForKey:@"name"],@"name",
//                                                         [tmpDict objectForKey:@"id"],@"id",
//                                                         [NSNumber numberWithInt:0],@"count",
//                                                         [NSNumber numberWithBool:NO],@"frame",
//                                                         [NSNumber numberWithBool:YES],@"frame_applied",
//                                                         [NSNumber numberWithBool:YES],@"count_applied",nil];
//                    
//                    [arrFacebookAlbums addObject:groupDict];
//                    // modify group
//                    
//                }
//                
//                // remove and fill data
//                [arrPhotoGroups removeAllObjects];
//                [arrPhotoGroups addObjectsFromArray:arrFacebookAlbums];
//                
//                // reload ?
//                RUN_ON_MAIN_QUEUE(^{
//                    [tblView reloadData];
//                });
//            });
//
//            
//
//        }] ;
    }

    // register notification
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFacebookAlbums:) name:NotificationFbAlbum object:nil];
    //[self loginFacebook];
}

-(IBAction) touchInstagram {
    [self showNumberSelector:NO];
    // go to instagram album
    // here i can set accessToken received on previous login
    (appDelegate).instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PREF_INSTAGRAM_TOKEN"];
    (appDelegate).instagram.sessionDelegate = self;
    if ([(appDelegate).instagram isSessionValid])
    {
        DLog(@"session valid");
        
        
        // switch to select photo view
        SelectPhotoViewController   *selectPhotoController = [[dictPhotosScreen objectForKey:@"InstagramControllerPocketPrint"] objectForKey:@"controller"];
        if (!selectPhotoController) {
            selectPhotoController = [[SelectPhotoViewController alloc] initWithNibName:@"SelectPhotoViewController" bundle:[NSBundle mainBundle]];
            selectPhotoController.albumType = ALBUM_INSTAGRAM;
            selectPhotoController.page = page;
            selectPhotoController.mainProduct = _mainProduct;
            //[dictPhotosScreen setObject:selectPhotoController forKey:@"InstagramControllerPocketPrint"];
            [dictPhotosScreen setObject:[NSDictionary dictionaryWithObjectsAndKeys:selectPhotoController,@"controller", nil] forKey:@"InstagramControllerPocketPrint"];
        }
        [self.navigationController pushViewController:selectPhotoController animated:YES];
    } else {
        //[(appDelegate).instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
        InstagramOAuthViewController *instagramOAuthController = [[InstagramOAuthViewController alloc] initWithNibName:@"InstagramOAuthViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:instagramOAuthController animated:YES];
    }
}

-(IBAction) touchCamera {
    [self showNumberSelector:NO];
    [btnFacebook setImage:[UIImage imageNamed:@"facebook_tab.png"] forState:UIControlStateNormal];
    [btnAlbum    setImage:[UIImage imageNamed:@"camera_roll_tab_hover.png"] forState:UIControlStateNormal];
    // show camera & photolibrary
    [self getDefaultPhotoAlbum];
}

#pragma mark instagram
#pragma - IGSessionDelegate

-(void)igDidLogin {
    NSLog(@"Instagram did login");
    // here i can store accessToken
    [[NSUserDefaults standardUserDefaults] setObject:(appDelegate).instagram.accessToken forKey:@"PREF_INSTAGRAM_TOKEN"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    // switch to select photo view
    SelectPhotoViewController   *selectPhotoController = [[SelectPhotoViewController alloc] initWithNibName:@"SelectPhotoViewController" bundle:[NSBundle mainBundle]];
    selectPhotoController.albumType = ALBUM_INSTAGRAM;
    selectPhotoController.mainProduct = _mainProduct;
    [dictPhotosScreen setObject:[NSDictionary dictionaryWithObjectsAndKeys:selectPhotoController,@"controller", nil] forKey:@"InstagramControllerPocketPrint"];
    [self.navigationController pushViewController:selectPhotoController animated:YES];
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PREF_INSTAGRAM_TOKEN"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

#pragma mark photo albums
- (void) getDefaultPhotoAlbum
{
    albumSection = SECTION_PHOTO;
    
    //xy =[[NSMutableArray alloc]init];
    if (arrPhotoAlbums) {
        [arrPhotoGroups removeAllObjects];
        [arrPhotoGroups addObjectsFromArray:arrPhotoAlbums];
        [tblView reloadData];
        return;
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    arrPhotoAlbums = [NSMutableArray new];
    
    __block BOOL    isDone = NO;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            isDone= NO;
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                if (asset && !isDone){
//                    NSNumber *width = [[[asset defaultRepresentation] metadata] objectForKey:@"PixelWidth"]; //find the key with "PixelWidth" name
//                    NSString *widthString = [NSString stringWithFormat:@"%@", width]; //take the value of the key
                    
                    NSString *assetAlbumName = [group valueForProperty:ALAssetsGroupPropertyName]; //it return to me an ALErrorInvalidProperty
                    DLog(@"found %d phot in %@",index,assetAlbumName);
                    NSMutableDictionary    *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         //[dict objectForKey:@"source"],@"url",
                                                         [[UIImage alloc] initWithCGImage:asset.thumbnail],@"image",
                                                         assetAlbumName,@"name",
                                                         assetAlbumName,@"id",
                                                         [NSNumber numberWithInt:0],@"count",
                                                         [NSNumber numberWithBool:NO],@"frame",
                                                         [NSNumber numberWithBool:YES],@"frame_applied",
                                                         [NSNumber numberWithBool:YES],@"count_applied",nil];
                    
                    if ([assetAlbumName isEqualToString:@"Camera Roll"]) {
                        [arrPhotoAlbums insertObject:groupDict atIndex:0];

                    }
                    else
                        [arrPhotoAlbums addObject:groupDict];
                    
                    isDone = YES;
                }
            }];
            DLog(@"group name = %@",[group valueForProperty:ALAssetsGroupPropertyName]);
        }
        else
        {
            RUN_ON_MAIN_QUEUE(^{
                DLog(@"======");
                // resort
                
                // reload
                [arrPhotoGroups removeAllObjects];
                [arrPhotoGroups addObjectsFromArray:arrPhotoAlbums];
                [tblView reloadData];
            });
        }
    } failureBlock:^(NSError *error) {
        
    }];
    

}

#pragma mark notification

-(void) notificationFacebookLogin:(NSNotification*) notification {
    DLog(@"Fb notification =>%@",notification.object);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationFbLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationFBNotLogin   object:nil];
    
    [self touchFacebook];
}

-(void) notificationFacebookNotLogin:(NSNotification*) notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationFbLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationFBNotLogin   object:nil];
    
    /// go back to album
    [self touchCamera];
}

#pragma mark utilities
-(NSMutableArray*) getAllSelectedPhotos:(Product*) aProduct {

    NSMutableArray  *rtnArr = [NSMutableArray new];
    
    NSArray *screens = [dictPhotosScreen allValues];
    for (NSDictionary *dictScreen in screens) {
        NSDictionary *dictData = [dictScreen objectForKey:@"data"];
        SelectPhotoViewController *screen = [dictScreen objectForKey:@"controller"];
        NSMutableArray  *arr = [screen getAllSelectedPhotos:dictData andProduct:aProduct] ;
//        if (!arr) {
//            // something break
//            return nil;
//        }
        [rtnArr addObjectsFromArray:arr];
    }
    
    //test
//    Product *aProduct = [dict objectForKey:@"product"];
//
//    int counter = 0;
//    for (NSDictionary *dictCounter in arrPhotos) {
//        counter += [[dictCounter objectForKey:@"count"] intValue];
//    }
//
//    int quantity_set = [aProduct.quantity_set intValue];
//    int leftQuantity = counter % quantity_set;
//    int devide = counter / quantity_set + ((leftQuantity > 0)?1:0);
//
//    if (leftQuantity > 0) {
//        NSString *str = [NSString stringWithFormat:@"You've chose %d photos, and you can select %d more photos for the same price!",counter,quantity_set - leftQuantity];
//        [[[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//        break;// 1 alert only
//    }
    return rtnArr;
}

-(void) updateCartInfo {
    int count  = [[HomeViewController getShared] countAllSelectedPhotos:_mainProduct];
//    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    
    int quantitySet  =[_mainProduct.quantity_set intValue];
    int multiply = count / quantitySet;
    if (count % quantitySet != 0) {
        multiply++;
    }
    if (multiply == 0) {
        multiply = 1;
    }

    [self setScreenTitle:[NSString stringWithFormat:@"%d/%d",count,quantitySet*multiply]];

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
//    UIImage *imgBg = [[UIImage imageNamed:@"notification_bg.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:0];
//    
//    UIImageView *imgViewNotification = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, imgWidth, imgHeight)];
//    imgViewNotification.image =imgBg;
//    // add label
//    [imgViewNotification addSubview:lbText];
    
    
    UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCart.frame = CGRectMake(0, 0, 31, 28);
    [btnCart setImage:[UIImage imageNamed:@"card_btn"] forState:UIControlStateNormal];
    [btnCart addTarget:self action:@selector(touchCart) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
    
    // draw on button
    //[btnCart addSubview:imgViewNotification];
    

}


- (void)hideTabBar {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y += 48;
        self.tabBarController.tabBar.frame = frame;
    } completion:^(BOOL finished) {
        DLog(@"frmae = %@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
    }];

}
@end
