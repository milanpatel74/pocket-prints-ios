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

#ifndef AdobeUXAppLibraryHeader
#define AdobeUXAppLibraryHeader

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Adobe360WorkflowStatusBarViewController;
@class Adobe360WorkflowActionsViewController;

/**
 * The app library items display order.
 */
typedef NS_ENUM (NSInteger, AdobeUXAppLibraryOrder)
{
    /** the default order returned by the service */
    AdobeUXAppLibraryOrderDefault     = 0,
    /** the random order generated from list */
    AdobeUXAppLibraryOrderRandomize   = 1,
    /** the apps are sorted in ascending order of title */
    AdobeUXAppLibraryOrderAscending   = 2,
    /** the apps are sorted in descending order of title */
    AdobeUXAppLibraryOrderDescending  = 3
};

/**
 * The filter list type. Either the items specified in the filter list are the types you
 * support (Inclusion) or the types you don't support (exclusion).
 */
typedef NS_ENUM (NSInteger, AdobeUXAppLibraryFilterType)
{
    /** the filter list is neither an inclusion nor exclusion list */
    AdobeUXAppLibraryFilterTypeUnspecified = 0,
    /** the filter list describes an inclusion list */
    AdobeUXAppLibraryFilterTypeInclusion,
    /** the filter list describes an exclusion list */
    AdobeUXAppLibraryFilterTypeExclusion
};

/**
 * Core class for adding the Adobe Creative Cloud App Library to your application.
 * This creates a way for folks to browse, and install, other applications that
 * make use of the Creative SDK.
 *
 * The following AdobeAppLibraryCategories constants can be used to setup the inclusionList and filter arrays:
 * <ul>
 * <li><code>kALCategoryAudio</code></li>
 * <li><code>kALCategoryCapture</code></li>
 * <li><code>kALCategoryCommunity</code></li>
 * <li><code>kALCategoryDesign</code></li>
 * <li><code>kALCategoryIllustration</code></li>
 * <li><code>kALCategoryPhotos</code></li>
 * <li><code>kALCategoryPresentation</code></li>
 * <li><code>kALCategoryProductivity</code></li>
 * <li><code>kALCategorySocial</code></li>
 * <li><code>kALCategoryStorage</code></li>
 * <li><code>kALCategoryVideo</code></li>
 * </ul>
 *
 */
__deprecated_msg("Use AdobeUXAppLibraryViewController instead.") @interface AdobeUXAppLibrary : NSObject

/**
 * Get the Adobe UX App Library singleton.
 * @returns The singleton object.
 */
+ (AdobeUXAppLibrary *)sharedLibrary __deprecated_msg("Use AdobeUXAppLibraryViewController instead.");

/**
 * Presents library of creative apps that use the Creative Cloud SDK.
 *
 * @param successBlock The code block called on closing the app library.
 * @param errorBlock The code block called on error completion.
 * @note We will attempt to display the app library on the top most view controller.
 */
- (void)popupAppLibrary:(void (^)())successBlock
                onError:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXAppLibraryViewController instead.");

/**
 * Presents library of creative apps that use the Creative Cloud SDK.
 *
 * @param parent The parent view controller for the App Library user interface component.
 * @param successBlock The code block called on closing the app library.
 * @param errorBlock The code block called on error completion.
 * @note Please provide a parent view controller on which the App Library needs to be presented.
 */
- (void)popupAppLibraryWithParent:(UIViewController *)parent
                        onSuccess:(void (^)(void))successBlock
                          onError:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXAppLibraryViewController instead.");

/**
 * Presents library of creative apps that use the Creative Cloud SDK & allows to specify the app categories &
 * order in which apps should be displayed.
 *
 * @param parent The parent view controller for the App Library user interface component.
 * @param inclusionList An array of AdobeUXMarketAssetBrowserCategoryFilterType that should be included. Specify nil for all categories.
 * @param order The order in which the apps should be shown.
 * @param successBlock The code block called on closing the app library.
 * @param errorBlock The code block called on error completion.
 */
- (void)popupAppLibraryWithParent:(UIViewController *)parent
                withInclusionList:(NSArray *)inclusionList
                        withOrder:(AdobeUXAppLibraryOrder)order
                        onSuccess:(void (^)())successBlock
                          onError:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXAppLibraryViewController instead.");

/**
 * Presents library of creative apps that use the Creative Cloud SDK & allows to specify the inclusion/exclusion
 * app categories & order in which apps should be displayed.
 *
 * @param parent The parent view controller for the App Library user interface component.
 * @param filter An array of AdobeAppLibraryCategories that should be used for filtering. Specify nil for all types.
 * @param filterType The AdobeUXAppLibraryFilterType which specifies how the filtering will behave.
 * @param order The order in which the apps should be shown.
 * @param successBlock The code block called on closing the app library.
 * @param errorBlock The code block called on error completion.
 */
- (void)popupAppLibraryWithParent:(UIViewController *)parent
                       withFilter:(NSArray *)filter
                       filterType:(AdobeUXAppLibraryFilterType)filterType
                        withOrder:(AdobeUXAppLibraryOrder)order
                        onSuccess:(void (^)())successBlock
                          onError:(void (^)(NSError *error))errorBlock __deprecated_msg("Use AdobeUXAppLibraryViewController instead.");

/**
 * Creates an instance of the Adobe360WorkflowAppLibraryController object. This should be presented in 
 * a popover on iPad and modally on iPhone.
 */
+ (Adobe360WorkflowActionsViewController *)createWorkflowActionsViewController __deprecated_msg("Use @c +instantiateWorkflowActionsViewController in Adobe360WorkflowActionsViewController instead.");

/**
 * Creates an instance of the Adobe360WorkflowActionStatusBarViewController object. This should be presented in
 * a popover on iPad and modally on iPhone.
 */
+ (Adobe360WorkflowStatusBarViewController *)createWorkflowStatusBarViewController __deprecated_msg("Use instantiateWorkflowStatusBarViewController in Adobe360WorkflowStatusBarViewController instead.");

@end

#endif
