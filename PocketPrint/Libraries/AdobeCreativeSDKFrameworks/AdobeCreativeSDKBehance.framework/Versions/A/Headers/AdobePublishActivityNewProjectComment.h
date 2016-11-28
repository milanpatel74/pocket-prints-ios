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
#import "AdobePublishComment.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishActivityNewProjectComment` is a subclass of `AdobePublishActivityActionItem` and represents activity for a new comment on a user's project
 */
@interface AdobePublishActivityNewProjectComment : AdobePublishActivityActionItem

/**
 The user that commented on a project
 */
@property (nonatomic, strong) AdobePublishUser * commenter;

/**
 The comment that the user made on a project
 */
@property (nonatomic, strong) AdobePublishComment * comment;

/**
 An array of `AdobePublishUser` users who have appreciated the project and are followed by the current user
 */
@property (nonatomic, strong) NSArray<AdobePublishUser *> * appreciators;

@end

NS_ASSUME_NONNULL_END
