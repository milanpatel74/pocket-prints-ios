//
//  StripeViewController.m
//  PocketPrint
//
//  Created by Quan Do on 30/08/2014.
//  Copyright (c) 2014 Quan Do. All rights reserved.
//

#import "StripeViewController.h"
#import "PKCard.h"


#define kStripeKey          STRIPE_API_TEST
#define CARD_KEY            @"CARD_KEY"

@interface StripeViewController ()

@end

@implementation StripeViewController

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
    [self setScreenTitle:@"Payment"];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelStripe)];
    [btnDone setTintColor:[UIColor redColor]];
    [btnDone setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"MuseoSans-300" size:17.0f], NSFontAttributeName, nil]  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = btnDone;

    lbInfo.font = lbPrice.font = [UIFont fontWithName:@"MuseoSans-300" size:17.0f];
    lbPrice.text = [@"$" stringByAppendingString:_price];
    lbPayment.font = lbOtherCard.font = lbCardNumber.font = [UIFont fontWithName:@"MuseoSans-300" size:16.0f];
    if (!cardView) {
        cardView = [[STPViewExt alloc] initWithFrame:CGRectMake(0,89,SCREEN_WIDTH,55) andKey:kStripeKey];
    }
    
    // reset
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_KEY];
    
    isLoadedCard = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CARD_KEY]) {
        // load card
        isLoadedCard = YES;
        cardView.hidden = YES;
        [self loadCard];
    }
    else
        viewLastCard.hidden = YES;
    [masterView addSubview:cardView];
    cardView.delegate = self;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark stripe delegate

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    // Enable the "save" button only if the card form is complete.
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

-(void) cancelStripe {
    // safe
    cardView.delegate = nil;
    self.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark actions
-(IBAction) processStripe {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    btnProgress.enabled = NO;
    lbPayment.text = @"Sending Payment";
    if (!isLoadedCard) {
        [cardView createToken:^(STPToken *token, NSError *error) {
            if (error) {
                btnProgress.enabled = YES;
                [[[UIAlertView alloc] initWithTitle:nil message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                btnProgress.enabled = YES;
                lbPayment.text = @"Send Payment";
            } else {
                btnProgress.enabled = YES;
                // get the token and save the card
                [self saveCardWithToken:token.tokenId];

                [self getTransactionTokenWithCardToken:token.tokenId];
                
            }
        }];
    }
    else {
        // load me
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_KEY];
        [self getTransactionTokenWithCardToken:[dict objectForKey:@"token"]];
    }
}

-(IBAction) touchAddOtherCard {
    isLoadedCard = NO;
    viewLastCard.hidden = YES;
    cardView.hidden = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_KEY];
}

#pragma mark utilities
-(void) saveCardWithToken:(NSString*) aToken {
    NSString *cardNumber = [cardView.paymentView.cardNumberField.text substringFromIndex:cardView.paymentView.cardNumberField.text.length - 4];
    NSDictionary *dict = @{@"number":cardNumber,@"token":aToken};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:CARD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) loadCard {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_KEY];
    lbCardNumber.text = [NSString stringWithFormat:@"**** **** **** %@",[dict objectForKey:@"number"]];
    viewLastCard.hidden = NO;
}

-(void) getTransactionTokenWithCardToken:(NSString*) cardToken {
    [[APIServices sharedAPIServices] stripePaymentWithToken:cardToken andAmount:[_price stringByReplacingOccurrencesOfString:@".00" withString:@""] onFail:^(NSError *error) {
        DLog(@"Stripe payment fail : %@",error.debugDescription);
        btnProgress.enabled = YES;
        self.navigationItem.rightBarButtonItem = nil;
    } onDone:^(NSError *error, id obj) {
        self.navigationItem.rightBarButtonItem = nil;
        btnProgress.enabled = YES;
        DLog(@"=>%@",[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
        NSDictionary    *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
        if ([dict objectForKey:@"error"]) {
            [[[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            lbPayment.text = @"Send Payment";
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        // proceed
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_delegate processWithStripeToken:[dict objectForKey:@"stripe_transaction_token"]];
        });
        
    }];
}
@end
