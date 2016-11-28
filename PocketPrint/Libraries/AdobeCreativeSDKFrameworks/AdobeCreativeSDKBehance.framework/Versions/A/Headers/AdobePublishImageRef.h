/******************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 * Copyright 2013 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property of
 * Adobe Systems Incorporated and its suppliers, if any. The intellectual and
 * technical concepts contained herein are proprietary to Adobe Systems
 * Incorporated and its suppliers and are protected by trade secret or
 * copyright law. Dissemination of this information or reproduction of this
 * material is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 * THIS FILE IS PART OF THE CREATIVE SDK PUBLIC API
 *
 ******************************************************************************/

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishImageRef` represents image url references, where a specific size and aspect ratio are provided.
 */
@interface AdobePublishImageRef : NSObject <NSCoding, NSCopying>

/**
 name of the image reference as provided by the Behance.net API
 */
@property (nonatomic, copy) NSString * name;

/**
 URL path to the image
 */
@property (nonatomic, copy) NSString * path;

/**
 Size of the image referenced
 */
@property (nonatomic) CGSize size;

/**
 Get the aspect ratio of the original image referenced
 
 @return the original aspect ratio of the referenced image, according to its size property
 */
- (CGFloat)aspectRatio;

/**
 Compare two image references
 
 @param otherRef a second `AdobePublishImageRef` to compare to this reference
 @return the `NSComparisonResult` for the two image references
 */
- (NSComparisonResult)compare:(AdobePublishImageRef *)otherRef;

@end

NS_ASSUME_NONNULL_END
