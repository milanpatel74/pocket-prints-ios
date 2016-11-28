//
//  POPMediaItem.h
//  Popstagram
//
//  Created by Mitchell Porter on 8/24/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "Mantle.h"

@interface POPMediaItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSURL *thumbnailImageUrl;
@property (nonatomic, readonly) NSURL *lowResolutionImageUrl;
@property (nonatomic, readonly) NSURL *standardResolutionImageUrl;
@property (nonatomic) UIImage *thumbnailImage;
@property (nonatomic) UIImage *lowResolutionImage;
@property (nonatomic) UIImage *standardResolutionImage;
@property (nonatomic, readonly) NSString *username;
@property(nonatomic) int count;

@end
