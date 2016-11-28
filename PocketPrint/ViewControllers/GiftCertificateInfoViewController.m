//
//  ShippingAddressViewController.m
//  PocketPrint
//
//  Created by Quan Do on 27/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "GiftCertificateInfoViewController.h"

@interface GiftCertificateInfoViewController ()

@end

@implementation GiftCertificateInfoViewController

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
    [self setScreenTitle:@"Gift Certificate"];
    
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
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfGiftValue.textColor = [UIColor redColor];
    tfGiftValue.font= tfName.font =tfEmail.font = tfEmailConfirm.font =tvMsg.font= [UIFont fontWithName:@"MuseoSans-300" size:17.0f];
    
    
    //scroll view
    //scrollView.contentSize = CGSizeMake(320, 615);
//    scrollView.contentOffset   = CGPointMake(0, 100);
    
    //arrfiels
    arrFields = @[tfName,tfEmail,tfEmailConfirm,tvMsg];
    
    //[tfName becomeFirstResponder];
    //[self touchGift];
    
    DLog(@"scorll size = %@",NSStringFromCGRect(scrollView.frame));
    
    screenHeight = SCREEN_HEIGHT;//(IS_4INCHES)?568:480;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        scrollView.contentSize = CGSizeMake(320, 360);
    });
    
    arrGiftValues = @[[NSDictionary dictionaryWithObjectsAndKeys:@"$20",@"title",[NSNumber numberWithInt:20],@"value", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"$30",@"title",[NSNumber numberWithInt:30],@"value", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"$50",@"title",[NSNumber numberWithInt:50],@"value", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"$100",@"title",[NSNumber numberWithInt:100],@"value", nil]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchGift];
    });
}

-(void) viewDidLayoutSubviews {
//    scrollView.contentSize = CGSizeMake(320, 360);
    [toolBar setFrameWidth:self.view.frame.size.width];
    //[self touchGift];
    
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



#pragma mark textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Message"]) {
        textView.text = @"";
    }
    
    int pos = (int)[arrFields indexOfObject:textView];
    
    if (IS_4INCHES) {
        [scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else
        [scrollView setContentOffset:CGPointMake(0, 210) animated:YES];
    
    tfCurrTextField = textView;
    tfName.textColor =tfEmail.textColor = tfEmailConfirm.textColor = tvMsg.textColor =  [UIColor redColor];
    textView.textColor = [UIColor whiteColor];
    
    tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Recipient Name" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmailConfirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Confirmation" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    [self highlightForTextField:textView];
    
    // move tool bar
    if (toolBar.hidden) {
        toolBar.hidden = NO;
        __block CGRect frame = toolBar.frame;
        frame.origin.y = screenHeight - frame.size.height;
        toolBar.frame = frame;
        [UIView animateWithDuration:0.31 animations:^{
            frame.origin.y = (IS_4INCHES)?308:220;
            toolBar.frame = frame;
        }];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!textView.text || [textView.text isEqualToString:@""]) {
        textView.text = @"Message";
    }
}

#pragma mark text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    int pos = (int)[arrFields indexOfObject:textField];

    if (IS_4INCHES) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
        [scrollView setContentOffset:CGPointMake(0, pos*51) animated:YES];

    tfCurrTextField = textField;
    tfName.textColor =tfEmail.textColor = tfEmailConfirm.textColor = tvMsg.textColor =  [UIColor redColor];
    textField.textColor = [UIColor whiteColor];
    
    tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Recipient Name" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmailConfirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Confirmation" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    [self highlightForTextField:textField];
    
    // move tool bar
    if (toolBar.hidden) {
        toolBar.hidden = NO;
        __block CGRect frame = toolBar.frame;
        frame.origin.y = screenHeight - frame.size.height;
        toolBar.frame = frame;
        [UIView animateWithDuration:0.31 animations:^{
            frame.origin.y = (IS_4INCHES)?308:220;
            toolBar.frame = frame;
        }];
    }
    
    return YES;
}


#pragma mark Utility

-(void) highlightForTextField:(UITextField*) aTextField {
    [self showGift:NO];
    imgViewName.image = imgViewEmail.image =imgViewEmailConfirm.image = [UIImage imageNamed:@"text_field.png"];
    imgViewMsg.image = [UIImage imageNamed:@"white_text_field_big.png"];
    if (aTextField == tfName) {
        imgViewName.image = [UIImage imageNamed:@"text_field_hover.png"];
        tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Recipient Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    else

                if (aTextField == tfEmail) {
                    imgViewEmail.image = [UIImage imageNamed:@"text_field_hover.png"];
                    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                }
                else
                    if (aTextField == tfEmailConfirm) {
                        imgViewEmailConfirm.image = [UIImage imageNamed:@"text_field_hover.png"];
                        tfEmailConfirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Confirmation" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
                    }
                    else
                        if (aTextField == tvMsg) {
                            imgViewMsg.image = [UIImage imageNamed:@"red_text_field_big.png"];
                        }

}

-(NSArray*) suggestedSuburbFromText:(NSString*) aSuburbName {
    SqlManager  *sqlMan = [SqlManager defaultShare];
    NSString    *sql = [NSString stringWithFormat:@"SELECT suburbs.*,states.state_name FROM suburbs INNER JOIN states ON suburbs.state_id = states.state_id WHERE suburb_name LIKE \"%%%@%%\"",aSuburbName];
    NSArray     *arrResult = [sqlMan doQueryAndGetArray:sql];
    return arrResult;
}

#pragma mark picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[arrGiftValues objectAtIndex:row] objectForKey:@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    giftValuePos = row;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [arrGiftValues count];
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
    
    if (mailArray.count > 0)
    {
        CNLabeledValue *mail = [mailArray objectAtIndex:0];
        
        NSLog(@"print label :%@",mail.value);
        
        tfEmail.text = tfEmailConfirm.text = mail.value;
    }
    else
    {
        tfEmail.text = tfEmailConfirm.text  = @"";
        
    }
    tfName.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ",namePrefix,givenName,middleName,lastName,nameSuffix];
    
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
-(ADDR_BOOK_RESULT) addContactToList:(CNContact *)contact {
    
    
    NSString *namePrefix = contact.namePrefix;
    NSString *givenName =contact.givenName;
    NSString *nameSuffix = contact.nameSuffix;
    NSString *middleName = contact.middleName;
    NSString *lastName = contact.familyName;
    NSArray *mailArray = contact.emailAddresses;
    
    
    
    //    NSString *name = person.givenName;
    //    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person),kABPersonFirstNameProperty);
    //    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person),kABPersonLastNameProperty);
    
    
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
    return  ADD_OK;
}

#pragma mark address book delegate
    
- (void)peoplePickerNavigationControllerDidCancel:

(ABPeoplePickerNavigationController *)peoplePicker

{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
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
//    ABMultiValueRef addr = ABRecordCopyValue(person,kABPersonAddressProperty);
//    //CFArrayRef arr = ABMultiValueCopyArrayOfAllValues(addr);
//    NSDictionary    *dict = (__bridge NSDictionary*)ABMultiValueCopyValueAtIndex(addr, 0);
//    NSString    *addrStr = @"";
//    if (dict) {
//        addrStr =     [NSString stringWithFormat:@"%@, %@, %@",
//                       [dict objectForKey:@"Street"],
//                       [dict objectForKey:@"City"],
//                       [dict objectForKey:@"Country"]
//                       ];
//    }

    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    //NSString    *email = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonEmailProperty);
    if (!lastName) {
        lastName = @"";
    }
    
    if (!firstName) {
        firstName = @"";
    }
    
    ABMultiValueRef emailArr = ABRecordCopyValue(person,kABPersonEmailProperty);
    if (ABMultiValueGetCount(emailArr) >0) {
        tfEmail.text = tfEmailConfirm.text = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailArr, 0);
    }
    else
        tfEmail.text = tfEmailConfirm.text  = @"";
    
    
    tfName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    // fetch data here

    
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
- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //DLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    [UIView animateWithDuration:0.35 animations:^{
        if (!toolBar.hidden) {
            toolBar.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - toolBar.frame.size.height, 320, toolBar.frame.size.height);
        }
    }];
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
                if (tfEmailConfirm.text.length == 0) {
                    isError = YES;
                    missingElem = @"Email Confirmation";
                    tfError= tfEmailConfirm;
                }
                else
                    if (tfEmail.text.length == 0) {
                        isError = YES;
                        missingElem = @"Email";
                        tfError= tfEmail;
                    }
    
    if (![tfEmailConfirm.text isEqualToString:tfEmail.text]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Email and Email Confirmation are not match" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        [tfEmail becomeFirstResponder];
        return;
    }
    
    if ([tfGiftValue.text isEqualToString:@"Gift Certificate Value"]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select Gift Certificate Value" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    if (isError) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Please enter information for %@",missingElem] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        [tfError becomeFirstResponder];
        return;
    }
    
    //compose data
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _product,@"product",
                                 tfEmail.text,@"email",
                                 tfName.text,@"name",
                                 (tvMsg.text)?tvMsg.text:@"",@"message",
                                 [[arrGiftValues objectAtIndex:giftValuePos] valueForKey:@"value"],@"gift_value",
                                 @"certificate",@"type",
                                 [NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"gift_certificate_thumb_red.png"],@"image",[NSNumber numberWithInt:1],@"count", nil]],@"photos",
                                 [NSString stringWithFormat:@"$%.2f",[_product.price floatValue]],@"price",
                                 nil];
    [_delegate onGiftAdd:dict];
    [self.navigationController popViewControllerAnimated:YES];

    
    
}

-(void) touchBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) touchClose {
    [tfCurrTextField resignFirstResponder];
    tfName.textColor = tfEmail.textColor =tfEmailConfirm.textColor =tvMsg.textColor = [UIColor redColor];
    //preset place holder
    tfName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Recipient Name" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    tfEmailConfirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Confirmation" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    //tvMsg.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    
    imgViewName.image =imgViewEmail.image = imgViewEmailConfirm.image = imgViewMsg.image = [UIImage imageNamed:@"text_field.png"];
    
    [UIView animateWithDuration:0.31 animations:^{
        CGRect frame = toolBar.frame;
        frame.origin.y = screenHeight - frame.size.height;
        toolBar.frame = frame;
    } completion:^(BOOL finished) {
        toolBar.hidden = YES;
    }];
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


-(IBAction) touchNext {

    int pos = [arrFields indexOfObject:tfCurrTextField];
    pos++;
    if (pos == arrFields.count) {
        pos = 0;
    }
    
    UITextField *tfTemp = [arrFields objectAtIndex:pos];
    [tfTemp becomeFirstResponder];
    
}

-(IBAction) touchPrev {
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

-(IBAction) touchDonePicker {
    [self showGift:NO];
    // update value;
    tfGiftValue.text = [NSString stringWithFormat:@"$%d Gift Certificate",[[[arrGiftValues objectAtIndex:giftValuePos] objectForKey:@"value"] intValue]];
}

-(IBAction) touchGift {
    [self showGift:YES];
}

-(void) showGift:(BOOL) isShowGift {
    if (isShowGift) {
        [self touchClose];
        [UIView animateWithDuration:0.75 animations:^{
            CGRect frame = viewPicker.frame;
            frame.origin.y = SCREEN_HEIGHT - viewPicker.frame.size.height - 44;
            viewPicker.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:0.75 animations:^{
            CGRect frame = viewPicker.frame;
            frame.origin.y = SCREEN_HEIGHT;
            viewPicker.frame = frame;
        }];
    }
}
@end
