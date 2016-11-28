/******************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 * Copyright 2015 Adobe Systems Incorporated
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

#ifndef AdobeUXMarketAssetBrowserConfigurationHeader
#define AdobeUXMarketAssetBrowserConfigurationHeader

#import <Foundation/Foundation.h>

@class AdobeCloud;

/**
 * The Category filter list type. Either the items specified in the filter list are the types you
 * support (inclusion) or the types you don't support (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeUXMarketAssetBrowserCategoryFilterType)
{
    /** the filter list is neither an inclusion nor exclusion list */
    AdobeUXMarketAssetBrowserCategoryFilterTypeUnspecified __deprecated_enum_msg("Use AdobeUXMarketBrowserCategoryFilterTypeUnspecified instead.") = 0,
    /** the filter list describes an inclusion list */
    AdobeUXMarketAssetBrowserCategoryFilterTypeInclusion __deprecated_enum_msg("Use AdobeUXMarketBrowserCategoryFilterTypeInclusion instead."),
    /** the filter list describes an exclusion list */
    AdobeUXMarketAssetBrowserCategoryFilterTypeExclusion __deprecated_enum_msg("Use AdobeUXMarketBrowserCategoryFilterTypeExclusion instead.")
};

/**
 * This class serves as a container for multiple different sets of AdobeUXAssetBrowser configuration values.
 */
__deprecated_msg("Use the AdobeUXMarketBrowserConfiguration class instead.")
@interface AdobeUXMarketAssetBrowserConfiguration : NSObject

/**
 * The initial category to show in the browser UI.
 */
@property (readwrite, nonatomic, strong) NSString *initialCategory __deprecated_msg("Use the AdobeUXMarketBrowserConfiguration class instead.");

/**
 * The categories to show in the UI.
 */
@property (readwrite, nonatomic, strong) NSArray *categories __deprecated_msg("Use the AdobeUXMarketBrowserConfiguration class instead.");

/**
 * The category filter type.
 */
@property (readwrite, nonatomic, assign) AdobeUXMarketAssetBrowserCategoryFilterType categoryFilterType __deprecated_msg("Use the AdobeUXMarketBrowserConfiguration class instead.");

/**
 * The cloud to connect to.
 */
@property (readwrite, nonatomic, strong) AdobeCloud *cloud __deprecated_msg("Use the AdobeUXMarketBrowserConfiguration class instead.");

@end

#endif
