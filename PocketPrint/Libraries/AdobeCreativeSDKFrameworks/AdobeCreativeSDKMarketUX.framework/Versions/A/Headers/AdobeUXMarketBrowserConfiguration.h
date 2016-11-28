/******************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 * Copyright 2016 Adobe Systems Incorporated
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

#ifndef AdobeUXMarketBrowserConfigurationHeader
#define AdobeUXMarketBrowserConfigurationHeader

#import <Foundation/Foundation.h>

@class AdobeCloud;

/**
 * The Category filter list type. Either the items specified in the filter list are the types you
 * support (inclusion) or the types you don't support (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeUXMarketBrowserCategoryFilterType)
{
    /**
     * The filter list is neither an inclusion nor exclusion list.
     */
    AdobeUXMarketBrowserCategoryFilterTypeUnspecified = 0,
    
    /**
     * The filter list describes an inclusion list.
     */
    AdobeUXMarketBrowserCategoryFilterTypeInclusion,
    
    /**
     * The filter list describes an exclusion list.
     */
    AdobeUXMarketBrowserCategoryFilterTypeExclusion
};

/**
 * Used to configure the behavior and functionality of AdobeUXMarketBrowserViewController.
 */
@interface AdobeUXMarketBrowserConfiguration : NSObject

/**
 * The initial category to show in the browser UI. Use the constant Category values defined in 
 * AdobeMarketCategory.
 */
@property (copy, nonatomic, nullable) NSString *initialCategory;

/**
 * List categories that will be included or excluded depending on the value of 
 * @c categoryFilterType property. Use the constant Category values defined AdobeMarketCategory.
 */
@property (strong, nonatomic, nullable) NSArray *categories;

/**
 * Type of the category filter, whether to only include the specified list or to exclude the 
 * specified categories.
 */
@property (assign, nonatomic) AdobeUXMarketBrowserCategoryFilterType categoryFilterType;

/**
 * The Creative cloud instance to connect to.
 */
@property (strong, nonatomic, nullable) AdobeCloud *cloud;

@end

#endif
