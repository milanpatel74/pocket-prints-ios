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

#ifndef AdobeAppLibraryCategoriesHeader
#define AdobeAppLibraryCategoriesHeader

/**
 *
 * This is the list of all AdobeAppLibraryCategories constants that can be used to setup the inclusionList and filter arrays for the
 * following AdobeUXAppLibrary methods:
 *
 * <ul>
 * <li><code>-popupAppLibraryWithParent:withInclusionList:withOrder:onSuccess:onError:</code></li>
 * <li><code>–popupAppLibraryWithParent:withFilter:filterType:withOrder:onSuccess:onError:</code>
 * </ul>
 *
 */

extern NSString *const kALCategoryDrawing __deprecated_msg("The category filter API is deprecated.");
extern NSString *const kALCategoryImageEditing __deprecated_msg("The category filter API is deprecated.");
extern NSString *const kALCategoryPhotography __deprecated_msg("The category filter API is deprecated.");
extern NSString *const kALCategoryPhotoVideo __deprecated_msg("The category filter API is deprecated.");
extern NSString *const kALCategoryStorytelling __deprecated_msg("The category filter API is deprecated.");
extern NSString *const kALCategoryUIUXDesign __deprecated_msg("The category filter API is deprecated.");
extern NSString *const kALCategoryUtility __deprecated_msg("The category filter API is deprecated.");

/**
 * Represents the Audio Category in the Adobe App Library.
 */
extern NSString *const kALCategoryAudio;

/**
 * Represents the Capture Category in the Adobe App Library.
 */
extern NSString *const kALCategoryCapture;

/**
 * Represents the Community Category in the Adobe App Library.
 */
extern NSString *const kALCategoryCommunity;

/**
 * Represents the Design Category in the Adobe App Library.
 */
extern NSString *const kALCategoryDesign;

/**
 * Represents the Illustration Category in the Adobe App Library.
 */
extern NSString *const kALCategoryIllustration;

/**
 * Represents the Photos Category in the Adobe App Library.
 */
extern NSString *const kALCategoryPhotos;

/**
 * Represents the Presentation Category in the Adobe App Library.
 */
extern NSString *const kALCategoryPresentation;

/**
 * Represents the Productivity Category in the Adobe App Library.
 */
extern NSString *const kALCategoryProductivity;

/**
 * Represents the Social Category in the Adobe App Library.
 */
extern NSString *const kALCategorySocial;

/**
 * Represents the Storage Category in the Adobe App Library.
 */
extern NSString *const kALCategoryStorage;

/**
 * Represents the Video Category in the Adobe App Library.
 */
extern NSString *const kALCategoryVideo;

#endif
