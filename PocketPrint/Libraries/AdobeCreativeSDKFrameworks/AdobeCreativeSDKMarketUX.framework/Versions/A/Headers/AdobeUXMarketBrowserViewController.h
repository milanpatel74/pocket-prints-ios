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

#ifndef AdobeUXMarketBrowserViewControllerHeader
#define AdobeUXMarketBrowserViewControllerHeader

#import <UIKit/UIKit.h>

@class AdobeMarketAsset;

@protocol AdobeUXMarketBrowserViewControllerDelegate <NSObject>

@optional

/**
 * Called when the user successfully chooses to "open" a Market asset.
 *
 * @param itemSelection An AdobeMarketAsset instance that represent the selected Market asset.
 *
 * @note The caller is responsible for dismissing the AdobeUXMarketBrowserViewController instance
 *       when this delegate method is called.
 */
- (void)marketBrowserDidSelectAsset:(nonnull AdobeMarketAsset *)itemSelection;

/**
 * Called when an error is encountered somewhere in the process of selecting a Market asset.
 *
 * @param error An NSError that indicates the cause of the error.
 *
 * @note The caller is responsible for dismissing the AdobeUXMarketBrowserViewController instance
 *       when this delegate method is called.
 */
- (void)marketBrowserDidEncounterError:(nonnull NSError *)error;

/**
 * Called when the user chooses to close the browser without selecting a Market asset..
 *
 * @note When this method is called the AdobeUXMarketBrowserViewController instance will
 * automatically be dismissed.
 */
- (void)marketBrowserDidClose;

@end


@class AdobeUXMarketBrowserConfiguration;

@interface AdobeUXMarketBrowserViewController : UIViewController

/**
 * The configuration object with which this instance was initialized.
 */
@property (strong, nonatomic, nullable, readonly) AdobeUXMarketBrowserConfiguration *configuration;

/**
 * The object that acts as the delegate of the Market Browser.
 */
@property (weak, nonatomic, nullable) id <AdobeUXMarketBrowserViewControllerDelegate> delegate;

/**
 * Allocates, initializes and returns an instance of @c AdobeUXMarketBrowserViewController.
 *
 * @param configuration The configuration object to use with the returned instance of
 *                      AdobeUXMarketBrowserViewController.
 * @param delegate      A class that conforms to AdobeUXMarketBrowserViewControllerDelegate
 *                      protocol.
 *
 * @return A newly allocated instance of @c AdobeUXMarketBrowserViewController.
 *
 * @note Upon obtaining an instance of @c AdobeUXMarketBrowserViewController, it must be presented
 *       via the @c presentViewController:animated: method.
 */
+ (nonnull instancetype)marketBrowserViewControllerWithConfiguration:(nullable AdobeUXMarketBrowserConfiguration *)configuration
                                                            delegate:(nullable id<AdobeUXMarketBrowserViewControllerDelegate>)delegate;

@end

#endif
