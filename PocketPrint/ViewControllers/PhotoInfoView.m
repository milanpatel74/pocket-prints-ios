//
//  PhotoInfoController.m
//  PocketPrint
//
//  Created by Quan Do on 11/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "PhotoInfoView.h"

@implementation PhotoInfoView 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

-(void) awakeFromNib
{
    lbPrice.font = [UIFont fontWithName:@"MuseoSans-300" size:15.0f];
    lbPrice.textColor = UIColorFromRGB(0x979797);
    lbSize.font = [UIFont fontWithName:@"MuseoSans-500" size:15.0f];
    tvDesc.font = [UIFont fontWithName:@"MuseoSans-300" size:15.0f];
    
    tvDesc.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    
    if (!IS_4INCHES) {
        CGRect frame = tvDesc.frame;
        frame.size.height -= 74;
        tvDesc.frame = frame;
    }
    
    // add default GUI
    // add shadow images
    UIImageView *imageShadowView = [[UIImageView alloc] initWithFrame:CGRectMake(106, 296, 108, 14)];
    imageShadowView.image = [UIImage imageNamed:@"black_bar.png"];
    [self addSubview:imageShadowView];
    
    //pageControl = [[CustomizePageControl alloc] initWithFrame:CGRectMake(0, 305, 320, 37)];
    pageControl = [[CustomizePageControl alloc] initWithFrame:CGRectMake(0, 285, 320, 37) andSmallDot:[UIImage imageNamed:@"red_dot_small.png"] andBigDot:[UIImage imageNamed:@"red_dot.png"]];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.tintColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    [self addSubview:pageControl];
    
    _arrPhotos = [[NSMutableArray alloc] init];
    
    // set some properties of scrollview
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        [tvDesc setFrameHeight:tvDesc.frame.size.height * 2];
    }
    
}

-(void) loadDataForProduct:(Product*) aProduct {
    RUN_ON_MAIN_QUEUE((^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        
        product = aProduct;
        kCurrentPage = 0;
        // static data
        lbSize.text = [NSString stringWithFormat:@"%@",product.size];
        // gift certificate ?
        if ([product.type isEqualToString:@"Gift Certificates"]) {
            lbPrice.text = @"From $20";
        }
        else
        lbPrice.text = [NSString stringWithFormat:@"%d print%@ for $%@ ",[product.quantity_set intValue],([product.quantity_set intValue]>1)?@"s":@"",product.price];;
        tvDesc.text = product.description;
        
        //reset
        for (UIView *aView in viewControllers) {
            [aView setHidden:YES];
            [aView removeFromSuperview];
            
        }
        [_arrPhotos removeAllObjects];
        [viewControllers removeAllObjects];
        
        // copy
        for (NSDictionary *dict in product.images) {
            NSMutableDictionary *dictImg = [NSMutableDictionary dictionaryWithDictionary:dict];
            [_arrPhotos addObject:dictImg];
        }
        
        if (_arrPhotos.count == 0) {
            // add main image as the only one photo
            NSMutableDictionary *dictImg = [NSMutableDictionary dictionaryWithObjectsAndKeys:product.main_image,@"image", nil];
            [_arrPhotos addObject:dictImg];
        }
        // preset;
        
        kNumberOfPages = _arrPhotos.count;
        pageControl.numberOfPages = kNumberOfPages;
        pageControl.currentPage = kCurrentPage;
        
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < kNumberOfPages; i++)
        {
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(i*320, 0, 320, _scrollView.frame.size.height)];
            
            __block NSMutableDictionary    *dictImg = [_arrPhotos objectAtIndex:i];
            // big BG
            //        UIImageView *imgBGView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 310, 444)];
            //        imgBGView.image = [UIImage imageNamed:@"white_bg_content.png"];
            //        [aView addSubview:imgBGView];
            
            // image
            __block UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 320, 265)];
            //imgView.backgroundColor = [UIColor redColor];
            imgView.image = [dictImg objectForKey:@"image_data"];
            [aView addSubview:imgView];
            
            if (![dictImg objectForKey:@"image_data"]) {
                imgView.image = [UIImage imageNamed:@"default_img_medium.png"];
                // download
                [[Downloader sharedDownloader] downloadWithCacheURL:[dictImg objectForKey:@"image"] allowThumb:NO andCompletionBlock:^(NSData *data) {
                    UIImage *img = [UIImage imageWithData:data];
                    RUN_ON_MAIN_QUEUE(^{
                        imgView.image = img;
                        [dictImg setObject:img forKey:@"image_data"];
                        
                    });
                    
                } andFailureBlock:^(NSError *error) {
                    DLog(@"Fail to download image");
                }];
            }
            [controllers addObject:aView];
        }
        viewControllers = controllers;
        
        // a page is the width of the scroll view
        _scrollView.contentSize = CGSizeMake(kNumberOfPages*320, _scrollView.frame.size.height);
        
        if (_arrPhotos.count >= 1) {
            [self loadScrollViewWithPage:0];
            if (_arrPhotos.count >= 2) {
                [self loadScrollViewWithPage:1];
            }
        }

    }));
    
}
#pragma mark scroll view photo

-(void) goToPage:(int) page {
    _scrollView.contentOffset = CGPointMake(page*320, 0);
}

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
        CGRect frame = _scrollView.frame;
        //frame.size.width = 232;
        [_scrollView insertSubview:controller atIndex:0];
        
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
            [_scrollView addSubview:aView];
            
            frame.origin.x = 320 * page;
            frame.origin.y = 0;
            
            //            [viewControllers addObject:aView];
        } else
        {
            frame.origin.y = 0;
            //frame.origin.x = (320 - 232)/2;
            frame.origin.x = 0;
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
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    kCurrentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    
    pageControl.currentPage = kCurrentPage;
    //load data
//    Product *product = [_arrPhotos objectAtIndex:kCurrentPage];
//    lbSize.text = [NSString stringWithFormat:@"%@ inches",product.size];
//    lbPrice.text = [NSString stringWithFormat:@"$%@ per print",product.price];;
//    tvDesc.text = product.description;
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

@end
