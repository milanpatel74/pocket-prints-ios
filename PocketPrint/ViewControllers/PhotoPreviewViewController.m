//
//  PhotoPreviewViewController.m
//  PocketPrint
//
//  Created by Quan Do on 18/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Orientation.h"
#import "HomeViewController.h"


@interface PhotoPreviewViewController ()

@end

@implementation PhotoPreviewViewController
@synthesize dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.btnSetFrame
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoachmarkDone) name:@"removeCoach" object:nil];
    [self setupActivityIndicator];
    // get size
    [self calculateSize];
    [self backButtonWithNameSubmit:@"Back"];
    SelectPhotoViewController *select = [[SelectPhotoViewController alloc] init];
    select.coachDelegate = (id)self;
    [self setScreenTitle:@"Preview" withColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor blackColor];
    _imgViewPhoto.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _imgViewPhoto.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    
    
    [btnSetFrame setTintColor:UIColorFromRGB(0xeb310b)];
    [cropButton setTintColor:UIColorFromRGB(0xeb310b)];
    originalImageButton.enabled = false;
    originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    
    
    [cropButton setTitle:@"Crop Image"];
    isCropped = NO;
    isFrameApplied = NO;
    cropButton.enabled = false;
    cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    fieldName = @"image";
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            
            [UIView transitionWithView:_imgViewPhoto
                              duration:0.7f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                //                                imgPhoto = [UIImage imageWithCGImage:iref];
                                imgPhoto = [UIImage
                                            imageWithCGImage:[rep fullScreenImage]
                                            scale:[rep scale]
                                            orientation:UIImageOrientationUp];
                                _imgViewPhoto.image = imgPhoto;
                                
                                //                                [self cancelButtonAllocation];
                                
                                [self.HUD hide:YES];
                            } completion:nil];
            
            
        }
    };
    
    
    
    NSString *imageString;
    if (dataArray.count)
    {
        //        [self backButtonWithNameSubmit];
        for (NSDictionary *imgdict in  dataArray)
        {
            imageString = [imgdict objectForKey:@"img_path"];
            
        }
        // assets-library://
        
//        if (![imageString containsString:@"https://"] && ![imageString containsString:@"assets-library://"] )
        if ([imageString rangeOfString:@"https://"].location == NSNotFound && [imageString rangeOfString:@"assets-library://"].location == NSNotFound)
        {
            isCropped = YES;
            // to get Original Image
            //            originalImageButton.enabled = true;
            //            [originalImageButton setTintColor:UIColorFromRGB(0xeb310b)];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"images"];
            if ([fileManager fileExistsAtPath:folderPath])
            {
                NSString *getImagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",imageString]];
                UIImage *newImg = [UIImage imageWithContentsOfFile:getImagePath];
                [UIView transitionWithView:_imgViewPhoto
                                  duration:0.7f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    imgPhoto = newImg;
                                    _imgViewPhoto.image = imgPhoto;
                                    //                                    [self cancelButtonAllocation];
                                    [self.HUD hide:YES];
                                } completion:nil];
                
            }
            
        }
        else
        {
            //            [self backButton];
            NSURL *urlString = [NSURL URLWithString:imageString];
//            if ([imageString containsString:@"assets-library://"])
            if ([imageString rangeOfString:@"assets-library://"].location != NSNotFound)
            {
                
                ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                {
                    NSLog(@"hi, cant get image - %@",[myerror localizedDescription]);
                };
                
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:urlString resultBlock:resultblock failureBlock:failureblock];
                
                
            }
            else
            {
                
                [UIView transitionWithView:_imgViewPhoto
                                  duration:0.7f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    NSURL *urlString = [NSURL URLWithString:imageString];
                                    imgPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlString]];
                                    _imgViewPhoto.image = imgPhoto;
                                    //                                    [self cancelButtonAllocation];
                                    [self.HUD hide:YES];
                                } completion:nil];
                
                
                
            }
            
        }
        
    }
    else
    {
        //        [self backButton];
        NSURL *url;
        
        if ([[_photoDict objectForKey:@"url_high"] isKindOfClass:[NSString class]])
        {
            url = [NSURL URLWithString:[_photoDict objectForKey:@"url_high"]];
        }
        else
        {
            url = [_photoDict objectForKey:@"url_high"];
        }
        
        
        NSString    *url_highString = [url absoluteString];
        
        NSLog(@"%@",url_highString);
//        if ([url_highString containsString:@"assets-library://"])
        if ([url_highString rangeOfString:@"assets-library://"].location != NSNotFound)
        {
            
            
            ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
            {
                NSLog(@"hi, cant get image - %@",[myerror localizedDescription]);
            };
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:url resultBlock:resultblock failureBlock:failureblock];
            
            
            
            
            NSLog(@"%@",resultblock);
            
            
        }
        else
        {
            [UIView transitionWithView:_imgViewPhoto
                              duration:0.7f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                imgPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                                _imgViewPhoto.image = imgPhoto;
                                //                                [self cancelButtonAllocation];
                                [self.HUD hide:YES];
                            } completion:nil];
            
            
            
        }
        
    }
    
    
    if ([[_photoDict objectForKey:@"framed"] boolValue])
    {
        // force frame
        _imgViewPhoto.image = [self applyFrame:_imgViewPhoto.image];
        [btnSetFrame setTitle:@"Remove Frame"];
    }
    
    
    // add spinner
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect frame = spinner.frame;
    frame.origin.x = (imgViewPhoto.frame.size.width - frame.size.width ) /2;
    frame.origin.y = (imgViewPhoto.frame.size.height - frame.size.height ) /2;
    spinner.frame = frame;
    spinner.hidden = YES;
    [imgViewPhoto addSubview:spinner];
    
    [self showSpiner:YES];
    CGSize size = CGSizeZero;
    size = CGSizeFromString([_photoDict objectForKey:@"sizes"]);
    CGFloat width =[[_photoDict objectForKey:@"width"] floatValue];
    CGFloat height =[[_photoDict objectForKey:@"height"] floatValue];
    NSLog(@"%f" @"%f",size.width,size.height);
    NSString *status =  [[NSUserDefaults standardUserDefaults] objectForKey:@"showalert"];
    if ([status isEqualToString:@"Yes"]) {
        [self removeCoachmarkDone];
    }
    
    
    
    //    if ([[_photoDict objectForKey:@"album_type"] isEqualToString:@"rectangle_album"])
    //    {
    //        if ([_type isEqualToString:@"instagram"])
    //        {
    ////            [self backButtonWithNameSubmit];
    //            originalImageButton.enabled = false;
    //            originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    //            cropButton.enabled = false;
    //            cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    //        }
    //        else if ([_type isEqualToString:@"hashtag"] || [_type isEqualToString:@"others"])
    //        {
    //            UIAlertView *alertMessage = [[UIAlertView alloc]initWithTitle:@"Square images are not suitable to be printed into a rectangular print, are you sure you want to continue." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    //            alertMessage.tag = 2;
    //            [alertMessage show];
    //        }
    //
    //
    //
    //    }
    //    else
    //    {
    //        if ([_type isEqualToString:@"instagram"])
    //        {
    ////            [self backButtonWithNameSubmit];
    //            originalImageButton.enabled = false;
    //            originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    //            cropButton.enabled = false;
    //            cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    //        }
    //        else
    //        {
    //            if ([_type isEqualToString:@"hashtag"])
    //            {
    //                if (self.imgViewPhoto.image.size.width == self.imgViewPhoto.image.size.height)
    //                {
    //                    originalImageButton.enabled = false;
    //                    originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    //                    cropButton.enabled = false;
    //                    cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    //                }
    //                else
    //                {
    //                    UIAlertView *squareAlertMessage = [[UIAlertView alloc]initWithTitle:@"Do you want it square?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    //                    squareAlertMessage.tag = 3;
    //                    [squareAlertMessage show];
    //
    //                    //[self.view sendSubviewToBack:squareAlertMessage];
    //
    //                }
    //            }
    //            else
    //            {
    //                UIAlertView *squareAlertMessage = [[UIAlertView alloc]initWithTitle:@"Do you want it square?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    //                squareAlertMessage.tag = 3;
    //                [squareAlertMessage show];
    //                [self.view sendSubviewToBack:squareAlertMessage];
    //            }
    //
    //        }
    //    }
    //
    //
    btnSetFrame.enabled = false;
    btnSetFrame.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
}

-(void) removeCoachmarkDone
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"showalert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[_photoDict objectForKey:@"album_type"] isEqualToString:@"rectangle_album"])
    {
        if ([_type isEqualToString:@"instagram"])
        {
            //            [self backButtonWithNameSubmit];
            originalImageButton.enabled = false;
            originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            cropButton.enabled = false;
            cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
        }
        else if ([_type isEqualToString:@"hashtag"] || [_type isEqualToString:@"others"])
        {
            UIAlertView *alertMessage = [[UIAlertView alloc]initWithTitle:@"Square images are not suitable to be printed into a rectangular print, are you sure you want to continue." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
            alertMessage.tag = 2;
            [alertMessage show];
        }
        
        
        
    }
    else
    {
        if ([_type isEqualToString:@"instagram"])
        {
            //            [self backButtonWithNameSubmit];
            originalImageButton.enabled = false;
            originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            cropButton.enabled = false;
            cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
        }
        else
        {
            if ([_type isEqualToString:@"hashtag"])
            {
                if (self.imgViewPhoto.image.size.width == self.imgViewPhoto.image.size.height)
                {
                    originalImageButton.enabled = false;
                    originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
                    cropButton.enabled = false;
                    cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
                }
                else
                {
                    UIAlertView *squareAlertMessage = [[UIAlertView alloc]initWithTitle:@"Do you want it square?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
                    squareAlertMessage.tag = 3;
                    [squareAlertMessage show];
                    
                    //[self.view sendSubviewToBack:squareAlertMessage];
                    
                }
            }
            else
            {
                UIAlertView *squareAlertMessage = [[UIAlertView alloc]initWithTitle:@"Do you want it square?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
                squareAlertMessage.tag = 3;
                [squareAlertMessage show];
                [self.view sendSubviewToBack:squareAlertMessage];
            }
            
        }
    }
    isCropped = NO;
    
    //    btnSetFrame.enabled = false;
    //    btnSetFrame.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
}

-(void) cancelButtonAllocation
{
    CGSize imgsize = _imgViewPhoto.image.size;
    if (imgsize.height == imgsize.width)
    {
        originalImageButton.enabled = true;
        [originalImageButton setTintColor:UIColorFromRGB(0xeb310b)];
    }
}
-(void) backButton
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 21);
    //[btnBack setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

-(void) backButtonWithNameSubmit:(NSString *)name
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 5, 30, 21);
    [btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *nameButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 30)];
    [nameButton setTitle:name forState:UIControlStateNormal];
    [nameButton setTitleColor:UIColorFromRGB(0xeb310b) forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:btnBack];
    [buttonView addSubview:nameButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
}



-(void)cropingMethod
{
//    self.displayImage=[[UIImageView alloc]initWithFrame:CGRectMake(_imgViewPhoto.frame.origin.x, _imgViewPhoto.frame.origin.y, _imgViewPhoto.frame.size.width ,_imgViewPhoto.frame.size.height)];
    self.imgViewPhoto.userInteractionEnabled = YES;
//    [self.imgViewPhoto.layer setBorderWidth:5];
    self.imgViewPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    // allocate crop interface with frame and image being cropped
    self.cropper = [[BFCropInterface alloc]initWithFrame:self.imgViewPhoto.bounds andImage:imgPhoto];
    // this is the default color even if you don't set it
    self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    // white is the default border color.
    self.cropper.borderColor = [UIColor whiteColor];
    // add interface to superview. here we are covering the main image view.
    [self.imgViewPhoto addSubview:self.cropper];
//    [self.view addSubview:self.displayImage];
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideTabBar];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showTabBar];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    // update
    if (isFrameApplied) {
        [_photoDict setObject:imgFramePhoto forKey:fieldName];
    }
}
- (void)setupActivityIndicator
{
    //Setup and show activity indicator
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDAnimationFade;
    [self.HUD show:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Action
-(IBAction)cropButtonTapped:(UIBarButtonItem *)sender
{
    _displayImage.image = nil;
    imgFramePhoto = nil;
    if ([sender.title isEqualToString:@"Crop Image"])
    {
        
        [self cropingMethod];
        
        
        [sender setTitle:@"Confirm"];
    }
    else
    {
        [sender setTitle:@"Crop Image"];
        croppedImage = [self.cropper getCroppedImage];
        [self.cropper removeFromSuperview];
        self.cropper = nil;
        self.imgViewPhoto.image = croppedImage;
        imgPhoto = croppedImage;
        NSLog(@"width -%f" @" height -%f",croppedImage.size.width,croppedImage.size.height);
        originalImageButton.enabled = true;
        [originalImageButton setTintColor:UIColorFromRGB(0xeb310b)];
        //        CGSize size = CGSizeMake(croppedImage.size.width, croppedImage.size.height);
        //        [_photoDict setObject:size forKey:@"size"];
        [_photoDict setObject:NSStringFromCGSize(croppedImage.size) forKey:@"size"];
                [self backButtonWithNameSubmit:@"Done"];
        isCropped = YES;
        
        
        
    }
    [_photoDict setObject:[NSNumber numberWithBool:NO] forKey:@"framed"];
    [btnSetFrame setTitle:@"Set Frame"];
    NSLog(@"Crop Button Tapped");
    imgFramePhoto = nil;
    
}
-(IBAction)originalImageButtonTapped:(id)sender
{
    [self setupActivityIndicator];
    //    [self backButton];
    originalImageButton.enabled = false;
    originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
    
    _displayImage.image = nil;
    croppedImage = nil;
    [cropButton setTitle:@"Crop Image"];
    NSLog(@"Original Button Tapped");
    [_photoDict setObject:[NSNumber numberWithBool:NO] forKey:@"framed"];
    [btnSetFrame setTitle:@"Set Frame"];
    imgFramePhoto = nil;
    NSURL *url_highImage;
    if ([[_photoDict objectForKey:@"url_high"] isKindOfClass:[NSString class]])
    {
        url_highImage = [NSURL URLWithString:[_photoDict objectForKey:@"url_high"]];
    }
    else
    {
        url_highImage = [_photoDict objectForKey:@"url_high"];
        
    }
    
    NSString *url_ImageString = [url_highImage absoluteString];
//    if ([url_ImageString containsString:@"assets-library://"])
    if ([url_ImageString rangeOfString:@"assets-library://"].location != NSNotFound)
    {
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            if (iref) {
                [UIView transitionWithView:_imgViewPhoto
                                  duration:0.7f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                    _imgViewPhoto.image = [UIImage
                                                           imageWithCGImage:[rep fullScreenImage]
                                                           scale:[rep scale]
                                                           orientation:UIImageOrientationUp];
                                    //                                    _imgViewPhoto.image = [UIImage imageWithCGImage:iref];
                                    imgPhoto = _imgViewPhoto.image;
                                    [self.HUD hide:YES];
                                } completion:nil];
                
            }
        };
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"hi, cant get image - %@",[myerror localizedDescription]);
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:url_highImage resultBlock:resultblock failureBlock:failureblock];
        
    }
    else
    {
        dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
        dispatch_async(imageQueue, ^{
            
            
            UIImage *urlImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url_highImage]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                [UIView transitionWithView:self.imgViewPhoto
                                  duration:0.7f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.imgViewPhoto.image = urlImage;
                                    [self.HUD hide:YES];
                                } completion:nil];
                //                self.imgViewPhoto.image = urlImage;
                imgPhoto = nil;
                imgPhoto = urlImage;
                
            });
            
        });
    }
    if (self.cropper)
    {
        [self.cropper removeFromSuperview];
    }
    [self backButtonWithNameSubmit:@"Back"];
    isCropped = NO;
    CGFloat width =[[_photoDict objectForKey:@"width"] floatValue];
    CGFloat height =[[_photoDict objectForKey:@"height"] floatValue];
    
    //    if ([[_photoDict objectForKey:@"album_type"] isEqualToString:@"rectangle_album"])
    //    {
    //        [self backButtonWithNameSubmit];
    //    }
    
}






#pragma mark utilities
-(void) calculateSize {
    NSArray *arrSize = [[HomeViewController getShared].currentProduct.size componentsSeparatedByString:@"x"];
    frameHeight = [[arrSize objectAtIndex:1] intValue] * 96.0f;
    frameWidth = [[arrSize objectAtIndex:0] intValue] * 96.0f;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex ==0)
        {
            if (self.imgViewPhoto.image.size.width == self.imgViewPhoto.image.size.height)
            {
                originalImageButton.enabled = true;
                [originalImageButton setTintColor:UIColorFromRGB(0xeb310b)];
            }
            else
            {
                originalImageButton.enabled = false;
                originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            }
            [cropButton setTintColor:UIColorFromRGB(0xeb310b)];
            cropButton.enabled = true;
            [self cropButtonTapped:cropButton];
            //            [self backButtonWithNameSubmit];
            
        }
        else if (buttonIndex == 1)
        {
            if (self.imgViewPhoto.image.size.width == self.imgViewPhoto.image.size.height)
            {
                originalImageButton.enabled = true;
                [originalImageButton setTintColor:UIColorFromRGB(0xeb310b)];
            }
            else
            {
                originalImageButton.enabled = false;
                originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            }
            cropButton.enabled = false;
            cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            //            [self backButtonWithNameSubmit];
        }
        
    }
    else if (alertView.tag == 3)
    {
        if (buttonIndex == 0)
        {
            if (self.imgViewPhoto.image.size.width == self.imgViewPhoto.image.size.height)
            {
                originalImageButton.enabled = true;
                [originalImageButton setTintColor:UIColorFromRGB(0xeb310b)];
            }
            else
            {
                originalImageButton.enabled = false;
                originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            }
            [cropButton setTintColor:UIColorFromRGB(0xeb310b)];
            cropButton.enabled = true;
            [self cropButtonTapped:cropButton];
            
            //            [self backButtonWithNameSubmit];
            
        }
        else if (buttonIndex == 1)
        {
            originalImageButton.enabled = false;
            originalImageButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
            cropButton.enabled = false;
            cropButton.tintColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0];
        }
        
        
    }
}
#pragma mark action
-(void) back
{
    UIAlertView *alertMsg = [[UIAlertView alloc]initWithTitle:@"Please crop the image" message:@"Without cropping this image you wont be able to add it to your cart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertMsg.tag = 1;
    [alertMsg show];
}

-(void) touchBack
{
    [self setupActivityIndicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateImage];
            [_photoDict setObject:NSStringFromCGSize(self.imgViewPhoto.image.size) forKey:@"size"];
            
            if (isCropped == YES)
            {
                [self.protocolDatas cropMessageDataTransfer:YES];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.HUD hide:YES];
            
        });
    });
    
    
}
-(void) updateImage
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
    UIImage *image = imgPhoto;
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sql = [NSString stringWithFormat:@"update upload_image set  img_path='%@' WHERE original_imgpath='%@' AND product_id='%@'",dateString,[self.photoDict objectForKey:@"url_high"],[defaults objectForKey:PRODUCTID]];
    [[SqlManager defaultShare] doUpdateQuery:sql];
    [_photoDict setObject:savedImagePath forKey:@"cropped_image"];
    [_photoDict setObject:dateString forKey:@"cropImage"];
    [self uploadcroppedImage:image];
    
    
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
//-(void) getImage
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@""]];
//    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
//}

#define FRAME_WIDTH     15

-(IBAction) setFrame
{
    _displayImage.image = nil;
    [cropButton setTitle:@"Crop Image"];
    UIImage * cropedTempImage=croppedImage;
    UIImage * tempImgPhoto=imgPhoto;
    
    [self.cropper removeFromSuperview];
    self.cropper = nil;
    
    if ([[_photoDict objectForKey:@"framed"] boolValue])
    {
        //remove frame
        [_photoDict setObject:[NSNumber numberWithBool:NO] forKey:@"framed"];
        [btnSetFrame setTitle:@"Set Frame"];
        //imgViewPhoto.image = imgPhoto;
        imgFramePhoto = nil;
        if (cropedTempImage == nil)
        {
            self.imgViewPhoto.image=tempImgPhoto;
        }
        else
        {
            self.imgViewPhoto.image=cropedTempImage;
            cropedTempImage=nil;
        }
    }
    else
    {
        // set frame
        
        [_photoDict setObject:[NSNumber numberWithBool:YES] forKey:@"framed"];
        [btnSetFrame setTitle:@"Remove Frame"];
        if (!imgFramePhoto)
        {
            
            if (cropedTempImage == nil)
            {
                imgFramePhoto = [self applyFrame:tempImgPhoto];
                
            }
            else
            {
                imgFramePhoto = [self applyFrame:cropedTempImage];
                cropedTempImage=nil;
            }
        }
        else
        {
            imgFramePhoto = [self applyFrame:cropedTempImage];
        }
        // imgViewPhoto.image = imgFramePhoto;
        self.imgViewPhoto.image=imgFramePhoto;
    }
    
    
}

-(UIImage*) applyFrame:(UIImage*) aImage {
    // apply frame
    CGFloat width, height;
    width = aImage.size.width;
    height = aImage.size.height;
    
    // create a new bitmap image context at the device resolution (retina/non-retina)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width , height), YES, 0.0);
    
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current
    // (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);
    
    // this example draws the inputImage into the context
    [aImage drawInRect:CGRectMake(0, 0, width, height)];
    
    // now we draw the frame
    // top frame
    CGRect rectangle = CGRectMake(0, 0, width, FRAME_WIDTH);
    CGContextSetRGBFillColor(context, 255.0, 255.0, 255.0, 1.0);   //this is the transparent color
    CGContextFillRect(context, rectangle);
    
    // bottom frame
    rectangle = CGRectMake(0, height-FRAME_WIDTH, width, FRAME_WIDTH);
    CGContextFillRect(context, rectangle);
    
    // left frame
    rectangle = CGRectMake(0, 0, FRAME_WIDTH, height);
    CGContextFillRect(context, rectangle);
    
    // right frame
    rectangle = CGRectMake(width-FRAME_WIDTH,0, FRAME_WIDTH, height);
    CGContextFillRect(context, rectangle);
    
    // pop context
    UIGraphicsPopContext();
    
    // get a UIImage from the image context- enjoy!!!
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return outputImage;
    
}

-(void) showSpiner:(BOOL) isShow {
    spinner.hidden = !isShow;
    if (isShow) {
        [spinner startAnimating];
    }
    else
        [spinner stopAnimating];
}

- (void)showTabBar {
    //[self.tabBarController.tabBar setTranslucent:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)hideTabBar {
    //[self.tabBarController.tabBar setTranslucent:YES];
    [self.tabBarController.tabBar setHidden:YES];
}
@end
