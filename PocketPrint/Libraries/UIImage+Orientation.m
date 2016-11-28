//
//  UIImage+Orientation.m
//  PocketPrint
//
//  Created by Quan Do on 14/05/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "UIImage+Orientation.h"

@implementation UIImage(Orientation)

-(UIImage*) forceOrientationUp {
    return [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:UIImageOrientationUp];
    
    UIImage *image = self;
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(UIImage*) centerCropForWidth:(float) aWidth andHeight:(float) aHeight {
    if (self.size.width <= aWidth || self.size.height <= aHeight) {
        // do nothing
        return self;
    }
    // proceed
    float widthRatio = self.size.width / aWidth;
    float heightRatio = self.size.height / aHeight;
    
    float ratio = (widthRatio < heightRatio)?widthRatio:heightRatio;
    
    float width = ratio * aWidth;
    float height = ratio * aHeight;
    
    // now we create image
    // create a new bitmap image context at the device resolution (retina/non-retina)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width , height), YES, 0.0);
    
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current
    // (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);
    float posX = (self.size.width - width) / 2;
    if (posX > 0) {
        posX *= -1;
    }
    float posY = (self.size.height - height) / 2;
    if (posY > 0) {
        posY *= -1;
    }
    // this example draws the inputImage into the context
    [self drawAtPoint:CGPointMake(posX, posY)];
    
    
    // pop context
    UIGraphicsPopContext();
    
    // get a UIImage from the image context- enjoy!!!
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return outputImage;
}
@end
