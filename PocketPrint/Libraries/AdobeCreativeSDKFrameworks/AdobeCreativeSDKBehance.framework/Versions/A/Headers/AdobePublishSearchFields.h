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
#import "AdobePublishSearchField.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishSearchFields` wraps a collection of pre-defined Creative Fields for Behance.net.
 
 Creative Fields are segmented into two `NSArrays`, one for all fields, and one for popular fields.
 */
@interface AdobePublishSearchFields : AdobePublishBaseModel

/**
 Array of `AdobePublishSearchField` creative fields for all Creative Fields on Behance.net
 */
@property (nonatomic, strong) NSArray<AdobePublishSearchField *> * allFields;

/**
 Array of popular `AdobePublishSearchField` creative fields on Behance.net as determined by the network.
 */
@property (nonatomic, strong) NSArray<AdobePublishSearchField *> * popularFields;


#pragma mark - API

/**
 Fetch `AdobePublishSearchFields` from the Behance API.
 
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)creativeFieldsWithCompletion:(AdobePublishNetworkResponseCompletion)completion;

@end

NS_ASSUME_NONNULL_END
