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
 Base class for AdobePublish delegation.
 */
@protocol AdobePublishDelegate <NSObject>
@optional

/**
 Called when an explicit action is taken which cannot finish due to network connectivity.
 Allows delegates to override the default behavior of cancelling the action and calling the failure delegate method.
 
 @return delegates should return NO if they wish to prevent the flow from being cancelled and an error returned, default is YES
 */
- (BOOL)shouldShowNetworkConnectionErrorAndCancel;

@end

NS_ASSUME_NONNULL_END
