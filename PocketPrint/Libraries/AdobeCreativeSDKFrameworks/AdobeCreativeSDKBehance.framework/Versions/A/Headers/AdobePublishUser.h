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

#import "AdobePublishNetworkResponse.h"
#import "AdobePublishProfile.h"
#import "AdobePublishWorkExperience.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishUser` is a subclass of `AdobePublishProfile`, and represents a user on the Behance network.
 */
@interface AdobePublishUser : AdobePublishProfile

/**
 first name of the user
 */
@property (nonatomic, copy) NSString * firstName;

/**
 last name of the user
 */
@property (nonatomic, copy) NSString * lastName;

/**
 user-specified company name for their current position
 */
@property (nonatomic, copy) NSString * company;

/**
 user-specified occupation name for their current position
 */
@property (nonatomic, copy) NSString * occupation;

/**
 Array of `AdobePublishWorkExperience` objects, representing their past and current positions as specified on their profile
 */
@property (nonatomic, strong) NSArray<AdobePublishWorkExperience *> * workExperience;

/**
 Number of members the user follows
 */
@property (nonatomic, strong) NSNumber * numFollowing;

#pragma mark - API

/*
 Search for users.
 
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
    q              Free text query string.
    field          Limits the search by creative field. Accepts a URL-encoded field name from the list of defined creative fields.
    country        Limits the search by a 2-letter FIPS country code.
    state          Limits the search by state or province name.
    city           Limits the search by city name.
    page           The page number of the results, always starting with 1.
    sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date, followed.
    tags           Limits the search by tags. Accepts one tag name or a pipe-separated list of tag names.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)userSearchWithParams:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch the currently logged in user.
 
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)meWithCompletion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch a specific user.
 
 @param userIdentifier username or user id of the user to fetch
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)userWithIdentifier:(NSString *)userIdentifier completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get projects by a user.
 
 @param userIdentifier username or user id of the user who's projects you wish to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
    sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date.
    time           Limits the search by time. Possible values: all (default), today, week, month.
    page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)projectsForUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get wips by a user.
 
 @param userIdentifier username or user id of the user who's wips you wish to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
    sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date.
    time           Limits the search by time. Possible values: all (default), today, week, month.
    page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)wipsForUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion __deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future. Use projectsForUserWithIdentifier:params:completion: with projects instead.");

/*
 Get projects recently appreciated by a user.
 
 @param userIdentifier username or user id of the user to fetch
 @param page page of the paginated results to fetch
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)recentlyAppreciatedProjectsForUserWithIdentifier:(NSString *)userIdentifier page:(NSNumber *)page completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get collections by a user.
 
 @param userIdentifier username or user id of the user to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
    sort           The order the results are returned in. Possible values: comments (default), views, last_item_added_date.
    time           Limits the search by time. Possible values: all (default), today, week, month.
    page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)collectionsForUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch stats for a user.
 
 @param userIdentifier username or user id of the user to fetch the stats of
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)statsForUserWithIdentifier:(NSString *)userIdentifier completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get followers of a user.
 
 @param userIdentifier username or user id of the user to fetch the followers of
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
    sort           The order the results are returned in. Possible values: created_date (default), appreciations, views, comments, followed, alpha.
    sort_order     The direction in which the results are returned. Possible values: asc, desc.
    per_page       The number of results per page. (Max:20)
    page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)followersForUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get users followed by a user.
 
 @param userIdentifier username or user id of the user of interest
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
    sort           The order the results are returned in. Possible values: created_date (default), appreciations, views, comments, followed, alpha.
    sort_order     The direction in which the results are returned. Possible values: asc, desc.
    per_page       The number of results per page. (Max:20)
    page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)usersFollowedByUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get teams associated with a user.
 
 @param userIdentifier username or user id of the user of interest
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
 
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
*/
+ (void)teamsForUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get a user's work experience.
 
 @param userIdentifier username or user id of the user of interest
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)workExperienceForUserWithIdentifier:(NSString *)userIdentifier completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get collections followed by a user.
 
 @param userIdentifier username or user id of the user to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)collectionsFollowedByUserWithIdentifier:(NSString *)userIdentifier params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Follow a user.
 
 @param userIdentifier username or user id of the user to follow
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)followUserWithIdentifier:(NSString *)userIdentifier completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Unfollow a user.
 
 @param userIdentifier username or user id of the user to unfollow
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)unfollowUserWithIdentifier:(NSString *)userIdentifier completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Get recommended creatives to follow
 
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)creativesToFollowWithParams:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

@end

NS_ASSUME_NONNULL_END
