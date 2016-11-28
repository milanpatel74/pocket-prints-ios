/******************************************************************************
*
* ADOBE CONFIDENTIAL
* ___________________
*
* Copyright 2016 Adobe Systems Incorporated
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

#ifndef AdobeAssetLibraryItemLookHeader
#define AdobeAssetLibraryItemLookHeader

#import <AdobeCreativeSDKAssetModel/AdobeAssetLibraryItem.h>

@class AdobeAssetFile;

#define IsAdobeAssetLibraryItemLook(item) ( [item isKindOfClass:[AdobeAssetLibraryItemLook class]])

/**
 * Represents a Look asset within a Creative Cloud Library.
 */
@interface AdobeAssetLibraryItemLook : AdobeAssetLibraryItem

@property (strong, nonatomic, readonly) AdobeAssetFile *look;
@property (strong, nonatomic, readonly) AdobeAssetFile *rendition;
@property (assign, nonatomic, readonly) NSUInteger renditionHeight;
@property (assign, nonatomic, readonly) NSUInteger renditionWidth;

@end

#endif
