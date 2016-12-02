#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"



@interface APIServices : NSObject {

}

+ (APIServices *)sharedAPIServices;

#pragma mark registration

@property (nonatomic,strong) NSString *token;

//- (ASIHTTPRequest*) sendRequestWithURL:(NSString*) aURL
//                            queryParam:(NSDictionary*) aQueryParamDict
//                             postParam:(NSDictionary*) aPostParamDict
//                            httpMethod:(NSString*) aMethod
//                                onFail:(void(^)(NSError*)) aFailBlock
//                                onDone:(void(^)(NSError* error, id obj)) aDoneBlock;

//- (NSMutableURLRequest*) uploadWithURL:(NSString*) aURL
//                       queryParam:(NSDictionary*) aQueryParamDict
//                        postParam:(NSDictionary*) aPostParamDict
//                       httpMethod:(NSString*) aMethod
//                           onFail:(void(^)(NSError*)) aFailBlock
//                           onDone:(void(^)(NSError* error, id obj)) aDoneBlock;


-(NSString*) getApiToken;

-(void) uploadPhoto:(UIImage*) aPhoto
             onFail:(void (^)(NSError* error)) aFailBlock
             onDone:(void (^)(NSError* error, id obj)) aDoneBlock;

-(void) uploadPhotoURL:(NSString*) aPhotoUrl
             onFail:(void (^)(NSError* error)) aFailBlock
             onDone:(void (^)(NSError* error, id obj)) aDoneBlock;

-(void) enablePush:(BOOL) enabled
            onFail:(void (^)(NSError* error)) aFailBlock
            onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;

-(void) registerTokenOnFail:(void (^)(NSError* error)) aFailBlock
                     onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;

-(void) getProductsOnFail:(void (^)(NSError* error)) aFailBlock
                   onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;

//-(void) getVoucherInfoWithVoucherId:(NSString*)voucherId andProductId:(NSString*) productId
//                             onFail:(void (^)(NSError* error)) aFailBlock
//                             onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;
//
//
//-(void) getCouponInfoWithCouponId:(NSString*)couponId andProductId:(NSString*) productId
//                             onFail:(void (^)(NSError* error)) aFailBlock
//                             onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;


-(void) preflightWithPromotionArray:(NSArray*)aPromotionArray andProductId:(NSString*) productId
                             onFail:(void (^)(NSError* error)) aFailBlock
                             onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;

-(void) createOrderWithPaypalTransactionToken:(NSString*) paypalToken
                                  stripeToken:(NSString*) stripeToken
                                     andTotal:(NSString*) totalCost
                              ansShippingCost:(NSString*) shippingCost
                                      andName:(NSString*) aName
                                     andEmail:(NSString*) aEmail
                                 andPromotionCode:(NSString*) aPromotionArrCode
                                     andPhone:(NSString*) aPhone
                                   andAddress:(NSString*) aAddress
                               andCompanyName:(NSString*) aCompanyName
                                    andSuburb:(NSString*) aSuburb
                                     andState:(NSString*) aState
                                  andPostCode:(NSString*) aPostCode
                              andProductArray:(NSString*) aProductArray
                                       onFail:(void (^)(NSError* error)) aFailBlock
                                       onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;

-(void) stripePaymentWithToken:(NSString*) stripeToken andAmount:(NSString*) amount
                        onFail:(void (^)(NSError* error)) aFailBlock
                        onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;

-(void) updateCustomerWithName:(NSString*) name
                      andEmail:(NSString*) email
                      andPhone:(NSString*) phone
                        onFail:(void (^)(NSError* error)) aFailBlock
                        onDone:(void (^)(NSError* error, id obj)) aDoneBlock;;
#pragma mark test 

- (NSMutableURLRequest *)requestWithUrl:(NSString *)url;
- (NSMutableURLRequest *)formRequestWithUrl:(NSString *)url;
- (NSMutableURLRequest*) sendRequestWithURL:(NSString*) aURL
                            queryParam:(NSDictionary*) aQueryParamDict
                             postParam:(NSDictionary*) aPostParamDict
                            httpMethod:(NSString*) aMethod
                                onFail:(void(^)(NSError*)) aFailBlock
                                onDone:(void(^)(NSError* error, id obj)) aDoneBlock;
@end
