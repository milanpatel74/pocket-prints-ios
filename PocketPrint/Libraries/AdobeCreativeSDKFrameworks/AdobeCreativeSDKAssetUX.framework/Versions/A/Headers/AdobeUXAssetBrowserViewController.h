/*************************************************************************
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2016 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by all applicable intellectual property
 * laws, including trade secret and copyright laws.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/

#ifndef AdobeUXAssetBrowserViewControllerHeader
#define AdobeUXAssetBrowserViewControllerHeader

#import <UIKit/UIKit.h>

@class AdobeUXAssetBrowserConfiguration;

@protocol AdobeUXAssetBrowserViewControllerDelegate <NSObject>

@optional

/**
 * Called when the user successfully chooses to "open" one or more assets.
 *
 * @param itemSelections An NSArray of AdobeAsset object(s) which the user selected.
 *
 * @note The caller is responsible for dismissing the AdobeUXAssetBrowserViewController instance 
 *       when this delegate method is called.
 */
- (void)assetBrowserDidSelectAssets:(nonnull AdobeSelectionAssetArray *)itemSelections;

/**
 * Called when an error is encountered somewhere in the process of selecting assets.
 *
 * @param error An NSError that indicates the cause of the error.
 *
 * @note The caller is responsible for dismissing the AdobeUXAssetBrowserViewController instance 
 *       when this delegate method is called.
 */
- (void)assetBrowserDidEncounterError:(nonnull NSError *)error;

/**
 * Called when the user chooses to close the browser without selecting an asset.
 *
 * @note When this method is called the AdobeUXAssetBrowserViewController instance will 
 * automatically be dismissed.
 */
- (void)assetBrowserDidClose;

@end

@interface AdobeUXAssetBrowserViewController : UIViewController

/**
 *  The configuration object with which this instance was initialized.
 */
@property (strong, nonatomic, nullable, readonly) AdobeUXAssetBrowserConfiguration *configuration;

/**
 *  Allocates, initializes and returns an instance of @c AdobeUXAssetBrowserViewController.
 *
 *  @param configuration The configuration object to use with the returned instance of 
 *                       AdobeUXAssetBrowserViewController.
 *  @param delegate      A class that conforms to AdobeUXAssetBrowserViewControllerDelegate 
 *                       protocol.
 *
 *  @return A newly allocated instance of @c AdobeUXAssetBrowserViewController.
 *  @note Upon obtaining an instance of @c AdobeUXAssetBrowserViewController, it must be presented via @c -presentViewController:animated:
 */
+ (nonnull instancetype)assetBrowserViewControllerWithConfiguration:(nullable AdobeUXAssetBrowserConfiguration *)configuration
                                                           delegate:(nullable id<AdobeUXAssetBrowserViewControllerDelegate>)delegate;

@end

#endif
