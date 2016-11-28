//
//  Uploader.h
//  PocketPrint
//
//  Created by Quan Do on 5/05/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Uploader : NSObject {
    BOOL isStarted;
}

-(void) start;
+(Uploader*) shared;
@end
