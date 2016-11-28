/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2014 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 **************************************************************************/

#import "AdobePublishURLDelegate.h"

FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuDestinationBehanceWIP __deprecated_msg("The Work in Progress feature is being deprecated and will be removed in the near future.");
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuDestinationCopyCC __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuDestinationCopyToClipboard __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuDestinationPushToPhotoshop __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuDestinationPushToIllustrator __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuDestinationMore __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");


/** A string representing a key for the UIImage of the shareItem.
 * 
 * This key needs to be defined in the  NSDictionarys returned by the 
 * shareItemsForDestination: delegate method.
 * It is always required by the Behance and More destinations.
 * For the other destinations, it is required if the data key is not defined.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyImage __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the NSData of the shareItem.
 *
 * This key needs to be defined in the NSDictionarys returned by the
 * shareItemsForDestination: delegate method if the image key is not defined.
 * Not valid for the Behance or More destinations.
 * Ignored if the Image key is defined.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyData __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the NSString MIME type of the shareItem.
 *
 * This key needs to be defined when the data key is also defined.
 * Ignored if the image key is defined.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyDataType __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the AGCManfiest of the shareItem.
 *
 * Ignored if the Image key or Data key is defined.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyAGCManifest __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the array of AGC image components.
 *
 * This key needs to be defined when the AGC manifest key is also defined.
 * Ignored if the Image key or Data key is defined.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyAGCImageComponents __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the NSString file extension of the shareItem.
 *
 * This key needs to be defined when the data key or AGC manifest key is also defined.
 * Do not include a dot (.) prefix (@"svg" instead of @".svg").
 * Ignored if the image key is defined.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyDataExtension __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the NSString name of the shareItem.  
 * 
 * This key needs to be defined in the NSDictionarys returned by the 
 * shareItemsForDestination: delegate method for ALL destinations.  */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyName __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");


/** A string representing a key for the NSString Behance WIP ID of the shareItem.
 * This key needs to be defined in the NSDictionarys returned by the 
 * shareItemsForDestination: delegate method for the kAdobePublishShareMenuDestinationBehanceWIP 
 * destination if the item has already been published as a WIP (and therefore has a WIP ID) 
 * to allow for revision publishing.
 * 
 * This is also returned as a key in the returnedData dictionary of the
 * shareCompleted:items:returnedData:destination:error: method for the NSNumber
 * Behance WIP ID for kAdobePublishShareMenuDestinationBehanceWIP items. */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyWipId __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");


/** A string representing a key for an NSArray of NSString tags for the shareItem.  
 * You need to define this, if desired in the NSDictionarys returned by the 
 * shareItemsForDestination: delegate method for the 
 * kAdobePublishShareMenuDestinationBehanceWIP destination.  */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyProjectTags __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");


/** A string representing a key for the NSString FacebookAppId for the shareItem.  
 * You needs to define this in the NSDictionarys returned by the 
 * shareItemsForDestination: delegate method for the 
 * kAdobePublishShareMenuDestinationBehanceWIP destination.  */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyFacebookAppId __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");


/** A string representing a key for the NSNumber Behance Revision ID returned
 * in the returnedData dictionary of the
 * shareCompleted:items:returnedData:destination:error: method.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyRevisionId __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/** A string representing a key for the XMP metadata to insert into an uploaded image.
 */
FOUNDATION_EXPORT NSString *const kAdobePublishShareMenuItemKeyXMPMetadata __deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.");

/**
 * Delegate for handling AdobePublishShareMenu events.
 * 
 */
__deprecated_msg("AdobePublishShareMenuDelegate is being deprecated and will be removed in the near future.")
@protocol AdobePublishShareMenuDelegate <AdobePublishURLDelegate>

/**
 * This method is invoked when the share menu is about to be presented with 
 * the view and the dimension of the button that will present it. 
 * Clients can use this to update their custom open-in UIActivity instance if they have one. 
 * 
 * It can also be used to start a background process to create the image to be 
 * shared, if desired.
 * 
 * @param view The view for the share menu.
 * @param rect The CGRect containing the button.
 */
- (void) willPresentInView:(UIView*)view buttonRect:(CGRect)rect;

/**
 * This method is invoked on the dismissal of the share menu. 
 * Some shared destinations may lead to the share menu being dismissed and then a 
 * secondary view controller being displayed. If so, this method is invoked after the 
 * share menu is dismissed but before the secondary view controller is displayed.
 */
- (void) shareMenuDismissed;

/**
 * This method is invoked when the user selects a share destination from the share menu.
 * 
 * The delegate should return an NSArray of NSDictionary instances containing the
 * correct kAdobePublishShareMenuItemKeys and associated values for the items to be
 * shared to the shareDestination.
 * 
 * @param shareDestination one of the kAdobePublishShareMenuDestination NSStrings.
 */
- (NSArray*) shareItemsForDestination:(NSString*)shareDestination;

/**
 * This method is invoked when the share process begins. 
 * Warning: For some actions this may get called synchronously right before 
 * the below shareCompleted:item:returnedData:destination:error: method.
 *
 * @param destination one of the kAdobePublishShareMenuDestination NSStrings.
 */
- (void) shareStarted:(NSString*)destination;

/**
 * This method is invoked on completetion of a share menu action, as long as 
 * the user navigates far enough to start an action. If they simply dismiss 
 * a menu, this method may not be called.
 *
 * @return delegates should return an UIViewController to present the success view controller 
 * with. Return nil if no success view is desired.
 * 
 * @param completed YES if share completed successfully. 
 * NO if there was an error or the share was cancelled.
 * 
 * @param sharedItems the same array of dictionaries that was returned 
 * from the shareItemsForDestination call.
 * 
 * @param returnedData a dictionary with NSNumber values for the 
 * kAdobePublishShareMenuItemKeyWipId and kAdobePublishShareMenuItemKeyRevisionId keys when
 * an image is successfully shared to the KAdobePublishShareMenuDestinationBehanceWIP
 * destination. The first published version of a Behance WIP does not have a
 * revision ID so there will be no key/value pair in that case. returnedData will 
 * be nil if the WIP publish fails and for all other share destinations.
 * 
 * 
 * @param destination the destination to which the item was shared.  
 * This will either be one of the UIActivity defined destination constants,
 * kAdobePublishShareMenuDestinationBehanceWIP, or kAdobePublishShareMenuDestinationCopyCC.
 * Even if there is an error, this will still be the destination that the user
 * selected. Will be nil if the share sheet was dismissed before any 
 * share action was completed.
 * 
 * @param error will be nil if there is no error or the menu was dismissed.
 */
- (UIViewController *) shareCompleted:(BOOL)completed
                  items:(NSArray*)sharedItems
           returnedData:(NSDictionary*)returnedData
            destination:(NSString*)destination
                  error:(NSError*)error;

@optional

/**
 * This method is invoked when a share destination is chosen.
 * This optional method allows the client to intercept the share workflow 
 * and make any adjustments prior to the sharing actually taking place. 
 * The client must call the provided block on the main thread when it is ready 
 * to continue, passing in YES to continue sharing or NO to abort the sharing.
 * 
 * 
 * @param destination the destination that was chosen in the share menu.
 * 
 * @param continueSharing the block that must be called by the client
 * to indicate whether or not to continue sharing.
 */
- (void) shareDestinationChosen:(NSString*) destination
                continueSharing:(void(^)(BOOL)) continueSharing;

/**
 * This method can be used to determine which text to show for the PublishWIP menu item.  
 * The delegates should return YES if the item to be shared has already been published as a WIP
 * to Behance and this publish would lead to a revision.  
 * 
 * When YES is returned the Share Menu shows localized text such as "Publish a Revision".  
 * 
 * When NO is returned, or this method is not defined, the Share Menu shows localized text
 * such as "Get Feedback".
 */
- (BOOL) useRevisionTextInMenu;

/**
 * This method can be used to determine which text and functionality to use for
 * the Save to Creative Cloud menu item.
 *
 * When YES is returned the Share Menu shows localized text such as 
 * "Save PSD to Creative Cloud" and saves a PSD file of the provided image to the
 * Cloud.
 *
 * When NO is returned, or this method is not defined, the Share Menu shows 
 * localized text such as "Copy Image to Creative Cloud" and saves a PNG file of 
 * the provided image to the Cloud.
 */
- (BOOL) useSaveToPSD;

/**
 * The delegates should define this method if they want to provide their own array
 * of UIActivity instance(s) to handle sharing via the "More..." option in the
 * Share Menu. If the delegate does not define this method, the CreativeSDK will
 * use its built-in UIActivity. */
- (NSArray*) activityTypesForMore;

/** 
 * The delegates should define this method if they want to provide an array of
 * UIActivityType to exclude from the "More..." option in the Share Menu.  
 * If the delegate does not define this method, no items will be excluded.  */
- (NSArray*) excludedActivityTypesForMore;

@end

/**
 * This interface provides the ability to work with "Share" menus and assets.
 */
__deprecated_msg("AdobePublishShareMenu is being deprecated and will be removed in the near future.")
@interface AdobePublishShareMenu : NSObject

/**
 * This delegate can be used for interacting with the share menu.
 */
@property (weak, nonatomic) id<AdobePublishShareMenuDelegate> delegate;

/**
 * The RGB accent color used for the icons and UI elements. Alpha channel is ignored.
 *
 * Defaults to #FF321D
 */
@property (nonatomic,strong) UIColor *accentColor;

/**
 Clients may customize the popover background chrome of the share menu by providing a class which subclasses `UIPopoverBackgroundView`
 and which implements the required instance and class methods on that class.
 */
@property (nonatomic, readwrite, retain) Class popoverBackgroundViewClass;

/**
 * Provides a Singleton access to the AdobePublishShareMenu instance.
 */
+ (AdobePublishShareMenu*) sharedInstance;

/**
 * Invoking this method displays the Share Menu in a pop-up in the provided view controller's
 * view using the rectangle region as location of the button that the pop-up should point to,
 * along with the permitted arrow directions for the popover.
 * 
 * 
 * @param viewController The view controller for the share menu.
 * @param rect The CGRect containing the button.
 * @param arrowDirections Specifies in what direction the share menu can be displayed.
 */
- (void)            showIn:(UIViewController*)viewController
                  fromView:(UIView*)view
                  fromRect:(CGRect)rect
  permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;

/**
 * Invoking this method dismisses the Share Menu. This is usually done automatically 
 * when the user selects an item or taps outside the pop-up.
 */
- (void) dismiss;

@end
