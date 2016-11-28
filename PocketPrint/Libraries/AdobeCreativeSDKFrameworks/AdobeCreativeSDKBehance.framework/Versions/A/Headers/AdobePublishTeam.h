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

#import "AdobePublishProfile.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishTeam` is a subclass of `AdobePublishProfile`, and represents a team on the Behance network.
 */
@interface AdobePublishTeam : AdobePublishProfile

/**
 Array of users associated with this team
 */
@property (nonatomic, strong) NSArray<AdobePublishUser *> * members;

/**
 Number of users associated with this team
 */
@property (nonatomic, strong) NSNumber * numMembers;

/**
 Whether the current user is an owner of this team
 */
@property (nonatomic, assign, readonly, getter = isOwner) BOOL owner;

/**
 Whether the current user is a member of this team
 */
@property (nonatomic, assign, readonly, getter = isMember) BOOL member;

/*
 Search for teams.
 
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
+ (void)teamsSearchWithParams:(nullable NSDictionary<NSString *, NSString *> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch a list of teams via autocomplete text.
 
 @param autocompleteText prefix of the team names to return via autocomplete matching
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)teamsAutocompleteWithText:(NSString *)autocompleteText completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch a specific team.
 
 @param teamIdentifier team id of the team to fetch
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)teamWithIdentifier:(NSString *)teamIdentifier completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get the members of a team.
 
 @param teamIdentifier team id of the team who's members you wish to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
 sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date.
 time           Limits the search by time. Possible values: all (default), today, week, month.
 page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)membersForTeamWithIdentifier:(NSString *)teamIdentifier params:(nullable NSDictionary<NSString *, NSString *> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get projects by a team.
 
 @param teamIdentifier team id of the team who's projects you wish to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
 sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date.
 time           Limits the search by time. Possible values: all (default), today, week, month.
 offset         The project id of the last project returned. Used for paging.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)projectsForTeamWithIdentifier:(NSString *)teamIdentifier params:(nullable NSDictionary<NSString *, NSString *> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Returns the current user's projects with an additional flag denoting which projects have been added to the given team.
 @param teamIdentifier  team slug or id of the team of interest
 @param offset          offset key used for pagination
 @param completion      `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)currentUserProjectAssociationsForTeamWithIdentifier:(NSString *)teamIdentifier offset:(nullable NSNumber *)offset completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get wips by a team.
 
 @param teamIdentifier username or team id of the team who's wips you wish to fetch
 @param params `NSDictionary` of parameters to provide to the API (see http://behance.net/dev for up-to-date information)
 sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date.
 time           Limits the search by time. Possible values: all (default), today, week, month.
 page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)wipsForTeamWithIdentifier:(NSString *)teamIdentifier params:(nullable NSDictionary<NSString *, NSString *> *)params completion:(AdobePublishNetworkResponseCompletion)completion __deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future. Use projectsForTeamWithIdentifier:params:completion: with projects instead.");

/*
 Add or remove projects from a team.
 
 @param teamIdentifier username or team id of the team who's wips you wish to fetch
 @param projectIdsToAdd ids of projects to add to team
 @param projectIdsToRemove ids of projects to remove from team
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)updateProjectsForTeamWithIdentifier:(NSString *)teamIdentifier projectIdsToAdd:(NSArray<NSNumber *> *)projectIdsToAdd projectIdsToRemove:(NSArray<NSNumber *> *)projectIdsToRemove completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Follow a team.
 
 @param teamIdentifier team name or team id of the team to follow
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)followTeamWithIdentifier:(NSString *)teamIdentifier completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Unfollow a user.
 
 @param teamIdentifier team name or team id of the team to unfollow
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)unfollowTeamWithIdentifier:(NSString *)teamIdentifier completion:(nullable AdobePublishNetworkResponseCompletion)completion;

@end

NS_ASSUME_NONNULL_END
