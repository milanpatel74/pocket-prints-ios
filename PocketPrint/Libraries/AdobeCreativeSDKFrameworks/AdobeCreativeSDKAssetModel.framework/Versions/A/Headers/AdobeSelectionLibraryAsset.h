/******************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 * Copyright 2014 Adobe Systems Incorporated
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

#ifndef AdobeSelectionLibraryAssetHeader
#define AdobeSelectionLibraryAssetHeader

#import <Foundation/Foundation.h>

#import <AdobeCreativeSDKAssetModel/AdobeSelection.h>

/**
 * A utility to help determine if an item is an AdobeSelectionLibraryAsset.
 */
#define IsAdobeSelectionLibraryAsset(item) ([item isKindOfClass:[AdobeSelectionLibraryAsset class]])

/**
 * Holds information about the items that are selected by a user from a library.
 */
@interface AdobeSelectionLibraryAsset : AdobeSelection

/**
 * Contains the IDs of AdobeAssetLibraryItem3DElement instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selected3DElementIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemBrush instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedBrushIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemCharacterStyle instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedCharacterStyleIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemColor instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedColorIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemColorTheme instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedColorThemeIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemImage instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedImageIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemLayerStyle instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedLayerStyleIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemLook instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedLookIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemPattern instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedPatternIDs;

/**
 * Contains the IDs of AdobeAssetLibraryItemVideo instances selected from a library.
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *selectedVideoIDs;

@end

#endif
