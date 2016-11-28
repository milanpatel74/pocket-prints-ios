/******************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 * Copyright 2014 Adobe Systems Incorporated
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

#ifndef AdobeAssetMIMETypeFilterHeader
#define AdobeAssetMIMETypeFilterHeader

#import <Foundation/Foundation.h>

/**
 * Whether the specified MIME types are the only ones supported (inclusion) or should be excluded
 * (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeAssetMIMETypeFilterType)
{
    /**
     * The specified MIME types should be the only included types.
     */
    AdobeAssetMIMETypeFilterTypeInclusion = 1,

    /**
     * The specified MIME types should be excluded.
     */
    AdobeAssetMIMETypeFilterTypeExclusion
};

/**
 * Wrapper class to help specify both a form of MIME type to filter by as well whether
 * the filter should be inclusive or exclusive.
 */
@interface AdobeAssetMIMETypeFilter : NSObject <NSCopying>

/**
 * Specifies the type of filter (inclusive or exclusive).
 */
@property (nonatomic, readonly, assign) AdobeAssetMIMETypeFilterType filterType;

/**
 * Shorthand property that returns true for inclusive filters.
 */
@property (nonatomic, readonly, getter = isInclusive) BOOL inclusive;

/**
 * Array of mime types.
 */
@property (nonatomic, readonly, strong) NSArray *MIMETypes;

/**
 * Allows for creating the class with an array of mime types and a setting for inclusive versus exclusive.
 *
 * @param MIMETypes An array of mine types.
 * @param filterType Inclusive or Exclusive.
 */
- (instancetype)initWithMIMETypes:(NSArray *)MIMETypes filterType:(AdobeAssetMIMETypeFilterType)filterType;

@end

#endif
