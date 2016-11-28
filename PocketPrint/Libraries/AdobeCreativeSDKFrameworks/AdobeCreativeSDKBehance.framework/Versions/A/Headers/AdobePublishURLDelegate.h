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

NS_ASSUME_NONNULL_BEGIN

@protocol AdobePublishURLDelegate <NSObject>
@optional

/**
 Called when the user taps on a URL in the publishing workflow, e.g. success view, a link in comments, an
 avatar, a link in a project etc. Clients have the option to integrate with the appURL or the webURL. An
 app URL can be nil if there are no associated URLs for such a action; webURL is always valid. When using
 the app URL, clients should verify the user has an app installed that is registered to handle that URL by
 calling [[UIApplication sharedApplication] canOpenURL:appURL]
 
 @param appURL an app scheme-prefixed URL associated with an action taken by the user (or nil)
 @param webURL a web URL associated with an action taken by the user
 */
- (void)openAppURL:(nullable NSURL *)appURL webURL:(nullable NSURL *)webURL;

@end

NS_ASSUME_NONNULL_END
