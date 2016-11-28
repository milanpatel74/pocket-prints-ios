#import "APIServices.h"
#import "SynthesizeSingleton.h"
#import "AFNetworking.h"
#import "BackgroundSessionManager.h"

//#import "Standing.h"
@interface  APIServices ()
//- (ASIHTTPRequest *)requestWithUrl:(NSString *)url;
//- (ASIFormDataRequest *)formRequestWithUrl:(NSString *)url;
//- (void)downloadContentForUrl:(NSString *)url withObject:(id)object path:(NSString *)path notificationName:(NSString *)notificationName;
@end

@implementation APIServices

#define RequestTimeOutSeconds 30

SYNTHESIZE_SINGLETON_FOR_CLASS(APIServices)


#pragma mark api key store persisent
-(NSString*) getApiToken {
    NSUserDefaults  *defaultUser = [NSUserDefaults standardUserDefaults];
    _token = [defaultUser valueForKey:PREF_APP_TOKEN];
    return _token;
}

#pragma mark test 
- (NSMutableURLRequest *)requestWithUrl:(NSString *)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:RequestTimeOutSeconds];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

- (NSMutableURLRequest *)formRequestWithUrl:(NSString *)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:RequestTimeOutSeconds];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forKey:@"Accept"];
    
    return request;
}

#pragma mark HTTP former

-(NSString*) authURL:(NSString*) urlStr {
    if (_token) {
        return [urlStr stringByAppendingFormat:@"?token=%@",_token];
    }
    else
        return urlStr;//[urlStr stringByAppendingString:@"?"];
}

//- (ASIHTTPRequest *)requestWithUrl:(NSString *)url
//{
//    // test URL
//    NSString    *strURL = url;
////    if ([strURL rangeOfString:@"device="].location == NSNotFound) {
////        if ([strURL rangeOfString:@"?"].location != NSNotFound) {
////            strURL = [strURL stringByAppendingFormat:@"&device=%@",[UserInfo UUID]];
////        }
////        else
////            strURL = [strURL stringByAppendingFormat:@"?device=%@",[UserInfo UUID]];
////    }
//
//	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
//	request.numberOfTimesToRetryOnTimeout = 1;
//	request.timeOutSeconds = RequestTimeOutSeconds;
//    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//    //[request addRequestHeader:@"Accept" value:@"application/json"];
//	request.allowCompressedResponse = TRUE;
//	
//	return request;
//}
//
//- (ASIFormDataRequest *)formRequestWithUrl:(NSString *)url
//{
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//	request.numberOfTimesToRetryOnTimeout = 2;
//	request.timeOutSeconds = RequestTimeOutSeconds;
//	[request setRequestMethod:@"POST"];
//    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//    [request addRequestHeader:@"Accept" value:@"application/json"];
//	request.allowCompressedResponse = TRUE;
//	//[request setPostValue:[UserInfo UUID] forKey:@"device"];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
//	[request setShouldContinueWhenAppEntersBackground:YES];
//#endif
//	
//	return request;
//}

- (NSMutableURLRequest *)formUploadRequestWithUrl:(NSString *)url
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:RequestTimeOutSeconds];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
	return request;
}

//- (NSMutableURLRequest*) uploadWithURL:(NSString*) aURL
//                            queryParam:(NSDictionary*) aQueryParamDict
//                             postParam:(NSDictionary*) aPostParamDict
//                            httpMethod:(NSString*) aMethod
//                                onFail:(void(^)(NSError*)) aFailBlock
//                                onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
//    NSString    *requestURL = [[NSString alloc] initWithString:aURL];
//    //requestURL = [self authURL:requestURL];
//    // process query params
//    NSArray *keys = [aQueryParamDict allKeys];
//    for (NSString   *key in keys) {
//        requestURL = [requestURL stringByAppendingFormat:@"&%@=%@",key,[aQueryParamDict objectForKey:key]];
//    }
//    
//    __block NSMutableURLRequest  *request = nil;
//    
//    
//    if ([aMethod isEqualToString:@"GET"]) {
//        request = [self requestWithUrl:requestURL];
//        
//    }
//    else
//        if ([aMethod isEqualToString:@"POST"]) {
//            request = [self formUploadRequestWithUrl:requestURL];
//        }
//        else
//        {
//            DLog(@"Unsupported method %@",aMethod);
//            // safe
//            return nil;
//        }
//    
//    [request setTimeoutInterval:RequestTimeOutSeconds];
//    
//    if ([request isKindOfClass:[ASIFormDataRequest class]]) {
//        // process post param
//        keys = [aPostParamDict allKeys];
//        for (NSString   *key in keys) {
//            [(ASIFormDataRequest*)request setPostValue:[aPostParamDict objectForKey:key] forKey:key];
//        }
//    }
//    
////    __weak  ASIHTTPRequest  *weakRequest = request;
////    
////    // fetch here
////    [request setRequestMethod:aMethod];
////    [request setValidatesSecureCertificate:NO];
////    
////    [request setCompletionBlock:^{
////        if (weakRequest.responseStatusCode != 200) {
////            NSError *error = [[NSError alloc] initWithDomain:[weakRequest.url absoluteString] code:weakRequest.responseStatusCode userInfo:[NSDictionary dictionaryWithObject:weakRequest.responseString forKey:@"msg"]];
////            aFailBlock(error);
////            return ;
////        }
////        aDoneBlock(weakRequest.error,weakRequest.responseData);
////    }];
////    [request setFailedBlock:^{
////        aFailBlock(weakRequest.error);
////    }];
////    
////    [request startAsynchronous];
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               //DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                               if (connectionError) {
//                                   aFailBlock(connectionError);
//                               }
//                               else {
//                                   aDoneBlock(connectionError,data);
//                               }
//                           }];
//    return request;
//}

#pragma mark APIs
//- (ASIHTTPRequest*) sendRequestWithURL:(NSString*) aURL
//                         queryParam:(NSDictionary*) aQueryParamDict
//                          postParam:(NSDictionary*) aPostParamDict
//                         httpMethod:(NSString*) aMethod
//                             onFail:(void(^)(NSError*)) aFailBlock
//                             onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
//    
//    NSString    *requestURL = [[NSString alloc] initWithString:aURL];
//    //requestURL = [self authURL:requestURL];
//    // process query params
//    NSArray *keys = [aQueryParamDict allKeys];
//    for (NSString   *key in keys) {
//        requestURL = [requestURL stringByAppendingFormat:@"&%@=%@",key,[aQueryParamDict objectForKey:key]];
//    }
//    
//    __block __weak ASIHTTPRequest  *request = nil;
//    
//    if ([aMethod isEqualToString:@"GET"]) {
//        request = [self requestWithUrl:requestURL];
//        
//    }
//    else
//        if ([aMethod isEqualToString:@"POST"]) {
//            request = [self formRequestWithUrl:requestURL];
//        }
//        else
//        {
//            DLog(@"Unsupported method %@",aMethod);
//            // safe
//            return nil;
//        }
//    
//
//    if ([request isKindOfClass:[ASIFormDataRequest class]]) {
//        // process post param
//        keys = [aPostParamDict allKeys];
//        for (NSString   *key in keys) {
//            [(ASIFormDataRequest*)request setPostValue:[aPostParamDict objectForKey:key] forKey:key];
//        }
//    }
//
//    
//    // fetch here
//    [request setRequestMethod:aMethod];
//    [request setValidatesSecureCertificate:NO];
//    
//    [request setCompletionBlock:^{
//        if (request.responseStatusCode != 200) {
//            NSError *error = [[NSError alloc] initWithDomain:[request.url absoluteString] code:request.responseStatusCode userInfo:[NSDictionary dictionaryWithObject:request.responseString forKey:@"msg"]];
//            aFailBlock(error);
//            return ;
//        }
//        aDoneBlock(request.error,request.responseData);
//    }];
//    [request setFailedBlock:^{
//        aFailBlock(request.error);
//    }];
//    
//    [request startAsynchronous];
//
//    return request;
//}

-(void) enablePush:(BOOL) enabled
            onFail:(void (^)(NSError* error)) aFailBlock
            onDone:(void (^)(NSError* error, id obj)) aDoneBlock;{
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    //NSMutableURLRequest *request = [self formRequestWithUrl:[PushURL stringByAppendingFormat:@"?access_token=%@",ACCESS_TOKEN_DEVELOPMENT] ];
    NSString *url = [PushURL stringByAppendingFormat:@"?access_token=%@",ACCESS_TOKEN_PRODUCTION] ;
//	NSString *token = (enabled)?[userDefault objectForKey:PREF_PUSH_TOKEN]:@"";
//    DLog(@"Token to upload %@",token);
    [self sendRequestWithURL:url queryParam:nil postParam:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"tag",[userDefault objectForKey:PREF_PUSH_TOKEN],@"device",(enabled)?@"true":@"false",@"enabled", nil] httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
    
    return;
//    NSString    *postString = [NSString stringWithFormat:@"tag=&device=%@",[userDefault objectForKey:PREF_PUSH_TOKEN]];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[request setPostValue:ACCESS_TOKEN_DEVELOPMENT forKey:@"access_token"];
//    [request setPostValue:@"" forKey:@"tags"];
//    [request setPostValue:[userDefault objectForKey:PREF_PUSH_TOKEN] forKey:@"device"];
//    [request setCompletionBlock:^{
//        if (weakRequest.responseStatusCode != 200) {
//            NSError *error = [[NSError alloc] initWithDomain:[weakRequest.url absoluteString] code:weakRequest.responseStatusCode userInfo:[NSDictionary dictionaryWithObject:weakRequest.responseString forKey:@"msg"]];
//            aFailBlock(error);
//            return ;
//        }
//        aDoneBlock(weakRequest.error,weakRequest.responseData);
//    }];
//    [request setFailedBlock:^{
//        aFailBlock(weakRequest.error);
//    }];
//    
//    [request startAsynchronous];
    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               //DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                               if (connectionError) {
//                                   aFailBlock(connectionError);
//                               }
//                               else {
//                                   aDoneBlock(connectionError,data);
//                               }
//                           }];
}


-(void) registerTokenOnFail:(void (^)(NSError* error)) aFailBlock
                     onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    NSString    *url = SERVER_URL_WITH_API(API_TOKEN);
    [self sendRequestWithURL:url queryParam:nil postParam:nil httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
}

-(void) getProductsOnFail:(void (^)(NSError* error)) aFailBlock
                   onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    NSString    *url = SERVER_URL_WITH_API(API_PRDUCTS);
    [self sendRequestWithURL:url queryParam:nil postParam:nil httpMethod:@"GET" onFail:aFailBlock onDone:aDoneBlock];
}

-(void) uploadPhoto:(UIImage*) aPhoto
             onFail:(void (^)(NSError* error)) aFailBlock
             onDone:(void (^)(NSError* error, id obj)) aDoneBlock {

 
    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_UPLOAD_PHOTO)];
    //url = [url stringByAppendingFormat:@"?email=%@&password=%@",aUserName,aPassword];
	NSMutableURLRequest *request = [[APIServices sharedAPIServices] formUploadRequestWithUrl:url];
    NSString *boundary = @"0xKhTmLbOuNdArY"; // This is important! //NSURLConnection is very sensitive to format.
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //compress 0.5
    NSData* imageData=UIImageJPEGRepresentation(aPhoto, 0.5);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"param2\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"paramstringvalue1" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [BackgroundSessionManager uploadURL:request onFail:aFailBlock onDone:aDoneBlock];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               //DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                               if (connectionError) {
//                                   aFailBlock(connectionError);
//                               }
//                               else {
//                                   aDoneBlock(connectionError,data);
//                               }
//                           }];
    
    
//    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_UPLOAD_PHOTO)];
//    
//    [self uploadRequestWithURL:url httpMethod:@"POST" andParam:@{@"image":aPhoto} onFail:aFailBlock onDone:aDoneBlock];
}

-(void) uploadPhotoURL:(NSString*) aPhotoUrl
                onFail:(void (^)(NSError* error)) aFailBlock
                onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_UPLOAD_PHOTO)];
    [self sendRequestWithURL:url queryParam:nil postParam:[NSDictionary dictionaryWithObject:aPhotoUrl forKey:@"image"] httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
}

//-(void) getVoucherInfoWithVoucherId:(NSString*)voucherId andProductId:(NSString*) productId
//                             onFail:(void (^)(NSError* error)) aFailBlock
//                             onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
//    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_PREFLIGHT)];
//        [self sendRequestWithURL:url queryParam:nil postParam:[NSDictionary dictionaryWithObjectsAndKeys:voucherId,@"voucher_code",productId,@"products", nil] httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
//}
//
//-(void) getCouponInfoWithCouponId:(NSString*)couponId andProductId:(NSString*) productId
//                           onFail:(void (^)(NSError* error)) aFailBlock
//                           onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
//    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_PREFLIGHT)];
//    NSDictionary    *dict = [NSDictionary dictionaryWithObjectsAndKeys:productId,@"products",couponId,@"promotion_code", nil] ;
//    DLog(@"=>%@",dict);
//    [self sendRequestWithURL:url queryParam:nil postParam:dict httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
//}

-(void) preflightWithPromotionArray:(NSArray*)aPromotionArray andProductId:(NSString*) productId
                             onFail:(void (^)(NSError* error)) aFailBlock
                             onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aPromotionArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_PREFLIGHT)];
    NSDictionary    *dict = [NSDictionary dictionaryWithObjectsAndKeys:productId,@"products",jsonString,@"promotions", nil] ;
    DLog(@"=>%@",dict);
    [self sendRequestWithURL:url queryParam:nil postParam:dict httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
}

-(void) createOrderWithPaypalTransactionToken:(NSString*) paypalToken
                                  stripeToken:(NSString*) stripeToken
                                     andTotal:(NSString*) totalCost
                              ansShippingCost:(NSString*) shippingCost
                                      andName:(NSString*) aName
                                     andEmail:(NSString*) aEmail
                             andPromotionCode:(NSString*) aPromotionArrCode
                                     andPhone:(NSString*) aPhone
                                   andAddress:(NSString*) aAddress
                                    andSuburb:(NSString*) aSuburb
                                     andState:(NSString*) aState
                                  andPostCode:(NSString*) aPostCode
                              andProductArray:(NSString*) aProductArray
                                       onFail:(void (^)(NSError* error)) aFailBlock
                                       onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    
    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_ORDER)];
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aProductArray options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:aAddress,@"address",
                                 aEmail,@"email",
                                 aName, @"name",
                                 paypalToken,@"paypal_transaction_token",
                                 stripeToken,@"stripe_transaction_token",
                                 aPhone,@"phone",
                                 aPostCode,@"postcode",
                                 shippingCost,@"shipping_cost",
                                 aState,@"state",
                                 aSuburb,@"suburb",
                                 totalCost,@"total",
                                 aProductArray,@"products",
                                 aPromotionArrCode,@"promotions",nil];
    
    DLog(@"====== CREATE ORDER");
    DLog(@"======> oder parameters: %@",dict);
    [self sendRequestWithURL:url queryParam:nil postParam:dict httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
    
    NSString *mailUrl = @"http://pocketprints.com.au/mcmail/subscribe.php?email=pocket_test@gmail.com";
    //    NSString *postString = [dict objectForKey:@"email"];
    NSDictionary *postdic = [[NSMutableDictionary alloc]init];
    [postdic setValue:[dict objectForKey:@"email"] forKey:@"email"];
    [self sendRequestWithURL:mailUrl queryParam:nil postParam:postdic httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];

}

-(void) updateCustomerWithName:(NSString*) name
                      andEmail:(NSString*) email
                      andPhone:(NSString*) phone
                        onFail:(void (^)(NSError* error)) aFailBlock
                        onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_ADD_CUSTOMER)];
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    [dictParam setObject:name forKey:@"name"];
    [dictParam setObject:email forKey:@"email"];
    [dictParam setObject:phone forKey:@"phone"];
    
    // device model
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceInfo = [NSString stringWithFormat:@"Model: %@ \n Local info: %@ \n System name: %@",device.model,device.localizedModel,device.systemName];
    [dictParam setObject:deviceInfo forKey:@"device_name"];
    [dictParam setObject:device.systemVersion forKey:@"os_version"];
    
    [self sendRequestWithURL:url queryParam:nil postParam:dictParam httpMethod:@"PUT" onFail:aFailBlock onDone:^(NSError *error, id obj) {
        if (aDoneBlock)
            aDoneBlock(error,[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding]);
    }];
}

-(void) stripePaymentWithToken:(NSString*) stripeToken andAmount:(NSString*) amount
                        onFail:(void (^)(NSError* error)) aFailBlock
                        onDone:(void (^)(NSError* error, id obj)) aDoneBlock {
    NSString    *url = [self authURL:SERVER_URL_WITH_API(API_STRIPE_PAYMENT)];
    
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    [dictParam setObject:stripeToken forKey:@"stripe_token"];
    [dictParam setObject:amount forKey:@"amount"];
    
    // get default
    NSString    *sql = @"SELECT * FROM shipping_addr WHERE default_addr='true'";
    NSArray *arr = [[SqlManager defaultShare] doQueryAndGetArray:sql];
    if (arr.count > 0) {
        NSDictionary    *dict = [arr objectAtIndex:0];
        [dictParam setObject:[dict objectForKey:@"name"] forKey:@"name"];
        [dictParam setObject:[dict objectForKey:@"phone"] forKey:@"phone"];
        [dictParam setObject:[dict objectForKey:@"email"] forKey:@"email"];
    }
    

    [self sendRequestWithURL:url queryParam:nil postParam:dictParam httpMethod:@"POST" onFail:aFailBlock onDone:aDoneBlock];
}

- (NSMutableURLRequest*) sendRequestWithURL:(NSString*) aURL
                                  queryParam:(NSDictionary*) aQueryParamDict
                                   postParam:(NSDictionary*) aPostParamDict
                                  httpMethod:(NSString*) aMethod
                                      onFail:(void(^)(NSError*)) aFailBlock
                                      onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
    
    NSString    *requestURL = [[NSString alloc] initWithString:aURL];
    //requestURL = [self authURL:requestURL];
    // process query params
    NSArray *keys = [aQueryParamDict allKeys];
    for (NSString   *key in keys) {
        requestURL = [requestURL stringByAppendingFormat:@"&%@=%@",key,[aQueryParamDict objectForKey:key]];
    }
    
//    __block __weak ASIHTTPRequest  *request = nil;
    NSMutableURLRequest *request = nil;
    
    if ([aMethod isEqualToString:@"GET"]) {
        request = [self requestWithUrl:requestURL];
        
    }
    else
        if ([aMethod isEqualToString:@"POST"] || [aMethod isEqualToString:@"PUT"]) {
            request = [self formRequestWithUrl:requestURL];
            NSString    *postString = @"";
            keys = [aPostParamDict allKeys];
            for (NSString   *key in keys) {
                //[(ASIFormDataRequest*)request setPostValue:[aPostParamDict objectForKey:key] forKey:key];
                //[request setValue:[aPostParamDict objectForKey:key] forKey:key];
                NSString    *newParam = [NSString stringWithFormat:@"&%@=%@",key,[self percentEscapeString:[aPostParamDict objectForKey:key]]];
                postString = [postString stringByAppendingString:newParam];
            }
            //NSString    *postString = [NSString stringWithFormat:@"tag=&device=%@",[userDefault objectForKey:PREF_PUSH_TOKEN]];
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            DLog(@"Unsupported method %@",aMethod);
            // safe
            return nil;
        }
    
    
//    if ([request isKindOfClass:[ASIFormDataRequest class]]) {
//        // process post param
//        keys = [aPostParamDict allKeys];
//        for (NSString   *key in keys) {
//            //[(ASIFormDataRequest*)request setPostValue:[aPostParamDict objectForKey:key] forKey:key];
//            [request setValue:[aPostParamDict objectForKey:key] forKey:key];
//        }
//    }
    
    
    // fetch here
    [request setHTTPMethod:aMethod];
    //[request setValidatesSecureCertificate:NO];
    
//    [request setCompletionBlock:^{
//        if (request.responseStatusCode != 200) {
//            NSError *error = [[NSError alloc] initWithDomain:[request.url absoluteString] code:request.responseStatusCode userInfo:[NSDictionary dictionaryWithObject:request.responseString forKey:@"msg"]];
//            aFailBlock(error);
//            return ;
//        }
//        aDoneBlock(request.error,request.responseData);
//    }];
//    [request setFailedBlock:^{
//        aFailBlock(request.error);
//    }];
//    
//    [request startAsynchronous];
    
    [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                             if (connectionError) {
                                 aFailBlock(connectionError);
                             }
                             else {
                                 aDoneBlock(connectionError,data);
                             }
                         }];
    return request;

    
}

//- (NSMutableURLRequest*) uploadRequestWithURL:(NSString*) aURL
//                                   httpMethod:(NSString*) aHttpMethod
//                                     andParam:(NSDictionary*) aPostParamDict
//                                       onFail:(void(^)(NSError*)) aFailBlock
//                                       onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
//    
//    NSMutableURLRequest* request = [self uploadRequestWithURL:aURL httpMethod:aHttpMethod andParam:aPostParamDict andProgressListener:nil onFail:aFailBlock onDone:aDoneBlock];
//    
//    return request;
//}

- (NSMutableURLRequest*) uploadRequestWithURL:(NSString*) aURL
                                   httpMethod:(NSString*) aHttpMethod
                                     andParam:(NSDictionary*) aPostParamDict
                                       onFail:(void(^)(NSError*)) aFailBlock
                                       onDone:(void(^)(NSError* error, id obj)) aDoneBlock {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSArray *arrKeys = aPostParamDict.allKeys;
    NSMutableDictionary *dictFile = [NSMutableDictionary new];
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    [dateFormater setDateFormat:@"MM-dd-yyyy hh:mm:ss:sss"];
    
    for (int i = 0; i < arrKeys.count; i++) {
        NSString    *key = [arrKeys objectAtIndex:i];
        NSString    *filePath = [dateFormater stringFromDate:[NSDate date]];
        NSObject    *obj = [aPostParamDict objectForKey:key];
        NSData  *preData = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            
        }
        else {
            
            // it can be image or data
            //            UIImage *tmpImg;
            if ([obj isKindOfClass:[UIImage class]]) {
                
                preData=UIImageJPEGRepresentation((UIImage*)obj, 0.5);
                
                //save
                
                filePath = [PATH_TEMP_FOLDER  stringByAppendingFormat:@"/%@-%@.jpg",filePath,key];
            }
            else {
                // if it is raw data, just let it go thru
                // it must data
                preData = (NSData*)obj;
                filePath = [PATH_TEMP_FOLDER  stringByAppendingFormat:@"/%@-%@.mp4",filePath,key];
            }
            
            
            
            // write to file
            [preData writeToFile:filePath atomically:YES];
            [dictFile setObject:filePath forKey:key];
        }
    }

//    NSURLSessionDownloadTask *downloadTask = [[BackgroundSessionManager sharedManager] downloadTaskWithRequest:request progress:nil destination:nil completionHandler:nil];
//    [downloadTask resume];
//    [[BackgroundSessionManager sharedManager] uploadURL:<#(NSURLRequest *)#> onFail:<#^(NSError *error)aFailBlock#> onDone:<#^(NSError *error, id obj)aDoneBlock#>]
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:aHttpMethod URLString:aURL parameters:aPostParamDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray *fileKeys = [dictFile allKeys];
        
        for (NSString *key in fileKeys) {
            NSString *path = [dictFile objectForKey:key];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:key error:nil];
            NSString *type = @"image/jpeg";
            if ([path rangeOfString:@"mp4"].location != NSNotFound) {
                type = @"application/octet-stream";
            }
            
            NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
            NSString *fileName = [path substringFromIndex:range.location];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"key" fileName:fileName mimeType:type error:nil];
        }
    } error:nil];
    
    // save to file now
    NSURL *urlFileStream = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/stream-%@",PATH_TEMP_FOLDER,[dateFormater stringFromDate:[NSDate date]]]];
    
    
    request = [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:request writingStreamContentsToFile:urlFileStream completionHandler:^(NSError *error) {
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration backgroundSessionConfiguration:[dateFormater stringFromDate:[NSDate date]]]];
        
        NSProgress  *progress = nil;
        
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:urlFileStream progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            RUN_ON_MAIN_QUEUE(^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            if (error) {
                NSLog(@"Error: %@", error);
                aFailBlock(error);
//                if (_progressHolder) {
//                    [_progressHolder notifyuploadFail];
//                }
            } else {
                //NSLog(@"%@ %@", response, responseObject);
//                if (errorCheckingBlock) {
//                    //NSDictionary *rtnDict = [NSJSONSerialization JSONObjectWithData:response. options:NSJSONReadingAllowFragments error:nil];
//                    NSError *error = errorCheckingBlock(responseObject);
//                    if (error) {
//                        aFailBlock(error);
//                        if (_progressHolder)
//                            [_progressHolder notifyuploadFail];
//                    }
//                    else {
//                        aDoneBlock(nil,responseObject);
//                        if (_progressHolder)
//                            [_progressHolder notifyUploadCompleteWithObj:responseObject];
//                    }
//                }
//                else {
                    aDoneBlock(error,responseObject);
//                    if (_progressHolder)
//                        [_progressHolder notifyUploadCompleteWithObj:responseObject];
//                }
            }
            
            
        }];
        
        [manager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
            DLog(@"=========================>>> FINISH A SESSION");
        }];
        [uploadTask resume];
        
//        if (progressListener) {
//            [progress addObserver:progressListener
//                       forKeyPath:@"fractionCompleted"
//                          options:NSKeyValueObservingOptionNew
//                          context:NULL];
//        }
    }];
    
    
    
    /*        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
     RUN_ON_MAIN_QUEUE(^{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     });
     if (error) {
     NSLog(@"Error: %@", error);
     aFailBlock(error);
     if (_progressHolder) {
     [_progressHolder notifyuploadFail];
     }
     } else {
     //NSLog(@"%@ %@", response, responseObject);
     if (errorCheckingBlock) {
     //NSDictionary *rtnDict = [NSJSONSerialization JSONObjectWithData:response. options:NSJSONReadingAllowFragments error:nil];
     NSError *error = errorCheckingBlock(responseObject);
     if (error) {
     aFailBlock(error);
     if (_progressHolder)
     [_progressHolder notifyuploadFail];
     }
     else {
     aDoneBlock(nil,responseObject);
     if (_progressHolder)
     [_progressHolder notifyUploadCompleteWithObj:responseObject];
     }
     }
     else {
     aDoneBlock(error,responseObject);
     if (_progressHolder)
     [_progressHolder notifyUploadCompleteWithObj:responseObject];
     }
     }
     }];
     
     [uploadTask resume];
     
     if (progressListener) {
     [progress addObserver:progressListener
     forKeyPath:@"fractionCompleted"
     options:NSKeyValueObservingOptionNew
     context:NULL];
     }
     }];*/
    
    
    
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    //NSDictionary *parameters = @{@"foo": @"bar"};
    //    //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    //    [manager POST:aURL parameters:aPostParamDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //        NSArray *fileKeys = [dictFile allKeys];
    //
    //        for (NSString *key in fileKeys) {
    //            NSString *path = [dictFile objectForKey:key];
    //            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:key error:nil];
    //        }
    //
    //    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSLog(@"Success: %@", responseObject);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //    }];
    
    /*    NSMutableURLRequest *request = [self formUploadRequestWithUrl:aURL];
     NSString *boundary = @"0xKhTmLbOuNdArY"; // This is important! //NSURLConnection is very sensitive to format.
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
     [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
     
     [request setHTTPMethod:aHttpMethod];
     
     NSArray *arrKeys = aPostParamDict.allKeys;
     
     NSMutableData *body = [NSMutableData data];
     // frirst boundary
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
     // scan
     for (int i = 0; i < arrKeys.count; i++) {
     NSString    *key = [arrKeys objectAtIndex:i];
     NSObject    *obj = [aPostParamDict objectForKey:key];
     NSData  *preData = nil;
     if ([obj isKindOfClass:[NSString class]]) {
     NSString *postStrTmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
     // process string
     [body appendData:[postStrTmp dataUsingEncoding:NSUTF8StringEncoding]];
     preData = [(NSString*)obj dataUsingEncoding:NSUTF8StringEncoding];
     [body appendData:preData];
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     }
     }
     
     BOOL isFileUpload = NO;
     for (int i = 0; i < arrKeys.count; i++) {
     NSString    *key = [arrKeys objectAtIndex:i];
     NSObject    *obj = [aPostParamDict objectForKey:key];
     NSData  *preData = nil;
     if ([obj isKindOfClass:[NSString class]]) {
     
     }
     else {
     if (!isFileUpload) {
     
     isFileUpload = YES;
     }
     
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
     // it can be image or data
     //            UIImage *tmpImg;
     if ([obj isKindOfClass:[UIImage class]]) {
     
     // check for size
     //                tmpImg = (UIImage*)obj;
     //                if (tmpImg.size.width > 1280) {
     //                    tmpImg = [tmpImg resizedImageToFitInSize:CGSizeMake(1280, 99999) preferedWidth:YES];
     //
     //                }
     
     // add
     NSString *postStrTmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",key,key];
     [body appendData:[postStrTmp dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     preData=UIImageJPEGRepresentation((UIImage*)obj, 0.5);
     }
     else {
     // if it is raw data, just let it go thru
     // it must data
     NSString *postStrTmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",key,key,([key isEqualToString:@"video"])?@"mp4":@"dat"];
     [body appendData:[postStrTmp dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     preData = (NSData*)obj;
     }
     
     
     
     [body appendData:[NSData dataWithData:preData]];
     // lock
     //[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     }
     }
     
     if (arrKeys.count == 0 || isFileUpload) {
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     }
     
     
     
     [request setHTTPBody:body];
     
     
     //    [NSURLConnection sendAsynchronousRequest:request
     //                                       queue:[NSOperationQueue mainQueue]
     //                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     //                               RUN_ON_MAIN_QUEUE(^{
     //                                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     //                               });
     //
     //                               //DLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
     //                               if (connectionError) {
     //                                   aFailBlock(connectionError);
     //                               }
     //                               else {
     //                                   aDoneBlock(connectionError,data);
     //                               }
     //                           }];
     
     NSDateFormatter *formater = [NSDateFormatter new];
     [formater setDateFormat:@"yyyy-MM-dd-hh-mm-ss-SSS"];
     NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:[formater stringFromDate:[NSDate date]]];
     NSURLSession *backgoundSession = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
     
     NSURLSessionDownloadTask * downloadTask =[ backgoundSession downloadTaskWithRequest:request];
     
     // create block session handler
     BlockSessionHandler *blockSession = [BlockSessionHandler blockSessionWithRequest:request andSession:backgoundSession andTask:downloadTask onFail:aFailBlock onDone:aDoneBlock];
     
     // add to block handler
     [arrSessions addObject:blockSession];
     
     
     
     [downloadTask resume];
     
     return request;
     
     */
    
    return nil;
}

#pragma mark utilities
- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}
@end
