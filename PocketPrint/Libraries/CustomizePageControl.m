//
//  CustomizePageControl.m
//  TradeEzi
//
//  Created by Quan Do on 2/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomizePageControl.h"

@implementation CustomizePageControl


// This assumes you're creating the control from a nib.  Depending on your
// usage you might do this step in initWithFrame:
- (void) awakeFromNib {
    // retain original subviews in case apple's implementation
    // relies on the retain count being maintained by the view's
    // presence in its superview.
    originalSubviews = [[NSArray alloc] initWithArray: self.subviews];
    
    for ( UIView *view in self.subviews ) [view removeFromSuperview];
    
    // make sure the view is redrawn not scaled when the device is rotated
    self.contentMode = UIViewContentModeRedraw;
}

-(id) initWithFrame:(CGRect)frame andSmallDot:(UIImage*) smallDot andBigDot:(UIImage*) bigDot {
    CustomizePageControl   *pageControl = [[CustomizePageControl alloc] initWithFrame:frame];
    pageControl.imgBigDot = bigDot;
    pageControl.imgSmallDot = smallDot;
    return pageControl;
}

- (void) dealloc {
    [originalSubviews release];
    [super dealloc];
}


- (void) drawRect:(CGRect) iRect {
    UIImage                 *grey, *image, *red;
    int                     i;
    CGRect                  rect;
    
    const CGFloat           kSpacing = 10.0;
    
    iRect = self.bounds;
    
//    if ( self.opaque ) {
//        [self.backgroundColor set];
//        UIRectFill( iRect );
//    }
    
    if ( self.hidesForSinglePage && self.numberOfPages == 1 ) return;
    
    red = _imgBigDot;
    grey = _imgSmallDot;
    
    rect.size.height = red.size.height;
    rect.size.width = self.numberOfPages * red.size.width + ( self.numberOfPages - 1 ) * kSpacing;
    rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0 );
    rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0 );
    rect.size.width = red.size.width;
    
    for ( i = 0; i < self.numberOfPages; ++i ) {
        image = i == self.currentPage ? red : grey;
        
        [image drawInRect: rect];
        
        rect.origin.x += red.size.width + kSpacing;
    }
}


// you must override the setCurrentPage: and setNumberOfPages:
// methods to ensure that your control is redrawn when its values change
- (void) setCurrentPage:(NSInteger) iPage {
    [super setCurrentPage: iPage];
    [self setNeedsDisplay];
}


- (void) setNumberOfPages:(NSInteger) iPages {
    [super setNumberOfPages: iPages];
    [self setNeedsDisplay];
}
@end

