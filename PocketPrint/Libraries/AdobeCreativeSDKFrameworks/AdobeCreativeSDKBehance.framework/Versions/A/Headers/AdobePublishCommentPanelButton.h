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

@protocol AdobePublishUnreadCommentsDelegate;

/**
 `AdobePublishCommentPanelButton` can be used to present an `AdobePublishCommentPanel`.
 It reacts to unread comment notifications, and displays the unread comment count.
 */
@interface AdobePublishCommentPanelButton : UIButton

/**
 Indicates whether the button should animate to the left to accomodate the unread number when unread comment count changes.
 Otherwise, it will remain centered.
 */
@property (nonatomic, assign) BOOL animateLeft; // defaults to true

/** The current contentId (either a projectId or a workInProgressId).  This id can be changed dynamically, but
  the type (project vs. wip) is fixed at initialization time */
@property (nonatomic, strong) NSNumber * contentId;

/** The origin (top-left) of the button, can optionally be modified if the origin must change after initialization */
@property (nonatomic, assign) CGPoint origin;

#pragma mark - API

/**
 Create an `AdobePublishCommentPanelButton` for a project
 @param origin origin of the button
 @param projectId id of the project to display and track comments for
 @param delegate optional delegate
 */
- (id)initWithOrigin:(CGPoint)origin
           projectId:(NSNumber *)projectId
            delegate:(id<AdobePublishUnreadCommentsDelegate>)delegate;

/**
 Create an `AdobePublishCommentPanelButton` for a work in progress
 @param origin origin of the button
 @param workInProgressId id of the work in progress to display and track comments for
 @param delegate optional delegate
 */
- (id)initWithOrigin:(CGPoint)origin
    workInProgressId:(NSNumber *)workInProgressId
            delegate:(id<AdobePublishUnreadCommentsDelegate>)delegate;

/**
 Begin tracking unread comment notifications
 */
- (void)beginTrackingUnreadComments;

/**
 End tracking unread comment notifications
 */
- (void)endTrackingUnreadComments;

@end


/**
 Notifies the delegate when unread comment counts change, when comments are marked as read
    and when an asset is deleted
 */
@protocol AdobePublishUnreadCommentsDelegate <NSObject>

@optional

/**
 the number of unread comments on the corresponding project or work in progress
 */
@property (nonatomic, strong) NSNumber * unreadCommentCount;

/**
 the number of unread comments on the currently selected work in progress revision
 */
@property (nonatomic, strong) NSNumber * unreadCommentCountForCurrentRevision;

/**
 incremented whenever comments for a project or wip revision are marked as read
 */
@property (nonatomic, assign) NSInteger commentsMarkedAsRead;

/**
 called when the project or work-in-progress has been deleted

 @param assetId ID value for the asset just deleted.
 */
- (void)publishedAssetDeleted:(NSNumber *)assetId;

/**
 called when the project has been unpublished
 
 @param assetId ID value for the asset just unpublished.
 */
- (void)publishedAssetUnpublished:(NSNumber *)assetId;

@end
