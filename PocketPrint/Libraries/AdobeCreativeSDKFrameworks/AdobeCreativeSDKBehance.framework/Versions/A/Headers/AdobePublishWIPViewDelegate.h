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

#import "AdobePublishComment.h"
#import "AdobePublishComponentDelegate.h"
#import "AdobePublishWorkInProgress.h"
#import "AdobePublishURLDelegate.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Allows clients to be notified of work in progress viewing events.
 */
__deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future. Use AdobePublishProjectViewDelegate together with Projects instead.")
@protocol AdobePublishWIPViewDelegate <AdobePublishComponentDelegate, AdobePublishURLDelegate>
@optional

#pragma mark - Loading Work in Progress

/**
 Called when a work in progress has finished loading.
 @param wip the work in progress that was loaded
 */
- (void)wipLoadDidComplete:(AdobePublishWorkInProgress *)wip;

/**
 Called when a work in progress has failed to load.
 @param error an error describing why the work in progress load request failed
 */
- (void)wipLoadDidFail:(NSError *)error;

/**
 Called when a user scrolls a revision into view, as well as when the default revision in the first position is displayed.
 @param revisionId the id of the revision that was displayed
 */
- (void)wipDidDisplayRevisionWithId:(NSNumber *)revisionId;

#pragma mark - Comments

/**
 Called when a work in progress comment has been posted successfully by the user.
 @param comment the comment that was posted
 */
- (void)wipCommentPostSucceeded:(NSString *)comment;

/**
 Called when a work in progress comment posted by the user fails.
 @param error an error describing why the comment request failed
 */
- (void)wipCommentPostFailed:(NSError *)error;

/**
 Called when a comment has been deleted by the user.
 @param comment the comment that is intended to be deleted
 */
- (void)wipCommentDeleted:(AdobePublishComment *)comment;

#pragma mark - Follow

/**
 Called when the user initiates following another user.
 The component handles making the follow network request.
 @param user the user that is intended to be followed
 */
- (void)followWillTriggerForUser:(AdobePublishUser *)user;

/**
 Called when following another user has completed successfully.
 @param user the user that was followed
 */
- (void)followSucceededForUser:(AdobePublishUser *)user;

/**
 Called when following another user fails.
 @param user the user that was intended to be followed
 @param error an error describing why the follow request failed
 */
- (void)followFailedForUser:(AdobePublishUser *)user error:(NSError *)error;

/**
 Called when the user initiates unfollowing another user. The component handles making the unfollow network request.
 @param user the user that is intended to be unfollowed
 */
- (void)unfollowWillTriggerForUser:(AdobePublishUser *)user;

/**
 Called when unfollowing another user has completed successfully.
 @param user the user that was unfollowed
 */
- (void)unfollowSucceededForUser:(AdobePublishUser *)user;

/**
 Called when unfollowing another user fails.
 @param user the user that was intended to be unfollowed
 @param error an error describing why the unfollow request failed
 */
- (void)unfollowFailedForUser:(AdobePublishUser *)user error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
