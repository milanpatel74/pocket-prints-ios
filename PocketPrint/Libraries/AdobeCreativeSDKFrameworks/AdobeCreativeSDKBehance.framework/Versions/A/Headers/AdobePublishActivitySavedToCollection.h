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

#import "AdobePublishActivityActionItem.h"
#import "AdobePublishCollection.h"
#import "AdobePublishProject.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishActivitySavedToCollection` is a subclass of `AdobePublishActivityActionItem` and represents an activity item for projects that were saved to a collection.
 */
@interface AdobePublishActivitySavedToCollection : AdobePublishActivityActionItem

/**
 An array of `AdobePublishProject` projects that were saved to the collection
 */
@property (nonatomic, strong) NSArray<AdobePublishProject *> * projectsSaved;

/**
 The owner of the collection
 */
@property (nonatomic, strong) AdobePublishUser * collectionOwner;

/**
 The collection that the projects were saved to
 */
@property (nonatomic, strong) AdobePublishCollection * collection;

/**
 The latest projects to be added to this collection, but not necessarily as a result of this activity 
 */
@property (nonatomic, strong) NSArray<AdobePublishProject *> * latestProjects;

@end

NS_ASSUME_NONNULL_END
