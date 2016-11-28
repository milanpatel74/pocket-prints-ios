//
//  NSString+GetSizeWithFont.m
//  FirstTimeScreen
//
//  Created by Minh Quan on 30/07/13.
//  Copyright (c) 2013 Appiphany. All rights reserved.
//

#import "NSString+GetSizeWithFont.h"

@implementation NSString (GetSizeWithFont)

-(CGSize) sizeForFont:(UIFont*) aFont {
    CGSize maximumSize = CGSizeMake(300, 9999);
    return [self sizeWithFont:aFont
               constrainedToSize:maximumSize
                   lineBreakMode:NSLineBreakByTruncatingTail];
}

-(CGSize) sizeForFont:(UIFont*) aFont withMaxSize:(CGSize) aSize {
    //CGSize maximumSize = CGSizeMake(width, 30);
    return [self sizeWithFont:aFont
            constrainedToSize:aSize
                lineBreakMode:NSLineBreakByTruncatingTail];
}

- (NSString *)stripTags
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[self length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.charactersToBeSkipped = NULL;
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    NSString *rtnStr = [NSString stringWithString:html];
    rtnStr = [rtnStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    rtnStr = [rtnStr stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    rtnStr = [rtnStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return html;
}
@end
