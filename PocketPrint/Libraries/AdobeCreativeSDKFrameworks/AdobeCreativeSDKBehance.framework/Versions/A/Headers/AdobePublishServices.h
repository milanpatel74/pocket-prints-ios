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

/**
 `AdobePublishPrivacyLevel` identifies the privacy settings for content on the Behance network
 */
typedef NS_ENUM(NSInteger, AdobePublishPrivacyLevel) {
    /**
     `AdobePublishPrivacyLevelPublic` means content is visible to everyone
     */
    AdobePublishPrivacyLevelPublic = 0,
    
    /**
     `AdobePublishPrivacyLevelPrivate` means content is visible to only the owner
     */
    AdobePublishPrivacyLevelPrivate = 1,
    
    /**
     `AdobePublishPrivacyLevelTeams` means content is visible to members of the owner's teams.
     */
    AdobePublishPrivacyLevelTeams = 2
};

/**
 `AdobePublishMatureAccess` identifies access restrictions for viewing mature content
 */
typedef NS_ENUM(NSInteger, AdobePublishMatureAccess) {
    /**
     Mature content viewing is allowed
     */
    AdobePublishMatureAccessAllowed = 0,
    
    /**
     Mature content is restricted because the user is logged out
     */
    AdobePublishMatureAccessRestrictedLoggedOut = 1,
    
    /**
     Mature content is restricted by the user's geographic location
     */
    AdobePublishMatureAccessRestrictedGeo = 2,
    
    /**
     Mature content is restricted by the user's age
     */
    AdobePublishMatureAccessRestrictedAge = 3,
    
    /**
     Mature content is restricted by the user's preference
     */
    AdobePublishMatureAccessRestrictedSafe = 4
};

NS_ASSUME_NONNULL_END
