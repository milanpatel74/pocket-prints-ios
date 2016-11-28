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
#import "AdobePublishServices.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishContentObject` is the base class for the two basic content types on Behance. 
 It includes properties that are common to both projects and works-in-progress.
 */
@interface AdobePublishContentObject : AdobePublishBaseModel <NSCopying, NSCoding>

/**
 title of the content
 */
@property (nonatomic, strong) NSString * title;

/**
 date the content was created
 */
@property (nonatomic, strong) NSDate * createdDate;

/**
 The user-supplied description of the content
 */
@property (nonatomic, strong) NSString * contentDescription;

/**
 URL of the content on the web
 */
@property (nonatomic, strong) NSURL * url;

/**
 Array of `AdobePublishUser` objects that own or co-own the content
 */
@property (nonatomic, strong) NSArray<AdobePublishUser *> * owners;

/**
 privacy level of the content
 */
@property (nonatomic, assign) AdobePublishPrivacyLevel privacyLevel;

/**
 A flag identifying whether the content contains adult content.
 */
@property (nonatomic) BOOL matureContent;

/**
 Identifies content mature access viewing properties for the current user.
 */
@property (nonatomic) AdobePublishMatureAccess matureAccess;

/**
 number of views the work in progress has received
 */
@property (nonatomic, strong) NSNumber * views;

/**
 number of comments the work in progress has received
 */
@property (nonatomic, strong) NSNumber * comments;

@end

NS_ASSUME_NONNULL_END
