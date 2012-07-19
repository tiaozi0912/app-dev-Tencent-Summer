//
//  StyliepicsDatabase.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsDatabase.h"


@implementation StylepicsDatabase

-(void) initialize{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    [db executeUpdate:@"CREATE  TABLE  IF NOT EXISTS \"UserTable\" (\"userID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"username\" VARCHAR NOT NULL , \"password\" VARCHAR NOT NULL , \"photo\" BLOB)"];
    [db executeUpdate:@"CREATE  TABLE  IF NOT EXISTS \"EventTable\" (\"eventID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"type\" VARCHAR, \"userID\" INTEGER, \"pollID\" INTEGER, \"itemID\" INTEGER, \"voteeID\" INTEGER)"];
    [db executeUpdate:@"CREATE  TABLE  IF NOT EXISTS \"PollTable\" (\"pollID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"name\" VARCHAR, \"ownerID\" INTEGER, \"state\" VARCHAR DEFAULT EDITING, \"totalVotes\" INTEGER DEFAULT 0, \"maxVotesForSingleItem\" INTEGER DEFAULT 1)"];
    
}

-(BOOL) isLoggedInWithUsername:(NSString*) username
                            password:(NSString*) password{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT userID FROM UserTable WHERE username =? AND password = ?", username, password];
    BOOL success = [results next];
    if (success) {
        [Utility setObject:[NSNumber numberWithInt:[results intForColumn:@"userID"]] forKey:CURRENTUSERID]; 
    }
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
    if (success){
    int userID = [db intForQuery:@"SELECT userID FROM UserTable WHERE username = ?", username];
    NSString *query = [[NSString alloc] initWithFormat:@"CREATE TABLE \"User_%d_PollTable\" (\"pollID\" INTEGER PRIMARY KEY  NOT NULL , \"type\" VARCHAR)", userID];
    [db executeUpdate:query];
    [Utility setObject:[NSNumber numberWithInt:userID] forKey:CURRENTUSERID];
    }
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
-(NSArray*) getMostRecentEventsNum:(NSNumber*) number
{
    NSMutableArray *events = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];  
    int eventCount = [db intForQuery:@"SELECT count(*) FROM EventTable"];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM EventTable WHERE eventID > ? ORDER BY eventID DESC", [NSNumber numberWithInt:(eventCount - [number intValue])]];
    while ([results next]) {
        UserEvent *event = [[UserEvent alloc] init];
        event.type = [results stringForColumn:@"type"];
        event.userID = [NSNumber numberWithInt:[results intForColumn:@"userID"]];
        event.pollID = [NSNumber numberWithInt:[results intForColumn:@"pollID"]];
        event.itemID = [NSNumber numberWithInt:[results intForColumn:@"itemID"]];
        event.voteeID= [NSNumber numberWithInt:[results intForColumn:@"voteeID"]];
        [events addObject:event];
    }
    [db close];
    return [events copy];
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
    [db close];
    return poll;
}

-(Poll*) getPollDetailsWithID:(NSNumber *)pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    Poll *poll = [[Poll alloc] init];
    poll.pollID = pollID;
    FMResultSet *results=[db executeQuery:@"SELECT * FROM PollTable WHERE pollID = ?", pollID];
    while ([results next]){
    poll.name = [results stringForColumn:@"name"];
    poll.ownerID =[NSNumber numberWithInt:[results intForColumn:@"ownerID"]];
    poll.state = [results stringForColumn:@"state"];
    poll.totalVotes = [NSNumber numberWithInt:[results intForColumn:@"totalVotes"]];
    }
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Poll_%d_ItemTable ORDER BY itemID DESC", [pollID intValue]];
    results = [db executeQuery:query];
    poll.items= [[NSMutableArray alloc] init];
    while ([results next]){
        Item *item = [[Item alloc] init];
        item.itemID = [NSNumber numberWithInt:[results intForColumn:@"itemID"]];
        item.description = [results stringForColumn:@"description"];
        item.price = [NSNumber numberWithDouble:[results doubleForColumn:@"price"]];
        item.photo = [[UIImage alloc] initWithData:[results dataForColumn:@"photo"]];
        item.numberOfVotes = [NSNumber numberWithInt:[results intForColumn:@"numberOfVotes"]];
        //item.comments to be implemented...
        [poll.items addObject:item];
    }
    //poll.audience...
    [db close];
    return poll;
}

-(Poll*) getPollResultWithID:(NSNumber *)pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    Poll *poll = [[Poll alloc] init];
    poll.pollID = pollID; 
    FMResultSet *results=[db executeQuery:@"SELECT * FROM PollTable WHERE pollID = ?", pollID];
    while ([results next]){
        poll.name = [results stringForColumn:@"name"];
        poll.ownerID =[NSNumber numberWithInt:[results intForColumn:@"ownerID"]];
        poll.state = [results stringForColumn:@"state"];
        poll.totalVotes = [NSNumber numberWithInt:[results intForColumn:@"totalVotes"]];
        poll.maxVotesForSingleItem = [NSNumber numberWithInt:[results intForColumn:@"maxVotesForSingleItem"]];
    }
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Poll_%d_ItemTable ORDER BY numberOfVotes DESC", [pollID intValue]];
    results = [db executeQuery:query];
    poll.items= [[NSMutableArray alloc] init];
    while ([results next]){
        Item *item = [[Item alloc] init];
        item.itemID = [NSNumber numberWithInt:[results intForColumn:@"itemID"]];
        item.description = [results stringForColumn:@"description"];
        item.price = [NSNumber numberWithDouble:[results doubleForColumn:@"price"]];
        item.photo = [[UIImage alloc] initWithData:[results dataForColumn:@"photo"]];
        item.numberOfVotes = [NSNumber numberWithInt:[results intForColumn:@"numberOfVotes"]];
        //item.comments to be implemented...
        [poll.items addObject:item];
    }
    //poll.audience...
    [db close];
    return poll;
}
-(Item*) getItemWithID:(NSNumber*) itemID
                pollID:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    Item *item = [[Item alloc] init];
    item.itemID = itemID;
    item.pollID = pollID;
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT photo FROM Poll_%@_ItemTable WHERE itemID = %@", pollID,itemID];
    item.photo = [[UIImage alloc] initWithData:[db dataForQuery:query]];
    [db close];
    return item;    
}
//new poll 

-(void) newAPollCalled:(NSString*) name
             byUserID:(NSNumber*) userID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    // db.traceExecution = YES;
    // db.logsErrors = YES;
    [db executeUpdate:@"INSERT INTO PollTable (name, ownerID, state) VALUES (?,?,?)", name, userID, @"EDITING"];
    NSNumber *pollID = [NSNumber numberWithInt:[db intForQuery:@"SELECT max(pollID) FROM PollTable"]];
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO User_%@_PollTable (pollID, type) VALUES (%@, \"ACTIVE\")", userID, pollID];
    [db executeUpdate:query];
    query = [[NSString alloc] initWithFormat:@"CREATE TABLE \"Poll_%d_ItemTable\" (\"itemID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"description\" VARCHAR, \"price\" DOUBLE, \"photo\" BLOB, \"numberOfVotes\" INTEGER DEFAULT 0)", [pollID intValue]];
    [db executeUpdate:query];
    query = [[NSString alloc] initWithFormat:@"CREATE TABLE \"Poll_%d_AudienceTable\" (\"audienceID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"voted\" BOOL DEFAULT (0), \"userID\" INTEGER )", [pollID intValue]];
    [db executeUpdate:query];
    [db executeUpdate:@"INSERT INTO EventTable (type, userID, pollID) VALUES ('new poll', ?, ?)", userID, pollID];
    [db close];
    [Utility setObject:pollID forKey:IDOfPollToBeShown];
}

-(void) addItems:(Item*)item toPoll:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
    [db open];
    sqlite3 *database = [db sqliteHandle];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT INTO Poll_%d_ItemTable (description, price, photo) VALUES (?,?,?)", [pollID intValue]];
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [item.description UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(statement, 2, [item.price doubleValue]);
		NSData *imageData = UIImagePNGRepresentation(item.photo);
		sqlite3_bind_blob(statement, 3, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
		sqlite3_step(statement);
	}
    sqlite3_finalize(statement); 
    NSNumber *userID = [NSNumber numberWithInt:[db intForQuery:@"SELECT ownerID FROM PollTable WHERE pollID = ?", pollID]];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT max(itemID) FROM Poll_%@_ItemTable", pollID];
    NSNumber *itemID = [NSNumber numberWithInt:[db intForQuery:query]];
    [db executeUpdate:@"INSERT INTO EventTable (type, userID, pollID, itemID) VALUES ('new item',?,?,?)", userID, pollID, itemID];
    [db close];
}

-(void) changeStateOfPoll:(NSNumber*) pollID to:(NSString*)state{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
    [db open];
    [db executeUpdate:@"UPDATE PollTable SET state = ? WHERE pollID = ?", state, pollID];
    if ([state isEqualToString:FINISHED]) {
        NSNumber *userID = [Utility getObjectForKey:CURRENTUSERID];
        NSString *query = [[NSString alloc] initWithFormat:@"UPDATE User_%@_PollTable SET type = \"PAST\" WHERE pollID = %@", userID, pollID];
        [db executeUpdate:query];
    }
    [db close];
}

-(BOOL) user:(NSNumber*) userID isAudienceOfPoll:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Poll_%d_AudienceTable WHERE userID = %d", [pollID intValue], [userID intValue]];
    FMResultSet *result = [db executeQuery:query];
    BOOL exist = [result next];
    [db close];
    return exist;
}

-(void) user:(NSNumber*) userID becomesAudienceOfPoll:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO Poll_%d_AudienceTable (userID) VALUES (%d)", [pollID intValue], [userID intValue]];
    [db executeUpdate:query];
    query = [[NSString alloc] initWithFormat:@"UPDATE User_%@_PollTable SET type = \"FOLLOWED\" WHERE pollID = %@", userID, pollID];
    [db executeUpdate:query];
    [db close];
}
-(BOOL) voteForItem:(NSNumber*) itemID 
             inPoll:(NSNumber*) pollID 
             byUser:(NSNumber*) userID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
    [db open];    
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT voted FROM Poll_%d_AudienceTable WHERE userID = %d", [pollID intValue], [userID intValue]];
    if ([db boolForQuery:query]){
        return NO;
    }
    query = [[NSString alloc] initWithFormat:@"SELECT numberOfVotes FROM Poll_%d_ItemTable WHERE itemID = %d", [pollID intValue], [itemID intValue]];
    int newNumberOfVotes = [db intForQuery:query] + 1;
    int maxVotesForSingleItem = [db intForQuery:@"SELECT maxVotesForSingleItem FROM PollTable WHERE pollID = ?", pollID];
    query = [[NSString alloc] initWithFormat:@"UPDATE Poll_%d_ItemTable SET numberOfVotes = %d WHERE itemID = %d", [pollID intValue],newNumberOfVotes+1, [itemID intValue]];
    [db executeUpdate:query];
    int newTotalVotes = [db intForQuery:@"SELECT totalVotes FROM PollTable WHERE pollID = ?", pollID] + 1;
    [db executeUpdate:@"UPDATE PollTable SET totalVotes = ? WHERE pollID = ?", [NSNumber numberWithInt: newTotalVotes], pollID]; 
    if (newTotalVotes > maxVotesForSingleItem){
        [db executeUpdate:@"UPDATE PollTable SET maxVotesForSingleItem = ? WHERE pollID = ?",[NSNumber numberWithInt: newTotalVotes], pollID];
    }
    query = [[NSString alloc] initWithFormat:@"UPDATE Poll_%d_AudienceTable SET voted = 1 WHERE userID = %d", [pollID intValue],[userID intValue]];
    [db executeUpdate:query];    
    NSNumber *voteeID = [NSNumber numberWithInt:[db intForQuery:@"SELECT ownerID FROM PollTable WHERE pollID = ?", pollID]];
    [db executeUpdate:@"INSERT INTO EventTable (type, userID, pollID, voteeID) VALUES ('vote', ?, ?, ?)", userID, pollID, voteeID];
    [db close];
    return YES;
}

-(NSArray*) getPollOfType:(NSString*) type forUser:(NSNumber*) userID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    db.traceExecution=YES; 
    db.logsErrors=YES; 
    [db open]; 
    NSMutableArray *polls = [[NSMutableArray alloc] init];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM User_%@_PollTable WHERE type = \"%@\" ORDER BY pollID DESC", userID, type];
    FMResultSet *results = [db executeQuery:query];
    while ([results next]&&(polls.count < 30)) {
        Poll *poll = [[Poll alloc] init];
        poll.type = [results stringForColumn:@"type"];
        poll.pollID = [NSNumber numberWithInt:[results intForColumn:@"pollID"]];
        FMResultSet *rs=[db executeQuery:@"SELECT * FROM PollTable WHERE pollID = ?", poll.pollID];
        while ([rs next]){
            poll.name = [rs stringForColumn:@"name"];
            poll.ownerID =[NSNumber numberWithInt:[rs intForColumn:@"ownerID"]];
            poll.state = [rs stringForColumn:@"state"];
            poll.totalVotes = [NSNumber numberWithInt:[rs intForColumn:@"totalVotes"]];
        }
        [polls addObject:poll];
    }
    [db close];
    return [polls copy];
}
@end
