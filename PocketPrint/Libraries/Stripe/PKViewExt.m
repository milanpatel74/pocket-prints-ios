//
//  PKViewExt.m
//  PocketPrint
//
//  Created by Quan Do on 30/08/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "PKViewExt.h"

@implementation PKViewExt

@dynamic cardNumberField,cardExpiryField,cardCVCField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void) setCard:(PKCard*) card {
    self.cardNumberField.text = card.number;
    self.cardCVCField.text = card.cvc;
    self.cardExpiryField.text = [NSString stringWithFormat:@"%@/%d",[NSString stringWithFormat:(card.expMonth < 10)?@"0%d":@"%d",card.expMonth],card.expYear];
}
@end
