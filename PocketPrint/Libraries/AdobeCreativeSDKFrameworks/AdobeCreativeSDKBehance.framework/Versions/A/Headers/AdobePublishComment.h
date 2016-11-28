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
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishComment` represents a user comment on Behance.net.
 */
@interface AdobePublishComment : AdobePublishBaseModel

/**
 The comment id for the comment
 */
@property (nonatomic, strong) NSNumber * commentId;

/**
 The comment body for the comment
 */
@property (nonatomic, strong) NSString * body;

/**
 The creation timestamp for the comment
 */
@property (nonatomic, strong) NSDate * timestamp;

/**
 The user that created the comment
 */
@property (nonatomic, strong) AdobePublishUser * user;

@end

NS_ASSUME_NONNULL_END
