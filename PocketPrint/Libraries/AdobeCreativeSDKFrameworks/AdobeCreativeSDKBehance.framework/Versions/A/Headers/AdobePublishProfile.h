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

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishProfile` is a subclass of `AdobePublishBaseModel`, and represents an entity with a profile on Behance (i.e. a user or a team).
 */
@interface AdobePublishProfile : AdobePublishBaseModel

/**
 unique numeric identifier
 */
@property (nonatomic, strong) NSNumber * uniqueID;

/**
 unique string identifier, e.g. username
 */
@property (nonatomic, copy) NSString * uniqueName;

/**
 display name
 */
@property (nonatomic, copy) NSString * displayName;

/**
 date that the user was created (joined Behance)
 */
@property (nonatomic, strong) NSDate * createdDate;

/**
 URL of the user's avatar
 */
@property (nonatomic, strong) NSURL * avatarURL;

/**
 user-specified city where the user lived
 */
@property (nonatomic, copy) NSString * city;

/**
 user-specified state where the user lived
 */
@property (nonatomic, copy) NSString * state;

/**
 user-specified country where the user lived
 */
@property (nonatomic, copy) NSString * country;

/**
 location string that combines city, state, country with abbreviations for state, province, and country code where appropriate
 */
@property (nonatomic, readonly) NSString * location;

/**
 URL of the user's profile on the web
 */
@property (nonatomic, strong) NSURL * url;

/**
 Array of url path strings of links the user has supplied for their profile
 */
@property (nonatomic, strong) NSArray<NSString *> * links;

/**
 Array of url path strings of social links of the user. For the section "on the web"
 */
@property (nonatomic, strong) NSArray<NSString *> * social_links;

/**
 Array of creative field strings the user associates with
 */
@property (nonatomic, strong) NSArray<NSString *> * fields;

/**
 user-specified twitter username
 */
@property (nonatomic, copy) NSString * twitter;

/**
 User-specified website URL
 */
@property (nonatomic, copy) NSString * website;

/**
 Dictionary of free-form text titles and bodies to be displayed on their profile
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * sections;

/**
 Whether the current user follows this profile
 */
@property (nonatomic, assign, getter = isFollowing) BOOL following;

/**
 Number of users following this profile
 */
@property (nonatomic, strong) NSNumber * numFollowers;

/**
 Number of appreciations received by all of the user's projects
 */
@property (nonatomic, strong) NSNumber * numAppreciations;

/**
 Number of comments received by all of the user's projects
 */
@property (nonatomic, strong) NSNumber * numComments;

/**
 Number of views received by the user
 */
@property (nonatomic, strong) NSNumber * numViews;

/**
 Array of `NSDictionary` objects, each identifying a Behance curated gallery where the user has been featured.
 Each dictionary includes a `site` (`name` and `key`) and a `featured_on` date of when the project was featured.
 */
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> * featuredOn;

/**
 Array of project cover url path strings
 */
@property (nonatomic, strong) NSArray<NSString *> * projectCovers;

/**
 Array of project ids as numbers
 */
@property (nonatomic, strong) NSArray<NSNumber *> * projectIds;

/**
 Returns YES if the profile represents a team, NO otherwise
 */
- (BOOL)isTeam;

/**
 Returns YES if the profile represents a user, NO otherwise
 */
- (BOOL)isUser;

/**
 Returns YES if the current logged in user owns this profile, NO otherwise
 */
- (BOOL)currentUserIsOwner;

@end

NS_ASSUME_NONNULL_END
