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

@interface SqlManager()
    - (int)getDbUserVersion;
    - (BOOL)setUserVersion;
    - (BOOL)updateDbFromVer:(int)version;
@end

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


    //get db user_version database
    int db_UserVersion = [self getDbUserVersion];
    //upgrade database to current version
    if (db_UserVersion < DATABASE_USER_VERSION) {
        for (int i = db_UserVersion; i < DATABASE_USER_VERSION; i++) {
            [self updateDbFromVer:i];
        }
        //set db user version to current version
        [self setUserVersion];
    }
}

-(int)getDbUserVersion{
    // get current database version of schema
    NSString *queryStr = @"PRAGMA user_version";
    string cSQL ([queryStr UTF8String]);
    const char *sqlStatement = cSQL.c_str();

    sqlite3_stmt *stmt_version;
    int databaseVersion = 0;

    if (sqlite3_prepare_v2(database, sqlStatement, -1, &stmt_version, NULL) == SQLITE_OK) {
        while(sqlite3_step(stmt_version) == SQLITE_ROW) {
            databaseVersion = sqlite3_column_int(stmt_version, 0);
            NSLog(@"%s: version %d", __FUNCTION__, databaseVersion);
        }
        NSLog(@"%s: the databaseVersion is: %d", __FUNCTION__, databaseVersion);
    } else {
        NSLog(@"%s: ERROR get databaseVersion: , %s", __FUNCTION__, sqlite3_errmsg(database) );
    }
    sqlite3_finalize(stmt_version);

    return databaseVersion;
}
- (BOOL)setUserVersion {
    NSString *queryStr = [NSString stringWithFormat:@"PRAGMA user_version = %d", DATABASE_USER_VERSION];
    string cSQL ([queryStr UTF8String]);
    const char *sqlStatement = cSQL.c_str();

    sqlite3_stmt *stmt_version;
    if(sqlite3_prepare_v2(database, sqlStatement, -1, &stmt_version, NULL) != SQLITE_OK) {
        NSLog(@"set database version returned error %d: %s", sqlite3_errcode(database), sqlite3_errmsg(database));
        return NO;
    }
    sqlite3_step(stmt_version);
    sqlite3_finalize(stmt_version);

    return YES;
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
#pragma mark Migrate Database

- (BOOL)updateDbFromVer:(int)version {

    switch (version) {
        case 0://version 1 : add the column <company_name> to the table <order_list>
        {
            //get list columns of table <order_list>
            NSString *queryStr = @"PRAGMA table_info('order_list')";
            string cSQL ([queryStr UTF8String]);
            const char *sqlQuery = cSQL.c_str();

            sqlite3_stmt *stmt_list;
            NSMutableArray *result = [[NSMutableArray alloc] init];

            if (sqlite3_prepare(database, sqlQuery, -1, &stmt_list, NULL) != SQLITE_OK) {
                NSLog(@"problem with get tableInfo %@",[NSString stringWithUTF8String:(const char *)sqlite3_errmsg(database)]);
            }
            while (sqlite3_step(stmt_list) == SQLITE_ROW)
            {
                [result addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt_list, 1)]];
            }

            sqlite3_finalize(stmt_list);

            if (![result containsObject:@"company_name"]) {
                //add column to table
                queryStr = @"ALTER TABLE order_list ADD COLUMN company_name TEXT";
                string cSQL ([queryStr UTF8String]);
                sqlQuery = cSQL.c_str();

                sqlite3_stmt *stmt;
                if (sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
                    sqlite3_step(stmt);
                }
                sqlite3_finalize(stmt);
            }
            return YES;
        }
        case 1:
            break;
        default:
            break;
    }
    return NO;
}

@end
