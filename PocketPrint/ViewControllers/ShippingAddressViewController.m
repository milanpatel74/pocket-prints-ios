//
//  ShippingAddressViewController.m
//  PocketPrint
//
//  Created by Quan Do on 27/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "CheckoutViewController.h"
@interface ShippingAddressViewController ()

@end

@implementation ShippingAddressViewController

float keyboardHeight;

typedef enum ADDR_BOOK_RESULT{
    ADD_OK,
    NO_EMAIL,
    ALREADY_ADDED
} ADDR_BOOK_RESULT;


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
    
    [self enableKeyboardListerner];
    // Do any additional setup after loading the view from its nib.
    [self setScreenTitle:@"Shipping Address"];
    
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBack.frame = CGRectMake(0, 0,30, 21);
//    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//    [btnBack addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    // done
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDone)];
    [btnDone setTintColor:UIColorFromRGB(0xe8320b)];
    [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnDone;
    
    //preset place holder
    tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfPostCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfStreetAddr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street Address" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfSuburb.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Suburb" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfCompany.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Company Name (optional)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    tfName.font =tfState.font =tfPhone.font =tfEmail.font =tfCompany.font = tfPostCode.font = tfStreetAddr.font = tfSuburb.font = [UIFont fontWithName:@"MuseoSans-300" size:17.0f];
    tblView = [[UITableView alloc] initWithFrame:CGRectMake(15, 250, 290, 80) style:UITableViewStylePlain];
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    tblView.delegate = self;
    tblView.dataSource = self;
    tblView.alpha = 0.9f;
    tblView.hidden = YES;
    [self.view addSubview:tblView];
    
    lbDefault.font = [UIFont fontWithName:@"MuseoSans-300" size:16];
    _isDefault = YES;
    
    // populate data
    if (_dictCell) {
        tfName.text = [_dictCell objectForKey:@"name"];
        tfPostCode.text = [_dictCell objectForKey:@"postal_code"];
        tfStreetAddr.text = [_dictCell objectForKey:@"street_addr"];
        tfSuburb.text = [_dictCell objectForKey:@"suburb"];
        tfCompany.text = [_dictCell objectForKey:@"company_name"];
        tfPhone.text = [_dictCell objectForKey:@"phone"];
        tfEmail.text = [_dictCell objectForKey:@"email"];
        tfState.text = [_dictCell objectForKey:@"state"];
        if ([[_dictCell objectForKey:@"default_addr"] boolValue]) {
            DLog(@"Cell is DEFAULT");
            _isDefault = YES;
            [btnStar setImage:[UIImage imageNamed:@"star_icon_solid.png"] forState:UIControlStateNormal];
        }
        else {
            DLog(@"cell is not default");
            [btnStar setImage:[UIImage imageNamed:@"star_icon.png"] forState:UIControlStateNormal];
            _isDefault = NO;
        }
    }
    
    //scroll view
    //scrollView.contentSize = CGSizeMake(320, 615);
//    scrollView.contentOffset   = CGPointMake(0, 100);
    
    //arrfiels
    arrFields = @[tfName,tfCompany,tfPhone,tfEmail,tfStreetAddr,tfSuburb,tfState,tfPostCode];
    
    [tfName becomeFirstResponder];
    
    DLog(@"scorll size = %@",NSStringFromCGRect(scrollView.frame));
    
    screenHeight = SCREEN_HEIGHT;//(IS_4INCHES)?568:480;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });
    
    
}

-(void) viewDidLayoutSubviews {
    [toolBar setFrameWidth:self.view.frame.size.width];
    scrollView.contentSize = CGSizeMake(320, 650);
    
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

-(void) viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark scrollview delegate 
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != tblView) {
        tblView.hidden = YES;
    }
    
}

#pragma mark text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    int pos = (int)[arrFields indexOfObject:textField];
    //scrollView.contentOffset = CGPointMake(0, pos*110);
    if (textField != tfSuburb) {
        //[scrollView scrollRectToVisible:CGRectMake(0, pos*110, 320, 200) animated:YES];
        [scrollView setContentOffset:CGPointMake(0, pos*51) animated:YES];
    }
    else {
        //scrollView.contentOffset = CGPointMake(0, 256);
        [scrollView setContentOffset:CGPointMake(0, 256) animated:YES];
    }
    tfCurrTextField = textField;
    tfName.textColor =tfCompany.textColor =tfEmail.textColor =tfPhone.textColor =tfState.textColor = tfPostCode.textColor = tfStreetAddr.textColor = tfSuburb.textColor = [UIColor redColor];
    textField.textColor = [UIColor whiteColor];
    
    tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfPostCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfStreetAddr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street Address" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfSuburb.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Suburb" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfCompany.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Company Name (optional)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    [self highlightForTextField:textField];
    
    // move tool bar
    if (toolBar.hidden) {
        toolBar.hidden = NO;
        __block CGRect frame = toolBar.frame;
        frame.origin.y = screenHeight - frame.size.height;
        toolBar.frame = frame;
//        [UIView animateWithDuration:0.31 animations:^{
//            frame.origin.y = (IS_4INCHES)?308:220;
//            toolBar.frame = frame;
//        }];
    }
    
    if (tfCurrTextField != tfSuburb) {
        tblView.hidden = YES;
    }
    else {
        [arrSuburb removeAllObjects];
        [tblView reloadData];
        tblView.hidden = YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfSuburb) {
        NSString    *text =@"";
        if (range.length == 1) {
            // subtract
            text = [tfSuburb.text substringToIndex:tfSuburb.text.length -1];
        }
        else
            text = [tfSuburb.text stringByAppendingString:string];
        
        text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        //NSDictionary *dict = [self suggestedSuburbFromText:text];
        DLog(@"text => %@",text);
        //[self reloadSuburbTable:text];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadSuburbTable:) object:prevSearchStr];
        // clean previous request
        [self performSelector:@selector(reloadSuburbTable:) withObject:text afterDelay:0.2];
        prevSearchStr = text;
    }
    return YES;
}

#pragma mark Utility

-(void) reloadSuburbTable:(NSString*) aSeachText {
    tblView.hidden = NO;
    if (!arrSuburb) {
        arrSuburb = [NSMutableArray new];
    }
    // clear
    [arrSuburb removeAllObjects];
    
    if (aSeachText.length > 0) {
        // get sugestion group
        NSArray *arrResult = [self suggestedSuburbFromText:aSeachText];
        [arrSuburb addObjectsFromArray:arrResult];
    }

    [tblView reloadData];
    
    if (arrSuburb.count == 0) {
        tblView.hidden = YES;
    }
    // convert point
    CGRect rect = [scrollView convertRect:tfSuburb.frame toView:self.view];
    tblView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, SCREEN_HEIGHT - rect.origin.y - keyboardHeight - rect.size.height - 46);
}

-(void) highlightForTextField:(UITextField*) aTextField {
    imgViewName.image =imgViewCompany.image =imgViewEmail.image =imgViewPhone.image =imgViewState.image = imgViewPostCode.image = imgViewStreet.image = imgViewSuburb.image = [UIImage imageNamed:@"text_field.png"];
    if (aTextField == tfName) {
        imgViewName.image = [UIImage imageNamed:@"text_field_hover.png"];
        tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    else
        if (aTextField == tfStreetAddr) {
            imgViewStreet.image = [UIImage imageNamed:@"text_field_hover.png"];
            tfStreetAddr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street Address" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        }
        else
            if (aTextField == tfSuburb) {
                imgViewSuburb.image = [UIImage imageNamed:@"text_field_hover.png"];
                tfSuburb.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Suburb" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
            }
            else
                if (aTextField == tfState) {
                imgViewState.image = [UIImage imageNamed:@"text_field_hover.png"];
                tfState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
            }
            else
                if (aTextField == tfEmail) {
                    imgViewEmail.image = [UIImage imageNamed:@"text_field_hover.png"];
                    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                }
                else
                    if (aTextField == tfPhone) {
                        imgViewPhone.image = [UIImage imageNamed:@"text_field_hover.png"];
                        tfPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                    }
                    else
                        if (aTextField == tfCompany) {
                            imgViewCompany.image = [UIImage imageNamed:@"text_field_hover.png"];
                            tfCompany.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Company Name (optional)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                        }
                        else {
            imgViewPostCode.image = [UIImage imageNamed:@"text_field_hover.png"];
            tfPostCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        }
}

-(NSArray*) suggestedSuburbFromText:(NSString*) aSuburbName {
    SqlManager  *sqlMan = [SqlManager defaultShare];
    NSString    *sql = [NSString stringWithFormat:@"SELECT suburbs.* FROM suburbs INNER JOIN states ON suburbs.state_id = states.state_id WHERE suburb_name LIKE \"%%%@%%\"",aSuburbName];
    NSArray     *arrResult = [sqlMan doQueryAndGetArray:sql];
    return arrResult;
}

#pragma mark location 
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:0];
    // stop
    [locationManager stopUpdatingLocation];
    
    //location = [[CLLocation alloc] initWithLatitude:-37.7530516 longitude:145.0040497];
    // geocdoe
    CLGeocoder  *geoCode = [[CLGeocoder alloc] init];
    [geoCode reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //DLog(@"check GPS : %@",locationStr);
        if (placemarks) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //[self testPlaceMark:placemark];
           // tf = [NSString stringWithFormat:@"%@, %@",[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"City"]];
            //DLog(@"");
            NSDictionary    *addrDict = placemark.addressDictionary;
            
            __block NSString    *addrStr = [NSString stringWithFormat:@"%@",[addrDict objectForKey:@"Name"]];
            RUN_ON_MAIN_QUEUE(^{
                tfPostCode.text = placemark.postalCode;
                tfStreetAddr.text = addrStr;
                tfState.text = [addrDict objectForKey:@"State"];
                tfSuburb.text = [addrDict objectForKey:@"City"];
                tfPostCode.text = [addrDict objectForKey:@"ZIP"];
            });
        }
        
        if (error) {
            // check out
            //[self testPlaceMark:placemarks location:location andError:error];
            //locationStr = @"";
            [[[UIAlertView    alloc] initWithTitle:nil message:@"Can not determine your location" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] show];
        }
    }];
}

#pragma mark contact delegate
-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    [self contactPicker:picker shouldContinueAfterSelectingPerson:contact];
}


- (BOOL)contactPicker:(CNContactPickerViewController *)picker shouldContinueAfterSelectingPerson:(CNContact *)contact
{
    ADDR_BOOK_RESULT   result = [self addContactToList:contact];
    
    if (result == ALREADY_ADDED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"The contact has already been added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return NO;
    }
    NSString *namePrefix = contact.namePrefix;
    NSString *givenName =contact.givenName;
    NSString *nameSuffix = contact.nameSuffix;
    NSString *middleName = contact.middleName;
    NSString *lastName = contact.familyName;
    NSString *companyName = contact.organizationName;
    NSArray *mailArray = contact.emailAddresses;
    NSArray *addressArray = contact.postalAddresses;
    NSArray *contactArray = contact.phoneNumbers;
    if (!namePrefix) {
        namePrefix = @"";
    }
    
    if (!givenName) {
        givenName = @"";
    }
    if (!middleName) {
        middleName = @"";
    }
    
    if (!lastName) {
        lastName = @"";
    }
    if (!nameSuffix) {
        nameSuffix = @"";
    }
    if (!companyName) {
        companyName = @"";
    }
    
    if (addressArray.count)
    {
        CNLabeledValue *address = [addressArray objectAtIndex:0];
        CNPostalAddress *postalAddress = address.value;
        tfStreetAddr.text =   (NSString *) postalAddress.street;
        tfState.text = postalAddress.state;
        tfPostCode.text = postalAddress.postalCode;
    }
    if (contactArray.count)
    {
        CNLabeledValue *contactValue = [contactArray objectAtIndex:0];
        CNPhoneNumber *contact = contactValue.value;
        tfPhone.text = contact.stringValue;
        
    }
    
    if (mailArray.count > 0)
    {
        CNLabeledValue *mail = [mailArray objectAtIndex:0];
        
        NSLog(@"print label :%@",mail.value);
        
        tfEmail.text  = mail.value;
    }
    else
    {
        tfEmail.text = @"";
        
    }
    tfName.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ",namePrefix,givenName,middleName,lastName,nameSuffix];
    tfCompany.text = companyName;
    [self dismissViewControllerAnimated:YES completion:^{
        //        addrTblView.hidden = YES;
        //        [UIView animateWithDuration:0.35 animations:^{
        //            CGRect frame = searchView.frame;
        //            frame.origin.y = 9;
        //            searchView.frame = frame;
        //        }];
    }];
    
    return NO;
    
}

-(ADDR_BOOK_RESULT) addContactToList:(CNContact *)contact
{
    
    
    NSString *namePrefix = contact.namePrefix;
    NSString *givenName =contact.givenName;
    NSString *nameSuffix = contact.nameSuffix;
    NSString *middleName = contact.middleName;
    NSString *lastName = contact.familyName;
    NSArray *mailArray = contact.emailAddresses;
    
    if (!namePrefix) {
        namePrefix = @"";
    }
    if (!givenName) {
        givenName = @"";
    }
    if (!middleName) {
        middleName = @"";
    }
    
    if (!lastName) {
        lastName = @"";
    }
    if (!nameSuffix) {
        nameSuffix = @"";
    }
    if (!mailArray) {
        mailArray = @[@"None"];
    }
    
    NSString* email = nil;
    if (mailArray.count > 0)
    {
        CNLabeledValue *mail = [mailArray objectAtIndex:0];
        NSLog(@"print label :%@",mail.value);
        email = mail.value;
    }
    else
    {
        return NO_EMAIL;
        email = @"[None]";
        
    }
    
    return ADD_OK;
}



#pragma mark address book delegate
- (void)peoplePickerNavigationControllerDidCancel:

(ABPeoplePickerNavigationController *)peoplePicker

{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (BOOL)peoplePickerNavigationController:

(ABPeoplePickerNavigationController *)peoplePicker

      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    ADDR_BOOK_RESULT   result = [self addPersonToList:person];
    
    if (result == ALREADY_ADDED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"The contact has already been added" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return NO;
    }
//    else
//        if (result == NO_EMAIL) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Contact does not have email address" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alertView show];
//            return NO;
//        }
    //[tblView reloadData];
    
    // fetch data here
    ABMultiValueRef addr = ABRecordCopyValue(person,kABPersonAddressProperty);
    //CFArrayRef arr = ABMultiValueCopyArrayOfAllValues(addr);
    NSDictionary    *dict = (__bridge NSDictionary*)ABMultiValueCopyValueAtIndex(addr, 0);
    NSString    *addrStr = @"";
    if (dict) {
        addrStr =     [dict objectForKey:@"Street"];
//        [NSString stringWithFormat:@"%@, %@, %@",
//                       [dict objectForKey:@"Street"],
//                       [dict objectForKey:@"City"],
//                       [dict objectForKey:@"Country"]
//                       ];
    }

    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    NSString  *companyName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonOrganizationProperty);
    //NSString    *email = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonEmailProperty);
    if (!lastName) {
        lastName = @"";
    }
    
    if (!firstName) {
        firstName = @"";
    }
    
    ABMultiValueRef emailArr = ABRecordCopyValue(person,kABPersonEmailProperty);
    if (ABMultiValueGetCount(emailArr) >0) {
        tfEmail.text = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailArr, 0);
    }
    else
        tfEmail.text = @"";
    
    
    tfName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    tfStreetAddr.text = addrStr;
    tfPostCode.text = [dict objectForKey:@"ZIP"];
    tfState.text = [dict objectForKey:@"State"];
    tfCompany.text = companyName;
    
    // fetch data here
    ABMultiValueRef phoneArr = ABRecordCopyValue(person,kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneArr) > 0) {
        tfPhone.text = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneArr, 0);
    }
        else
            tfPhone.text = @"";

    
    [self dismissViewControllerAnimated:YES completion:^{
//        addrTblView.hidden = YES;
//        [UIView animateWithDuration:0.35 animations:^{
//            CGRect frame = searchView.frame;
//            frame.origin.y = 9;
//            searchView.frame = frame;
//        }];
    }];
    
    return NO;
    
}



- (BOOL)peoplePickerNavigationController:

(ABPeoplePickerNavigationController *)peoplePicker

      shouldContinueAfterSelectingPerson:(ABRecordRef)person

                                property:(ABPropertyID)property

                              identifier:(ABMultiValueIdentifier)identifier

{
    
    return NO;
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
}

-(ADDR_BOOK_RESULT) addPersonToList:(ABRecordRef)person {
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    
    if (!lastName) {
        lastName = @"";
    }
    
    if (!firstName) {
        firstName = @"";
    }
    
    NSString* email = nil;
    
    ABMultiValueRef emails = ABRecordCopyValue(person,kABPersonAddressProperty);
    // copt now
    
    int i = (int)ABMultiValueGetCount(emails);

    //DLog(@"adddre  = %@",addrStr);
    if (ABMultiValueGetCount(emails) > 0) {
        
        email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emails, 0);
        
        // verify
//        for (NSDictionary   *dict in arrAssistants) {
//            Assistant *assistant = [dict objectForKey:@"obj"];
//            if ([email isEqualToString:assistant.email]) {
//                return ALREADY_ADDED;
//            }
//        }
    } else {
        return NO_EMAIL;
        email = @"[None]";
        
    }
    
    
//    Assistant   *assistant = [[Assistant alloc] init];
//    NSString    *fullName = [firstName stringByAppendingFormat:@" %@",lastName];
//    NSString    *testName = [fullName stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (testName.length == 0) {
//        fullName = @"Unknown";
//    }
//    assistant.name = [fullName capitalizedString];
//    assistant.email = email;
//    
//    CFRelease(emails);
//    
//    // add
//    [self addLabelToBox:assistant];
    return ADD_OK;
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary   *dict = [arrSuburb objectAtIndex:indexPath.row];
    //
    tblView.hidden = YES;
    tfSuburb.text = [dict objectForKey:@"suburb_name"];
    
    tfPostCode.text = [dict objectForKey:@"suburb_post_code"];
    NSArray *arrStateTmp = [[SqlManager defaultShare] doQueryAndGetArray:[NSString stringWithFormat:@"SELECT * FROM states WHERE state_id='%@'",[dict objectForKey:@"state_id"]]];
    tfState.text = [[arrStateTmp objectAtIndex:0] objectForKey:@"state_name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSuburb.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ShippingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        // create new cell
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.frame = CGRectMake(0, 0, 320, 30);
    
    
    // remove all contents
    //    for (UIView *aView in cell.contentView.subviews) {
    //        [aView removeFromSuperview];
    //    }
    
    NSMutableDictionary *dict = [arrSuburb objectAtIndex:indexPath.row];
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"suburb_name"],[dict objectForKey:@"suburb_post_code"]];
    cell.textLabel.font = cell.detailTextLabel.font =[UIFont fontWithName:@"MuseoSans-300" size:13];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"suburb_name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"suburb_post_code"]];
    //config cell
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectedBackgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark actions
-(void) touchDone {
    // verify
    NSString    *missingElem = @"";
    BOOL        isError = NO;
    UITextField *tfError;
    if (tfName.text.length == 0) {
        isError = YES;
        missingElem = @"Name";
        tfError= tfName;
    }
    else
        if (tfStreetAddr.text.length == 0) {
            isError = YES;
            missingElem = @"Street Address";
            tfError= tfStreetAddr;
        }
        else
            if (tfSuburb.text.length == 0) {
                isError = YES;
                missingElem = @"Suburb";
                tfError= tfSuburb;
            }
            else
                if (tfPostCode.text.length == 0) {
                    isError = YES;
                    missingElem = @"Postcode";
                    tfError= tfPostCode;
                }
                else
                    if (tfEmail.text.length == 0) {
                        isError = YES;
                        missingElem = @"Email";
                        tfError= tfEmail;
                    }
                    else
                        if (tfState.text.length == 0) {
                            isError = YES;
                            missingElem = @"State";
                            tfError= tfState;
                        }
                        else
                            if (tfPhone.text.length == 0) {
                                isError = YES;
                                missingElem = @"Phone";
                                tfError= tfPhone;
                            }
    
    if (isError) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Please enter information for %@",missingElem] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        [tfError becomeFirstResponder];
        return;
    }
    
    // seek for state
//    NSString    *sql = [NSString stringWithFormat:@"SELECT states.state_short_name FROM states LEFT JOIN suburbs ON suburbs.state_id = states.state_id  WHERE suburbs.suburb_post_code='%@' AND suburbs.suburb_name='%@' LIMIT 1",tfPostCode.text,tfSuburb.text];

    NSString    *sql = [NSString stringWithFormat:@"SELECT states.state_short_name FROM states LEFT JOIN suburbs ON suburbs.state_id = states.state_id  WHERE suburbs.suburb_post_code='%@' LIMIT 1",tfPostCode.text];
    
    NSArray *arrState = [[SqlManager defaultShare] doQueryAndGetArray:sql];
    if (arrState.count ==0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Suburb or post code is not correct." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    NSString    *stateName = [[arrState objectAtIndex:0] objectForKey:@"state_short_name"];
    
    // resign first responder
    [tfCurrTextField resignFirstResponder];
    
    // save to database
    sql = [NSString stringWithFormat:@"INSERT INTO shipping_addr (name,street_addr,postal_code,selected,suburb,default_addr,state,company_name,phone,email) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                        [tfName.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
                        [tfStreetAddr.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
                        [tfPostCode.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
                        @"true",
                        [tfSuburb.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
                        (_isDefault)?@"true":@"false",stateName,
           tfCompany.text,
           tfPhone.text,
           tfEmail.text];
    
    
    if (_dictCell) {
        // update sql
        sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET name='%@',street_addr = '%@',postal_code = '%@', selected= '%@',suburb = '%@' , default_addr='%@' , state = '%@',company_name = '%@',phone = '%@',email = '%@' WHERE id='%@'",
               [tfName.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
               [tfStreetAddr.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
               [tfPostCode.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
               ([[_dictCell objectForKey:@"selected"] boolValue])?@"true":@"false",
               [tfSuburb.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
               (_isDefault)?@"true":@"false",stateName,
               tfCompany.text,
               tfPhone.text,
               tfEmail.text,
               [_dictCell objectForKey:@"id"]];
        
        [[SqlManager defaultShare] doUpdateQuery:sql];
        
        if (_isDefault) {
            // remove all other default
            sql = [NSString stringWithFormat:@"UPDATE shipping_addr SET default_addr='false' WHERE id!='%@'",[_dictCell objectForKey:@"id"]];
            
            [[SqlManager defaultShare] doUpdateQuery:sql];
        }

        DLog(@"Update shipping address");
    }
    else {
        if (_isDefault) {
            // remove all other default
            NSString *clearDefaultSql = [NSString stringWithFormat:@"UPDATE shipping_addr SET default_addr='false'"];
            
            [[SqlManager defaultShare] doUpdateQuery:clearDefaultSql];
        }
        [[SqlManager defaultShare] doInsertQuery:sql];
    }

    // update customer now
    [[APIServices sharedAPIServices] updateCustomerWithName:tfName.text andEmail:tfEmail.text andPhone:tfPhone.text onFail:^(NSError *error) {
        DLog(@"fail to update customer %@",error.debugDescription);
    } onDone:^(NSError *error, id obj) {
        
    }];
    
    if (_delegate) {
        [self.navigationController popViewControllerAnimated:NO];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchClose];
//            [_delegate showPaymentMedthod];
        [_delegate pushToShippingAdress];
        
        //});
        
    }
    else {

        NSArray *arrController = self.navigationController.viewControllers;

        UIViewController *controler = [arrController objectAtIndex:arrController.count-3];
        //[self.navigationController popToViewController:controler animated:YES];
        if ([controler isKindOfClass:[CheckoutViewController class]]) {
            [self.navigationController popViewControllerAnimated:NO];
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [controler performSelector:@selector(showPaypal) withObject:nil];
            });
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) touchBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) touchClose {
    [tfCurrTextField resignFirstResponder];
    tfName.textColor =tfCompany.textColor =tfEmail.textColor =tfPhone.textColor =tfState.textColor = tfPostCode.textColor = tfStreetAddr.textColor = tfSuburb.textColor = [UIColor redColor];
    //preset place holder
    tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfPostCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Postcode" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfStreetAddr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Street Address" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfSuburb.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Suburb" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfCompany.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Company Name (optional)" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    imgViewName.image =imgViewCompany.image =imgViewEmail.image =imgViewPhone.image =imgViewState.image = imgViewPostCode.image = imgViewStreet.image = imgViewSuburb.image = [UIImage imageNamed:@"text_field.png"];
    
    [UIView animateWithDuration:0.31 animations:^{
        CGRect frame = toolBar.frame;
        frame.origin.y = screenHeight - frame.size.height;
        toolBar.frame = frame;
    } completion:^(BOOL finished) {
        toolBar.hidden = YES;
    }];
}

-(IBAction) touchLocation {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

-(IBAction) touchNext {
//    if (tfCurrTextField == tfName) {
//        [tfStreetAddr becomeFirstResponder];
//    }
//    else
//        if (tfCurrTextField == tfStreetAddr) {
//            [tfSuburb becomeFirstResponder];
//        }
//        else
//            if (tfCurrTextField == tfSuburb) {
//                [tfPostCode becomeFirstResponder];
//            }
//            else
//                if (tfCurrTextField == tfPostCode) {
//                    [tfName becomeFirstResponder];
//                }
    int pos = [arrFields indexOfObject:tfCurrTextField];
    pos++;
    if (pos == arrFields.count) {
        pos = 0;
    }
    
    UITextField *tfTemp = [arrFields objectAtIndex:pos];
    [tfTemp becomeFirstResponder];
    
}

-(IBAction) touchPrev {
//    if (tfCurrTextField == tfName) {
//        [tfPostCode becomeFirstResponder];
//    }
//    else
//        if (tfCurrTextField == tfPostCode) {
//            [tfSuburb becomeFirstResponder];
//        }
//        else
//        if (tfCurrTextField == tfSuburb) {
//            [tfStreetAddr becomeFirstResponder];
//        }
//        else
//            if (tfCurrTextField == tfStreetAddr) {
//                [tfName becomeFirstResponder];
//            }
    int pos = [arrFields indexOfObject:tfCurrTextField];
    pos--;
    if (pos <0) {
        return;
        //pos = arrFields.count - 1;
    }
    
    UITextField *tfTemp = [arrFields objectAtIndex:pos];
    [tfTemp becomeFirstResponder];
}

-(IBAction) touchBookmark{
    tblView.hidden = YES;
    [self touchClose];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
    {
        
        //older than iOS 9 code here
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        
        picker.peoplePickerDelegate = self;
        
        [self presentViewController:picker animated:YES completion:^{
            //        [UIView animateWithDuration:0.31 animations:^{
            //            CGRect frame = toolBar.frame;
            //            frame.origin.y = 568 - frame.size.height;
            //            toolBar.frame = frame;
            //        } completion:^(BOOL finished) {
            //            toolBar.hidden = YES;
            //        }];
        }];
        
    }
    else
    {
        CNContactPickerViewController * picker = [[CNContactPickerViewController alloc]init];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{
            //        [UIView animateWithDuration:0.31 animations:^{
            //            CGRect frame = toolBar.frame;
            //            frame.origin.y = 568 - frame.size.height;
            //            toolBar.frame = frame;
            //        } completion:^(BOOL finished) {
            //            toolBar.hidden = YES;
            //        }];
        }];
        

    }

    
}

-(IBAction) touchStar {
    _isDefault = !_isDefault;
    if (_isDefault) {
        [btnStar setImage:[UIImage imageNamed:@"star_icon_solid.png"] forState:UIControlStateNormal];
    }
    else
        [btnStar setImage:[UIImage imageNamed:@"star_icon.png"] forState:UIControlStateNormal];
}

- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    keyboardHeight = kbSize.height;
    
    //DLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    [UIView animateWithDuration:0.35 animations:^{
        if (!toolBar.hidden) {
            toolBar.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - toolBar.frame.size.height, 320, toolBar.frame.size.height);
        }
    }];
}
@end
