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
 ******************************************************************************/

#import "AdobePublishDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishComponentDelegate` defines callbacks that project and work in progress 
 viewer components will make to their delegate.
 */
@protocol AdobePublishComponentDelegate <AdobePublishDelegate>
@optional

#pragma mark - Component Lifecycle

/**
 Called when the component will be dismissed.
 */
- (void)componentWillClose;

/**
 Called when the component dismissal has completed.
 */
- (void)componentDidClose;

@end

NS_ASSUME_NONNULL_END
