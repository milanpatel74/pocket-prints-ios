/*************************************************************************
* ADOBE CONFIDENTIAL
* ___________________
*
*  Copyright 2015 Adobe Systems Incorporated
*  All Rights Reserved.
*
* NOTICE:  All information contained herein is, and remains
* the property of Adobe Systems Incorporated and its suppliers,
* if any.  The intellectual and technical concepts contained
* herein are proprietary to Adobe Systems Incorporated and its
* suppliers and are protected by all applicable intellectual property 
* laws, including trade secret and copyright laws.
* Dissemination of this information or reproduction of this material
* is strictly forbidden unless prior written permission is obtained
* from Adobe Systems Incorporated.
**************************************************************************/

#import <UIKit/UIKit.h>

@class AdobeColorViewController;

/**
 * Defines the interface for the delegate of the AdobeColorViewController
 */
@protocol AdobeColorPickerControllerDelegate<NSObject>
@optional

/**
 * The color picker will call this method when the color is changing based on live user input.
 *
 * This is useful if the application UI needs to update live with user's input. This callback 
 * must be quick.
 *
 * @param color The color has been set.
 */
- (void)colorPickerControllerColorChanged:(UIColor *)color;

/**
 * The color picker will call this method when the color has been set by the user.
 *
 * The performance of this delegate does not impact the fluidity of control.
 *
 * @param color The color that has been changed.
 */
- (void)colorPickerControllerColorSet:(UIColor *)color;

/**
 * The color picker will call this method when it has been dismissed.
 *
 * @param vc The color view controller that has been dismissed.
 */
- (void)dismissColorPickerController:(AdobeColorViewController *)vc;

/**
 * The color picker will call this method when the user has chosen to clear the color history.
 */
- (void)colorPickerColorHistoryCleared;

/**
 * The color picker will call this method when it has been dismissed and the Cancel button is hit.
 * @param vc The color view controller that has been cancelled.
 */
- (void)colorPickerControllerDidCancel:(AdobeColorViewController *)vc;

@end
