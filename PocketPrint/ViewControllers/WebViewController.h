//
//  WebViewController.h
//  PocketPrint
//
//  Created by Quan Do on 2/06/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : AppViewController <UIWebViewDelegate>{
    IBOutlet UIWebView  *webView;
    IBOutlet    UIActivityIndicatorView *spinner;
}

@end
