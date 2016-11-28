//
//  UIImageViewWithData.m
//  PocketPrint
//
//  Created by Quan Do on 20/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "UIImageViewWithData.h"

@implementation UIImageViewWithData

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // add spinner
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect frame = spinner.frame;
        frame.origin.x = (self.frame.size.width - frame.size.width ) /2;
        frame.origin.y = (self.frame.size.height - frame.size.height ) /2;
        spinner.frame = frame;
        spinner.hidden = YES;
        [self addSubview:spinner];
        
        // add border
//        imgViewBorder   = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 99, 99)];
//        imgViewBorder.image = [UIImage imageNamed:@"border_w_shadow.png"];
//        imgViewBorder.hidden = YES;
//        [self addSubview:imgViewBorder];
        
        // draw over image
        self.clipsToBounds = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) showSpiner:(BOOL) isShow {
    spinner.hidden = !isShow;
    if (isShow) {
        [spinner startAnimating];
    }
    else
        [spinner stopAnimating];
}

//-(void) activateBorder:(BOOL) allowBorder {
//    imgViewBorder.hidden = !allowBorder;
//}
@end
