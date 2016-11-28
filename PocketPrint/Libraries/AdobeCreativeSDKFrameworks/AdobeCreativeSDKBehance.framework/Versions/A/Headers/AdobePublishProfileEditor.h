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

#import "AdobePublishProfileSpecs.h"
#import "AdobePublishProfileDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublish` is the base class for publishing projects and works in progress to the Behance network,
 as well as editing Behance profiles.
 
 Content can be published in one of two formats:
 Work in Progress: a single image, commonly used to represent an unfinished work
 Project: a composed piece, including one or more images/video embeds, and a cover image
 
 Project images can be added from a user’s Photo Library as well as from their Creative Cloud assets.
 
 Users can edit their profiles.
 
 Users can share their work to Facebook/Twitter upon publishing.
 */
@interface AdobePublish ()

#pragma mark - Profile Editor

/**
 Edit the current logged-in user's Behance profile. Presents in a modal view controller.
 
 @warning must first authenticate with the `AdobeUXAuthManager`
 
 @param specs `AdobePublishProfileSpecs` definition of the user who's profile should be edited, along with any default values
 @param viewController a presenting viewController for the profile editor to be presented with
 @param delegate receives `id<AdobePublishProfileDelegate>` callbacks for profile editing events, such as completion, failure, and upload progress
 */
- (void)showProfileEditorWithSpecs:(AdobePublishProfileSpecs *)specs presentingViewController:(UIViewController *)viewController delegate:(nullable id<AdobePublishProfileDelegate>)delegate;

/**
 Presents the last profile editor controller again (ex. to display again in the case of an error)
 
 @param viewController a presenting viewController for the profile editor to be presented with
 @param delegate receive `id<AdobePublishProfileDelegate>` callbacks for project profile editing events, such as completion, failure, and upload progress
 */
- (void)showLastProfileEditorWithPresentingViewController:(UIViewController *)viewController delegate:(nullable id<AdobePublishProfileDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
