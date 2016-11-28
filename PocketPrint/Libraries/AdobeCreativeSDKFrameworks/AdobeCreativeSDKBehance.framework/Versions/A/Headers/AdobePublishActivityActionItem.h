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

#import "AdobePublishActivity.h"
#import "AdobePublishBaseModel.h"
#import "AdobePublishContentObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishActivityActionItem` represents an item to be displayed in a user's activity feed.
 */
@interface AdobePublishActivityActionItem : AdobePublishBaseModel

/**
 ID of the activity item
 */
@property (nonatomic, copy) NSString * activityId;

/**
 `AdobePublishContentObject` associated with the activity item
 */
@property (nonatomic, strong) AdobePublishContentObject * contentObject;

/**
 `AdobePublishActivityActionType` type of the activity item
 */
@property (nonatomic) AdobePublishActivityActionType type;

@end

NS_ASSUME_NONNULL_END
