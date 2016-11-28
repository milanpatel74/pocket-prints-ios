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

#ifndef AdobeAssetLibraryItemStockVideoHeader
#define AdobeAssetLibraryItemStockVideoHeader

#import <Foundation/Foundation.h>

#import <AdobeCreativeSDKAssetModel/AdobeAssetLibraryItemVideo.h>

@interface AdobeAssetLibraryItemStockVideo : AdobeAssetLibraryItemVideo

@property (strong, nonatomic, readonly) NSURL *assetURL;
@property (assign, nonatomic, getter = isLicensed, readonly) BOOL licensed;

@end

#endif
