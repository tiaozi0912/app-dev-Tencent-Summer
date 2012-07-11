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
-(void) initDatabase{
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"stylepics.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }

}
-(BOOL) isLoggedInWithUsername:(NSString*) username
                            password:(NSString*) password{
    BOOL result;
    @try {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT id FROM UserTable WHERE username ='%@' AND password = '%@'", username, password];
        const char *sql = [query UTF8String];
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        result = (sqlite3_step(sqlStatement)==SQLITE_ROW);
        sqlite3_finalize(sqlStatement);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return result;
    }
}

-(BOOL) existUsername:(NSString*) username{
    BOOL result;
    @try {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT id FROM UserTable WHERE username ='%@'", username];
        const char *sql = [query UTF8String];
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        result = (sqlite3_step(sqlStatement)==SQLITE_ROW);
        sqlite3_finalize(sqlStatement);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return result;
    }
}

-(NSMutableArray *) getUserInfo{
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    @try {
        const char *sql = "SELECT id, username, password, photo FROM UserTable";
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
}
@end
