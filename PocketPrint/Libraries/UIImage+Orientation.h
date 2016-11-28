//
//  UIImage+Orientation.h
//  PocketPrint
//
//  Created by Quan Do on 14/05/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

-(UIImage*) forceOrientationUp;
-(UIImage*) centerCropForWidth:(float) aWidth andHeight:(float) aHeight;
@end
