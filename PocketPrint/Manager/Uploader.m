//
//  Uploader.m
//  PocketPrint
//
//  Created by Quan Do on 5/05/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "Uploader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+CropHeads.h"
#import "HomeViewController.h"
#import "Product.h"
#import "UIImage+Resize.h"

@interface UIImage (crop_by_frame)

-(UIImage*) cropForProductId:(NSString*) productId;

@end

@implementation UIImage (crop_by_frame)

-(UIImage*) cropForProductId:(NSString*) productId {
    CGSize size = [[HomeViewController getShared] getPhotoSizeFromProductId:productId];
    UIImage *img = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(size.width * 80, size.height*80) interpolationQuality:kCGInterpolationHigh];
    return img;
}
@end

@implementation Uploader

static Uploader *singleton;

-(id) init {
    self = [super init];
    if (self) {
        singleton = self;
        isStarted = NO;
    }
    
    return self;
}

+(Uploader*) shared {
    if (!singleton) {
        singleton = [[Uploader alloc] init];
    }
    
    return singleton;
}

-(void) start {
    DLog(@"Kcik start UPLOADER");
    if (isStarted) {
        DLog(@"UPLOADER is running! no need to kick start");
        return;
    }
    
    isStarted = YES;
    // start
    SqlManager  *sqlMan = [SqlManager defaultShare];
    // get all order
    NSString    *sql = @"SELECT * FROM order_list";
    NSArray *arrOrders = [sqlMan doQueryAndGetArray:sql];
    
    for (NSDictionary *dictOrder in arrOrders) {
        // scan order
        NSString    *orderId = [dictOrder objectForKey:@"id"];
        NSMutableArray  *arrUploadedId = [NSMutableArray new];
        NSMutableArray  *arrUploadData = [NSMutableArray new];
        
        // now look for images relative to this order
        sql = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE order_id='%@'",orderId];
        NSArray *arrImgs = [sqlMan doQueryAndGetArray:sql];
        NSString *filterSql = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE order_id='%@' and uploaded='false'",orderId];
        NSArray *imgToGo= [sqlMan doQueryAndGetArray:filterSql];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUploadingPhoto object:[NSNumber numberWithInt:imgToGo.count]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [imgToGo count];
        for (NSDictionary *dictImage in arrImgs) {
            if (![[dictImage objectForKey:@"uploaded"] boolValue]) {
                // check for image path
                NSString    *imgPath = [dictImage objectForKey:@"img_path"];
                // start upload
                if ([imgPath rangeOfString:@"assets-library://"].location == NSNotFound) {
                    // facebook or twitter
                    [[APIServices sharedAPIServices] uploadPhotoURL:imgPath onFail:^(NSError *error) {
                        DLog(@"fail to upload image %@",imgPath);
                        // restart
                        isStarted = NO;
                        [[Uploader shared] start];
                    } onDone:^(NSError *error, id obj) {
                        DLog(@"upload image %@ and get ID=%@",imgPath,[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
                        NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
                        
                        if (!error) {
                            if ([dict objectForKey:@"error"]) {
                                DLog(@"Upload iamge error => %@",dict);
                            }
                            else {
                                NSString *rtnImgId = [dict objectForKey:@"uid"];
                                if (rtnImgId && rtnImgId.length > 0) {
                                    // update id
                                    NSString *sql = [NSString stringWithFormat:@"UPDATE upload_image SET uploaded = 'true' , uploaded_id ='%@' WHERE id = '%@'",rtnImgId,[dictImage objectForKey:@"id"]];
                                    // update
                                    [sqlMan doUpdateQuery:sql];
                                }
                                else
                                    DLog(@"UID of upload photo is wrong! check again %@",dict);
                            }
                        }
                        else
                            DLog(@"Fail to upload photo with error %@",error.debugDescription);
                        // start again
                        isStarted = NO;
                        [[Uploader shared] start];
                    }];
                }
                else {
                    // photo asset
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        ALAssetRepresentation *rep = [myasset defaultRepresentation];
                        CGImageRef iref = [rep fullResolutionImage];
                        UIImage *img = [UIImage imageWithCGImage:iref];
                        if ([[dictImage objectForKey:@"square"] boolValue]) {
                            img = [img cropHeads];
                        }
                        
                        img = [img cropForProductId:[dictImage objectForKey:@"product_id"]];
                        
                        if (!img) {
                            DLog(@"NIL image found!!!!!!!");
                        }
                        // compresess
                        [[APIServices
                          sharedAPIServices] uploadPhoto:img
                                                              onFail:^(NSError *error) {
                                                                  DLog(@"fail to upload image %@",imgPath);
                                                                  // restart
                                                                  isStarted = NO;
                                                                  [[Uploader shared] start];
                                                              } onDone:^(NSError *error, id obj) {
                                                                  DLog(@"upload image %@ and get ID=%@",imgPath,obj);
                                                                  NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
                                                                  
                                                                  if (!error) {
                                                                      if ([dict objectForKey:@"error"]) {
                                                                          DLog(@"Upload iamge error => %@",dict);
                                                                      }
                                                                      else {
                                                                          NSString *rtnImgId = [dict objectForKey:@"uid"];
                                                                          if (rtnImgId && rtnImgId.length > 0) {
                                                                              // update id
                                                                              NSString *sql = [NSString stringWithFormat:@"UPDATE upload_image SET uploaded = 'true' , uploaded_id ='%@' WHERE id = '%@'",rtnImgId,[dictImage objectForKey:@"id"]];
                                                                              // update
                                                                              [sqlMan doUpdateQuery:sql];
                                                                          }
                                                                          else
                                                                              DLog(@"UID of upload photo is wrong! check again  %@",dict);
                                                                      }
                                                                  }
                                                                  else
                                                                      DLog(@"Fail to upload photo with error %@",error.debugDescription);
                                                                  // start again
                                                                  isStarted = NO;
                                                                  [[Uploader shared] start];
                                                              }];
                    };
                    
                    //
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                    };
                    
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:[NSURL URLWithString:imgPath]
                                   resultBlock:^(ALAsset *asset) {
                                       if (asset) {
                                           // OK
                                           resultblock(asset);
                                       }
                                       else
                                           // fail
                                       {
                                           // 8.1
                                           [assetslibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                                        usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                                            {
                                                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    if([result.defaultRepresentation.url isEqual:[NSURL URLWithString:imgPath]])
                                                    {
                                                        ///////////////////////////////////////////////////////
                                                        // SUCCESS POINT #2 - result is what we are looking for
                                                        ///////////////////////////////////////////////////////
                                                        resultblock(result);
                                                        *stop = YES;
                                                    }
                                                }];
                                            }
                                            
                                                                      failureBlock:^(NSError *error)
                                            {
                                                NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                                                failureblock(error);
                                                
                                            }];
                                       }
                                       
                                   }
                                  failureBlock:failureblock];
                    //isStarted = NO;
                }
                
                // exit ?
                return;
            }
            else {
                
                // add them to array
                [arrUploadedId addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictImage objectForKey:@"id"],@"id",[dictImage objectForKey:@"uploaded_id"],@"uploaded_id", nil]];
                [arrUploadData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dictImage objectForKey:@"product_id"],@"id",[dictImage objectForKey:@"quantity"],@"quantity",[dictImage objectForKey:@"uploaded_id"],@"image_id",([[dictImage objectForKey:@"framed"] boolValue])?@"true":@"false" ,@"frame",nil]];
            }
            
        }
        
        // if not exit - order is completed
        // get coupon and voucher
        sql = @"SELECT product_id as id,recipient_name,recipient_email,message,gift_value FROM gift";
        NSArray *arrGiftData = [sqlMan doQueryAndGetArray:sql];
        for (NSDictionary *dictTmp in arrGiftData) {
            NSMutableDictionary *dictGift = [[NSMutableDictionary alloc] initWithDictionary:dictTmp];
            [dictGift setObject:@"1" forKey:@"quantity"];
            [arrUploadData addObject:dictGift];
        }
        
        
        // update order
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrUploadData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        sql = [NSString stringWithFormat:@"UPDATE order_list SET products='%@'  WHERE id='%@'",jsonString,orderId];
        
        [sqlMan doUpdateQuery:sql];
        
        DLog(@"================= INFO =================");
        DLog(@"Uploader did upload : %d photos",arrUploadData.count);
        
        // send out order
        [[APIServices sharedAPIServices] createOrderWithPaypalTransactionToken:[dictOrder objectForKey:@"paypal_transaction_token"]
                                                                   stripeToken:[dictOrder objectForKey:@"stripe_transaction_token"]
                                                                      andTotal:[dictOrder objectForKey:@"total"]
                                                               ansShippingCost:[dictOrder objectForKey:@"shipping_cost"]
                                                                       andName:[dictOrder objectForKey:@"name"]
                                                                      andEmail:[dictOrder objectForKey:@"email"]
                                                                   andPromotionCode:[dictOrder objectForKey:@"voucher_id"]
                                                                      andPhone:[dictOrder objectForKey:@"phone"]
                                                                    andAddress:[dictOrder objectForKey:@"address"]
                                                                     andSuburb:[dictOrder objectForKey:@"surburb"]
                                                                      andState:[dictOrder objectForKey:@"state"]
                                                                   andPostCode:[dictOrder objectForKey:@"postcode"]
                                                               andProductArray:jsonString
                                                                        onFail:^(NSError *error) {
                                                                            DLog(@" create order error %@",error);
                                                                            
                                                                            // restart
                                                                            isStarted = NO;
                                                                            [[Uploader shared] start];
                                                                        }
                                                                        onDone:^(NSError *error, id obj) {
                                                                            DLog(@" creat order ok with result %@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
                                                                            
                                                                            NSDictionary    *resultDict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
                                                                            
                                                                            if ([resultDict objectForKey:@"error"]) {
                                                                                // error
                                                                                DLog(@"Error create order =>%@",resultDict);
                                                                            }
                                                                            else {
                                                                                // delete record now;
                                                                                for (NSDictionary *dictImg in arrUploadedId) {
                                                                                    NSString    *sql = [NSString stringWithFormat:@"DELETE FROM upload_image WHERE id='%@'",[dictImg objectForKey:@"id"]];
                                                                                    [sqlMan doUpdateQuery:sql];
                                                                                    NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                                                    NSString *documentsDirectory = [paths objectAtIndex:0];
                                                                                    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"images"];
                                         [fileManager removeItemAtPath:folderPath error:&error];                                  }
                                                                                
                                                                                // delete all gift record
                                                                                [sqlMan doUpdateQuery:@"DELETE FROM gift"];
                                                                                
                                                                                // delete order record
                                                                                NSString *sql = [NSString stringWithFormat:@"DELETE FROM order_list WHERE id='%@'",[dictOrder objectForKey:@"id"]];
                                                                                [sqlMan doUpdateQuery:sql];
                                                                                
                                                                                // notify now
                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUploaderDidCreateOrder object:nil];
                                                                                
                                                                                [appDelegate scheduleAlarmForDate:nil];
                                                                            }

                                                                            //restart
                                                                            isStarted = NO;
                                                                            [[Uploader shared] start];
                                                                        }];
        
        // exit
        return;
    }
    
    if (arrOrders.count == 0) {
        /// there may by no order but Uploader is being asked for upload selected images
        // now look for images relative to no where
        sql = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE order_id='' AND uploaded='false'"];
        NSArray *arrImgs = [sqlMan doQueryAndGetArray:sql];
        for (NSDictionary *dictImage in arrImgs) {
            DLog(@"=====> Working at phot id = %@",[dictImage objectForKey:@"id"]);
            if (![[dictImage objectForKey:@"uploaded"] boolValue]) {
                // check for image path
                NSString    *imgPath = [dictImage objectForKey:@"img_path"];
                // start upload
                if ([imgPath rangeOfString:@"assets-library://"].location == NSNotFound) {
                    // facebook or twitter
                    [[APIServices sharedAPIServices] uploadPhotoURL:imgPath onFail:^(NSError *error) {
                        DLog(@"fail to upload image %@",imgPath);
                        // restart
                        isStarted = NO;
                        [[Uploader shared] start];
                    } onDone:^(NSError *error, id obj) {
                        DLog(@"upload image %@ and get ID=%@",imgPath,[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
                        NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
                        
                        if (!error) {
                            if ([dict objectForKey:@"error"]) {
                                DLog(@"Upload iamge error => %@",dict);
                            }
                            else {
                                NSString *rtnImgId = [dict objectForKey:@"uid"];
                                if (rtnImgId && rtnImgId.length > 0) {
                                    // update id
                                    NSString *sql = [NSString stringWithFormat:@"UPDATE upload_image SET uploaded = 'true' , uploaded_id ='%@' WHERE id = '%@'",rtnImgId,[dictImage objectForKey:@"id"]];
                                    // update
                                    [sqlMan doUpdateQuery:sql];
                                }
                                else
                                    DLog(@"UID of upload photo is wrong! check again %@",dict);
                            }
                        }
                        else
                            DLog(@"Fail to upload photo with error %@",error.debugDescription);

                        // start again
                        isStarted = NO;
                        [[Uploader shared] start];
                    }];
                }
                else {
                    // photo asset
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                    {
                        ALAssetRepresentation *rep = [myasset defaultRepresentation];
                        CGImageRef iref = [rep fullResolutionImage];
                        UIImage *img = [UIImage imageWithCGImage:iref];
                        
                        // compresess
                        if ([[dictImage objectForKey:@"square"] boolValue]) {
                            img = [img cropHeads];
                        }
                        
                        // crop to size
                        img = [img cropForProductId:[dictImage objectForKey:@"product_id"]];
                        if (!img) {
                            DLog(@"NIL image found!!!!!!!");
                        }
                        [[APIServices sharedAPIServices] uploadPhoto:img
                                                              onFail:^(NSError *error) {
                                                                  DLog(@"fail to upload image %@",imgPath);
                                                                  // restart
                                                                  isStarted = NO;
                                                                  [[Uploader shared] start];
                                                              } onDone:^(NSError *error, id obj) {
                                                                  DLog(@"upload image %@ and get ID=%@",imgPath,obj);
                                                                  NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
                                                                  
                                                                  if (!error) {
                                                                      if ([dict objectForKey:@"error"]) {
                                                                          DLog(@"Upload iamge error => %@",dict);
                                                                      }
                                                                      else {
                                                                          NSString *rtnImgId = [dict objectForKey:@"uid"];
                                                                          if (rtnImgId && rtnImgId.length > 0) {
                                                                              // update id
                                                                              NSString *sql = [NSString stringWithFormat:@"UPDATE upload_image SET uploaded = 'true' , uploaded_id ='%@' WHERE id = '%@'",rtnImgId,[dictImage objectForKey:@"id"]];
                                                                              // update
                                                                              [sqlMan doUpdateQuery:sql];
                                                                          }
                                                                          else
                                                                              DLog(@"UID of upload photo is wrong! check again %@",dict);
                                                                      }
                                                                  }
                                                                  else
                                                                      DLog(@"Fail to upload photo with error %@",error.debugDescription);
                                                                  // start again
                                                                  isStarted = NO;
                                                                  [[Uploader shared] start];
                                                              }];
                    };
                    
                    //
                    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                    {
                        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
                        isStarted = NO;
                        [self start];
                    };
                    
                    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:[NSURL URLWithString:imgPath]
                                   resultBlock:^(ALAsset *asset) {
                                       if (asset) {
                                           // OK
                                           resultblock(asset);
                                       }
                                       else
                                           // fail
                                       {
                                           // 8.1
                                           [assetslibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                                            {
                                                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    if([result.defaultRepresentation.url isEqual:[NSURL URLWithString:imgPath]])
                                                    {
                                                        ///////////////////////////////////////////////////////
                                                        // SUCCESS POINT #2 - result is what we are looking for
                                                        ///////////////////////////////////////////////////////
                                                        resultblock(result);
                                                        *stop = YES;
                                                    }
                                                }];
                                            }
                                            
                                            failureBlock:^(NSError *error)
                                            {
                                                NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                                                failureblock(error);
                                                
                                            }];
                                       }
                                           
                                   }
                                  failureBlock:failureblock];
                    //isStarted = NO;
                }
                
                // exit ?
                return;
            }
            
        }
    }
    
    isStarted = NO;
    DLog(@"UPLOADER found nothing to do! Uploaded stopped");
}
@end
