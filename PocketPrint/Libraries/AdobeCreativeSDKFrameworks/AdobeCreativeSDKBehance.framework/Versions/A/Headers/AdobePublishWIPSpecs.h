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

NS_ASSUME_NONNULL_BEGIN

@class AdobeDCXMutableMetadata;

/**
 Types of content editors that can be shown when creating/editing a work in progress. Each represents a screen in the work in progress publishing flow.
 */
__deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future. Use AdobePublishProjectSpecsEditingOption with project publishing instead.")
typedef NS_OPTIONS(NSInteger, AdobePublishWIPSpecsEditingOption)  {
    /**
     Headless work in progress publishing with no interaction by the user
     @warning `image`, `title`, `wipDescription`, and `tags` properties must all be supplied as specs when publishing a new work in progress or revision.
     */
    AdobePublishWIPSpecsEditingOptionNone           = 1 << 0,
    
    /**
     Allow the ability to preview the work in progress `image` prior to publishing and edit the `image` if the `AdobeCreativeSDKImage` component is included in your project.
     */
    AdobePublishWIPSpecsEditingOptionPreview        = 1 << 1,
    
    /**
     Allow the ability to customize work in progress details and sharing options when publishing a work in progress.
     @warning if this option is not set, the `image`, `title`, `wipDescription`, and `tags` properties must all be supplied as specs when publishing a new work in progress or revision.
     */
    AdobePublishWIPSpecsEditingOptionDetails        = 1 << 2,
};

/**
 `AdobePublishWIPSpecs` wraps all fields available for publishing projects and works in progress to the Behance network.
 
 All fields except `image` are optional. Any fields provided will be pre-filled in the work in progress publishing UI. 
 All fields except `image` can be overridden by the user.
 */
__deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future. Use AdobePublishProjectSpecs with project publishing instead.")
@interface AdobePublishWIPSpecs : NSObject

/**
 UIImage to be published as a work in progress.
 
 @warning This field is required when creating a new work in progress or revision.
 @warning This field is ignored when editing an existing work in progress or revision.
 */
@property (nonatomic, strong, nullable) UIImage * image;

/**
 Title of the work in progress to be published.
 @warning If an `originalWIPId` is provided, title will be ignored.
 */
@property (nonatomic, strong, nullable) NSString * title;

/**
 Description of the work in progress to be published.
 */
@property (nonatomic, strong, nullable) NSString * wipDescription;

/**
 Array of `NSString` tags to associate with the work in progress to be published.
 @warning If an `originalWIPId` is provided, tags will be ignored.
 */
@property (nonatomic, strong, nullable) NSArray<NSString *> * tags;

/**
 Flag (0 or 1) indicating whether the project contains any adult content: nudity, sexual themes, expletives, or violence
 For more information: http://www.behance.net/faq
 */
@property (nonatomic, strong, nullable) NSNumber * matureContent;

/**
 One or more `AdobePublishWIPSpecsEditingOption` providing the ability to specify what steps of the work in progress publishing flow are shown
 
 Multiple can be provided AdobePublishWIPSpecsEditingOptionPreview|AdobePublishWIPSpecsEditingOptionDetails.
 By default, all editing steps in the work in progress publishing flow will be shown.
 @warning if `AdobePublishWIPSpecsResourceOptionDetails` is not set, the `title`, `wipDescription`, and `tags` properties must all be supplied as specs.
 */
@property (nonatomic) AdobePublishWIPSpecsEditingOption editingOptions;

/**
 When adding a new revision to an existing work in progress, set `originalWIPId` to the id of the work in progress.
 This field is ignored when editing.
 @warning If an `originalWIPId` is provided, title and tags will be ignored as the original WIP's title and tags carry over.
 */
@property (nonatomic, strong, nullable) NSNumber * originalWIPId;

#pragma mark - Metadata

/**
 XMP Metadata for insertion into the work in progress image
 */

@property (nonatomic, retain, nullable) AdobeDCXMutableMetadata * metadata;

#pragma mark - Editing Existing Works-in-Progress

/**
 To edit the content of an existing work in progress, supply its id
 
 @warning the `revisionId` must also be supplied, or this property will be ignored
 */
@property (nonatomic, strong, nullable) NSNumber * workInProgressId;

/**
 To edit the content of an existing work in progress, supply its revision id
 
 @warning the `workInProgressId` must also be supplied, or this property will be ignored
 */
@property (nonatomic, strong, nullable) NSNumber * revisionId;

@end

NS_ASSUME_NONNULL_END
