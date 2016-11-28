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

#ifndef AdobeAssetDataSourceFilterHeader
#define AdobeAssetDataSourceFilterHeader

#import <Foundation/Foundation.h>

/**
 * File assets datasource in the Asset Browser. This is the default initial datasource.
 */
extern NSString * const AdobeAssetDataSourceFiles;

/**
 * Library Assets (previously My/Design Libraries) in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourceLibrary;

/**
 * Photos (Lightroom) datasource in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourcePhotos;

/**
 * Illustrator Draw datasource in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourceDraw;

/**
 * Illustrator Line datasource in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourceLine;

/**
 * Photoshop Sketch datasource in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourceSketch;

/**
 * Photoshop Mix datasource in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourceMix;

/**
 * Adobe Comp CC datasource in the Asset Browser.
 */
extern NSString * const AdobeAssetDataSourceCompCC;

/**
 * Adobe Shape CC datasource in the Asset Browser.
 *
 * @note Not implemented yet.
 */
extern NSString * const AdobeAssetDataSourceShapeCC;

/**
 * Adobe Brush CC datasource in the Asset Browser.
 *
 * @note Not yet implemented.
 */
extern NSString * const AdobeAssetDataSourceBrushCC;

/**
 * Represents iOS device Camera Roll objects.
 *
 * @note Not yet implemented.
 */
extern NSString * const AdobeAssetDataSourceCameraRoll;

/**
 * Represents all user brushes in the Creative Cloud.
 *
 * @note This datasource was never implemented.
 *
 * @deprecated Use @c AdobeAssetDataSourceBrushCC instead.
 */
extern NSString * const AdobeAssetDataSourceBrushes __deprecated_msg("Use AdobeAssetDataSourceBrushCC instead.");

/**
 * Represents Compositions in the Creative Cloud.
 *
 * @note This datasource was never implemented.
 *
 * @deprecated Use @c AdobeAssetDataSourceCompCC instead.
 */
extern NSString * const AdobeAssetDataSourceCompositions __deprecated_msg("Use AdobeAssetDataSourceCompCC instead.");

/**
 * Represents Photoshop Sketch assets in the Creative Cloud.
 *
 * @deprecated Use @c AdobeAssetDataSourceSketch instead.
 */
extern NSString * const AdobeAssetDataSourceSketches __deprecated_msg("Use AdobeAssetDataSourceSketch instead.");

/**
 * Represents Shape objects in the Creative Cloud.
 *
 * @note Not yet implemented.
 */
extern NSString * const AdobeAssetDataSourceShapes __deprecated_msg("Use AdobeAssetDataSourceShapeCC instead.");

/**
 * Whether the specified data sources are the only ones supported (inclusion) or should be excluded
 * (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeAssetDataSourceFilterType)
{
    /**
     * The specified data sources should be the only included types.
     */
    AdobeAssetDataSourceFilterInclusive = 1,
    
    /**
     * The specified data sources should be excluded.
     */
    AdobeAssetDataSourceFilterExclusive
};

/**
 * Class that represents filters that will be applied to the datasources available in the Asset Browser. (See AdobeUXAssetBrowser.)
 */
@interface AdobeAssetDataSourceFilter : NSObject <NSCopying>

/**
 * Datasources to consider. An NSArray of AdobeAssetDataSource constants.
 */
@property (nonatomic, readonly, strong) NSArray *dataSources;

/**
 * The type of the filter; inclustionary or exclusionary.
 */
@property (nonatomic, readonly, assign) AdobeAssetDataSourceFilterType filterType;

/**
 * Whether the datasources are inclusionary or exclusionary as specified by the @c filterType
 * attribute when creating an instance of the receiver.
 */
@property (nonatomic, readonly, getter = isInclusive) BOOL inclusive;

/**
 * Returns a collection of all supported data sources in the order that they should be displayed.
 *
 * @return An NSArray containing one or all of the AdobeAssetDataSource types in the order they
 * should be displayed. This is usually an en-US alphabetically sorted list of the datasource names.
 */
+ (NSArray *)allSupportedDataSources;

- (instancetype)initWithDataSources:(NSArray *)dataSource filterType:(AdobeAssetDataSourceFilterType)filterType;

@end

#endif
