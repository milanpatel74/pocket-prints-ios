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
 **************************************************************************/

#import <UIKit/UIKit.h>
#import <AdobeCreativeSDKColor/AdobeColorPickerControllerDelegate.h>

@class AdobeColorTheme;

/**
 * Represents the view options supported in the color picker.
 */
typedef NS_OPTIONS (NSUInteger, AdobeColorPickerViews)
{
    /** The color picker view */
    AdobeColorPickerViewPicker  = 1,
    /** The application and community themes view */
    AdobeColorPickerViewLibraries   = 1 << 1,
    /** The design libraries view */
    AdobeColorPickerViewThemes      = 1 << 2
};

/**
 * An enum for setting the picker types supported by the color picker.
 */
typedef NS_OPTIONS (NSUInteger, AdobeColorPickerTypes)
{
    /** The Wheel Color Picker */
    AdobeColorPickerWheelView = 1,
    /** The RGB Color Picker */
    AdobeColorPickerRGBView = 1 << 1,
    /** The CMYK Color Picker */
    AdobeColorPickerCMYKView = 1 << 2,
    /** The History picker view */
    AdobeColorPickerHistoryView=  1 << 3
};

/**
 * An enum for setting the initial picker type in the color picker.
 */
typedef NS_ENUM (NSUInteger, AdobeColorPickerInitialPicker)
{
    /** The Color Wheel picker view */
    AdobeColorPickerWheel = 0,
    /** The RGB picker view */
    AdobeColorPickerRGB = 1,
    /** The CMYK picker view */
    AdobeColorPickerCMYK = 2,
    /** The History picker view */
    AdobeColorPickerHistory = 3
};

/**
 * An enum for setting the initial view in the color picker.
 */
typedef NS_ENUM (NSUInteger, AdobeColorPickerInitialView)
{
    /** The color wheel view */
    AdobeColorPickerColorPicker          = 0,
    /** The application and community themes view */
    AdobeColorPickerColorLibraries      = 1,
    /** The design libraries view */
    AdobeColorPickerColorThemes         = 2
};


/**
 * Represents the color picker options in the color controller.
 *
 * The default will be both single and harmony rules.
 */
typedef NS_OPTIONS (NSUInteger, AdobeColorHarmonyOptions)
{
    /** Harmony value color wheel selections with the exception of single color */
    AdobeColorHarmonyRules          = 1,
    /** Single value color wheel selection */
    AdobeColorSingleColorRule       = 1 << 1
};

/**
 * The color harmony types to display in the harmony selector.
 * If the AdobeColorSingleColorRule only is set for the harmony options, these
 * values are ignored.
 */
typedef NS_ENUM (NSUInteger, AdobeColorHarmony)
{
    /** One single color wheel selection, one value */
    AdobeColorSingleColor              = 0,
    /** Five analagous color values */
    AdobeColorAnalogous,
    /** Five monochromatic color values */
    AdobeColorMonochromatic,
    /** Five triadic color values */
    AdobeColorTriad,
    /** Five complimentary color values */
    AdobeColorComplementary,
    /** Five compound/split complimentary color values*/
    AdobeColorCompound,
    /** One single color wheel selection, five shades */
    AdobeColorShades,
    /** Five completely custom color values */
    AdobeColorCustom
};


/**
 * The main entry point for the color component. To use the color component, create an instance of 
 * AdobeColorViewController and either present in a UIPopoverController on iPad or present directly 
 * on iPhone. The color view controller will call back the delegate with appropriate events.
 */
@interface AdobeColorViewController : UIViewController

/**
 * The AdobeColorPickerControllerDelegate delegate object for handling color change events.
 */
@property (nonatomic, weak) id<AdobeColorPickerControllerDelegate> delegate;

/**
 * The application specific color themes. These themes will display in the Themes tab above the community
 * themes associated with the user.
 * 
 * An NSMutableArray of AdobeColorTheme objects.
 * 
 * Please refer to AdobeCreativeSDKAssetModel/AdobeColorTheme.h for more information.
 */
@property (nonatomic, strong) NSArray *appThemes;

/**
 * Initial color set in the color wheel picker on launch.
 *
 * Is [UIColor blackColor] by default.
 */
@property (nonatomic, strong) UIColor *initialColor;

/**
 * Reflects the color currently selected by the color view.
 */
@property (nonatomic, readonly, strong) UIColor *currentColor;

/**
 * The design library ID to display by default in the libraries view.
 *
 * Defaults to nil and will display a user message.
 */
@property (nonatomic, copy) NSString *defaultLibraryId;

/**
 * The color picking options available.
 *
 * The default value is (AdobeColorPickerViewPicker | AdobeColorPickerViewExplore | AdobeColorPickerViewColorServices).
 *
 * @see AdobeColorPickerViews
 */
@property (nonatomic, assign) AdobeColorPickerViews colorPickerViewOptions;

/**
 * Which view is displayed on launch of the color picker.
 *
 * The default value is AdobeColorPickerColorPicker.
 *
 * @see AdobeColorPickerInitialView.
 */
@property (nonatomic, assign) AdobeColorPickerInitialView initialColorPickerView;

/**
 * Which view is displayed on launch of the color picker.
 *
 * The default value is the value set in initialColorPickerView.
 *
 * @see AdobeColorPickerInitialView.
 */
@property (nonatomic, assign, readonly) AdobeColorPickerInitialView currentColorPickerView;

/**
 * Whether the color picker view allows harmony selection, single color selection, or both.
 *
 * The default value is (AdobeColorHarmonyRules | AdobeColorSingleColorRule).
 *
 * @see AdobeColorHarmonyOptions.
 */
@property (nonatomic, assign) AdobeColorHarmonyOptions harmonyRuleOptions;

/**
 * If allowing color harmony selection, which color harmony mode is set by default. This
 * option will be ignored if harmonyOptions are set to AdobeColorSingleColorRule alone.
 *
 * The default value is AdobeColorSingleColor. If the harmonyRuleOptions are set to
 * AdobeColorHarmonyRules only, the default is AdobeColorAnalogous.
 *
 * @see AdobeColorHarmony.
 */
@property (nonatomic, assign) AdobeColorHarmony initialHarmonyRule;

/**
 * The color picking types available.
 *
 * The default value is (AdobeColorPickerWheelView | AdobeColorPickerRGBView | AdobeColorPickerCMYKView | AdobeColorPickerHistoryView).
 *
 * @see AdobeColorPickerTypes
 */
@property (nonatomic, assign) AdobeColorPickerTypes colorPickerTypes;

/**
 * Which picker type is displayed on launch of the color picker. This can be the 
 * color wheel, RGB, CMYK, and History picker.
 *
 * The default value is AdobeColorPickerWheel.
 *
 * @see AdobeColorPickerInitialPicker.
 */
@property (nonatomic, assign) AdobeColorPickerInitialPicker initialPickerType;

/**
 * Which picker type has been chosen by the user.
 *
 * The default value is the value set by initialPickerType.
 *
 * @see AdobeColorPickerInitialPicker.
 */
@property (nonatomic, assign, readonly) AdobeColorPickerInitialPicker currentPickerType;


/**
 * A utility that indicates whether the color picker type is available based on the initial settings.
 * 
 * @param colorPickerType The color picker type to test for
 */
- (BOOL)isColorPickerOptionAvailable:(AdobeColorPickerViews)colorPickerType;

/*
 * Appends the array of colors to the existing color history.
 *
 * @param colors An NSArray of UIColor objects.
 */
- (void)appendToColorHistory:(NSArray *)colors;

/**
 * Overwrites the color history collection with the array specified by colors. 
 *
 * @param colors An NSArray of UIColor objects.
 */
- (void)setColorHistory:(NSArray *)colors;

/**
 * Returns an array of UIColor objects which represents the color history.
 *
 * @return An NSArray containing one or more of the UIColor objects displayed in the color view's history.
 */
- (NSArray *)colorHistory;

/**
 * Sets whether to show the title header on both iPad and iPhone. This
 * is useful if the clients want to insert their own tile/navigation bar.
 *
 * YES by default.
 *
 * @param showHeader whether or not to show the header.
 */
- (void)setShowTitleHeader:(BOOL)showHeader;

/**
 * Performs the same operations as selecting the cancel button
 * will perform if the color controller manages the navigation bar.
 *
 * This routine is useful for clients who wish to implement their
 * own navigation/title bar for the color component.
 */
- (void)cancelChanges;

/**
 * Performs the same operations as selecting the done button
 * will perform if the color controller manages the navigation bar.
 *
 * This routine is useful for clients who wish to implement their
 * own navigation/title bar for the color component.
 */
- (void)commitChanges;

@end
