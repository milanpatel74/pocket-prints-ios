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
#import "AdobePublishComponentDelegate.h"
#import "AdobePublishURLDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Allows clients to be notified of project publishing flow.
 */
@protocol AdobePublishProjectDelegate <AdobePublishComponentDelegate, AdobePublishURLDelegate>
@optional

/**
 Called when the project publishing flow is about to close.
 */
- (void)projectPublishWillClose;

/**
 Called when the project publishing flow has closed.
 */
- (void)projectPublishDidClose;

/**
 Called on project publishing upload progress for the project cover image.
 
 @param bytesWritten number of bytes that were just uploaded
 @param totalBytesWritten total number of bytes that have been written so far
 @param totalBytesExpected total number of bytes of the cover image to be uploaded
 */
- (void)projectPublishCoverImageUploadBytesWritten:(NSUInteger)bytesWritten totalBytes:(long long)totalBytesWritten totalBytesExpected:(long long)totalBytesExpected;

/**
 Called on project publishing upload progress for individual project images.
 
 @param bytesWritten number of bytes that were just uploaded
 @param totalBytesWritten total number of bytes that have been written so far
 @param totalBytesExpected total number of bytes of the cover image to be uploaded
 @param imageNumber the image number written
 @param totalImages the total number of images
 */
- (void)projectPublishImageUploadBytesWritten:(NSUInteger)bytesWritten totalBytes:(long long)totalBytesWritten totalBytesExpected:(long long)totalBytesExpected
                                  imageNumber:(NSUInteger)imageNumber totalImages:(NSUInteger)totalImages;

/**
 Called when the project is saved by the user, and upload has begun.
 */
- (void)projectPublishDidStart;

/**
 Called on project publishing success.
 
 @param projectId the id of the project that was created
 
 @return delegates should return an UIViewController to present the success view controller with. Return nil if no success view is desired.
 */
- (nullable UIViewController *)projectPublishDidComplete:(NSNumber *)projectId;

/**
 Called immediately after projectPublishDidComplete:
 allows delegates to override the default behavior of presenting a popup window upon publishing success
 
 @return delegates should return NO if they wish to prevent the popup window from being shown, default is YES
 
 DEPRECATED: If a success pop up is required, you must use projectPublishDidComplete:(NSNumber *)projectId instead.
 Otherwise, returning NO for this method is still supported.
 */
- (BOOL)projectPublishShouldPresentSuccessPopup __deprecated;

/**
 Called if the end user taps "VIEW ON BEHANCE" in the success popup, indicating that they would like to view the published project
 if this method is not handled in the delegate, the project will be opened in the Behance app, or, if it's not installed, on behance.net in Safari.
 
 @param projectId the id of the project that was created
 */
- (void)viewProjectTapped:(NSNumber *)projectId;

/**
 Called on project publishing failure.
 
 @param error the error that resulted in a failure
 */
- (void)projectPublishDidFail:(NSError *)error;

/**
 Called if loading an existing project for editing fails.
 
 @param error the error that resulted in a failure
 */
- (void)projectEditDidFail:(NSError *)error;

/**
 Supply a custom string to use when sharing a project to external services (ex. Twitter).
 Please note that AdobePublishAccountTypeFacebook is not supported.
 
 @param accountType `AdobePublishAccountType` account type string is being shared to
 @param projectURL short url of the project on behance.net
 @param projectText the user supplied project title
 @return the string to post to Twitter
 */
- (NSString *)projectPublishStringForExternalAccount:(AdobePublishAccountType)accountType url:(NSURL *)projectURL projectText:(NSString *)projectText;

@end

NS_ASSUME_NONNULL_END
