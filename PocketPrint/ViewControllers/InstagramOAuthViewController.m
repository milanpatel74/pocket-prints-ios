//
//  InstagramOAuthViewController.m
//  PocketPrint
//
//  Created by Cuong Nguyen-Minh on 6/15/16.
//  Copyright © 2016 Quan Do. All rights reserved.
//

#import "InstagramOAuthViewController.h"

@interface InstagramOAuthViewController ()

@end

@implementation InstagramOAuthViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setScreenTitle:@"Instagram Login"];
    
    NSString *loginURL = [self.app.instagram getFullLoginURL:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    
    DLog("Login URL: %@", loginURL);
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loginURL]]];
    
    webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 21);
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] absoluteString] hasPrefix:INSTAGRAM_REDIRECT_URI])
    {
        // pop viewcontroller
        [self.navigationController popViewControllerAnimated:YES];
        
        // call instagram to handle this URL
        DLog(@"instagram URL handling...");
        [self.app.instagram handleOpenURL:[request URL]];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Fail to load information from Pocket Prints. Please try again later" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

-(void) touchBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
