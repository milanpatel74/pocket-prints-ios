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
#import "AdobePublishContentObject.h"

NS_ASSUME_NONNULL_BEGIN

@class AdobePublishActivityAction;

/**
 `AdobePublishActivityItem` represents a single activity item in an activity feed
 */
@interface AdobePublishActivityItem : AdobePublishBaseModel <NSCopying>

/*
 id of the activity item
 */
@property (nonatomic, copy) NSString * itemId;

/*
 Array of `AdobePublishActivityAction` actions associated with the activity item
 */
@property (nonatomic, copy) NSArray<AdobePublishActivityAction *> * actions;

/*
 Content object associated with the activity item, if any
 */
@property (nonatomic, strong) AdobePublishContentObject * contentObject;

/*
 id of the work in progress revision associated with the activity item, if any
 */
@property (nonatomic, copy) NSNumber * revisionId;

@end

NS_ASSUME_NONNULL_END
