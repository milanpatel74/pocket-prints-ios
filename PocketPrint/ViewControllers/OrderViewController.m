//
//  OrderViewController.m
//  PocketPrint
//
//  Created by Quan Do on 8/04/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "OrderViewController.h"
#import "UIImageViewWithData.h"
#import "Product.h"
#import "HomeViewController.h"
#import "CheckoutViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

#define PHOTO_HEIGHT  90
#define PHOTO_GAP 1
int ITEMS_PER_ROW;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ITEMS_PER_ROW = 3;
    if (IS_IPHONE_6P) {
        ITEMS_PER_ROW = 4;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneOrder) name:NotificationUploaderDidCreateOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitle:) name:NotificationUpdateUploadingPhoto object:nil];
    // Do any additional setup after loading the view from its nib.
    [self setScreenTitle:@"Uploading Photos"];
    
    //hide tabbar
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y += 48;
        self.tabBarController.tabBar.frame = frame;
    } completion:^(BOOL finished) {
        DLog(@"frmae = %@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
    }];
    
    // add spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.navigationItem.hidesBackButton = YES;
    
    arrPhotos = [NSMutableArray new];

    // combine photo
    
    int count = 0;
    for (NSDictionary *dictGroup in _arrPhotoGroups) {
        for (NSDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
//            if (count == 9) {
//                break;
//            }
            [arrPhotos addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[dictPhoto objectForKey:@"image"],@"image", [dictPhoto objectForKey:@"cropped_image"], @"cropped_image", nil]];
            count++;
        }
    }


    
    lbAddr.font = lbCompany.font = lbInfo.font = lbName.font = lbShip.font = lbSuburb.font = [UIFont fontWithName:@"MuseoSans-300" size:13];
    lbName.textColor = UIColorFromRGB(0xe9310b);
    
//    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDone)];
//    [btnDone setTintColor:UIColorFromRGB(0xe8320b)];
//    [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = btnDone;
//    self.navigationItem.hidesBackButton = YES;
    
    // get default
    NSString    *sql = @"SELECT * FROM shipping_addr WHERE default_addr='true'";
    NSArray *arr = [[SqlManager defaultShare] doQueryAndGetArray:sql];
    if (arr.count > 0) {
        NSDictionary    *dict = [arr objectAtIndex:0];
        lbName.text = [dict objectForKey:@"name"];
        lbCompany.text = [dict objectForKey:@"company_name"];
        lbAddr.text = [dict objectForKey:@"street_addr"];
        lbSuburb.text = [NSString stringWithFormat:@"%@, %@",[dict objectForKey:@"suburb"],[dict objectForKey:@"state"]];
        
        NSString *shipText  = @"Your order will be shipped to";

        
        // verify
        lbShip.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",shipText,lbName.text, lbCompany.text,lbAddr.text,lbSuburb.text];
        
        if (_arrPhotoGroups.count ==1) {
            NSDictionary    *dictCert = [_arrPhotoGroups objectAtIndex:0];
            if ([[dictCert objectForKey:@"type"] isEqualToString:@"certificate"]) {
                shipText = @"Your gift certificate has been purchased and will be emailed to the recipient at\n";
                lbShip.text = [NSString stringWithFormat:@"%@\n%@\n%@",shipText,lbName.text,[dictCert objectForKey:@"email"]];
            }
        }
    }
    
    // kick start uploader
    [self saveOrderToDatabase];
    
//    if (!IS_4INCHES) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            scrollView.contentSize = CGSizeMake(320, 455);
//        });
//        
//    }
    
//    CGRect frame = scrollView.frame;
//    frame.size.height =44;
//    scrollView.frame = frame;

}

-(void) updateTitle:(NSNotification*) nof {
    
    RUN_ON_MAIN_QUEUE((^{
        NSNumber *number = nof.object;
        [self setScreenTitle:[NSString stringWithFormat:@"%d photo%@ to upload",number.intValue,(number.intValue >1)?@"s":@""]];
    }));

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // now we calculate row
    int countInlineRows = (arrPhotos.count + ITEMS_PER_ROW - 1) / ITEMS_PER_ROW;
    
    return countInlineRows * (PHOTO_GAP + PHOTO_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"row = %lu",(arrPhotos.count + ITEMS_PER_ROW-1) / ITEMS_PER_ROW);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //cell.frame = CGRectMake(0, 0, tblView.frame.size.width, CELL_HEIGHT);
    
    
    // remove all contents
    for (UIView *aView in cell.contentView.subviews) {
        [aView removeFromSuperview];
    }
    
    // add header now
    //    NSMutableDictionary *dict = [arrPhotoGroups objectAtIndex:indexPath.row];
    //    NSMutableArray  *arrPhotos = [dict objectForKey:@"photos"];
    
    //    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, HEADER_HEIGHT)];
    //    headerView.backgroundColor = [UIColor whiteColor];
    //
    //    UILabel *lbDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 240, 22)];
    //    lbDate.font = [UIFont fontWithName:@"MuseoSans-300" size:14];
    //    lbDate.text = (_albumType != ALBUM_PHOTO)?[[dict objectForKey:@"fullDate"] uppercaseString]:[dict objectForKey:@"desc"];
    //    lbDate.textColor = [UIColor redColor];
    //
    //    [headerView addSubview:lbDate];
    //
    //    UILabel *lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 240, 22)];
    //    lbLocation.font = [UIFont fontWithName:@"MuseoSans-300" size:14];
    //    lbLocation.text = (_albumType != ALBUM_PHOTO)?[dict objectForKey:@"location"]:[dict objectForKey:@"price"];//@"Melbourne, Blackburn North";
    //    lbLocation.textColor = [UIColor lightGrayColor];
    //
    //    [headerView addSubview:lbLocation];
    //
    //    // circle
    //    UIImage *albumCircleImg = [UIImage imageNamed:@"grey_ring.png"];
    //    UIButton    *btnAlbumCircle = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnAlbumCircle.frame = CGRectMake(257, 8, albumCircleImg.size.width, albumCircleImg.size.height);
    //    [btnAlbumCircle setImage:albumCircleImg forState:UIControlStateNormal];
    //    [btnAlbumCircle addTarget:self action:@selector(touchAlbumCircle:) forControlEvents:UIControlEventTouchUpInside];
    //    [headerView addSubview:btnAlbumCircle];
    //-> end header
    
    
    //    [cell.contentView addSubview:headerView];
    
    // add new data
    /// get 2 cells
    
    UIView  *photoContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, ((arrPhotos.count + ITEMS_PER_ROW-1) / ITEMS_PER_ROW)*(PHOTO_HEIGHT + PHOTO_GAP))];
    
    photoContainerView.backgroundColor = [UIColor whiteColor];
    
    
    // scan the row
    for (int i = 0; i< arrPhotos.count; i++) {
        
        __block NSMutableDictionary *photoDict = [arrPhotos objectAtIndex:i];
        
        UIView  *aView = [[UIView alloc] initWithFrame:CGRectMake(PHOTO_GAP + (i % ITEMS_PER_ROW)*(PHOTO_HEIGHT + PHOTO_GAP),  (i / ITEMS_PER_ROW)*(PHOTO_HEIGHT+ PHOTO_GAP), PHOTO_HEIGHT, PHOTO_HEIGHT)];
        aView.backgroundColor = [UIColor redColor];
        aView.clipsToBounds = YES;
        // add image
        __block UIImageViewWithData *imgView = [[UIImageViewWithData alloc] initWithFrame:CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        //imgView.tag = TAG_PHOTO;
        // set container
        imgView.data = photoDict;
        
        NSString *imgPath = [photoDict objectForKey:@"cropped_image"];
        UIImage *img = nil;
        
        if (imgPath == nil)
        {
            img = [photoDict objectForKey:@"image"];
        }
        else
        {
            img = [UIImage imageWithContentsOfFile:imgPath];
        }
        
        imgView.image = img;
        
        /*if ([[photoDict objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
            imgView.image = [UIImage imageNamed:@"default_img_small.png"];
            // download now
            [[Downloader sharedDownloader] downloadWithCacheURL:[photoDict objectForKey:@"url"]
                                                     allowThumb:NO
                                             andCompletionBlock:^(NSData *data) {
                                                 UIImage *img = [UIImage imageWithData:data];
                                                 imgView.image = img;
                                                 [photoDict setObject:img forKey:@"image"];
                                             }
                                                andFailureBlock:^(NSError *error) {
                                                    DLog(@"Download error %@",error.debugDescription);
                                                }];
        }
        else
            imgView.image = [photoDict objectForKey:@"image"];*/
        
        
        [aView addSubview:imgView];
        
        
        // add button photo
        //        UIButton    *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btnPhoto.frame = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
        //        [btnPhoto addTarget:self action:@selector(touchPhoto:) forControlEvents:UIControlEventTouchUpInside];
        //        [aView addSubview:btnPhoto];
        
        // circle
        //        UIImage *photoCircleImg = [UIImage imageNamed:@"white_circle_small.png"];
        //        UIButton    *btnCircle = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btnCircle.frame = CGRectMake(65, 2, photoCircleImg.size.width, photoCircleImg.size.height);
        //        [btnCircle setImage:photoCircleImg forState:UIControlStateNormal];
        //        [btnCircle addTarget:self action:@selector(touchPhotoCircle:) forControlEvents:UIControlEventTouchUpInside];
        //        [aView addSubview:btnCircle];
        
        [photoContainerView addSubview:aView];
        //DLog(@"cell = %@ => i=%d",NSStringFromCGRect(aView.frame),i);
    }
    
    [cell.contentView addSubview:photoContainerView];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView  *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 68)];
//    containerView.backgroundColor = self.view.backgroundColor;
//
//    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, tblView.frame.size.width, 50)];
//    headerView.backgroundColor = [UIColor whiteColor];
//
//    [containerView addSubview:headerView];
//
//    return containerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 68;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return arrPhotoGroups.count;
//}

#pragma mark actions

-(void) touchDone {
    
    //[arrPhotos removeAllObjects];
    //[tblView reloadData];
    [[CheckoutViewController getShared] setData:[NSArray new]];
    // reset screen
    [[HomeViewController getShared] clearAllOrders];
   
   [self.navigationController popToRootViewControllerAnimated:NO];
    
[[HomeViewController getShared] showTabBar];
}


#pragma mark utilities
-(void) doneOrder {
    [self setScreenTitle:@"Order Placed"];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDone)];
    [btnDone setTintColor:UIColorFromRGB(0xe8320b)];
    [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnDone;
    self.navigationItem.hidesBackButton = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUploaderDidCreateOrder object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateUploadingPhoto object:nil];

}

-(void) saveOrderToDatabase {
    // get default aaddress
    //RUN_ON_BACKGROUND_QUEUE((^{
        SqlManager  *sqlMan = [SqlManager defaultShare];
        
        // get default addr
        NSString *sql = @"SELECT * FROM shipping_addr WHERE default_addr = 'true'";
        NSArray *arrAddr = [sqlMan doQueryAndGetArray:sql];
        NSDictionary    *dictAddr = [arrAddr objectAtIndex:0];
        
        // insert voucher and couping here
        DLog(@"Insert voucher and coupon");
//        for (int i=0; i<_arrPromotions.count; i++) {
//            NSDictionary    *dict = [_arrPromotions objectAtIndex:i];
//            NSString    *email = [dict objectForKey:@"email"];
//            sql = [NSString stringWithFormat:@"INSERT INTO promotions (order_id,promotion_code,promotion_email) VALUES ('%@','%@','%@')",orderId,[dict objectForKey:@"code"],(email)?email:@""];
//            [sqlMan doInsertQuery:sql];
//        }
        NSMutableArray  *arrTmpPromotion = [NSMutableArray new];
        for (int i=0; i<_arrPromotions.count; i++) {
            NSDictionary    *dict = [_arrPromotions objectAtIndex:i];
            NSMutableDictionary    *tmpDict = [NSMutableDictionary new];
            NSString    *email = [dict objectForKey:@"email"];
            if (!email)
                email = @"";
            [tmpDict setObject:email forKey:@"voucher_email"];
            [tmpDict setObject:[dict objectForKey:@"code"] forKey:@"promotion_code"];
            [arrTmpPromotion addObject:tmpDict];
        }

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrTmpPromotion options:NSJSONWritingPrettyPrinted error:nil];
        NSString *promotionString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // filter shipping cost
    NSString *shipFee = [[NSString alloc] initWithString:_shippingCost];
    if ([shipFee isEqualToString:@"Free"]) {
        shipFee = @"0";
    }
    else
        shipFee = [shipFee stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
        // create order
        sql = [NSString stringWithFormat:@"INSERT INTO order_list (address,voucher_id,coupon_id,email,name,paypal_transaction_token,stripe_transaction_token,phone,postcode,products,shipping_cost,state,surburb,total,voucher_email,company_name) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@')",
               [dictAddr objectForKey:@"street_addr"],
               promotionString,
               @"no coupon",
               [dictAddr objectForKey:@"email"],
               [dictAddr objectForKey:@"name"],
               _paypal_token,
               _stripe_token,
               [dictAddr objectForKey:@"phone"],
               [dictAddr objectForKey:@"postal_code"],
               @"product json string",
               shipFee,
               [dictAddr objectForKey:@"state"],
               [dictAddr objectForKey:@"suburb"],
               _totalCost,
               @"voucher email",
               [dictAddr objectForKey:@"company_name"]];
        [sqlMan doInsertQuery:sql];
        
        // get order id
        sql = @"SELECT last_insert_rowid() AS order_id FROM order_list LIMIT 1";
        NSArray *arrId = [sqlMan doQueryAndGetArray:sql];
        NSString    *orderId = [[arrId objectAtIndex:0] objectForKey:@"order_id"];
        
        

        
        
        // add image to database
        for (NSDictionary *dictGroup in _arrPhotoGroups) {
            Product *product = [dictGroup objectForKey:@"product"];
            // check if it is certificate
            // gift certificate ?
            if (![product.type isEqualToString:@"Gift Certificates"]) {
                // we dont need to add any image for gift certificate
                for (NSDictionary *dictPhoto in [dictGroup objectForKey:@"photos"]) {
                    //now we need to see if the image still there
                     NSString    *sql = [NSString stringWithFormat:@"SELECT * FROM upload_image WHERE original_imgPath='%@' AND product_id='%@'",[dictPhoto objectForKey:@"url_high"],product.uid];
                    NSArray *arrTmp = [sqlMan doQueryAndGetArray:sql];
                    
                    // we can asure that there will be only 1 record like that in the database
                    if (arrTmp.count > 0) {
                        // update current record with orderid
                        sql = [NSString stringWithFormat:@"UPDATE upload_image SET order_id='%@',quantity='%@',square='%@' WHERE original_imgPath='%@' AND product_id='%@'",orderId,[dictPhoto objectForKey:@"count"],(product.width == product.height)?@"true":@"false",[dictPhoto objectForKey:@"url_high"],product.uid];
                        [sqlMan doUpdateQuery:sql];
                    }
                    else
                    {
                        // get image and insert new record
                        sql = [NSString stringWithFormat:@"UPDATE upload_image SET order_id='%@',quantity='%@',square='%@' WHERE original_imgPath='%@' AND product_id='%@'",orderId,[dictPhoto objectForKey:@"count"],(product.width == product.height)?@"true":@"false",[dictPhoto objectForKey:@"url_high"],product.uid];
                    }
                }
            }
            else
            {
                // add to gift table
                NSString    *sql = [NSString stringWithFormat:@"INSERT INTO gift (product_id,recipient_name,recipient_email,message,gift_value) VALUES ('%@','%@','%@','%@','%@')",
                                    product.uid,
                                    [dictGroup objectForKey:@"name"],
                                    [dictGroup objectForKey:@"email"],
                                    [dictGroup objectForKey:@"message"],
                                    [NSString stringWithFormat:@"%d",[[dictGroup objectForKey:@"gift_value"] intValue]]];

                
                // add
                [sqlMan doInsertQuery:sql];
            }

        }
    
        // before kick start, delete other images
        sql = @"DELETE FROM upload_image WHERE order_id=''";
        [sqlMan doUpdateQuery:sql];
    
        // execute uploader
        [[Uploader shared] start];
        
        RUN_ON_MAIN_QUEUE(^{
//            [arrPhotos removeAllObjects];
            
        });
    //}));

}


@end
