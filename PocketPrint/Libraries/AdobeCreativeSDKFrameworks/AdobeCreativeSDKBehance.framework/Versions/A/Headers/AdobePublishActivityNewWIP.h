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

#import "AdobePublishActivityActionItem.h"
#import "AdobePublishUser.h"
#import "AdobePublishWorkInProgress.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishActivityNewWIP` is a subclass of `AdobePublishActivityActionItem`. It represents the Activity type for a new Work in Progress or revision of an existing Work in Progress.
 */
__deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future.")
@interface AdobePublishActivityNewWIP : AdobePublishActivityActionItem

/**
 The user object for the owner of the Work in Progress.
 */
@property (nonatomic, strong) AdobePublishUser * owner;

/**
 The revision id of the new work in progress revision
 */
@property (nonatomic, strong) NSNumber * revisionId;

/**
 The work in progress object associated with this work in progress or work in progress revision.
 */
@property (nonatomic, readonly) AdobePublishWorkInProgress * wip;

@end

NS_ASSUME_NONNULL_END
