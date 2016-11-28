//
//  ShippingAddressManagerViewController.m
//  PocketPrint
//
//  Created by Quan Do on 27/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "ShippingAddressManagerViewController.h"

#import "ShippingAddressViewController.h"
#import "OrderViewController.h"
#import "MoreViewController.h"
@interface ShippingAddressManagerViewController ()

@end

@implementation ShippingAddressManagerViewController

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
    // Do any additional setup after loading the view from its nib.
    tblView.backgroundColor =  UIColorFromRGB(0xe7e7e7);
    [self setScreenTitle:@"Shipping Address"];
    
//    if (_enableOrder) {
//        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDone)];
//        [btnDone setTintColor:UIColorFromRGB(0xe8320b)];
//        [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
//        self.navigationItem.leftBarButtonItem = btnDone;
//    }
//    else {
//        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnBack.frame = CGRectMake(0, 0, 30, 21);
//        [btnBack setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//        [btnBack addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//    }
    
//    UISegmentedControl *statFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done",[UIImage imageNamed:@"add_btn.png"], nil]];
//    [statFilter sizeToFit];
//    [statFilter setTintColor:[UIColor redColor]];
//    [statFilter addTarget:self
//     
//                         action:@selector(segmentControlUpdate:)
//     
//               forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:statFilter];
    
    // done
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(0, 0, 15, 16);
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(touchAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    
    //load data
    [self reloadFromDatabase];


}

-(void) viewDidLayoutSubviews {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 21);
    //[btnBack setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_IPHONE_6P) {
        UIBarButtonItem* sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        sp.width = -10;
        
        self.navigationItem.leftBarButtonItems = @[sp,[[UIBarButtonItem alloc] initWithCustomView:btnBack]];
    }
    else
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadFromDatabase];
    
    // show coach mark
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"coach5"]) {
        if (!_noCoachmark) {
            UIImage *imgCoach = [UIImage imageNamed:(IS_4INCHES)?@"coach_mark05-568h.png":@"coach_mark05.png"];
            if (IS_IPHONE_6P) {
                imgCoach = [UIImage imageNamed:@"coach_mark05-736h@3x.png"];
            }
            else
                if (IS_IPHONE_6) {
                    imgCoach = [UIImage imageNamed:@"coach_mark05-667h@2x.png"];
                }
            UIButton    *btnCoach = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnCoach setImage:imgCoach forState:UIControlStateNormal];
            btnCoach.frame = CGRectMake(0, 0, imgCoach.size.width, imgCoach.size.height);
            [btnCoach addTarget:self action:@selector(removeCoachmark:) forControlEvents:UIControlEventTouchUpInside];
            [(appDelegate).window addSubview:btnCoach];
        }

    }
    else
        if (arrAddrs.count == 0) {
            // go to shipping address
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self touchAdd];
            });
            
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeCoachmark:(UIButton*) aBtn {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"coach5"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.75 animations:^{
        aBtn.alpha = 0;
    } completion:^(BOOL finished) {
        aBtn.hidden = YES;
        [aBtn removeFromSuperview];
    }];
}

#pragma mark segment control
-(void) segmentControlUpdate:(UISegmentedControl*) segmentControl {
    
    if (segmentControl.selectedSegmentIndex == 0) {
        //
        [self touchDone];
    }
    else {
        //
        [self touchAdd];
    }
    
    segmentControl.selectedSegmentIndex = -1;
}
#pragma mark reload data

-(void) reloadFromDatabase {
    // load data
    NSString    *sql = @"SELECT * FROM shipping_addr";
    NSArray *arr = [[SqlManager defaultShare] doQueryAndGetArray:sql];
    // add
//    for (NSMutableDictionary *dict in arr) {
//        // add selection
//        //[dict setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
//    }
    
    if (!arrAddrs) {
        arrAddrs = [NSMutableArray new];
    }
    else
        [arrAddrs removeAllObjects];
    
    [arrAddrs addObjectsFromArray:arr];
    

    [tblView reloadData];
    

}

#pragma mark table delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // remove in database
    NSDictionary    *dict  =[arrAddrs objectAtIndex: indexPath.row];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM shipping_addr WHERE id=%@",[dict objectForKey:@"id"]];
    [[SqlManager defaultShare] doUpdateQuery:sql];
    
    // reload
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadFromDatabase];
    });
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary   *dict = [arrAddrs objectAtIndex:indexPath.row];
//    if (arrAddrs.count == 1 || [[dict objectForKey:@"default_addr"]boolValue]) {
//        [[[UIAlertView alloc] initWithTitle:nil message:@"You must have at least 1 shipping address and you can not unselect default address" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//        return;
//    }
//    BOOL    selected = [[dict objectForKey:@"selected"] boolValue];
//    [dict setObject:[NSNumber numberWithBool:!selected] forKey:@"selected"];
//    
//    // update database
//    // update sql
//    NSString *sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET  selected= '%@' WHERE id='%@'",(!selected)?@"true":@"false",[dict objectForKey:@"id"]];
//    
//    [[SqlManager defaultShare] doUpdateQuery:sql];
//    
//    // reload data
//    [tblView reloadData];
    // submit data now
    // update customer
    [[APIServices sharedAPIServices] updateCustomerWithName:[dict objectForKey:@"name"] andEmail:[dict objectForKey:@"email"] andPhone:[dict objectForKey:@"phone"] onFail:^(NSError *error) {
        DLog(@"fail to update customer %@",error.debugDescription);
    } onDone:^(NSError *error, id obj) {
        
    }];
    
    UIViewController *prevController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] -2];
    
    if ([prevController isKindOfClass:[MoreViewController class]]) {
        ShippingAddressViewController   *shippingAddrController = [[ShippingAddressViewController alloc] initWithNibName:@"ShippingAddressViewController" bundle:[NSBundle mainBundle]];
        shippingAddrController.dictCell = dict;
        [self.navigationController pushViewController:shippingAddrController animated:YES];
        return;
    }
    
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET default_addr='true',selected='true' WHERE id='%@'",
                     [dict objectForKey:@"id"]];
    
    [[SqlManager defaultShare] doUpdateQuery:sql];
    
    //if (aEnable) {
    // remove all other default
    sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET default_addr='false',selected='false' WHERE id!='%@'",[dict objectForKey:@"id"]];
    
    [[SqlManager defaultShare] doUpdateQuery:sql];
    
    // go back to show paypa;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (_delegate) {
        [_delegate showPaymentMedthod];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    //});
    
//    ShippingAddressViewController   *shippingAddrController = [[ShippingAddressViewController alloc] initWithNibName:@"ShippingAddressViewController" bundle:[NSBundle mainBundle]];
//    shippingAddrController.dictCell = dict;
//    [self.navigationController pushViewController:shippingAddrController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAddrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*NSMutableDictionary *dict  = [arrAddrs objectAtIndex:indexPath.row];
    
    if ([dict objectForKey:@"company_name"] != nil && [[dict valueForKey:@"company_name"] isEqualToString:@""] == NO)
    {
        return 151.0;
    }
    
    return 110.0;*/
    return 151.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    // remove all contents
//    for (UIView *aView in cell.contentView.subviews) {
//        [aView removeFromSuperview];
//    }
    
    NSMutableDictionary *dict  = [arrAddrs objectAtIndex:indexPath.row];
    NSString    *xibName = @"ShippingAddrCell";
    
//    if ([[dict objectForKey:@"default_addr"] boolValue]) {
//        xibName = @"SelectedShippingAddrCell";
//    }
    
    static NSString *identifier = @"ShippingAddrCell";
    ShippingAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
        UIViewController    *viewController = [[UIViewController alloc] initWithNibName:xibName bundle:[NSBundle mainBundle]];
        cell = (ShippingAddrCell*) viewController.view;
    }
    
    /*CGRect lbCompanyFrame = cell.lbCompany.frame;
    CGRect lbAddressFrame = cell.lbAddr.frame;
    
    if ([dict objectForKey:@"company_name"] == nil || [[dict valueForKey:@"company_name"] isEqualToString:@""])
    {
        cell.frame = CGRectMake(0, 0, 320, 110);
        cell.lbCompany.hidden = YES;
        cell.lbAddr.frame = lbCompanyFrame;
        cell.lbSuburb.frame = lbAddressFrame;
    }
    else
    {
        cell.frame = CGRectMake(0, 0, 320, 151);
        cell.lbCompany.hidden = NO;
        cell.lbCompany.text = [dict objectForKey:@"company_name"];
    }*/
    
    cell.data = dict;
    cell.lbCompany.text = [dict objectForKey:@"company_name"];
    cell.lbAddr.text = [dict objectForKey:@"street_addr"];
    cell.lbName.text =[dict objectForKey:@"name"];
    cell.lbSuburb.text = [NSString stringWithFormat:@"%@, %@ %@",[dict objectForKey:@"suburb"],[dict objectForKey:@"state"],[dict objectForKey:@"postal_code"]];
    if ([[dict objectForKey:@"default_addr"] boolValue]) {
        [cell setEnable:YES];
    }
    else
        [cell setEnable:NO];
    
    cell.delegate = self;
    if ([[dict objectForKey:@"default_addr"] boolValue]) {
        cell.defaultView.hidden = NO;
        [cell.btnDefaultAddr setImage:[UIImage imageNamed:@"star_icon_new_solid.png"] forState:UIControlStateNormal];
    }
    //config cell
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark actions
-(void) touchBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) touchAdd {
    ShippingAddressViewController   *shippingAddrController = [[ShippingAddressViewController alloc] initWithNibName:@"ShippingAddressViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:shippingAddrController animated:YES];
}

-(void) touchDone {
    [self touchBack];
    if (arrAddrs.count == 0) {
        //[[[UIAlertView alloc] initWithTitle:nil message:@"Please add an address" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_delegate showPaymentMedthod];
    });
    
//    OrderViewController *orderController = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:[NSBundle mainBundle]];
//    orderController.arrPhotoGroups = _arrPhotoGroups;
//    [self.navigationController pushViewController:orderController animated:YES];
}

#pragma mark

-(void) editShippingCellForCell:(ShippingAddrCell *)aCell {
    NSDictionary    *dict = (NSDictionary*) aCell.data;
    ShippingAddressViewController   *shippingAddrController = [[ShippingAddressViewController alloc] initWithNibName:@"ShippingAddressViewController" bundle:[NSBundle mainBundle]];
    shippingAddrController.dictCell = dict;
    [self.navigationController pushViewController:shippingAddrController animated:YES];
}

-(void) setDefaultAddr:(ShippingAddrCell *)aCell enable:(BOOL) aEnable {
    // make default
    NSDictionary    *dict = (NSDictionary*) aCell.data;
    NSString *sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET default_addr='true',selected='true' WHERE id='%@'",
           [dict objectForKey:@"id"]];
    
    [[SqlManager defaultShare] doUpdateQuery:sql];
    
    //if (aEnable) {
        // remove all other default
        sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET default_addr='false',selected='false' WHERE id!='%@'",[dict objectForKey:@"id"]];
        
        [[SqlManager defaultShare] doUpdateQuery:sql];
    //}
    
    [self reloadFromDatabase];
}
@end
