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

#ifndef AdobeUXAssetBrowserHeader
#define AdobeUXAssetBrowserHeader

#import <Foundation/Foundation.h>

#import <AdobeCreativeSDKAssetUX/AdobeUXAssetBrowserConfiguration.h>

/**
 * AdobeUXAssetBrowser is the class by which the Adobe Creative Cloud asset browsing component is invoked.
 *
 * Adobe UXAssetBrowser allows clients to browse for and select assets and have them supplied back as AdobeAsset instances.
 *
 * The following properties/methods have been deprecated:
 * <ul>
 * <li><code>-popupFileBrowserWithParent:withOptions:withFilter:withFilterType:onSuccess:onError:</code></li>
 * <li><code>–popupFileBrowserWithParent:options:mimeTypeFilter:dataSourceFilter:onSuccess:onError:</code>
 * </ul>
 *
 * The following method should be used instead of the two deprecated methods above:
 *
 * <pre><code>
 * - (void)popupFileBrowserWithParent:(UIViewController *)parent
 *         configuration:(AdobeUXAssetBrowserConfiguration *)configuration
 *           onSuccess:(void (^)(AdobeSelectionAssetArray *itemSelections))successBlock
 *             onError:(void (^)(NSError *error))errorBlock;
 * </code></pre>
 */
__deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.") @interface AdobeUXAssetBrowser : NSObject

/**
 * Get the Adobe Storage File Browser singleton.
 *
 * @returns the singleton object.
 */
+ (AdobeUXAssetBrowser *)sharedBrowser __deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.");

/**
 * Pops up a Creative Cloud file browsing component for selecting all Adobe Creative Cloud files.
 *
 * @param successBlock the code block called on successful selection of a set of item selections or when cancelling the selection.
 *      When cancelling the selection the block receives a nil argument.
 * @param errorBlock the code block called on error completion
 * @note we will attempt to popup the File Browser on the top most view controller
 */
- (void)popupFileBrowser:(void (^)(AdobeSelectionAssetArray *itemSelections))successBlock
                 onError:(void (^)(NSError *error))errorBlock __deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.");

/**
 * Pops up a Creative Cloud file browsing component for selecting Image files.
 *
 * @param parent the parent view controller for the file browser user interface component
 * @param exclusionList an array of NSStrings representing the mime types that should NOT be browsed for
 * @param successBlock the code block called on successful selection of a set of item selections or when cancelling the selection.
 *      When cancelling the selection the block receives a nil argument.
 * @param errorBlock the code block called on error completion
 */
- (void)popupFileBrowserWithParent:(UIViewController *)parent
                 withExclusionList:(NSArray *)exclusionList
                         onSuccess:(void (^)(AdobeSelectionAssetArray *itemSelections))successBlock
                           onError:(void (^)(NSError *error))errorBlock __deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.");

/**
 * Pops up a Creative Cloud file browsing component for selecting filtered Adobe Creative Cloud files.
 *
 * @param parent the parent view controller for the file browser user interface component
 * @param options a bitmask field of startup option flags
 * @param filter an array of AdobeStorageConstant mime types that should be used for filtering.
 *      Specify nil for all types.
 * @param filterType the AdobeUXAssetBrowserFilterType which specifies how the filtering will behave.
 * @param successBlock the code block called on successful selection of a set of item selections or when cancelling the selection.
 *      When cancelling the selection the block receives a nil argument.
 * @param errorBlock the code block called on error completion
 */
- (void)popupFileBrowserWithParent:(UIViewController *)parent
                       withOptions:(AdobeUXAssetBrowserOptions)options
                        withFilter:(NSArray *)filter
                    withFilterType:(AdobeUXAssetBrowserFilterType)filterType
                         onSuccess:(void (^)(AdobeSelectionAssetArray *itemSelections))successBlock
                           onError:(void (^)(NSError *error))errorBlock __deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.");

/**
 * Displays a Creative Cloud asset browser component for selecting Adobe Creative Cloud assets.
 *
 * @param parent           Parent view controller to use as the launching point. The Creative Cloud
 *                         asset browser will be displayed modally on top of @c parent by calling
 *                         the @c presentViewController:animated: method of UIViewController.
 * @param options          A bitmask of startup options as defined in @c AdobeUXAssetBrowserOption.
 * @param mimeTypeFilter   An instance of @c AdobeAssetMIMETypeFilter class that defines an
 *                         inclusion/exclusion type and MIME types that should be included/excluded.
 * @param dataSourceFilter An instance of @c AdobeDataSourceFilterType class that defines an
 *                         inclusion/exclusion type and data sources that should be
 *                         included/excluded.
 * @param successBlock     Called on successful selection of a set of assets or when cancelling the
 *                         selection process and effectively closing the asset browser.
 * @param errorBlock       Called on an error that occur.
 */
- (void)popupFileBrowserWithParent:(UIViewController *)parent
                           options:(AdobeUXAssetBrowserOptions)options
                    mimeTypeFilter:(AdobeAssetMIMETypeFilter *)mimeTypeFilter
                  dataSourceFilter:(AdobeAssetDataSourceFilter *)dataSourceFilter
                         onSuccess:(void (^)(AdobeSelectionAssetArray *itemSelections))successBlock
                           onError:(void (^)(NSError *error))errorBlock __deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.");

/**
 * Displays a Creative Cloud asset browser component for selecting Adobe Creative Cloud assets.
 *
 * @param parent           Parent view controller to use as the launching point. The Creative Cloud
 *                         asset browser will be displayed modally on top of @c parent by calling
 *                         the @c presentViewController:animated: method of UIViewController.
 * @param configuration    The configuration settings for the asset broswer as defined in @c
 *                         AdobeUXAssetBrowserConfiguration.
 * @param successBlock     Called on successful selection of a set of assets or when cancelling the
 *                         selection process and effectively closing the asset browser.
 * @param errorBlock       Called on an error that occur.
 */
- (void)popupFileBrowserWithParent:(UIViewController *)parent
                     configuration:(AdobeUXAssetBrowserConfiguration *)configuration
                         onSuccess:(void (^)(AdobeSelectionAssetArray *itemSelections))successBlock
                           onError:(void (^)(NSError *error))errorBlock __deprecated_msg("AdobeUXAssetBrowserViewController should be used instead.");

@end

#endif
