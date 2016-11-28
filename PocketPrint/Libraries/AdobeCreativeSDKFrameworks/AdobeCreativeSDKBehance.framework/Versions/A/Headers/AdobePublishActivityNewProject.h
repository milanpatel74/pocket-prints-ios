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

#import "AdobePublishActivityActionItem.h"
#import "AdobePublishProfile.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AdobePublishActivityNewProject` is a subclass of `AdobePublishActivityActionItem`, and represents the activity item for a newly published project.
 */
@interface AdobePublishActivityNewProject : AdobePublishActivityActionItem

/**
 Owner of the newly-published project (could be an AdobePublishUser or AdobePublishTeam)
 */
@property (nonatomic, strong) AdobePublishProfile * projectOwnerProfile;

@end

NS_ASSUME_NONNULL_END
