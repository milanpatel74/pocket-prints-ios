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
#import "AdobePublishWIPRevision.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishWorkInProgress` is an `AdobePublishContentObject` subclass, and represents a work in progress on the Behance network.
 */
__deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future.")
@interface AdobePublishWorkInProgress : AdobePublishContentObject <NSCopying, NSCoding>

/**
 id of the work in progress
 */
@property (nonatomic, strong) NSNumber * workInProgressId;

/**
 number of revisions created for this the work in progress
 */
@property (nonatomic, strong) NSNumber * revisionCount;

/**
 array of `AdobePublishWIPRevision` revisions to the work in progress
 */
@property (nonatomic, strong) NSArray<AdobePublishWIPRevision *> * revisions;

/**
 stats for the work in progress
 */
@property (nonatomic, strong) NSDictionary *stats;

/**
 @return the latest `AdobePublishWIPRevision` revision of the work in progress by date
 */
- (AdobePublishWIPRevision *)latestRevision;

/**
 @return array of `NSString` tags on all revisions of this work in progress
 */
- (NSArray<NSString *> *)tags;


#pragma mark - API

/**
 Search for wips.
 
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 q              Free text query string.
 sort           The order the results are returned in. Possible values: comments (default), views, last_item_added_date.
 time           Limits the search by time. Possible values: all, today (default), week, month.
 page           The page number of the results, always starting with 1.
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)wipsSearchWithParams:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/**
 Get a work in progress by id
 
 @param wipId id of the work in progress to retrieve
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)wipWithId:(NSNumber *)wipId completion:(AdobePublishNetworkResponseCompletion)completion;

/**
 Get a work in progress revision by id
 
 @param revisionId id of the revision to retrieve
 @param wipId id of the work in progress the revision belongs to
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)wipRevisionWithId:(NSNumber *)revisionId wipId:(NSNumber *)wipId completion:(AdobePublishNetworkResponseCompletion)completion;

/**
 Get comments on a work in progress revision by id
 
 @param revisionId id of the revision to retrieve comments from
 @param wipId id of the work in progress the revision belongs to
 @param page page of paginated results to retrieve
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)commentsForWipRevisionWithId:(NSNumber *)revisionId wipId:(NSNumber *)wipId page:(NSNumber *)page params:(nullable NSDictionary<NSString *, id> *)params completion:(AdobePublishNetworkResponseCompletion)completion;

/*
 Upload a new work in progress image
 
 @param jpegImageData `NSData` in JPEG format, for the work in progress image.
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 image              An HTTP file upload. Minimum dimensions are 320px by 320px. If larger, an auto-centered crop will be taken from the uploaded image.
 title              Text to post as the title.
 description        The text to post as the description, used to start the conversation.
 tags               Text tag name or a pipe-separated list of tag names.
 privacy(optional)  Who is allowed to view this Work in Progress. Possible values: public (default), feedback_circle
 @param progress `AdobePublishNetworkResponseProgress` callback for the progress of the image upload
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
*/
+ (void)postWipWithData:(NSData *)jpegImageData params:(nullable NSDictionary<NSString *, id> *)params progress:(nullable AdobePublishNetworkResponseProgress)progress completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Upload a new image as a revision for an existing work in progress
 
 @param wipId id of the work in progress to upload a revision for
 @param jpegImageData `NSData` in JPEG format, for the work in progress image.
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 image              An HTTP file upload. Minimum dimensions are 320px by 320px. If larger, an auto-centered crop will be taken from the uploaded image.
 description        The text to post as the description, used to start the conversation.
 tags               Text tag name or a pipe-separated list of tag names.
 @param progress `AdobePublishNetworkResponseProgress` callback for the progress of the image upload
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)postWipRevisionForWipWithId:(NSNumber *)wipId data:(NSData *)jpegImageData params:(nullable NSDictionary<NSString *, id> *)params progress:(nullable AdobePublishNetworkResponseProgress)progress completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/**
 Post a comment on a work in progress
 
 @param comment comment to post
 @param wipId id of the associated work in progress
 @param revisionId id of the associated revision
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)postComment:(NSString *)comment wipId:(NSNumber *)wipId revisionId:(NSNumber *)revisionId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/*
 Update an existing work in progress
 
 @param wipId id of the work in progress to update
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 title              Updated title for existing wip
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)updateWipWithId:(NSNumber *)wipId params:(nullable NSDictionary<NSString *, id> *)params completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/**
 Update an existing revision of a work in progress
 
 @param wipId id of the work in progress to update
 @param revisionId id of the revision to update
 @param params `NSDictionary` of parameters to supply to the API. (see http://behance.net/dev for up-to-date information)
 description        Updated description for existing wip revision
 tags               Updated tags for existing wip revision
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)updateRevisionWithWipId:(NSNumber *)wipId revisionId:(NSNumber *)revisionId params:(nullable NSDictionary<NSString *, id> *)params completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/**
 Delete a comment on a work in progress
 
 @param commentId id of the comment to delete
 @param wipId id of the associated work in progress
 @param revisionId id of the associated revision
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)deleteCommentWithId:(NSNumber *)commentId wipId:(NSNumber *)wipId revisionId:(NSNumber *)revisionId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/**
 Delete a work in progress
 
 @param wipId id of the work in progress
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)deleteWipWithId:(NSNumber *)wipId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

/**
 Delete a work in progress revision
 
 @param revisionId id of the work in progress revision
 @param wipId id of the work in progress
 @param completion `AdobePublishNetworkResponseCompletion` callback for the API request
 */
+ (void)deleteRevisionWithId:(NSNumber *)revisionId wipId:(NSNumber *)wipId completion:(nullable AdobePublishNetworkResponseCompletion)completion;

@end

NS_ASSUME_NONNULL_END
