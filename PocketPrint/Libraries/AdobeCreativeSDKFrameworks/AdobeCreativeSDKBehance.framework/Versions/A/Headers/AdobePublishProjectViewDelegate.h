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
#import "AdobePublishProject.h"
#import "AdobePublishURLDelegate.h"
#import "AdobePublishUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Allows clients to be notified of project viewing events.
 */
@protocol AdobePublishProjectViewDelegate <AdobePublishComponentDelegate, AdobePublishURLDelegate>
@optional

#pragma mark - Loading Projects

/**
 Called when a project has finished loading.
 @param project the project that was loaded
 */
- (void)projectLoadDidComplete:(AdobePublishProject *)project;

/**
 Called when a project has failed to load.
 @param error an error describing why the project load request failed
 */
- (void)projectLoadDidFail:(NSError *)error;

#pragma mark - Comments

/**
 Called when a project comment has been posted successfully by the user.
 @param comment the comment that was posted
 */
- (void)projectCommentPostSucceeded:(NSString *)comment;

/**
 Called when a project comment posted by the user fails.
 @param error an error describing why the comment request failed
 */
- (void)projectCommentPostFailed:(NSError *)error;

/**
 Called when a comment has been deleted by the user.
 @param comment the comment that is intended to be deleted
 */
- (void)projectCommentDeleted:(AdobePublishComment *)comment;

#pragma mark - Appreciations

/**
 Called when the user initiates project appreciation. 
 The component handles making the appreciation network request.
 */
- (void)projectWillAppreciate;

/**
 Called when project appreciation initiated by the user has completed successfully.
 */
- (void)projectAppreciateSucceeded;

/**
 Called when project appreciation initiated by the user fails.
 @param error an error describing why the appreciate request failed
 */
- (void)projectAppreciateFailed:(NSError *)error;

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
