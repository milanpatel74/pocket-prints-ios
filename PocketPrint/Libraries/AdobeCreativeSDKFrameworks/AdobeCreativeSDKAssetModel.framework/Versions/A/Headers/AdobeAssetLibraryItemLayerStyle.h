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

#ifndef AdobeAssetLibraryItemLayerStyleHeader
#define AdobeAssetLibraryItemLayerStyleHeader

#import <AdobeCreativeSDKAssetModel/AdobeAssetFile.h>
#import <AdobeCreativeSDKAssetModel/AdobeAssetLibraryItem.h>

#define IsAdobeAssetLibraryItemLayerStyle(item) ( [item isKindOfClass: [AdobeAssetLibraryItemLayerStyle class]])

/**
 * AdobeAssetLibraryItemLayerStyle represents a layer style item within a library.
 */
@interface AdobeAssetLibraryItemLayerStyle : AdobeAssetLibraryItem

@property (readonly, nonatomic, strong) AdobeAssetFile *layer;
@property (readonly, nonatomic, strong) AdobeAssetFile *rendition;
@property (readonly, nonatomic, assign) CGFloat renditionHeight;
@property (readonly, nonatomic, assign) CGFloat renditionWidth;

@end

#endif
