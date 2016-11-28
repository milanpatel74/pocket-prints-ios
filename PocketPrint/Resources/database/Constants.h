//
//  Constants.h
//  NationalSupportCentre
//
//  Created by Laxman kumar on 20/11/14.
//  Copyright (c) 2014 rize. All rights reserved.
//

#ifndef NationalSupportCentre_Constants_h
#define NationalSupportCentre_Constants_h



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width


#define PASSWORD @"password"
#define EC_NUMBER @"ecNumber"
#define USER_TYPE @"usertype"
#define EMAIL @"email"
#define VALIDDAY @"validDay"
#define LOGINTITLE @"loginTitle"
#define PRODUCTID @"product_id"


#endif
