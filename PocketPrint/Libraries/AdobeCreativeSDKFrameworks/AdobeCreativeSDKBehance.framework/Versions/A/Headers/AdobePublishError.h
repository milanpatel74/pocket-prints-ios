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

#import <CFNetwork/CFNetwork.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Error domain defined for AdobePublish.
 */
extern NSString * AdobePublishErrorDomain;

/**
 AdobePublishErrorCode is an enumerated type that specifies the type of error that
 may occur while interacting with Behance.
 */
typedef NS_ENUM(NSInteger, AdobePublishErrorCode) {
    
    /** offline */
    AdobePublishErrorCodeOffline = kCFURLErrorNotConnectedToInternet,
    
    /** The action was cancelled */
    AdobePublishErrorCodeCancelled = 1,
    
    /** DEPRECATED: The Behance account linking window could not be displayed because it is already shown. */
    AdobePublishErrorCodeLinkingWindowAlreadyShownError = 2,
    
    /** The supplied Work in Progress does not meet the minimum requirements */
    AdobePublishErrorCodeWIPImageFailedValidation __deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future.") = 3,
    
    /** The supplied Project cannot be loaded because it may have been unpublished */
    AdobePublishErrorCodeProjectUnpublished = 4,
    
    /** The request failed because the request was not well formed */
    AdobePublishErrorCodeBadRequest = 400,
    
    /** The request failed because user authorization was required and not provided */
    AdobePublishErrorCodeUnauthorized = 401,
    
    /** The request was refused by the server */
    AdobePublishErrorCodeForbidden = 403,
    
    /** The specified asset or resource requested was not found */
    AdobePublishErrorCodeNotFound = 404,
    
    /** The request failed because the specified account was not verified */
    AdobePublishErrorCodeUserNotVerified = 417,
    
    /** The request encountered a server error */
    AdobePublishErrorCodeServerError = 500,
    
    /** The request encountered a bad gateway */
    AdobePublishErrorCodeBadGateway = 502,
    
    /** The publish service is currently unavailable */
    AdobePublishErrorCodeServiceUnavailable = 503,
    
    /** The publish service experienced an unknown error */
    AdobePublishErrorCodeUnknownError = 999,
};

NS_ASSUME_NONNULL_END
