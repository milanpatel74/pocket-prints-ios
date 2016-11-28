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
 *
 * THIS FILE IS PART OF THE CREATIVE SDK PUBLIC API
 *
 ******************************************************************************/

#ifndef AdobeUXAssetBrowserConfigurationHeader
#define AdobeUXAssetBrowserConfigurationHeader

#import <Foundation/Foundation.h>

@class AdobeAssetDataSourceFilter;
@class AdobeAssetDesignLibraryItemFilter;
@class AdobeAssetMIMETypeFilter;
@class AdobeCloud;

/**
 * Options that control the various features and functionalities of the Asset Browser.
 */
typedef NS_OPTIONS (NSUInteger, AdobeUXAssetBrowserOption)
{
    /**
     * Enable multiple assets to be selected in the Asset Browser. You'll need to also specify
     * the `ShowMultipleSelectOnPopup` for this option to take effect.
     */
    EnableMultiSelect = 1,
    
    /**
     * Whether to enable the multiple asset selection mode in the Asset Browser. This option only 
     * works in conjunction with the `EnableMultiSelect` option. Specifying this option alone has
     * no effect.
     */
    ShowMultiSelectOnPopup = 1 << 1,
    
    /**
     * By default the assets are sorted by recently updated date. Specify this option so the assets 
     * are sorted alphabetically.
     * NOTE: This option only applies to the Files (`AdobeAssetDataSourceFiles`) datasource.
     */
    SortAlphabeticallyOnPopup = 1 << 3,
    
    /**
     * Enable layer extraction for PSD files.
     * To allow multiple layers and/or layer groups to be selected, specify
     * the `EnableMultiplePSDLayerSelection` option as well.
     */
    EnablePSDLayerExtraction = 1 << 4,
    
    /**
     * Whether to allow multiple PSD layer selection when exploring a PSD file's layers. If
     * `EnablePSDLayerExtraction` isn't specified, this option does nothing.
     */
    EnableMultiplePSDLayerSelection = 1 << 5
};

/**
 * By default the assets are displayed in a grid view. Specify this option to see the assets in
 * a list view.
 * NOTE: This option only applies to the Files (`AdobeAssetDataSourceFiles`) datasource.
 */
extern const NSUInteger ShowListViewOnPopup __deprecated_msg(" List view is no longer supported by AdobeUXAssetBrowser");

/**
 * Bitmask field of startup option flags.
 */
typedef NSUInteger AdobeUXAssetBrowserOptions;

/**
 * The filter list type. Either the items specified in the filter list are the types you
 * support (Inclusion) or the types you don't support (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeUXAssetBrowserFilterType)
{
    /**
     * The filter list is neither an inclusion nor exclusion list.
     */
    AdobeUXAssetBrowserFilterTypeUnspecified = 0,
    
    /**
     * The filter list describes an inclusion list.
     */
    AdobeUXAssetBrowserFilterTypeInclusion,
    
    /**
     * The filter list describes an exclusion list.
     */
    AdobeUXAssetBrowserFilterTypeExclusion
};

#define AdobeUXAssetBrowserFilterWithBasicImages  @[ kAdobeMimeTypeTIFF, kAdobeMimeTypeJPEG, kAdobeMimeTypeGIF, kAdobeMimeTypePNG, kAdobeMimeTypeBMP ]
#define AdobeUXAssetBrowserFilterWithAdobeContent @[ kAdobeMimeTypeIllustrator ]

/**
 * This class serves as a container for multiple different sets of AdobeUXAssetBrowser 
 * configuration values.
 */
@interface AdobeUXAssetBrowserConfiguration : NSObject <NSCopying>

/**
 * Filters the assets by a particular data source.
 */
@property (readwrite, nonatomic, strong) AdobeAssetDataSourceFilter *dataSourceFilter;

/**
 * Filters assets displayed in the user's design libraries.
 */
@property (readwrite, nonatomic, strong) AdobeAssetDesignLibraryItemFilter *designLibraryItemFilter;

/**
 * Specifies a list of MIME types and whether they should be inclusive or exclusive.
 */
@property (readwrite, nonatomic, strong) AdobeAssetMIMETypeFilter *mimeTypeFilter;

/**
 * Options that control the behavior and appearance of the Asset Browser.
 */
@property (readwrite, nonatomic, assign) AdobeUXAssetBrowserOptions options;

/**
 * The cloud object to use.
 */
@property (readwrite, nonatomic, strong) AdobeCloud *cloud;

@end

#endif
