//
//  AppViewController.m
//  Bootylicious
//
//  Created by luongnguyen on 9/27/12.
//  Copyright (c) 2012 luongnguyen. All rights reserved.
//

#import "AppViewController.h"
//#import "NavViewController.h"
#import "NSString+GetSizeWithFont.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_GAP 20
#define BASE_IMG_BTN_BACK_NORMAL        @"back_btn.png"
#define BASE_IMG_BTN_BACK_ACTIVE        @"back_btn.png"
#define BASE_IMG_BTN_DONE_NOMRAL        @"done_btn.png"
#define BASE_IMG_BTN_DONE_ACTIVE        @"done_btn.png"
#define COVER_VIEW_TAG  9999

@interface AppViewController (Private)

-(UIButton*) createButtonWithImageNormalState:(UIImage*) imgNormalState
                      withImageHighlightState:(UIImage*) imgHighlightState
                                 withWidthCap:(int) widthCap withTopCapHeight:(int) topCapHeight
                              withButtonWidth:(NSNumber*) btnWidth
                             withButtonHeight:(int) btnHeight
                                     withFont:(UIFont*) aFont
                                    withColor:(UIColor*) aColor
                                    withTitle:(NSString*) aTitle
                                   withTarget:(id) target
                                  forSelector:(SEL) aSelector;

-(UIBarButtonItem*) createBarButtonItemWithImageNormalState:(UIImage*) imgNormalState
                                    withImageHighlightState:(UIImage*) imgHighlightState
                                               withWidthCap:(int) widthCap
                                           withTopCapHeight:(int) topCapHeight
                                            withButtonWidth:(NSNumber*) btnWidth
                                                  withTitle:(NSString*) aTitle
                                                   withFont:(UIFont*)font
                                                  withColor:(UIColor*)color
                                                 withTarget:(id) target
                                                forSelector:(SEL) aSelector;

-(CGSize) getSizeOfString:(NSString*) aString forFont:(UIFont*) aFont;

//

@end

@implementation AppViewController

#define DEFAULT_IPHONE_4_NIB_EXT    @"-iphone4"
#define DEFAULT_IPAD_NIB_EXT        @"-iPad"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // verify here
    NSFileManager   *fileMan = [NSFileManager defaultManager];
    NSString    *nibName = nibNameOrNil;
    if (IS_IPAD) {
        NSString    *testNib = [NSString stringWithFormat:@"%@/%@%@.nib",[[NSBundle mainBundle] bundlePath],nibName,DEFAULT_IPAD_NIB_EXT];
        if ([fileMan fileExistsAtPath:testNib]) {
            nibName = [nibName stringByAppendingString:DEFAULT_IPAD_NIB_EXT];
        };
    }
    else {
        if (IS_4INCHES == NO) {
            // is nib file exists ?
            
            NSString    *testNib = [NSString stringWithFormat:@"%@/%@%@.nib",[[NSBundle mainBundle] bundlePath],nibName,DEFAULT_IPHONE_4_NIB_EXT];
            if ([fileMan fileExistsAtPath:testNib]) {
                nibName = [nibName stringByAppendingString:DEFAULT_IPHONE_4_NIB_EXT];
            };
        }
    }
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _handlers = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    //force not rotate
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe7e7e7);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void) setScreenTitle:(NSString *)aTitle withColor:(UIColor*) aColor{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont fontWithName:@"Gleigh" size:19];
    lbTitle.textColor = aColor;
    lbTitle.text = aTitle;
    [lbTitle sizeToFit];
    self.navigationItem.titleView = lbTitle;
}

-(void) setScreenTitle:(NSString *)aTitle {
    [self setScreenTitle:aTitle withColor:[UIColor blackColor]];
}

-(void) addBackButton {
    [self addBackButtonWithWidth:50];
}

-(void) addBackButtonWithWidth:(int) width {
    
    UIButton    *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IOS_7 || IS_IPAD ) {
        btn.frame = CGRectMake(0, 0, IS_IPAD?width:35,IS_IOS_7 ?30:45);
        btn.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD?12: 10];
        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn setTitle:@"BACK" forState:UIControlStateNormal];
    }
    else {
        if (!IS_IPAD) {
            btn.frame = CGRectMake(0, 0, 50,45);
            [btn setImage:[UIImage imageNamed:@"back_nav_btn.png"] forState:UIControlStateNormal];
        }
//        else {
//            btn.frame = CGRectMake(0, 0, 50,30);
//            [btn setImage:[UIImage imageNamed:@"ipad_back_nav_btn.png"] forState:UIControlStateNormal];
//        }
    }
    
    [btn addTarget:self action:@selector(doGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = backBtn;

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    _backBarBtnItem = nil;
    _doneBarBtnItem = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView  *coverView = [self.view viewWithTag:COVER_VIEW_TAG];
    if (coverView) {
        coverView.hidden = YES;
    }
//    NavViewController *nav = (NavViewController*) self.navigationController;
//    nav.titleView.text = _navTitle;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return  YES;
//}

// orientation
- (void) changedOrientation:(NSNotification*) notification {
    if (![self shouldAutorotate]) {
        return;
    }
    ///DLog(@"Orientation change");
    [self didChangeOrientation:notification];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void) didChangeOrientation:(NSNotification*) notification {
    
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    
//    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
//}

- (void) dealloc
{    
    [_handlers removeAllObjects];
    _handlers = nil;
    
    _navTitle = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

//--------------------------------------------------
//  MAIN
//--------------------------------------------------
//- (void) setNavigationTitle:(NSString*)title
//{
//    _navTitle = title;
//    
//    NavViewController *nav = (NavViewController*) self.navigationController;
//    nav.titleView.text = title;
//    
//    nav.titleView.hidden = NO;
//    nav.titleImage.hidden = YES;
//}

//- (void) setNavigationImage:(UIImage *)img {
//    NavViewController *nav = (NavViewController*) self.navigationController;
//    nav.titleImage.image = img;
//    
//    UIView* bar = nav.navigationBar;
//    
//    nav.titleImage.frame = CGRectMake(0, 0, img.size.width, img.size.height);
//    nav.titleImage.frame = CGRectMake(5+(bar.frame.size.width - nav.titleImage.frame.size.width)/2, (bar.frame.size.height - nav.titleImage.frame.size.height)/2, nav.titleImage.frame.size.width, nav.titleImage.frame.size.height);
////    nav.titleImage.backgroundColor = [UIColor greenColor];
//    
//    nav.titleView.hidden = YES;
//    nav.titleImage.hidden = NO;
//    
//}

- (void) setHandlerOnBack:(void(^)(void))onBack andOnDone:(void(^)(void))onDone
{
    if (onBack)
    {
        _backBarBtnItem = [self createBarButtonItemWithImageNormalState:[UIImage imageNamed:BASE_IMG_BTN_BACK_NORMAL]
                                                withImageHighlightState:[UIImage imageNamed:@""]
                                                           withWidthCap:12
                                                       withTopCapHeight:0
                                                        withButtonWidth:nil
                                                              withTitle:@" Back"
                                                               withFont:[UIFont boldSystemFontOfSize:12]
                                                              withColor:UIColorFromRGB(0xffffff)
                                                             withTarget:self
                                                            forSelector:@selector(doGoBack)];
        
        self.navigationItem.leftBarButtonItem = _backBarBtnItem;
        [_handlers setObject:[onBack copy] forKey:@"onBackButton"];
    }
    
    if (onDone)
    {
        _doneBarBtnItem = [self createBarButtonItemWithImageNormalState:[UIImage imageNamed:BASE_IMG_BTN_DONE_NOMRAL]
                                                withImageHighlightState:[UIImage imageNamed:@""]
                                                           withWidthCap:0
                                                       withTopCapHeight:0
                                                        withButtonWidth:[NSNumber numberWithInt:45]
                                                              withTitle:@""
                                                               withFont:[UIFont boldSystemFontOfSize:12]
                                                              withColor:UIColorFromRGB(0x363636)
                                                             withTarget:self
                                                            forSelector:@selector(doDone)];
        
        self.navigationItem.rightBarButtonItem = _doneBarBtnItem;
        [_handlers setObject:[onDone copy] forKey:@"onDoneButton"];
    }
}

- (UIBarButtonItem *) setCustomButtonWithImageNormalState:(UIImage*) imgNormalState
                                  withImageHighlightState:(UIImage*) imgHighlightState
                                          withButtonWidth:(NSNumber*) btnWidth
                                               withTarget:(id) target
                                              forSelector:(SEL) aSelector
{
    return [self createBarButtonItemWithImageNormalState:imgNormalState
                          withImageHighlightState:imgHighlightState
                                     withWidthCap:0
                                 withTopCapHeight:0
                                  withButtonWidth:btnWidth
                                        withTitle:@""
                                         withFont:[UIFont boldSystemFontOfSize:12]
                                        withColor:UIColorFromRGB(0x363636)
                                       withTarget:target
                                      forSelector:aSelector];
}

- (UIBarButtonItem *) setCustomButtonWithImageNormalState:(UIImage*) imgNormalState
                                  withImageHighlightState:(UIImage*) imgHighlightState
                                          withButtonWidth:(NSNumber*) btnWidth
                                                withTitle:(NSString *) title
                                               withTarget:(id) target
                                              forSelector:(SEL) aSelector
{
    return [self createBarButtonItemWithImageNormalState:imgNormalState
                                 withImageHighlightState:imgHighlightState
                                            withWidthCap:0
                                        withTopCapHeight:0
                                         withButtonWidth:btnWidth
                                               withTitle:title
                                                withFont:[UIFont boldSystemFontOfSize:12]
                                               withColor:UIColorFromRGB(0xffffff)
                                              withTarget:target
                                             forSelector:aSelector];
}

//--------------------------------------------------
//  PRIVATE
//--------------------------------------------------
-(UIButton*) createButtonWithImageNormalState:(UIImage*) imgNormalState
                      withImageHighlightState:(UIImage*) imgHighlightState
                                 withWidthCap:(int) widthCap withTopCapHeight:(int) topCapHeight
                              withButtonWidth:(NSNumber*) btnWidth
                             withButtonHeight:(int) btnHeight
                                     withFont:(UIFont*) aFont
                                    withColor:(UIColor*) aColor
                                    withTitle:(NSString*) aTitle
                                   withTarget:(id) target
                                  forSelector:(SEL) aSelector
{
    UIButton    *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    int buttonWith;
    if (btnWidth!= nil) {
        buttonWith = [btnWidth intValue];
    }
    else
        buttonWith = [self getSizeOfString:aTitle forFont:aFont].width + BUTTON_GAP;
    
    btn.frame = CGRectMake(0, 0, buttonWith, btnHeight);
    [btn setBackgroundImage:[imgNormalState stretchableImageWithLeftCapWidth:widthCap topCapHeight:topCapHeight] forState:UIControlStateNormal];
    [btn setBackgroundImage:[imgHighlightState stretchableImageWithLeftCapWidth:widthCap topCapHeight:topCapHeight] forState:UIControlStateHighlighted];
    [btn addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UILabel  *lbTitle = [[UILabel alloc] initWithFrame:btn.frame];
    lbTitle.font = aFont;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = aColor;//[UIColor whiteColor];
    //lbTitle.shadowColor = [UIColor whiteColor];
    //lbTitle.shadowOffset = CGSizeMake(0, 1);
    lbTitle.text = aTitle;
    [lbTitle sizeToFit];
    lbTitle.frame = CGRectMake(([aTitle length] > [[aTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) ? 12 : 8, (btn.frame.size.height - lbTitle.frame.size.height)/2 -1, lbTitle.frame.size.width, lbTitle.frame.size.height);
    [btn addSubview:lbTitle];
    return btn;
}

-(UIBarButtonItem*) createBarButtonItemWithImageNormalState:(UIImage*) imgNormalState
                                    withImageHighlightState:(UIImage*) imgHighlightState
                                               withWidthCap:(int) widthCap
                                           withTopCapHeight:(int) topCapHeight
                                            withButtonWidth:(NSNumber*) btnWidth
                                                  withTitle:(NSString*) aTitle
                                                   withFont:(UIFont*)font
                                                  withColor:(UIColor*)color
                                                 withTarget:(id) target
                                                forSelector:(SEL) aSelector
{
    // prepare some UI component
    UIButton    *btn = [self createButtonWithImageNormalState:imgNormalState
                                      withImageHighlightState:imgHighlightState
                                                 withWidthCap:widthCap
                                             withTopCapHeight:topCapHeight
                                              withButtonWidth:btnWidth
                                             withButtonHeight: imgNormalState.size.height
                                                     withFont:font
                                                    withColor:color
                                                    withTitle:aTitle
                                                   withTarget: target
                                                  forSelector:aSelector];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barBtnItem;
}

-(CGSize) getSizeOfString:(NSString*) aString forFont:(UIFont*) aFont
{
    CGSize maximumSize = CGSizeMake(300, 9999);
    return [aString sizeWithFont:aFont
               constrainedToSize:maximumSize
                   lineBreakMode:UILineBreakModeTailTruncation];
}

//--------------------------------------------------
//  SELECTORS
//--------------------------------------------------
- (void) doGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doDone
{
    void(^onDone)(void) = [_handlers objectForKey:@"onDoneButton"];
    if (onDone) onDone();
}

#pragma mark UI 

//-(void) setTitle:(NSString *)aTitle {
//    [super setTitle:aTitle];
//    UIImage *imgTitle = [self imageWithTitle:aTitle];
//    
//    UIImageView *imgViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgTitle.size.width / 2, imgTitle.size.height / 2)];
//    imgViewTitle.image = imgTitle;
//    imgViewTitle.contentMode = UIViewContentModeScaleAspectFit;
//    self.navigationItem.titleView = imgViewTitle;
//}

-(UIImage*) imageWithTitle:(NSString*) aTitle {
    float   fontSize = 18*2;
    int     gap = 10;
    UIFont  *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    //CGSize  titleSize = [aTitle sizeForFont:font];
    
    UIImage *img = [UIImage imageNamed:@"flip_bg_title@2x.png"];//[self imageWithView:imgView];
    CGSize  fullSize = CGSizeMake([self fullWidthOfString:aTitle forFont:font andGap:10], 29*2);
    
    // create context
    UIGraphicsBeginImageContext(fullSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    
    // draw text
    
    // get array of string set
    NSArray *parts = [aTitle componentsSeparatedByString:@" "];
    int x = 0;
    for (NSString   *str in parts) {
        if (x!=0) {
            // space
            x+=10;
        }
        CGSize  titleSize = [str sizeForFont:font];
        CGSize  bgSize = CGSizeMake(titleSize.width+gap*2, 29*2);
        /// pattern drawing
        int times = bgSize.width / (img.size.width-5);
        
        for (int i=0; i<times; i++) {
            [img drawAtPoint:CGPointMake(x + (img.size.width-5)*i, 0)];
        }
        // cover last part
        [img drawAtPoint:CGPointMake(x + bgSize.width - img.size.width, 0)];
        
        //draw text
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, titleSize.width, titleSize.height)];
        lb.text = str;
        [lb setFont:font];
        [lb setTextColor:[UIColor whiteColor]];
        [lb drawTextInRect:CGRectMake(x + gap, 7, titleSize.width, titleSize.height)];
        // plus
        x+= bgSize.width;
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
};


-(int) fullWidthOfString:(NSString*) aStr forFont:(UIFont*) aFont andGap:(int) aGap{
    int width = 0;
    NSArray *parts = [aStr componentsSeparatedByString:@" "];
    for (int i=0; i<parts.count; i++) {
        if (width != 0) {
            width += 10;
        }
        NSString    *s = [parts objectAtIndex:i];
        CGSize  titleSize = [s sizeForFont:aFont];
        CGSize  size = CGSizeMake(titleSize.width + aGap*2, 29*2);
        width += size.width;
    }
    return width;
}

// ios7
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

#pragma mark action



-(void) touchListBtn {
    //check for tag
    UIButton  *coverView = (UIButton*)[self.view viewWithTag:COVER_VIEW_TAG];
    if (coverView) {
        coverView.hidden = NO;
        [UIView animateWithDuration:0.35 animations:^{
            coverView.alpha = 0;
        } completion:^(BOOL finished) {
            coverView.hidden = YES;
            [coverView removeFromSuperview];
        }];

    }
    else {
        // cover windows
        coverView = [UIButton buttonWithType:UIButtonTypeCustom];
        coverView.frame = self.view.frame;
        [coverView addTarget:self action:@selector(touchListBtn) forControlEvents:UIControlEventTouchUpInside];
        if (IS_IOS_7) {
            CGRect frame = coverView.frame;
            frame.origin.y -=64;
            coverView.frame = frame;
        }
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0;
        coverView.tag = COVER_VIEW_TAG;
        [self.view addSubview:coverView];
        UIPanGestureRecognizer  *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [coverView addGestureRecognizer:pan ];
        [UIView animateWithDuration:0.35 animations:^{
            coverView.alpha = 0.75f;
        }];
    }

    [self.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil];
}

#pragma mark gesture
-(void) panGesture:(UIPanGestureRecognizer*) sender {
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [self touchListBtn];
    }
}

#pragma mark obsever
-(void) enableKeyboardListerner {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
}

- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //DLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
}
@end
