/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2014 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

#ifndef AdobeUXMarketAssetBrowserHeader
#define AdobeUXMarketAssetBrowserHeader

#import <Foundation/Foundation.h>

#import <AdobeCreativeSDKMarketUX/AdobeUXMarketAssetBrowserConfiguration.h>

@class AdobeMarketAsset;

/**
 * AdobeUXMarketAssetBrowser is the user experience component that provides access to the Creative 
 * Cloud Market.
 */
__deprecated_msg("Use AdobeUXMarketBrowserViewController instead.") @interface AdobeUXMarketAssetBrowser : NSObject

/**
 * Get the Creative Cloud Market Asset Browser singleton object.
 *
 * @returns the singleton object.
 */
+ (AdobeUXMarketAssetBrowser *)sharedBrowser __deprecated_msg("Use AdobeUXMarketBrowserViewController to present the Market Browser.");

/**
 * Displays a Creative Cloud Market Asset Browser component for selecting assets from the Creative
 * Cloud Market.
 *
 * @note The top-most view controller will be used to display the Market Browser modally. To 
 * specify a specific parent controller use 
 * popupMarketAssetBrowserWithParent:category:withCategoryFilter:withCategoryFilterType:onSuccess:onError:
 * or popupMarketAssetBrowserWithParent:configuration:successBlock:errorBlock: and specify the 
 * @c parent argument.
 *
 * @param category     The initial category of assets to display. Specify @c nil to omit.
 * @param successBlock Block to execute on successful selection of a Market Asset or when
 *                     canceling the selection process. When canceling, the selection object that 
 *                     is passed in will be @c nil.
 * @param errorBlock   Block to execute to be notified of any errors. Specify @c NULL to omit.
 */
- (void)popupMarketAssetBrowserWithCategory:(NSString *)category
                                  onSuccess:(void (^)(AdobeMarketAsset *itemSelection))successBlock
                                    onError:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXMarketBrowserViewController to present the Market Browser.");

/**
 * Displays a Creative Cloud Market Asset Browser component for selecting assets from the Creative
 * Cloud Market.
 *
 * @param parent       Parent view controller to use as the launching point.
 * @param category     The initial category of assets to display. Specify @c nil to omit.
 * @param filter       An array of AdobeMarketCategory constants used to filter the market 
 *                     categories. The @c filterType argument specifies whether the specified 
 *                     categories inclusive or exclusive. Specify @c nil to omit this argument.
 * @param filterType   Used to specify the type of the filter, either inclusive or exclusive.
 * @param successBlock Block to execute on successful selection of a Market Asset or when
 *                     canceling the selection. When canceling, the selection object that is 
 *                     passed in will be @c nil.
 * @param errorBlock   Block to execute to be notified of any errors. Specify @c NULL to omit.
 */
- (void)popupMarketAssetBrowserWithParent:(UIViewController *)parent
                                 category:(NSString *)category
                       withCategoryFilter:(NSArray *)filter
                   withCategoryFilterType:(AdobeUXMarketAssetBrowserCategoryFilterType)filterType
                                onSuccess:(void (^)(AdobeMarketAsset *itemSelection))successBlock
                                  onError:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXMarketBrowserViewController to present the Market Browser.");

/**
 * Displays a Creative Cloud Market asset browser component for selecting assets in the market.
 *
 * @param parent        Parent view controller to use as the launching point. .
 * @param configuration The configuration settings for the Asset Browser as defined in @c
 *                      AdobeUXAssetBrowserConfiguration.
 * @param successBlock  Called on successful selection of a set of assets or when canceling the
 *                      selection process and effectively closing the asset browser.
 * @param errorBlock    Called on an error that occur.
 */
- (void)popupMarketAssetBrowserWithParent:(UIViewController *)parent
                            configuration:(AdobeUXMarketAssetBrowserConfiguration *)configuration
                             successBlock:(void (^)(AdobeMarketAsset *itemSelection))successBlock
                               errorBlock:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXMarketBrowserViewController to present the Market Browser.");

@end

#endif
