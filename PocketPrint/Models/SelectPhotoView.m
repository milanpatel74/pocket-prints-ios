//
//  SelectPhotoView.m
//  PocketPrint
//
//  Created by Quan Do on 12/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "SelectPhotoView.h"

@implementation SelectPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // set font here
    }
    return self;
}

-(void) awakeFromNib {
    _lbGroupName.font = [UIFont fontWithName:@"MuseoSans-300" size:12];
    _lbNumberOfPhotos.font = [UIFont fontWithName:@"MuseoSans-300" size:18];
    
    // add spinner
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect frame = spinner.frame;
    frame.origin.x = (_imgView.frame.size.width - frame.size.width ) /2;
    frame.origin.y = (_imgView.frame.size.height - frame.size.height ) /2;
    spinner.frame = frame;
    spinner.hidden = YES;
    [_imgView addSubview:spinner];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark actions
-(IBAction) touchPhoto {
    [_delegate touchPhoto:self];
}

-(IBAction) touchNumber {
    [_delegate touchNumber:self];
}

-(IBAction) touchFrame {
    [_delegate touchFrame:self];
}

-(void) applyFrame:(BOOL) allowFrame {
    frameView.hidden = !allowFrame;
}

-(void) showSpiner:(BOOL) isShow {
    spinner.hidden = !isShow;
    if (isShow) {
        [spinner startAnimating];
    }
    else
        [spinner stopAnimating];
}
@end
