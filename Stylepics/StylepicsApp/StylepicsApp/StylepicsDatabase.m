//
//  StyliepicsDatabase.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsDatabase.h"


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
    NSString *query = [[NSString alloc] initWithString:@"SELECT count(*) AS '# of user' FROM UserTable"];
    int userCount = [db intForQuery:query];
    NSLog(@"%d", userCount);
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
-(NSMutableArray*) getMostRecentEventsNum:(NSNumber*) number
{
    NSMutableArray *events = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];  
    int eventCount = [db intForQuery:@"SELECT count(*) FROM EventTable"];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM EventTable ORDER BY eventID DESC WHERE eventID > ?", [NSNumber numberWithInt:(eventCount - [number intValue])]];
    [db close];
    while ([results next]) {
        UserEvent *event = [[UserEvent alloc] init];
        event.type = [results stringForColumn:@"type"];
        event.userID = [NSNumber numberWithInt:[results intForColumn:@"userID"]];
        event.pollID = [NSNumber numberWithInt:[results intForColumn:@"pollID"]];
        event.itemID = [NSNumber numberWithInt:[results intForColumn:@"itemID"]];
        event.voteeID= [NSNumber numberWithInt:[results intForColumn:@"voteeID"]];
        [events addObject:event];
    }
    return events;
}

-(User*) getUserWithID:(NSNumber*) userID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    User *user = [[User alloc] init];
    user.userID = userID;
    user.name = [db stringForQuery:@"SELECT username FROM UserTable WHERE userID = ?", userID];
    user.photo = [[UIImage alloc] initWithData:[db dataForQuery:@"SELECT photo FROM UserTable WHERE userID = ?", userID]];
    return user;
}

-(Poll*) getPollWithID:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    Poll *poll = [[Poll alloc] init];
    poll.pollID = pollID;
    poll.name = [db stringForQuery:@"SELECT name FROM PollTable WHERE pollID = ?", pollID];
    return poll;
}

-(Item*) getItemWithID:(NSNumber*) itemID
                pollID:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    Item *item = [[Item alloc] init];
    item.userID = userID;
    user.name = [db stringForQuery:@"SELECT username FROM UserTable WHERE userID = ?", userID];
    user.photo = [[UIImage alloc] initWithData:[db dataForQuery:@"SELECT photo FROM UserTable WHERE userID = ?", userID]];
    return user;    
}
@end
