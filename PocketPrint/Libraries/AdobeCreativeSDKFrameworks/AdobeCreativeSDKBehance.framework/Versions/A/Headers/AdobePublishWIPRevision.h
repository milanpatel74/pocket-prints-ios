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

#import "AdobePublishBaseModel.h"
#import "AdobePublishComment.h"
#import "AdobePublishImageRef.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishWIPRevision` represents a single revision for a work in progress on Behance.
 */
__deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future.")
@interface AdobePublishWIPRevision : AdobePublishBaseModel

/**
 The id of the revision.
 */
@property (nonatomic, strong) NSNumber * revisionId;

/**
 The user-supplied description for the revision.
 */
@property (nonatomic, strong) NSString * revisionDescription;

/**
 The user-supplied tags for the revision.
 */
@property (nonatomic, strong) NSArray<NSString *> * tags;

/**
 The date the revision was created.
 */
@property (nonatomic, strong) NSDate * createdOn;

/**
 An array of comments that have been made on this revision.
 */
@property (nonatomic, strong) NSArray<AdobePublishComment *> * comments;

/**
 The short version of the web url for this revision.
 */
@property (nonatomic, strong) NSURL * shortUrl;

/**
 The long version of the web url for this revision.
 @see shortUrl
 */
@property (nonatomic, strong) NSURL * url;

/**
 A reference to the image that is associated with this revision.
 */
@property (nonatomic, readonly) AdobePublishImageRef * image;

/**
 A reference to a thumbnail of the image that is associated with this revision.
 */
@property (nonatomic, readonly) AdobePublishImageRef * thumbnail;

/**
 Indicates if this revision is new on the network.
 */
@property (nonatomic, readonly) BOOL isNew;

/**
 Fetch an image for this revision, constrained to the image size supplied
 
 @param minSize minimum size for the image to be returned
 @return a `AdobePublishImageRef` reference to an image with the supplied constraints
 */
- (AdobePublishImageRef *)imageConstrainedToSize:(CGSize)minSize;

/**
 Fetch a thumbnail for this revision, constrained to the image size supplied
 
 @param minSize minimum size for the thumbnail to be returned
 @return a `AdobePublishImageRef` reference to a thumbnail with the supplied constraints
 */
- (AdobePublishImageRef *)thumbnailConstrainedToSize:(CGSize)minSize;

/**
 Fetch an image url path for this revision, constrained to the image size supplied
 
 @param minSize minimum size for the image to be returned
 @return an image url path for an image with the supplied constraints
 */
- (NSString *)imagePathConstrainedToSize:(CGSize)minSize;

/**
 Fetch an thumbnail url path for this revision, constrained to the image size supplied
 
 @param minSize minimum size for the thumbnail to be returned
 @return an image url path for an thumbnail with the supplied constraints
 */
- (NSString *)thumbnailPathConstrainedToSize:(CGSize)minSize;

@end

NS_ASSUME_NONNULL_END
