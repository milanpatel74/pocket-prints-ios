//
//  SqlManager.m
// 
//
//  Created by Minh Quan on 1/14/10.
//  dohoangminhquan@gmail.com
//

#import "SqlManager.h"
#import "Define.h"
#include <iostream>
using namespace std;

@implementation SqlManager

static SqlManager*	singleton;


+(SqlManager*) defaultShare {
	if (singleton == nil) {
		// create new instance
		singleton = [SqlManager new];
		[singleton openDatabase];
	}
	return singleton;
}

-(void) openDatabase {
    
    
    //
    
    
    // Get the path to the main bundle resource directory.
    
   NSString *yourOriginalDatabasePath = [PATH_DOCUMENT_FOLDER stringByAppendingPathComponent:@"pocketprint.sqlite"];
    
    // Create the path to the database in the Documents directory.
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"pocketprint.sqlite"];
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:yourNewDatabasePath]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:NULL] != YES)
            
            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
        
    }
    
    
    
    
    //
    
//	NSString *databasePath = [PATH_DOCUMENT_FOLDER stringByAppendingPathComponent:@"pocketprint.sqlite"];
	if(sqlite3_open([yourNewDatabasePath UTF8String], &database) == SQLITE_OK)
		NSLog(@"init database at path %@ ok",yourNewDatabasePath);
	else {
		NSLog(@"init database at path %@ FAILED",yourNewDatabasePath);
	}

}

-(void) openDatabaseWithFile:(NSString*) dbFile{
	//NSString *databasePath = [[NSString alloc] initWithFormat:@"%@/%@.%@",FOLDER_TEMP,SQL_FILE_NAME,SQL_FILE_EXT];
	if(sqlite3_open([dbFile UTF8String], &database) == SQLITE_OK)
		NSLog(@"init database at path %@ ok",dbFile);
	else {
		NSLog(@"init database at path %@ FAILED",dbFile);
	}
    
}

-(sqlite3_stmt*) doQuery:(NSString*) queryStr {
	//NSLog(@"query ->%@",queryStr);
	string cSQL ([queryStr UTF8String]);
	const char *sqlStatement = cSQL.c_str();
	// declared
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
	}
	else {
		NSLog(@"sql is not okie =>%@",queryStr);
	}
	return compiledStatement;
}

-(NSMutableArray*) doQueryAndGetArray:(NSString*) queryStr {
	string cSQL ([queryStr UTF8String]);
	const char *sqlStatement = cSQL.c_str();
	// declared
	sqlite3_stmt *compiledStatement;
	NSMutableArray	*arrResult = nil;
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// create new array
		arrResult = [[[NSMutableArray alloc] init] autorelease];
		int colsCount = sqlite3_column_count(compiledStatement);
		int i;
		NSString	*colName, *colValue;
		char* cValue;
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			NSMutableDictionary	*dict = [[NSMutableDictionary alloc] init];
			for (i = 0 ;i<colsCount;i++) {
				colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
				//NSLog(@"cols = %@",colName);
				cValue = (char*)sqlite3_column_text(compiledStatement, i);
				if (cValue == NULL) {
					colValue = @"";
				}
				else
					colValue =  [NSString stringWithUTF8String:cValue];
                
                if (!colValue) {
                    colValue = @"";
                }
				[dict setObject:colValue forKey:colName];
				// add dict to array
			}
			[arrResult addObject:dict];
		}
	}
	else {
		NSLog(@"sql is not okie ->%@",queryStr);
	}
	
	sqlite3_finalize(compiledStatement);
	
	// return nil if nothing to return
	return arrResult;
}

-(void) doInsertQuery:(NSString*) queryStr {
	sqlite3_stmt *compiledStatement = (sqlite3_stmt*)[self doQuery:queryStr];
	sqlite3_step(compiledStatement);
	sqlite3_finalize(compiledStatement);
}


-(void) doUpdateQuery:(NSString*) queryStr {
	string cSQL ([queryStr UTF8String]);
	const char *sqlStatement = cSQL.c_str();
	// declared
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
	}
	else {
		NSLog(@"sql is not okie ->%@",queryStr);
	}
	sqlite3_step(compiledStatement);
	sqlite3_finalize(compiledStatement);
}

-(int) getLastInsertId {
    return sqlite3_last_insert_rowid(database);
}

-(void) close {
	sqlite3_close(database);
    singleton = nil;
}

@end
