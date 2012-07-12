//
//  StyliepicsDatabase.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsDatabase.h"
#import "User.h"

@implementation StylepicsDatabase

-(BOOL) isLoggedInWithUsername:(NSString*) username
                            password:(NSString*) password{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT userID FROM UserTable WHERE username ='%@' AND password = '%@'", username, password];
    FMResultSet *results = [db executeQuery:query];
    BOOL success = [results next];
    [db close];
    return success; 
}

-(BOOL) existUsername:(NSString*) username{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT userID FROM UserTable WHERE username ='%@'", username];
    FMResultSet *results = [db executeQuery:query];
    BOOL exist = [results next];
    [db close];
    return exist; 
}

-(int) getUserCount{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [[NSString alloc] initWithString:@"SELECT COUNT(*) AS count FROM UserTable"];;
    FMResultSet *results = [db executeQuery:query];
    int userCount = [results intForColumn:@"count"];
    [db close];
    return userCount; 
/*    @try {
        NSString *query = [[NSString alloc] initWithString:@"SELECT COUNT(*) FROM UserTable"];
        const char *sql = [query UTF8String];
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        result = sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return result;
    }*/
}
-(BOOL) addNewUserWithUsername:(NSString*) username
                      password:(NSString*) password{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    BOOL success = [db executeUpdate:@"INSERT INTO UserTable (username, password) VALUES(?,?)", username, password];
    [db close];
    return success;
}

/*-(NSMutableArray *) getUserInfo{
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    @try {
        const char *sql = "SELECT userID, username, password, photo FROM UserTable";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            User *MyUser = [[User alloc]init];
            MyUser.userID = sqlite3_column_int(sqlStatement, 0);
            MyUser.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            MyUser.password = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            const char *raw = sqlite3_column_blob(sqlStatement, 3);
            int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            NSData *data = [NSData dataWithBytes:raw length:rawLen];
            MyUser.photo = [[UIImage alloc] initWithData:data];
            [userArray addObject:MyUser];
        }
        sqlite3_finalize(sqlStatement);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return userArray;
    }
 }*/


@end
