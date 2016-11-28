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
 ******************************************************************************/

#import "AdobePublishBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishWorkExperience` represents a position that a user has held within an organization for some period of time in their career.
 */
@interface AdobePublishWorkExperience : AdobePublishBaseModel

/**
 User-supplied name of the position held.
 */
@property (nonatomic, strong) NSString * position;

/**
 User-supplied name of the organization.
 */
@property (nonatomic, strong) NSString * organization;

/**
 User-supplied location of the position held.
 */
@property (nonatomic, strong) NSString * location;

/**
 User-supplied start date for the position.
 */
@property (nonatomic, strong) NSDate * startDate;

/**
 User-supplied end date for the position.
 */
@property (nonatomic, strong) NSDate * endDate;

/**
 @return a human-readable string for the duration the position was held, as determined from `startDate` and `endDate`. If `endDate` is nil, this property will return the localized string: "PRESENT"
 */
- (NSString *)duration;

@end

NS_ASSUME_NONNULL_END
