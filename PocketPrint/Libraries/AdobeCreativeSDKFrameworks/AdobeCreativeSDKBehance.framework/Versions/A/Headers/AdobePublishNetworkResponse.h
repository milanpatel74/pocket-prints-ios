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
 `AdobePublishNetworkResponse` encapsulates a network response from the Behance API.
 Two typedefs are defined in this class:

	typedef void(^AdobePublishNetworkResponseCompletion)(AdobePublishNetworkResponse *response);
	typedef void(^AdobePublishNetworkResponseProgress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpected);

 */
@interface AdobePublishNetworkResponse : NSObject

/**
 Flag identifying whether the network request was successful or not.
 */
@property (nonatomic, readonly, getter = isSuccessful) BOOL successful;

/**
 Response object returned from the network request. Typically an `NSDictionary` of JSON data.
 */
@property (nonatomic, strong, readonly, nullable) id responseObject;

/**
 Error returned from the request, if any.
 */
@property (nonatomic, strong, readonly, nullable) NSError * error;

/**
 Response object returned from the network request. Typically a single `AdobePublishBaseModel` subclass object, or an array containing `AdobePublishBaseModel` subclass objects.
 */
@property (nonatomic, strong, readonly, nullable) id result;

/**
 Date that the network response was received.
 */
- (NSDate *)responseDate;

@end

/**
 `AdobePublishNetworkResponseCompletion` represents the completion block for all AdobePublish network operations.
 */
typedef void(^AdobePublishNetworkResponseCompletion)(AdobePublishNetworkResponse *response);

/**
 `AdobePublishNetworkResponseProgress` represents the progress block for AdobePublish upload and download operations.
 */
typedef void(^AdobePublishNetworkResponseProgress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpected);

NS_ASSUME_NONNULL_END
