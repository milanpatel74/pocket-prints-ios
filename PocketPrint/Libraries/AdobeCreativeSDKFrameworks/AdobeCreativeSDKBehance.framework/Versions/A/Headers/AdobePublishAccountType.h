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
 Account types that can be used for sharing published projects to other networks.
 */
typedef NS_OPTIONS(NSInteger, AdobePublishAccountType)  {
    /** All known account types */
    AdobePublishAccountTypeAll              = 1 << 0,
    
    /** Facebook account type */
    AdobePublishAccountTypeFacebook         = 1 << 1,
    
    /** Twitter account type */
    AdobePublishAccountTypeTwitter          = 1 << 2,
};

NS_ASSUME_NONNULL_END
