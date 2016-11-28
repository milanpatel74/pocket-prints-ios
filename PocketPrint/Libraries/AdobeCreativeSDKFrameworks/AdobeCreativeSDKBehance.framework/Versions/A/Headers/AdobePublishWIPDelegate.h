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

#import "AdobePublishAccountType.h"
#import "AdobePublishDelegate.h"
#import "AdobePublishURLDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Allows clients to be notified of WIP publishing flow.
 */
__deprecated_msg("Work in Progress publishing is being deprecated and will be removed in the near future. Use AdobePublishProjectDelegate with project publishing instead.")
@protocol AdobePublishWIPDelegate <AdobePublishDelegate, AdobePublishURLDelegate>
@optional

/**
 Called when the work in progress publishing flow is about to close.
 */
- (void)wipPublishWillClose;

/**
 Called when the work in progress publishing flow has closed.
 */
- (void)wipPublishDidClose;

/**
 Called on work in progress publishing upload progress for the work in progress image.
 
 @param bytesWritten number of bytes that were just uploaded
 @param totalBytesWritten total number of bytes that have been written so far
 @param totalBytesExpected total number of bytes of the image to be uploaded
 */
- (void)wipPublishImageUploadBytesWritten:(NSUInteger)bytesWritten totalBytes:(long long)totalBytesWritten totalBytesExpected:(long long)totalBytesExpected;

/**
 Called when the work in progress is saved by the user, and upload has begun.
 */
- (void)wipPublishDidStart;

/**
 Called on work in progress publishing success.
 
 @param wipId the id of the work in progress that was created
 @param revisionId the id of the revision if this was added as a revision to an existing work in progress
 
 @return delegates should return an UIViewController to present the success view controller with. Return nil if no success view is desired.
 */
- (nullable UIViewController *)wipPublishDidComplete:(NSNumber *)wipId revisionId:(nullable NSNumber *)revisionId;

/**
 Called immediately after wipPublishDidComplete:revisionId:
 allows delegates to override the default behavior of presenting a popup window upon publishing success
 
 @return delegates should return NO if they wish to prevent the popup window from being shown, default is YES
 
 DEPRECATED: If a success pop up is required, you must use wipPublishDidComplete:(NSNumber *)wipId revisionID:(NSNumber *)revisionId instead.
 Otherwise, returning NO for this method is still supported.
 */
- (BOOL)wipPublishShouldPresentSuccessPopup __deprecated;

/**
 Called if the end user taps "VIEW ON BEHANCE" in the success popup, indicating that they would like to view the published work in progress
 if this method is not handled in the delegate, the project will be opened in the Behance app, or, if it's not installed, on behance.net in Safari.
 
 @param wipId the id of the work in progress that was created
 @param revisionId the id of the work in progress revision that was created
 */
- (void)viewWorkInProgressTapped:(NSNumber *)wipId revisionId:(NSNumber *)revisionId;

/**
 Called on work in progress publishing failure.
 
 @param error the error that resulted in a failure
 */
- (void)wipPublishDidFail:(NSError *)error;

/**
 Called if loading an existing work in progress revision for editing fails.
 
 @param error the error that resulted in a failure
 */
- (void)wipEditDidFail:(NSError *)error;

/**
 Supply a custom string to use when sharing work in progress to external services (ex. Twitter).
 Please note that AdobePublishAccountTypeFacebook is not supported.
 
 @param accountType `AdobePublishAccountType` account type string is being shared to
 @param wipURL short url of the work in progress on behance.net
 @param wipText the user supplied work in progress title, or revision description
 @return the string to post to Twitter
 */
- (NSString *)wipPublishStringForExternalAccount:(AdobePublishAccountType)accountType url:(NSURL *)wipURL wipText:(NSString *)wipText;

@end

NS_ASSUME_NONNULL_END
