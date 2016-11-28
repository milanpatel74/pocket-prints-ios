//
//  ShippingAddressViewController.h
//  PocketPrint
//
//  Created by Quan Do on 27/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Product.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@protocol GiftCertificateInfoViewControllerProtocol <NSObject>

-(void) onGiftAdd:(NSMutableDictionary*) dict;

@end

@interface GiftCertificateInfoViewController : AppViewController <UITextFieldDelegate,NSLayoutManagerDelegate, ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,CNContactPickerDelegate> {
    IBOutlet    UITextField *tfName, *tfEmail,*tfEmailConfirm,*tfGiftValue;
    IBOutlet    UITextView  *tvMsg;
    IBOutlet    UIImageView *imgViewName, *imgViewEmail,*imgViewEmailConfirm,*imgViewMsg;
    IBOutlet    UIToolbar   *toolBar;
    UITextField *tfCurrTextField;
    IBOutlet    UIButton    *btnStar;
    IBOutlet    UIScrollView    *scrollView;
    NSArray     *arrFields;
    int screenHeight;
    
    IBOutlet    UIPickerView    *pickerView;
    
    NSArray     *arrGiftValues;
    IBOutlet    UIView  *viewPicker;
    int         giftValuePos;
}

@property   (nonatomic,weak) id<GiftCertificateInfoViewControllerProtocol> delegate;
@property   (nonatomic,weak) Product    *product;

-(IBAction) touchDonePicker;
-(IBAction) touchGift;
@end
