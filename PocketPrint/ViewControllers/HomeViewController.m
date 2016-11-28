//
//  HomeViewController.m
//  PocketPrint
//
//  Created by Quan Do on 3/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "HomeViewController.h"
//#import "PhotoInfoViewController.h"
#import "CheckoutViewController.h"
#import "GiftCertificateInfoViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

static HomeViewController *shareDefault;

BOOL flipped;

#define PRODUCT_KEY     @"PRODUCT_KEY"

+(HomeViewController*) getShared {
    return shareDefault;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#define GAP 15
#define PAGE_WIDTH  232
#define INITIAL_GAP ((SCREEN_WIDTH - PAGE_WIDTH) /2)

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //[[[UIAlertView alloc] initWithTitle:nil message:@"Home base loaded" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    shareDefault = self;
    // register notification
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProductList) name:NotificationGetAppToken object:nil];
   
    flipped  = NO;
//    [self setScreenTitle:@"TEST ONLY"];
    UIImage *imgTitle = [UIImage imageNamed:@"logo_new.png"];

    UIImageView *imgViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgTitle.size.width , imgTitle.size.height )];
    imgViewTitle.image = imgTitle;
    imgViewTitle.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgViewTitle;
    
    //pageControl = [[CustomizePageControl alloc] initWithFrame:CGRectMake(0, 432, 320, 37)];
    arrAlbums = [NSMutableArray new];
    
//    if (!IS_4INCHES) {
//        CGRect frame = scrollView.frame;
//        frame.origin.y -= 34;
//        scrollView.frame = frame;
//    }

    
    // load
//    [self loadProductList];
    

    
    arrGiftCerts = [NSMutableArray new];
    
    isByPassMorePhotos = NO;
    
    // centerlize
    [scrollView setYPos:(self.view.frame.size.height - scrollView.frame.size.height)/2];
    [scrollView setXPos:(self.view.frame.size.width - scrollView.frame.size.width)/2];
    
//    [pageControl setYPos:scrollView.frame.origin.y + scrollView.frame.size.height + 10];
//    [pageControl setXPos:(self.view.frame.size.width - pageControl.frame.size.width)/2];
//    pageControl.hidden = YES;
    [flipView setXPos:(self.view.frame.size.width - flipView.frame.size.width)/2];
    [flipView setYPos:(self.view.frame.size.height - flipView.frame.size.height)/2];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(methodNotification:) name:@"Example" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(methodHashTagData:) name:@"HashTagData" object:nil];
    [self loadProductList];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // show coach mark
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"coach1"]) {
        UIImage *imgCoach = [UIImage imageNamed:(IS_4INCHES)?@"coach_mark01-568h.png":@"coach_mark01.png"];
        if (IS_IPHONE_6P) {
            imgCoach = [UIImage imageNamed:@"coach_mark01-736h@3x.png"];
        }
        else
            if (IS_IPHONE_6) {
                imgCoach = [UIImage imageNamed:@"coach_mark01-667h@2x.png"];
            }
        UIButton    *btnCoach = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCoach setImage:imgCoach forState:UIControlStateNormal];
        btnCoach.frame = CGRectMake(0, 0, imgCoach.size.width, imgCoach.size.height);
        [btnCoach addTarget:self action:@selector(removeCoachmark:) forControlEvents:UIControlEventTouchUpInside];
        [(appDelegate).window addSubview:btnCoach];
    }
    
    [self showTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeCoachmark:(UIButton*) aBtn {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"coach1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.75 animations:^{
        aBtn.alpha = 0;
    } completion:^(BOOL finished) {
        aBtn.hidden = YES;
        [aBtn removeFromSuperview];
    }];
}

-(void) methodNotification:(NSNotification *)notify;
{
    NSLog(@"-----NOTIFICATION---RECIEVED-----Successfully--");
    NSLog(@"%@",notify.userInfo);
    //    someLabel.text=[notify.userInfo objectForKey:@"imageskey"];
    // [self.navigationController popViewControllerAnimated:YES];
    hashTagDataArray = [[NSMutableArray alloc]init];
    [hashTagDataArray addObject: notify.userInfo];
    
}

-(void) toClearHashTagData
{
    
    hashTagSquares = [[NSMutableArray alloc]init];
    
    hashTagBigSquares = [[NSMutableArray alloc]init];
    
    hashTagMiniSquares = [[NSMutableArray alloc]init];
    
    hashTagRectagles = [[NSMutableArray alloc]init];
    
    hashTagMetalPrints = [[NSMutableArray alloc]init];
    
    hashTagPhotoBlocks = [[NSMutableArray alloc]init];
    
    
}


-(void) methodHashTagData:(NSNotification *)notify;
{
    NSLog(@"-----NOTIFICATION---RECIEVED-----Successfully--");
    NSLog(@"%@",notify.userInfo);
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
    [dataDict addEntriesFromDictionary:notify.userInfo];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    dataArray = [dataDict objectForKey:@"hashTagImages"];
    currentPage = [[dataDict objectForKey:@"page"] intValue];
    if (currentPage == 0)
    {
        hashTagSquares = [[NSMutableArray alloc]init];
    }
    else if (currentPage == 1)
    {
        hashTagBigSquares = [[NSMutableArray alloc]init];
    }
    else if (currentPage == 2)
    {
         hashTagMiniSquares = [[NSMutableArray alloc]init];
    }
    else if (currentPage == 3)
    {
        hashTagRectagles = [[NSMutableArray alloc]init];
    }
    else if (currentPage == 4)
    {
        hashTagMetalPrints = [[NSMutableArray alloc]init];
    }
    else if (currentPage == 5)
    {
        hashTagPhotoBlocks = [[NSMutableArray alloc]init];
    }

   
    
    for (NSDictionary *dict in dataArray)
    {
        if ([[dict objectForKey:@"count"] intValue] > 0)
        {
            
            [dict setValue:[dataDict objectForKey:@"page"] forKey:@"page"];
            if (currentPage == 0)
            {
               
                [hashTagSquares addObject:dict];
            }
            else if (currentPage == 1)
            {
                
                [hashTagBigSquares addObject:dict];
            }
            else if (currentPage == 2)
            {
               
                [hashTagMiniSquares addObject:dict];
            }
            else if (currentPage == 3)
            {
                
                [hashTagRectagles addObject:dict];
            }
            else if (currentPage == 4)
            {
               
                [hashTagMetalPrints addObject:dict];
            }
            else if (currentPage == 5)
            {
                
                [hashTagPhotoBlocks addObject:dict];
            }
           
        }
    }
    
    
}


#pragma mark gift certificate delegate
-(void) onGiftAdd:(NSMutableDictionary *)dict {
    [self.navigationController popToRootViewControllerAnimated:NO];
//    [arrGiftCerts addObject:dict];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self doCheckOut];
//    });
    /// go to cart
//    [appDelegate goToTab:1];
//    [appDelegate goToTab:0];
//    [appDelegate goToTab:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [appDelegate goToTab:1];
        if (![CheckoutViewController getShared]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // call Checkout
                [[CheckoutViewController getShared] addData:dict];
            });
        }
        else
            [[CheckoutViewController getShared] addData:dict];
        
    });


    
}

#pragma mark load data
-(void) loadProductList {
//    _arrProducts = [NSMutableArray new];
    // preload here
    // save Array
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefault objectForKey:PRODUCT_KEY];
    if (!arr) {
        // copy resource
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"product_cache"];
        NSArray *arrContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for (NSString *str in arrContent) {
            DLog(@"copy %@",str);
            NSString *url =[path stringByAppendingPathComponent:str];
            // copy file
            [[NSFileManager defaultManager] copyItemAtPath:url toPath:[PATH_TEMP_FOLDER stringByAppendingPathComponent:str] error:nil];
        }
        // load from file
        arr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"product_cache.txt" ofType:@""]] options:NSJSONReadingAllowFragments error:nil];
    }
    
//    if (arr) {
//        [_arrProducts removeAllObjects];
    NSMutableArray *arrNewProduct = [NSMutableArray new];
        for (NSDictionary *dict in arr) {
            Product *product = [[Product alloc] init];
            [product parseFromJsonDictionary:dict];
            //product.uid = [[dict objectForKey:@"product"] objectForKey:@"id"];
            if ([product.width isKindOfClass:[NSNull class]] || product.width.intValue <= 0) {
                product.width = [NSNumber numberWithInt:9];
            }
            if ([product.height isKindOfClass:[NSNull class]] || product.height.intValue <= 0) {
                product.height = [NSNumber numberWithInt:9];
            }
            [arrNewProduct addObject:product];
            
            // create view
        }
    
    _arrProducts = arrNewProduct;
    
        [self resetProductPermission];
        
        // setup scroll
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupScroller];
//    });
    

    
//    }

    
//    if (![[APIServices sharedAPIServices] getApiToken] ) {
//        DLog(@"No token found, can not get product list");
//        return;
//    }
    DLog(@"Call Product");
    //[[[UIAlertView alloc] initWithTitle:nil message:@"Start loading production list" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    
    [[APIServices sharedAPIServices] getProductsOnFail:^(NSError *error) {
        DLog(@"Fail to get product %@",error.debugDescription);

    } onDone:^(NSError *error, id obj) {
        DLog(@"Product info %@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
        
        // save Array
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:arr forKey:PRODUCT_KEY];
        [userDefault synchronize];
        
//        [_arrProducts removeAllObjects];
        
        NSMutableArray *arrNewProduct = [NSMutableArray new];
        
        for (NSDictionary *dict in arr) {
            Product *product = [[Product alloc] init];
            [product parseFromJsonDictionary:dict];

            //product.uid = [[dict objectForKey:@"product"] objectForKey:@"id"];
            if ([product.width isKindOfClass:[NSNull class]] || product.width.intValue <= 0) {
                product.width = [NSNumber numberWithInt:9];
            }
            if ([product.height isKindOfClass:[NSNull class]] || product.height.intValue <= 0) {
                product.height = [NSNumber numberWithInt:9];
            }
            [arrNewProduct addObject:product];
            
            // create view
        }
        
//        for (unsigned i = 0; i < kNumberOfPages; i++)
//        {
//            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(i*(232 + GAP), 0, 232, scrollView.frame.size.height)];
//
//            SquarePrintView *squareView = [[SquarePrintView alloc] standardInit];
//            squareView.backgroundColor = [UIColor whiteColor];
//            squareView.lbTitle.text = @"Square Print";
//            squareView.lbSize.text = @"4x4";
//            squareView.lbPrice.text = @"$0.99 per print";
//            squareView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
//            squareView.delegate = self;
//            [aView addSubview:squareView];
//
//            [controllers addObject:aView];
//            
//        }
        
        _arrProducts = arrNewProduct;
        
        // reset
        [self resetProductPermission];
        
        // setup scroll
        RUN_ON_MAIN_QUEUE(^{
            [self setupScroller];
        });
        
    }];
    
}


-(void) setupScroller {
    kCurrentPage = 0;
    for (UIView *view in scrollView.subviews) {
        view.hidden = YES;
        [view removeFromSuperview];
    }
    if (pageControl) {
        [pageControl removeFromSuperview];
        pageControl.hidden = YES;
        pageControl = nil;
    }
    pageControl = [[CustomizePageControl alloc] initWithFrame:CGRectMake(0, (IS_4INCHES)?432:394, 320, 37) andSmallDot:[UIImage imageNamed:@"dot.png"] andBigDot:[UIImage imageNamed:@"dot_hover.png"]];
    
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.tintColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    [self.view addSubview:pageControl];
    [self.view sendSubviewToBack:pageControl];
    [pageControl setYPos:scrollView.frame.origin.y + scrollView.frame.size.height + 5];
    [pageControl setXPos:(self.view.frame.size.width - pageControl.frame.size.width)/2];
    
    // Do any additional setup after loading the view from its nib.
    kNumberOfPages = _arrProducts.count;
    pageControl.numberOfPages = kNumberOfPages;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(INITIAL_GAP + i*(232 + GAP), 0, 232, scrollView.frame.size.height)];
        __block Product *product = [_arrProducts objectAtIndex:i];
        __block SquarePrintView *squareView = [[SquarePrintView alloc] standardInit];
        squareView.pageIndex = i;
        squareView.backgroundColor = [UIColor whiteColor];
        squareView.lbTitle.text = product.type;
        squareView.lbSize.text = [NSString stringWithFormat:@"%@",product.size];
        if ([product.type isEqualToString:@"Gift Certificates"]) {
            squareView.lbPrice.text = @"From $20";
        }
        else
        squareView.lbPrice.text = [NSString stringWithFormat:@"%d print%@ for $%@", [product.quantity_set intValue],([product.quantity_set intValue]>1)?@"s":@"",product.price];
        squareView.image = [UIImage imageNamed:@"default_img.png"];
        squareView.delegate = self;
        [aView addSubview:squareView];
        
        // gift certificate ?
        if ([product.type isEqualToString:@"Gift Certificates"]) {
            [squareView activateGiftCertificate];
            squareView.image = [UIImage imageNamed:@"gift_certificates_default.png"];
        }
        
        // set data image
        if ([product.main_image rangeOfString:@"https://"].location != NSNotFound) {
            [squareView showSpiner:YES];
            [[Downloader sharedDownloader] downloadWithCacheURL:product.main_image allowThumb:NO andCompletionBlock:^(NSData *data) {
                UIImage *img = [UIImage imageWithData:data];
                RUN_ON_MAIN_QUEUE(^{
                    product.img = img;
                    [squareView showSpiner:NO];
                    [UIView transitionWithView:squareView
                                      duration:0.7f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                         squareView.image = img;
                                    } completion:nil];
                });
                
            } andFailureBlock:^(NSError *error) {
                DLog(@"Fail to download image");
                RUN_ON_MAIN_QUEUE(^{
                    [squareView showSpiner:NO];
                });
            }];
        }

        [controllers addObject:aView];
        
    }
    viewControllers = controllers;
    
    // a page is the width of the scroll view
    //scrollView.pagingEnabled = YES;
    //scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(INITIAL_GAP*2 + kNumberOfPages*(232 + GAP), 310);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    //init flip view
    // data
    //    imgPhoto.image = [UIImage imageNamed:@"1.jpg"];
    //    lbPrice.font = [UIFont fontWithName:@"MuseoSans-300" size:15.0f];
    //    lbPrice.textColor = UIColorFromRGB(0x979797);
    //    lbPrice.text = @"$1.44 per print";
    //    lbSize.font = [UIFont fontWithName:@"MuseoSans-500" size:15.0f];
    //    lbSize.text = @"6x6 inches";
    //    tvDesc.font = [UIFont fontWithName:@"MuseoSans-300" size:15.0f];
    //
    //    tvDesc.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    
    //preload photo view
//    NSArray *arr = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"1.jpg"],@"image",@"10",@"price",@"9x9",@"size",@"This is the description",@"desc", nil],
//                    [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"2.jpg"],@"image",@"10",@"price",@"10x9",@"size",@"This is the description",@"desc", nil],
//                    [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"3.jpg"],@"image",@"10",@"price",@"9x6",@"size",@"This is the description",@"desc", nil],
//                    [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"4.jpg"],@"image",@"10",@"price",@"9x14",@"size",@"This is the description",@"desc", nil],
//                    [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"5.jpg"],@"image",@"10",@"price",@"9x50",@"size",@"This is the description",@"desc", nil],nil];
    
//    flipView.arrPhotos = _arrProducts;
//    [flipView loadData];
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark scroll view photo
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    UIImageView *controller = [viewControllers objectAtIndex:page];
    
    // add the controller's view to the scroll view
    if (controller.superview == nil)
    {
        CGRect frame = scrollView.frame;
        //frame.size.width = 232;
        [scrollView insertSubview:controller atIndex:0];
        
        if (page > 0)
        {
            // create view
            //UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(page*(232 + GAP), 0, 232, scrollView.frame.size.height)];
            UIView *aView = [viewControllers objectAtIndex:page];
//            SquarePrintView *squareView = [[SquarePrintView alloc] standardInit];
//            squareView.backgroundColor = [UIColor whiteColor];
//            squareView.lbTitle.text = @"Square Print";
//            squareView.lbSize.text = @"4x4";
//            squareView.lbPrice.text = @"$0.99";
//            squareView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",page+1]];
//            squareView.delegate = self;
//            [aView addSubview:squareView];
            [scrollView addSubview:aView];
            
            frame.origin.x = INITIAL_GAP + (PAGE_WIDTH+GAP) * page;
            frame.origin.y = 0;
            
//            [viewControllers addObject:aView];
        } else
        {
            frame.origin.y = 0;
            //frame.origin.x = (320 - 232)/2;
            frame.origin.x = INITIAL_GAP;
        }
        
        controller.frame = frame;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    kCurrentPage = page;

    int page = kCurrentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    

    pageControl.currentPage = kCurrentPage;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    DLog(@"will end draging at %@",NSStringFromCGPoint(*targetContentOffset));
    //float cellWith = 320 / 7;
    float x = (*targetContentOffset).x;
    
    float range = x - kCurrentPage*PAGE_WIDTH;
    
    if (range < 0) {
        if (range < -1 * PAGE_WIDTH / 2) {
            kCurrentPage--;
        }
//        else
//            range = 0;
    }
    else {
        if (range > PAGE_WIDTH / 2) {
            //range = PAGE_WIDTH;
            kCurrentPage++;
            if (kCurrentPage >= kNumberOfPages) {
                kCurrentPage = kCurrentPage -1;
            }
        }
//        else
//            range = 0;
    }
    
    x = kCurrentPage*(PAGE_WIDTH + GAP);

    DLog(@"new point x=%.1f",x);
    DLog(@"velocity %@",NSStringFromCGPoint(velocity));
    // set back
    (*targetContentOffset).x = x;
    
    // adjust
    if (fabsf(velocity.x) < 1) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            [scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        }];
        
//        });

    }
    
}


#pragma mark suqre print delegate
-(void) touchPhotoInfo:(id)aPhoto {
    // load page of flip view
    //[flipView loadScrollViewWithPage:kCurrentPage];
    //[flipView goToPage:kCurrentPage];
    // load product
    int pageIndex = 0;
    if (aPhoto) {
        SquarePrintView *squareView = (SquarePrintView*) aPhoto;
        pageIndex = squareView.pageIndex;
        if (pageIndex != kCurrentPage) {
            // prevent
            return;
        }
        [flipView loadDataForProduct:[_arrProducts objectAtIndex:pageIndex]];
    }
    
    
    __block UIView   *leftView, *rightView;
    //[[appDelegate window] setBackgroundColor:[UIColor whiteColor]];

    if (aPhoto) {
        [UIView animateWithDuration:0.5 animations:^{
            // look for current
            if (kCurrentPage > 0) {
                leftView = (UIView*)[viewControllers objectAtIndex:kCurrentPage-1];
                leftView.alpha = 0;
            }
            
            if (kCurrentPage < viewControllers.count-1) {
                rightView = (UIView*)[viewControllers objectAtIndex:kCurrentPage+1];
                rightView.alpha = 0;
            }
        }];
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                // look for current
                if (kCurrentPage > 0) {
                    leftView = (UIView*)[viewControllers objectAtIndex:kCurrentPage-1];
                    leftView.alpha = 1;
                }
                
                if (kCurrentPage < viewControllers.count-1) {
                    rightView = (UIView*)[viewControllers objectAtIndex:kCurrentPage+1];
                    rightView.alpha = 1;
                }
            }];
        });
    }


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:containerView
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            
                            if (!flipped) {
                                scrollView.hidden = YES;

                                [containerView addSubview:flipView];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    Product *aProduct = [_arrProducts objectAtIndex:kCurrentPage];
                                    NSString    *flipTitle = [NSString stringWithFormat:@"%@ %@", aProduct.type,aProduct.size];
                                    if ([aProduct.type isEqualToString:@"Gift Certificates"]) {
                                        flipTitle = aProduct.type;
                                    }
                                    [self setScreenTitle:flipTitle];
                                });
                                
                            } else {
                                [scrollView setHidden:NO];
                                [flipView removeFromSuperview]; //or hide it.
                                //[self setScreenTitle:@"Pocket Prints"];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    UIImage *imgTitle = [UIImage imageNamed:@"logo_new.png"];
                                    
                                    UIImageView *imgViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgTitle.size.width , imgTitle.size.height )];
                                    imgViewTitle.image = imgTitle;
                                    imgViewTitle.contentMode = UIViewContentModeScaleAspectFit;
                                    self.navigationItem.titleView = imgViewTitle;
                                });
                                self.navigationItem.rightBarButtonItem = nil;
                            }
                            flipped =!flipped;
                            
                        } completion:^(BOOL finished){
                            // show it back
                            [leftView setHidden:NO];
                            //leftView.alpha =1.0;
                            [rightView setHidden:NO];
                            //rightView.alpha = 1.0;
                            
                            if (flipped) {
                                // done
                                UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDone)];
                                [btnDone setTintColor:UIColorFromRGB(0xe8320b)];
                                [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
                                self.navigationItem.rightBarButtonItem = btnDone;
                            }
                        }];
    });
}

- (BOOL)shouldAllowCroppingToolForProduct:(NSString *)type {
    
    NSDictionary *dict = @{@"Rectangles": @(0)};
    NSNumber *num = [dict objectForKey: type];
    
    if (!num || (num == (id)[NSNull null])) {
        return YES;
    }
    
    return NO;
}

-(void) touchPhoto:(id)aPhoto {
    
    // save last product
    _lastProduct =_currentProduct;
    
    _currentProduct = [_arrProducts objectAtIndex:kCurrentPage];
    
    BOOL allowCropping = [self shouldAllowCroppingToolForProduct: _currentProduct.type];
    [[NSUserDefaults standardUserDefaults] setObject: @(allowCropping) forKey: kAllowCropping];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([_currentProduct.type isEqualToString:@"Gift Certificates"]) {
        GiftCertificateInfoViewController *giftController = [[GiftCertificateInfoViewController alloc] initWithNibName:@"GiftCertificateInfoViewController" bundle:[NSBundle mainBundle]];
        giftController.product = _currentProduct;
        giftController.delegate = self;
        [self.navigationController pushViewController:giftController animated:YES];
    }
    else {
        // album
        SelectPhotoAlbumViewController   *selectPhotoController = nil;
        for (NSDictionary *dict in arrAlbums) {
            if ([[dict objectForKey:@"page"] intValue] == kCurrentPage) {
                selectPhotoController = [dict objectForKey:@"obj"];
            }
        }
        
        if (!selectPhotoController) {
            selectPhotoController = [[SelectPhotoAlbumViewController alloc] initWithNibName:@"SelectPhotoAlbumViewController" bundle:[NSBundle mainBundle]];
            selectPhotoController.page = (int)kCurrentPage;
            selectPhotoController.mainProduct = _currentProduct;
            [arrAlbums addObject:[NSDictionary dictionaryWithObjectsAndKeys:selectPhotoController,@"obj",[NSNumber numberWithInt:kCurrentPage],@"page", nil]];
            
        }
        
        // show square alert if product is squares, big squares, mini squares 0, 1, 3
        if (kCurrentPage == 0 || kCurrentPage == 1 || kCurrentPage == 2 || kCurrentPage == 3 || kCurrentPage == 5 || kCurrentPage == 6 || kCurrentPage == 7 || kCurrentPage == 8)
        {
            alertSquare = [[UIAlertView alloc] initWithTitle:nil message:@"For the best results we recommend cropping your image square using our crop function." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Go to FAQ",@"OK", nil];
            [alertSquare show];
        }
        
        
        // check the product
//        int counter = [self countAllSelectedPhotos:_lastProduct];
//        if (counter> 0) {
//            int quantity_set = [_lastProduct.quantity_set intValue];
//            int leftQuantity = counter % quantity_set;
//            BOOL isAllowByPass = [self permissionForProduct:_lastProduct];
//            
//            if (!isAllowByPass) {
//                if (!isByPassMorePhotos) {
//                    NSString *str = [NSString stringWithFormat:@"You've chose %d photos, and you can select %d more photos for the same price!",counter,quantity_set - leftQuantity];
//                    [[[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"More Photos",@"Only Print These", nil] show];
//                    return;
//                }
//                
//            }
//        }

        [self.navigationController pushViewController:selectPhotoController animated:YES];
    }
    
    lastKey = kCurrentPage;
}

-(void) touchDone {
    [self touchPhotoInfo:nil];
}

#pragma mark utilities
-(CGSize) getPhotoSizeFromProductId:(NSString*) productID {
    for (Product *product in _arrProducts) {
        // search
        if ([product.uid isEqualToString:productID]) {
            // naalyse size
//            NSString *str = [product.size stringByReplacingOccurrencesOfString:@"cm" withString:@""];
//            str = [str stringByReplacingOccurrencesOfString:@"x" withString:@","];
//            return CGSizeFromString([NSString stringWithFormat:@"{%@}",str]);
            return CGSizeMake(product.width.floatValue, product.height.floatValue);
        }
    }
    
    return CGSizeMake(-1, -1);
}

-(void) removeProductForRow:(int) row {
    [appDelegate goToTab:0];
    if (row < arrAlbums.count && row >=0) {
        // safe
        [arrAlbums removeObjectAtIndex:row];
    }
    [appDelegate goToTab:1];
}

-(BOOL) permissionForProduct:(Product*) aProduct {
    BOOL permission = NO;
    for (NSDictionary *dict in arrProductPermission) {
        Product *product = [dict objectForKey:@"product"];
        if ([aProduct.uid isEqualToString:product.uid]) {
            return [[dict objectForKey:@"permission"] boolValue];
        }
    }
    return permission;
}
-(void) resetProductPermission {
    if (!arrProductPermission) {
        arrProductPermission = [[NSMutableArray alloc] init];
    }
    
    [arrProductPermission removeAllObjects];
    for (Product *product in _arrProducts) {
        [arrProductPermission addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:product,@"product",[NSNumber numberWithBool:NO],@"permission", nil]];
    }
}

- (void)showTabBar {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 44 - 6;//519 -((IS_4INCHES)?0:88);
        self.tabBarController.tabBar.frame = frame;
    } completion:^(BOOL finished) {
        DLog(@"frmae = %@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
    }];
    
}

-(void) addToCart:(Product*) aProduct {
    NSMutableDictionary *groupDict = nil;
    
    for (NSDictionary *dict in arrAlbums) {
        int page = [[dict objectForKey:@"page"] intValue];
        Product *product = [_arrProducts objectAtIndex:page];
        if (![product.uid isEqualToString:aProduct.uid]) {
            continue;
        }
        
        SelectPhotoAlbumViewController  *album = [dict objectForKey:@"obj"];
        
        
//        NSMutableArray  *hashArrPhotos;
//        hashArrPhotos = hashTagImagesArray;
//        if (!arrPhotos.count) {
          NSMutableArray * arrPhotos = [album getAllSelectedPhotos:product];
        if (kCurrentPage == page)
        {
//            [arrPhotos addObjectsFromArray:hashTagImagesArray];
            if (kCurrentPage == 0)
            {
                [arrPhotos addObjectsFromArray:hashTagSquares];
            }
            else if (kCurrentPage == 1)
            {
                [arrPhotos addObjectsFromArray:hashTagBigSquares];
            }
            else if (kCurrentPage == 2)
            {
                
                [arrPhotos addObjectsFromArray:hashTagMiniSquares];
            }
            else if (kCurrentPage == 3)
            {
                
                [arrPhotos addObjectsFromArray:hashTagRectagles];
            }
            else if (kCurrentPage == 4)
            {
                
                [arrPhotos addObjectsFromArray:hashTagMetalPrints];
            }
            else if (kCurrentPage == 5)
            {
                [arrPhotos addObjectsFromArray:hashTagPhotoBlocks];
            }
            


        }
//        }
        
        if (arrPhotos.count > 0) {
            groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrPhotos,@"photos",
                               //[NSString stringWithFormat:@"%@ inches",product.size],@"desc",
                                product.size,@"desc",
                         product.width,@"width",
                         product.height,@"height",
                               [NSString stringWithFormat:@"$%@",product.price],@"price",
                               product,@"product",nil];
        }
        
        // test
        int counter = 0;
        for (NSDictionary *dictCounter in arrPhotos) {
            counter += [[dictCounter objectForKey:@"count"] intValue];
        }
        
        int quantity_set = [product.quantity_set intValue];
        int leftQuantity = counter % quantity_set;
        
        //BOOL isAllowByPass = [self permissionForProduct:product];
        if (leftQuantity > 0 ) {
            //if (!isAllowByPass) {
            if (!isByPassMorePhotos) {
                _lastProduct = product;
                NSString *str = [NSString stringWithFormat:@"You have chosen %d photos, and you can select %d more photos for the same price!",counter,quantity_set - leftQuantity];
                [[[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"More Photos",@"Only Print These", nil] show];
                return;
            }
            
        }
        
        // break;
        break;
        
    }
    isByPassMorePhotos = NO;
    
    /// go to cart
    [appDelegate goToTab:1];
    
    if (![CheckoutViewController getShared]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // call Checkout
            [[CheckoutViewController getShared] removeCouponData];
            [[CheckoutViewController getShared] addData:groupDict];
            
        });
    }
    else
    {
         [[CheckoutViewController getShared] removeCouponData];
        [[CheckoutViewController getShared] addData:groupDict];
       

    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void) doCheckOut {
    // now we clean all empty stuff
    for (int i=arrAlbums.count-1; i>-1; i--) {
        // decerease
        NSDictionary *dict = [arrAlbums objectAtIndex:i];
        int page = [[dict objectForKey:@"page"] intValue];
        Product *product = [_arrProducts objectAtIndex:page];
        int counter = [self countAllSelectedPhotos:product];
        if (counter == 0) {
            // remove it
            [arrAlbums removeObjectAtIndex:i];
        }
    }
    
    NSMutableArray  *rtnArr = [NSMutableArray new];
    //album
    for (NSDictionary *dict in arrAlbums) {
        int page = [[dict objectForKey:@"page"] intValue];
        Product *product = [_arrProducts objectAtIndex:page];
        SelectPhotoAlbumViewController  *album = [dict objectForKey:@"obj"];
        NSMutableArray  *arrPhotos = [album getAllSelectedPhotos:product];
        
        if (arrPhotos.count > 0) {
            [rtnArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:arrPhotos,@"photos",
                               //[NSString stringWithFormat:@"%@ inches",product.size],@"desc",
                                product.size,@"desc",
                               product.width,@"width",
                               product.height,@"height",
                               [NSString stringWithFormat:@"$%@",product.price],@"price",
                               product,@"product",nil]];
        }
        
        // test
        int counter = 0;
        for (NSDictionary *dictCounter in arrPhotos) {
            counter += [[dictCounter objectForKey:@"count"] intValue];
        }
        
        int quantity_set = [product.quantity_set intValue];
        int leftQuantity = counter % quantity_set;
        
        //BOOL isAllowByPass = [self permissionForProduct:product];
        if (leftQuantity > 0 && arrAlbums.count == 1) {
            //if (!isAllowByPass) {
            if (!isByPassMorePhotos) {
                _lastProduct = product;
                NSString *str = [NSString stringWithFormat:@"You have chosen %d photos, and you can select %d more photos for the same price!",counter,quantity_set - leftQuantity];
                [[[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"More Photos",@"Only Print These", nil] show];
                return;
            }
            
        }
        
        
    }
    
    isByPassMorePhotos = NO;
    
    // gift certificate
    [rtnArr addObjectsFromArray:arrGiftCerts];
    
    /// go to cart
    [appDelegate goToTab:1];
    
    if (![CheckoutViewController getShared]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // call Checkout
            [[CheckoutViewController getShared] setData:rtnArr];
        });
    }
    else
        [[CheckoutViewController getShared] setData:rtnArr];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void) uploadCacheImages:(NSArray*) aArrImgs {
    NSString *sql;
    SqlManager *sqlMan = [SqlManager defaultShare];
    // now scan thru them and add add them to database to precache
    for (NSDictionary *dictGroup in aArrImgs) {
        Product *product = [dictGroup objectForKey:@"product"];
        for (NSDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
            // verify if it is already in the list
            sql = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE original_imgpath = '%@' and product_id='%@'",[dictPhoto objectForKey:@"url_high"],product.uid];
            
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:product.uid forKey:PRODUCTID];
            [defaults synchronize];
            
            
            NSArray *tmpArr = [sqlMan doQueryAndGetArray:sql];
            if (tmpArr.count ==0) {
                // add now
                // get image
                sql = [NSString stringWithFormat:@"INSERT INTO upload_image (img_path,uploaded,product_id,order_id,quantity,framed,square,original_imgPath) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",
                                    [dictPhoto objectForKey:@"url_high"],
                                    @"false",
                                    product.uid,
                                    @"",
                                    [dictPhoto objectForKey:@"count"],
                                    ([[dictPhoto objectForKey:@"framed"] boolValue])?@"true":@"false",
                    (product.width == product.height)?@"true":@"false",[dictPhoto objectForKey:@"url_high"]];
                
                // add
                [sqlMan doInsertQuery:sql];
                
            }
        }
    }
    
    // kick start?
    [[Uploader shared] start];
}

-(int) countAllSelectedPhotos:(Product*) aProduct {
    NSMutableArray  *rtnArr = [NSMutableArray new];
    //album
    Product *product;
    NSString *albumType;
    for (NSDictionary *dict in arrAlbums) {
        int page = [[dict objectForKey:@"page"] intValue];
        if (page == 3)
        {
            albumType = @"rectangle_album";
        }
        else
        {
            albumType = @"square_album";
        }
        product = [_arrProducts objectAtIndex:page];
        if ([product.uid isEqualToString:aProduct.uid]) {
            SelectPhotoAlbumViewController  *album = [dict objectForKey:@"obj"];
            NSMutableArray  *arrPhotos;
            arrPhotos = hashTagDataArray;
            if (!arrPhotos.count || arrPhotos.count)
            {
                arrPhotos = [album getAllSelectedPhotos:product];
            }
            if (kCurrentPage == page)
            {
                
                if (kCurrentPage == 0)
                {
                    [arrPhotos addObjectsFromArray:hashTagSquares];
                }
                else if (kCurrentPage == 1)
                {
                    [arrPhotos addObjectsFromArray:hashTagBigSquares];
                }
                else if (kCurrentPage == 2)
                {
                    
                    [arrPhotos addObjectsFromArray:hashTagMiniSquares];
                }
                else if (kCurrentPage == 3)
                {
                  
                    [arrPhotos addObjectsFromArray:hashTagRectagles];
                }
                else if (kCurrentPage == 4)
                {
                
                    [arrPhotos addObjectsFromArray:hashTagMetalPrints];
                }
                else if (kCurrentPage == 5)
                {
                    [arrPhotos addObjectsFromArray:hashTagPhotoBlocks];
                }

              
            }

//            [arrPhotos addObjectsFromArray:hashTagImagesArray];
//            [arrPhotos addObjectsFromArray:hashTagDataArray];
            
            if (arrPhotos.count > 0) {
                [rtnArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:arrPhotos,@"photos",
                                   //[NSString stringWithFormat:@"%@ inches",product.size],@"desc",
                                   product.size,@"desc",
                                   product.width,@"width",
                                   product.height,@"height",
                                   [NSString stringWithFormat:@"$%@",product.price],@"price",
                                   product,@"product",albumType,@"album_type",nil]];
            }
        }

    }
        // test
    int counter = 0;
    for (NSDictionary *dictPhoto in rtnArr) {
        for (NSDictionary *dictCounter in [dictPhoto objectForKey:@"photos"]) {
            
            [dictCounter setValue:[dictPhoto objectForKey:@"album_type"] forKey:@"album_type"];
            [dictCounter setValue:product.size forKey:@"sizes"];
            [dictCounter setValue:product.width forKey:@"width"];
            [dictCounter setValue:product.height forKey:@"height"];

            counter += [[dictCounter objectForKey:@"count"] intValue];
        }
        
    }
    
    // everytime you call count it mean you are asking for updating images counter
    [self uploadCacheImages:rtnArr];
    
    return counter;
}

-(void) clearAllOrders {
    
    [appDelegate goToTab:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [arrAlbums removeAllObjects];
        [arrGiftCerts removeAllObjects];
        [self toClearHashTagData];
    });
    
}

#pragma mark alert delegate and datasource
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
//    int i =0;
//    // no matter what set it to true
//    for (NSMutableDictionary *dict in arrProductPermission) {
//        if ([_lastProduct isEqual:[dict objectForKey:@"product"]]) {
//            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"permission"];
//            break;
//        }
//        i++;
//    }
//    if (buttonIndex == 0) {
//        // scroll to the last product
//        [scrollView setContentOffset:CGPointMake(i*(232+GAP), 0) animated:YES];
//    }
//    else {
//        // now we look for the current one and go to it
////        int i =0;
////        // no matter what set it to true
////        for (NSMutableDictionary *dict in arrProductPermission) {
////            if ([_currentProduct isEqual:[dict objectForKey:@"product"]]) {
////                // jump
////                [self]
////                return;
////            }
////            i++;
////        }
//    }
    
    if (alertView == alertSquare) {
        if (buttonIndex == 0) {
            [self showTabBar];
            // go to FAQ
            [appDelegate goToTab:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MoreViewController *moreController = [MoreViewController getShared];
                [moreController touchFAQ];
            });
            
        }
        else if (buttonIndex == 1)
        {
            
        }
        
        return;
    }else{
        if (buttonIndex == 1) {
            isByPassMorePhotos = YES;
            [self addToCart:_lastProduct];
        }
    }
}

-(void) reloadCoachmark {
    if (scrollView.hidden) {
        // okie need to go back
        [self touchDone];
    }
}
@end
