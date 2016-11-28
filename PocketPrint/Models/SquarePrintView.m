//
//  SquarePrintView.m
//  PocketPrint
//
//  Created by Quan Do on 11/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "SquarePrintView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SquarePrintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 232, 232)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        // add
        [self addSubview:imgView];
        
        
        // add spinner
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect frame = spinner.frame;
        frame.origin.x = (imgView.frame.size.width - frame.size.width ) /2;
        frame.origin.y = (imgView.frame.size.height - frame.size.height ) /2;
        spinner.frame = frame;
        spinner.hidden = YES;
        [imgView addSubview:spinner];
        
        
        

        
        
        // activate container
        viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        // title
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 230, 232, 37)];
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.textColor = [UIColor blackColor];
        _lbTitle.font = [UIFont fontWithName:@"Gleigh" size:16];
        
        // add
        [viewContainer addSubview:_lbTitle];
        
        // size
        _lbSize = [[UILabel alloc] initWithFrame:CGRectMake(12, 253, 232, 37)];
        _lbSize.backgroundColor = [UIColor clearColor];
        _lbSize.textColor = UIColorFromRGB(0x969696);
        _lbSize.font = [UIFont fontWithName:@"MuseoSans-300" size:12];;
        
        // add
        [viewContainer addSubview:_lbSize];
        
        // price
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(12, 276, 232, 37)];
        _lbPrice.backgroundColor = [UIColor clearColor];
        _lbPrice.textColor = UIColorFromRGB(0x4d4d4d);
        _lbPrice.font = [UIFont fontWithName:@"MuseoSans-300" size:12];
        
        // add
        [viewContainer addSubview:_lbPrice];
        

        //round corner
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        [self addSubview:viewContainer];

        // add button
        UIButton    *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhoto.frame = imgView.frame;
        [btnPhoto addTarget:self action:@selector(touchPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnPhoto];
        // add ifon icon
        UIButton    *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *btnImg = [UIImage imageNamed:@"info_icon.png"];
        btn.frame = CGRectMake(198, 278, btnImg.size.width+10, btnImg.size.height+10);
        //[btn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [btn setImage:btnImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchShowInfo) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    return self;
}

-(SquarePrintView*)standardInit {
    return [self initWithFrame:CGRectMake(0, 0, 232, 310)];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

#pragma mark actions
-(void) touchShowInfo {
    [_delegate touchPhotoInfo:self];
}

-(void) touchPhoto {
    [_delegate touchPhoto:self];
}
#pragma mark GUI
-(void) setImage:(UIImage *)image {
    imgView.image = image;
}

-(void) showSpiner:(BOOL) isShow {
    spinner.hidden = !isShow;
    if (isShow) {
        [spinner startAnimating];
    }
    else
        [spinner stopAnimating];
}

-(void) activateGiftCertificate {
    //viewContainer.hidden = YES;
    //imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _lbSize.hidden = YES;
}

@end
