//
//  ShippingAddressViewController.h
//  PocketPrint
//
//  Created by Quan Do on 27/03/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@protocol ShippingAddressViewControllerDelegate <NSObject>

-(void) showPaymentMedthod;
-(void) pushToShippingAdress;

@end
@interface ShippingAddressViewController : AppViewController <UITextFieldDelegate,CLLocationManagerDelegate, ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,CNContactPickerDelegate> {
    IBOutlet    UITextField *tfName, *tfStreetAddr, *tfPostCode, *tfSuburb, *tfCompany, *tfPhone, *tfEmail,*tfState;
    IBOutlet    UIImageView *imgViewName, *imgViewStreet, *imgViewPostCode, *imgViewSuburb, *imgViewState,*imgViewCompany,*imgViewEmail,*imgViewPhone;
    IBOutlet    UIToolbar   *toolBar;
    UITextField *tfCurrTextField;
    CLLocationManager   *locationManager;
    UITableView *tblView;
    NSMutableArray  *arrSuburb;
    NSString    *prevSearchStr;
    IBOutlet    UIButton    *btnStar;
    IBOutlet    UILabel *lbDefault;
    IBOutlet    UIScrollView    *scrollView;
    NSArray     *arrFields;
    int screenHeight;
}


@property   (nonatomic) BOOL    isDefault;
@property   (nonatomic) NSDictionary    *dictCell;
@property   (nonatomic,weak) id<ShippingAddressViewControllerDelegate> delegate;
@end
