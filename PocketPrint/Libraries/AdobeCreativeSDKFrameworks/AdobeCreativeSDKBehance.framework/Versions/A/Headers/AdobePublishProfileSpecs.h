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
 `AdobePublishProfileSpecs` wraps all fields available for editing profiles on the Behance network.
 
 All fields are optional. If set, `city` and `state` require a `country`. Empty/nil fields will remove the existing values.
 */

@interface AdobePublishProfileSpecs : NSObject

#pragma mark - Optional Overrides

/**
 UIImage to be used as the profile avatar image.
 @warning Any images larger than 276x276 will be center cropped to fit
 */
@property (nonatomic, strong, nullable) UIImage * avatar;

/**
 The URL of the avatar to use for the user's profile. Note that if `avatar` is supplied, it will take precedence over `avatarURL`.
 */
@property (nonatomic, strong, nullable) NSURL * avatarURL;

/**
 First name of the user who's profile is being edited.
 */
@property (nonatomic, copy, nullable) NSString * firstName;

/**
 Last name of the user who's profile is being edited.
 */
@property (nonatomic, copy, nullable) NSString * lastName;

/**
 Occupation or job title of the user who's profile is being edited.
 */
@property (nonatomic, copy, nullable) NSString * occupation;

/**
 Company name of the user who's profile is being edited.
 */
@property (nonatomic, copy, nullable) NSString * company;

/**
 Country for the location of the user who's profile is being edited.
 @warning Required if `city` and/or `state` are set
 */
@property (nonatomic, copy, nullable) NSString * country;

/**
 State, province, or territory for the location of the user who's profile is being edited.
 @warning Requires a valid `country`
 */
@property (nonatomic, copy, nullable) NSString * state;

/**
 City for the location of the user who's profile is being edited.
 @warning Requires a valid `country`
 */
@property (nonatomic, copy, nullable) NSString * city;

/**
 Website URL of the user who's profile is being edited.
 @warning Must begin with "http://" "https://" or "www." If not included, "http://" will be automatically prepended
 */
@property (nonatomic, copy, nullable) NSString * website;

/**
 AVCaptureSessionPreset for camera capture of avatars. Defaults to AVCaptureSessionPresetMedium.
 */
@property (nonatomic, strong) NSString * cameraCaptureSessionPreset;

@end

NS_ASSUME_NONNULL_END
