//
//  NSString+GetSizeWithFont.h
//  FirstTimeScreen
//
//  Created by Minh Quan on 30/07/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetSizeWithFont)
-(CGSize) sizeForFont:(UIFont*) aFont;
-(CGSize) sizeForFont:(UIFont*) aFont withMaxSize:(CGSize) aSize;
- (NSString *)stripTags;
@end
