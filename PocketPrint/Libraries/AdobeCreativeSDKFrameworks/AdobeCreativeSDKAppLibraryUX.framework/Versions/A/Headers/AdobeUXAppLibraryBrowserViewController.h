/******************************************************************************
 *
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

#ifndef AdobeUXAppLibraryBrowserViewControllerHeader
#define AdobeUXAppLibraryBrowserViewControllerHeader

#import <UIKit/UIKit.h>

@class AdobeUXAppLibraryBrowserConfiguration;

@protocol AdobeUXAppLibraryBrowserViewControllerDelegate <NSObject>

@optional

/**
 *  Called when AdobeUXAppLibraryBrowserViewController encounters an error.
 *
 *  @param error An error describing the failure.
 *  @note: Upon Receiving this message, the caller is responsible for dismissing the @c AdobeUXAppLibraryBrowserViewController.
 */
- (void)appLibraryBrowserDidEncounterError:(nonnull NSError *)error;

/**
 *  Indicates that the user manually closed the browser. 
 *  @note This method is called just after the browser is automatically dismissed.
 */
- (void)appLibraryBrowserDidClose;

@end

@interface AdobeUXAppLibraryBrowserViewController : UINavigationController

/**
 *  The configuration object with which this instance was initialized.
 */
@property (strong, nonatomic, nullable, readonly) AdobeUXAppLibraryBrowserConfiguration *configuration;

/**
 *  Allocates, initializes and returns an instance of AdobeUXAppLibraryBrowserViewController.
 *
 *  @param configuration The configuration object with which this instance should be initialized.
 *  @param delegate      The delegate with which this instance should be initialized.
 *
 *  @return A newly allocated and initialized instance of AdobeUXAppLibraryBrowserViewController.
 */
+ (nonnull instancetype)appLibraryBrowserViewControllerWithConfiguration:(nullable AdobeUXAppLibraryBrowserConfiguration *)configuration
                                                                delegate:(nullable id<AdobeUXAppLibraryBrowserViewControllerDelegate>)delegate;

@end

#endif
