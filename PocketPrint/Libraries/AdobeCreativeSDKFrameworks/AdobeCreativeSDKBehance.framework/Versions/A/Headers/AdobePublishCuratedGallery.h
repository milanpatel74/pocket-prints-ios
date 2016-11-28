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

#import "AdobePublishBaseModel.h"
#import "AdobePublishProject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Identifies what type of gallery is represented
 */
typedef NS_ENUM(NSInteger, AdobePublishCuratorType) {
    /**
     Organizations - https://www.behance.net/galleries/organizations
     */
    AdobePublishCuratorTypeOrganization,
    /**
     Served Sites - https://www.behance.net/galleries/curated
     */
    AdobePublishCuratorTypeServedSite
};

/**
 `AdobePublishCuratedGallery` represents a curated gallery on the Behance network.
 */
@interface AdobePublishCuratedGallery : AdobePublishBaseModel

/**
 The id of the curated gallery
 */
@property (nonatomic, strong) NSNumber * galleryId;

/**
 The site id of the curated gallery
 */
@property (nonatomic, strong) NSNumber * siteId;

/**
 The title of the curated gallery
 */
@property (nonatomic, strong) NSString * title;

/**
 The url of the curated gallery icon
 */
@property (nonatomic, strong) NSURL * iconUrl;

/**
 The key of the curated gallery
 */
@property (nonatomic, strong) NSString * key;

/**
 The url of the curated gallery on the web
 */
@property (nonatomic, strong) NSString * url;

/**
 The type of curated gallery
 */
@property (nonatomic, strong) NSString * type;

/**
 The type of curator (AdobePublishCuratorTypeOrganization, AdobePublishCuratorTypeSchool, AdobePublishCuratorTypeServedSite)
 */
@property (nonatomic, assign) AdobePublishCuratorType curatorType;

/**
 The url of the ribbon image associated with this curated gallery (low-resolution)
 */
@property (nonatomic, strong) NSURL * ribbonImageUrl;

/**
 The url of the ribbon image associated with this curated gallery (high-resolution)
 */
@property (nonatomic, strong) NSURL * ribbonImage2xUrl;

/**
 The latest projects to be added to this curated gallery
 */
@property (nonatomic, strong) NSArray<AdobePublishProject *> * latestProjects;

/**
 Flag as to whether the current user follows this curated gallery
 */
@property (nonatomic, getter = isFollowing) BOOL following;

@end

NS_ASSUME_NONNULL_END
