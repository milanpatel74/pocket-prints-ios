//
//  InstagramOAuthViewController.h
//  PocketPrint
//
//  Created by Cuong Nguyen-Minh on 6/15/16.
//  Copyright © 2016 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramOAuthViewController : AppViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
