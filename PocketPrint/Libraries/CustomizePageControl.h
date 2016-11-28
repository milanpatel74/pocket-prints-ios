//
//  CustomizePageControl.h
//  TradeEzi
//
//  Created by Quan Do on 2/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomizePageControl : UIPageControl {
    NSArray                     *originalSubviews;
    
}

@property   (nonatomic,strong) UIImage *imgSmallDot, *imgBigDot;

-(id) initWithFrame:(CGRect)frame andSmallDot:(UIImage*) smallDot andBigDot:(UIImage*) bigDot;
@end
