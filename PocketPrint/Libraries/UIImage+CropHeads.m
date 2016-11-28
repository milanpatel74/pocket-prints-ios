//
//  UIImage+CropHeads.m
//  PocketPrint
//
//  Created by Quan Do on 21/08/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "UIImage+CropHeads.h"
#import "UIImage+Resize.h"

@implementation UIImage(CropHeads)

-(UIImage*) cropHeads {
    
    // step 1
    /*
     *  declare some useful constant
     */
    
    float topX = 99999;
    float topY = 99999;
    float bottomX = 0;
    float bottomY = 0;
    
    // vertical range
    float topRange = 0;
    float bottomRange = 0;
    float topRangeRatio = 1.3f; // golden ratio
    float bottomRangeRatio = 0.45f; // golden ratio
    
    // horizontal range
    float eyeRange = 0;
    float eyeRangeRatio = 0.3f; // golden ratio
    
    // step 2
    /*
     *  face detection
     */
    
    NSDictionary *options = [NSDictionary dictionaryWithObject: CIDetectorAccuracyHigh forKey: CIDetectorAccuracy];
    CIDetector  *detector = [CIDetector detectorOfType: CIDetectorTypeFace context: nil options: options];

    
    CIImage *ciImage = [CIImage imageWithCGImage: [self CGImage]];
    //    NSNumber *orientation = [NSNumber numberWithInt:[image imageOrientation]+1];
    //    NSDictionary *fOptions = [NSDictionary dictionaryWithObject:orientation forKey: CIDetectorImageOrientation];
    
    CGRect frame;
    NSArray *features = [detector featuresInImage:ciImage];
    int faceCount= 0 ;
    for (CIFaceFeature *f in features) {
        
        DLog(@"\n\nFace :%d",faceCount);
        
        float maxEyePos = 0;
        float leftEyePos = 0;
        float rightEyePos = 0;
        
        if(f.hasLeftEyePosition) {
            maxEyePos = f.leftEyePosition.y;
            //            NSLog(@"left eye position x = %f , y = %f", f.leftEyePosition.x, f.leftEyePosition.y);
            if (topX > f.leftEyePosition.x) {
                topX = f.leftEyePosition.x;
            }
            if (topY > f.leftEyePosition.y) {
                topY = f.leftEyePosition.y;
                topRange = abs(maxEyePos - f.mouthPosition.y);
            }
            if (bottomX < f.leftEyePosition.x) {
                bottomX = f.leftEyePosition.x;
                
            }
            if (bottomY < f.leftEyePosition.y) {
                bottomY = f.leftEyePosition.y;
                bottomRange = abs(maxEyePos - f.mouthPosition.y);
            }
            
            leftEyePos = f.leftEyePosition.x;
        }
        
        if(f.hasRightEyePosition) {
            if (maxEyePos < f.rightEyePosition.y) {
                maxEyePos = f.rightEyePosition.y;
            }
            //            NSLog(@"right eye position x = %f , y = %f",f.rightEyePosition.x, f.rightEyePosition.y);
            if (topX > f.rightEyePosition.x) {
                topX = f.rightEyePosition.x;
            }
            if (topY > f.rightEyePosition.y) {
                topY = f.rightEyePosition.y;
                topRange = abs(maxEyePos - f.mouthPosition.y);
            }
            if (bottomX < f.rightEyePosition.x) {
                bottomX = f.rightEyePosition.x;
            }
            if (bottomY < f.rightEyePosition.y) {
                bottomY = f.rightEyePosition.y;
                bottomRange = abs(maxEyePos - f.mouthPosition.y);
            }
            
            rightEyePos = f.rightEyePosition.x;
        }
        
        if(f.hasMouthPosition) {
            
            //            NSLog(@"mouth position x = %f , y = %f", f.mouthPosition.x, f.mouthPosition.y);
            if (topX > f.mouthPosition.x) {
                topX = f.mouthPosition.x;
            }
            if (topY > f.mouthPosition.y) {
                topY = f.mouthPosition.y;
                topRange = abs(maxEyePos - f.mouthPosition.y);
            }
            if (bottomX < f.mouthPosition.x) {
                bottomX = f.mouthPosition.x;
            }
            if (bottomY < f.mouthPosition.y) {
                bottomY = f.mouthPosition.y;
                bottomRange = abs(maxEyePos - f.mouthPosition.y);
            }
        }
        
        // check eye range
        float tmpEyeRange = abs(rightEyePos - leftEyePos);
        if (eyeRange < tmpEyeRange) {
            eyeRange = abs(rightEyePos - leftEyePos);
        }
        faceCount++;
    }
    
    // step 3
    /*
     *  mirror coordinates
     */
    float centerY = self.size.height / 2;
    
    bottomY = bottomY - 2 *(bottomY - centerY);
    topY = topY - 2 *(topY - centerY);
    
    float width = abs(bottomX - topX);
    float height = abs(bottomY - topY);
    
    // final frame
    frame = CGRectMake(topX, bottomY, width, height);
    NSLog(@"first Frame %@",NSStringFromCGRect(frame));
    
    
    // step 4
    /*
     *  estimate expansion frame
     */
    
    // now we calculate the width and height expansion
    float expWidth = self.size.width - width;
    float expHeight = self.size.height - height;
    
    DLog(@"Expansion count = w= %.0f h= %.0f",expWidth, expHeight);
    DLog(@"Coordinate Range: Top: %.0f bottom %.0f",topRange,bottomRange);
    DLog(@"Eye rannge %.0f",eyeRange);
    
    if (expWidth <= expHeight) {
        DLog(@"Follow width");
        // expand width
        
        topX -= expWidth/2;
        width += expWidth;
        
        // height
        float topRangeHeight = topRangeRatio * topRange;
        float bottomRangeHeight = bottomRangeRatio * bottomRange;
        float extHeight = abs(expWidth - topRangeHeight - bottomRangeHeight);
        
        bottomY = bottomY - topRangeHeight - extHeight / 2;
        height = width;
    }
    else {
        DLog(@"Follow height");
        // expand height
        height += expHeight;
        topX -= abs(height - width) / 2;
        
        
        // height
        float topRangeHeight = topRangeRatio * topRange;
        float bottomRangeHeight = bottomRangeRatio * bottomRange;
        float extHeight = abs(expHeight - topRangeHeight - bottomRangeHeight);
        
        bottomY = bottomY - topRangeHeight - extHeight / 2;
        width = height;
    }
    
    // step 5
    /*
     *  correct frame and make sure it is within the original image
     */
    
    // shift right
    if (topX < 0) {
        topX = 0;
    }
    
    // shift left
    if (topX + width > self.size.width) {
        topX = self.size.width - width;
    }
    
    // shift down
    
    if (bottomY < 0) {
        bottomY =0;
    }
    
    // shift up
    
    if (bottomY + height > self.size.height) {
        bottomY = self.size.height - height;
    }
    
    // convert all to int to make sure there is no gap
    frame = CGRectMake((int)topX, (int)bottomY, (int)width, (int)height);
    
    NSLog(@"correct Frame %@",NSStringFromCGRect(frame));
    
    
    // step 6
    /*
     *  crop and save image
     */
    
    if (faceCount == 0) {
        return self;
    }
    else
        return [self croppedImage:frame];
    
}

@end
