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

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishJSONMapping` protocol defines how base model objects are created 
 from corresponding JSON retrieved through the Behance API.
 */
@protocol AdobePublishJSONMapping <NSObject>
@required
/*
 Create a model object out of a corresponding JSON dictionary.
 
 @param json an `NSDictionary` of JSON as retrieved from the Behance API
 @return the base model object created from the supplied JSON
 */
+ (instancetype)objectFromJson:(NSDictionary *)json;
@end

/**
 `AdobePublishBaseModel` represents the base class for all Behance model objects
 */
@interface AdobePublishBaseModel : NSObject <NSCoding, NSCopying, AdobePublishJSONMapping>
@end

NS_ASSUME_NONNULL_END
