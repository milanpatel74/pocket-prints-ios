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

#ifndef AdobeAssetDesignLibraryItemFilterHeader
#define AdobeAssetDesignLibraryItemFilterHeader

#import <Foundation/Foundation.h>

/**
 * Represents 3D Elements in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItem3DElements;

/**
 * Represents the brush items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemBrushes;

/**
 * Represents the character style items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemCharacterStyles;

/**
 * Represents the color items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemColors;

/**
 * Represents the color theme items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemColorThemes;

/**
 * Represents the raster image items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemImages;

/**
 * Represents the layer style items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemLayerStyles;

/**
 * Represents Look assets in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemLooks;

/**
 * Represents Pattern assets in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemPatterns;

/**
 * Represents the video items in a Creative Cloud library.
 */
extern NSString * const AdobeAssetDesignLibraryItemVideos;

/**
 * Whether the specified data sources are the only ones supported (inclusion) or should be excluded
 * (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeAssetDesignLibraryItemFilterType)
{
    /**
     * Inclusive.
     */
    AdobeAssetDesignLibraryItemFilterInclusive = 1,

    /**
     * Exclusive.
     */
    AdobeAssetDesignLibraryItemFilterExclusive
};

@interface AdobeAssetDesignLibraryItemFilter : NSObject <NSCopying>

@property (nonatomic, readonly, strong) NSArray *designLibraryItems;
@property (nonatomic, readonly, assign) AdobeAssetDesignLibraryItemFilterType filterType;
@property (nonatomic, readonly, getter = isInclusive) BOOL inclusive;

- (instancetype)initWithDesignLibraryItems:(NSArray *)designLibraryItems filterType:(AdobeAssetDesignLibraryItemFilterType)filterType;

@end

#endif
