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

#import "AdobePublishActivityItem.h"
#import "AdobePublishBaseModel.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishActivityAction` ties together a `AdobePublishActivityItem`, its user, type, creation date, and associated meta data
 */
@interface AdobePublishActivityAction : AdobePublishBaseModel

/**
 `AdobePublishActivityItem` representing a single element in a user's activity feed
 */
@property (nonatomic, strong) AdobePublishActivityItem * activityItem;

/**
 The `AdobePublishActivityActionType` of this activity item
 */
@property (nonatomic) AdobePublishActivityActionType action;

/**
 The creation date for this activity item
 */
@property (nonatomic) NSTimeInterval createdOn;

/**
 The user or team responsible for the activity item's existence
 */
@property (nonatomic, strong) AdobePublishProfile * profile;

/**
 Metadata for actions with their own data, e.g. a comment (`AdobePublishComment`), collection (`AdobePublishCollection`)
 */
@property (nonatomic, strong) id actionObject;

@end

NS_ASSUME_NONNULL_END
