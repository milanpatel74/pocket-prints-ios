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

#import "AdobePublish.h"
#import "AdobePublishAccountType.h"
#import "AdobePublishProjectDelegate.h"
#import "AdobePublishProjectSpecs.h"
#import "AdobePublishWIPDelegate.h"
#import "AdobePublishWIPSpecs.h"

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

/**
 Facebook app id, for sharing published projects and works in progress to Facebook.
 
 If a Facebook app id is not supplied, sharing to Facebook will be hidden.
 In order to publish to Facebook, your Facebook app must be approved for the "publish_actions" login permission.
 */
@property (nonatomic, strong, nullable) NSString * facebookAppId;


#pragma mark - Project Editor

/**
 Publish a project to Behance.  Presents in a modal view controller.
 
 @warning if specs.resourceOptions includes AdobePublishProjectSpecsResourceOptionCreativeCloud, you must first authenticate with the `AdobeUXAuthManager`
 
 @param viewController a presenting viewController for the project editor to be presented with
 @param specs `AdobePublishProjectSpecs` definition of the project to be published to Behance
 @param delegate receive `id<AdobePublishProjectDelegate>` callbacks for project publishing events, such as completion, failure, and upload progress
 */
- (void)showProjectEditorWithSpecs:(AdobePublishProjectSpecs *)specs presentingViewController:(UIViewController *)viewController delegate:(nullable id<AdobePublishProjectDelegate>)delegate;

/**
 Presents the last project view controller again (ex. to display again in the case of a publishing error)
 
 @param viewController a presenting viewController for the project editor to be presented with
 @param delegate receive `id<AdobePublishProjectDelegate>` callbacks for project publishing events, such as completion, failure, and upload progress
 */
- (void)showLastProjectEditorWithPresentingViewController:(UIViewController *)viewController delegate:(nullable id<AdobePublishProjectDelegate>)delegate;

/**
 Cancel the current proejct editor task, such as publishing or editing a project.
 */
- (void)cancelCurrentProjectEditorTask;


#pragma mark - Work in Progress Editor

/**
 Publish a work in progress to Behance. Presents in a modal view controller.
 
 @param specs `AdobePublishWIPSpecs` definition of the work in progress to be published to Behance
 @param viewController a presenting viewController for the WIP editor to be presented with
 @param delegate receive `id<AdobePublishWIPDelegate>` callbacks for work in progress publishing events, such as completion, failure, and upload progress
 */
- (void)showWorkInProgressEditorWithSpecs:(AdobePublishWIPSpecs *)specs presentingViewController:(UIViewController *)viewController delegate:(nullable id<AdobePublishWIPDelegate>)delegate __deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future. Use showProjectEditorWithSpecs:presentingViewController:delegate: to publish content as a project instead.");

/**
 Presents the last work in progress view controller again (ex. to display again in the case of a publishing error)
 
 @param viewController a presenting viewController for the WIP editor to be presented with
 @param delegate receive `id<AdobePublishWIPDelegate>` callbacks for work in progress publishing events, such as completion, failure, and upload progress
 */
- (void)showLastWorkInProgressEditorWithPresentingViewController:(UIViewController *)viewController delegate:(nullable id<AdobePublishWIPDelegate>)delegate __deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future. Use showLastProjectEditorWithPresentingViewController:delegate: with project publishing instead.");

/**
 Cancel the current work in progress editor task, such as publishing or editing a work in progress.
 */
- (void)cancelCurrentWorkInProgressEditorTask __deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future. Use cancelCurrentProjectEditorTask with project publishing  instead.");


#pragma mark - Accounts

/**
 Remove an account previously stored by the user as their preferred account for an outside network (Facebook, Twitter)
 When a user first chooses to share their work to an outside network, they choose their preferred account on that network from all accounts they are signed into on the device settings.
 If only one account exists, that account is automatically stored as the preferred account.
 
 @param accountType The account type to remove the preferred account for
 */
- (void)removePreferredAccountWithType:(AdobePublishAccountType)accountType;

@end

NS_ASSUME_NONNULL_END
