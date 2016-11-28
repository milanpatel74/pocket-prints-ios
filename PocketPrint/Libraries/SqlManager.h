//
//  SqlManager.h
//  
//
//  Created by Minh Quan on 1/14/10.
//  dohoangminhquan@gmail.com
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/**
 SqlManager to manage sqlite and create singleton
 */

@interface SqlManager : NSObject {
	sqlite3 *database;
}

-(void) openDatabaseWithFile:(NSString*) dbFile;
/**
 execute a query to update data
 */

-(void) doUpdateQuery:(NSString*) queryStr ;

/**
 execute a query
 */

-(sqlite3_stmt*) doQuery:(NSString*) queryStr;

/**
 close database
 */

-(void) close;

/**
 open database
 */

-(void) openDatabase:(NSString*) dataPath;

/**
 singleton
 */

+(SqlManager*) defaultShare;

-(void) doInsertQuery:(NSString*) queryStr;


-(NSMutableArray*) doQueryAndGetArray:(NSString*) queryStr;

-(int) getLastInsertId;

@end
