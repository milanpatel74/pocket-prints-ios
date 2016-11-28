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

#import "AdobePublishContentObject.h"
#import "AdobePublishNetworkResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishProject` is an `AdobePublishContentObject` subclass, and represents a project on the Behance network.
 */
@interface AdobePublishProject : AdobePublishContentObject <NSCopying, NSCoding>

/**
 The id of the project
 */
@property (nonatomic, strong) NSNumber * projectId;

/**
 Date the project was last published
 */
@property (nonatomic, strong) NSDate * publishedOn;

/**
 Date the project was last modified
 */
@property (nonatomic, strong) NSDate * modifiedOn;

/**
 URL of the project cover image
 @see anyCoverImageURL for a convenience method to return an appropriate cover image url that respects `matureContent` and `matureAccess` properties
 */
@property (nonatomic, strong) NSURL * coverImageUrl;

/**
 Array of `NSString` objects identifying user-defined Creative Fields associated with the project
 */
@property (nonatomic, strong) NSArray<NSString *> * fields;

/**
 Number of member appreciations associated with the project
 */
@property (nonatomic, strong) NSNumber * appreciations;

/**
 Array of `NSDictionary` objects, each representing a discrete project module for this project.
 Modules may be of `type`: `image`, `text`, or `embed`, representing user-supplied images, text or html embedded content respectively.
 */
@property (nonatomic, strong) NSArray<NSDictionary *> * modules;

/**
 Code identifying the copyright license the user has supplied for their project.
 Most license codes are derived from the Creative Commons.
 */
@property (nonatomic, strong) NSString * license;

/**
 Description identifying the copyright license the user has supplied for their project.
 */
@property (nonatomic, strong) NSString * licenseDescription;

/**
 Array of `NSString` objects identifying user-supplied tags associated with the project
 */
@property (nonatomic, strong) NSArray<NSString *> * tags;

/**
 Array of `NSString` objects identifying tools used to create the project
 */
@property (nonatomic, strong) NSArray<NSString *> * toolsUsed;

/**
 NSDictionary of `toolsUsed` strings mapping to `NSURL` links for tools used to create the project if an associated link is available
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSURL *> * toolsUsedURLsDict;

/**
 Array of `NSDictionary` objects, each identifying a Behance curated gallery where the project has been featured.
 Each dictionary includes a `site` (`name` and `key`) and a `featured_on` date of when the project was featured.
 */
@property (nonatomic, strong) NSArray<NSDictionary *> * featured;

/**
 A user-defined background color for the project
 */
@property (nonatomic, strong) UIColor * backgroundColor;

/**
 An `NSDictionary` of user-defined styles to be applied to the project when displayed in HTML form
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * styles;

/**
 Convenience method for retrieving a project cover image
 
 @return URL to the highest quality cover image that can be retrieved. Also respects the current `matureContent` and `matureAccess` properties
 */
- (NSURL *)anyCoverImageURL;

/**
 YES if the project is associated with a given team. This field is only set from certain teams endpoints.
 */
@property (nonatomic, getter=isAssociatedWithTeam) BOOL associatedWithTeam;

/** 
 YES if any image modules in the project should span the full-width of a project
 */
- (BOOL)containsFullWidthImages;

#pragma mark - API

/*
 Search for projects.
 
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
     q              Free text query string.
     sort           The order the results are returned in. Possible values: featured_date (default), appreciations, views, comments, published_date.
     time           Limits the search by time. Possible values: all (default), today, week, month.
     field          Limits the search by creative field. Accepts a URL-encoded field name from the list of defined creative fields.
     country        Limits the search by a 2-letter FIPS country code.
     state          Limits the search by state or province name.
     city           Limits the search by city name.
     page           The page number of the results, always starting with 1.
     tags           Limits the search by tags. Accepts one tag name or a pipe-separated list of tag names.
     color_hex      Limit results to an RGB hex value (without #)
    color_range    How closely to match the requested color_hex, in color shades (default:20) [0-255]
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
*/
+ (void)projectsSearchWithParams:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch project with the supplied project id.
 
 @param projectId id of the project to retrieve
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)projectWithId:(NSNumber *)projectId completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch multiple projects with the supplied NSArray of project ids.
 
 @param projectIds array of project ids, each represented as an `NSNumber`.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)projectsWithIds:(NSArray<NSNumber *> *)projectIds completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Fetch comments for the project associated with the supplied project id.
 
 @param projectId id of the project to retrieve
 @param page page of paginated results to retrieve
 @param params `NSDictionary` of additional parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)commentsForProjectWithId:(NSNumber *)projectId page:(NSNumber *)page params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Get user's collections where the given project appears.
 
 @param projectId id of the project to search for
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)userCollectionsContainingProjectWithId:(NSNumber *)projectId completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Mark a project as viewed by the current user. Also returns whether current user has previously appreciated this project.
 
 @warning Requires post_as scope.
 
 @param projectId id of the project to view
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)viewProjectWithId:(NSNumber *)projectId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Post a comment on the project with the specified project id.
 
 @param comment the comment to post for the project
 @param projectId id of the project to add a comment to
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)postComment:(NSString *)comment projectId:(NSNumber *)projectId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Appreciates the project from the current user. 
 
 @warning Must have had a view previously.
 @warning Requires post_as scope.
 
 @param projectId id of the project to add a comment to
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)appreciateProjectWithId:(NSNumber *)projectId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Delete a comment by comment and project id.
 
 @warning Must have had a view previously.
 @warning Requires post_as scope.
 
 @param projectId id of the project to add a comment to
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)deleteCommentWithId:(NSNumber *)commentId projectId:(NSNumber *)projectId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

@end

NS_ASSUME_NONNULL_END
