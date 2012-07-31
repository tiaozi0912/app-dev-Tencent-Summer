//
//  StyliepicsDatabase.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsDatabase.h"


@implementation StylepicsDatabase{
    BOOL success;
    
}

/*-(void) initialize{
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
    int userCount = [db intForQuery:@"SELECT count(*) AS '# of user' FROM UserTable"];
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
/*}
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
    user.username = [db stringForQuery:@"SELECT username FROM UserTable WHERE userID = ?", userID];
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
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Poll_%d_ItemTable WHERE deleted = 0 ORDER BY itemID DESC", [pollID intValue]];
    results = [db executeQuery:query];
    poll.items= [[NSMutableArray alloc] init];
    while ([results next]){
        Item *item = [[Item alloc] init];
        item.itemID = [NSNumber numberWithInt:[results intForColumn:@"itemID"]];
        item.description = [results stringForColumn:@"description"];
        item.price = [NSNumber numberWithDouble:[results doubleForColumn:@"price"]];
        item.photoURL = [NSURL URLWithString:[results stringForColumn:@"photoURL"]];
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
   /* NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Poll_%d_ItemTable ORDER BY numberOfVotes DESC", [pollID intValue]];*/
/*    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM Poll_%d_ItemTable WHERE deleted = 0 ORDER BY itemID DESC", [pollID intValue]];
    results = [db executeQuery:query];
    poll.items= [[NSMutableArray alloc] init];
    while ([results next]){
        Item *item = [[Item alloc] init];
        item.itemID = [NSNumber numberWithInt:[results intForColumn:@"itemID"]];
        item.description = [results stringForColumn:@"description"];
        item.price = [NSNumber numberWithDouble:[results doubleForColumn:@"price"]];
        item.photoURL = [NSURL URLWithString:[results stringForColumn:@"photoURL"]];
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
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT photoURL FROM Poll_%@_ItemTable WHERE itemID = %@", pollID,itemID];
    item.photoURL = [NSURL URLWithString:[db stringForQuery:query]];
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
    query = [[NSString alloc] initWithFormat:@"CREATE TABLE \"Poll_%d_ItemTable\" (\"itemID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"description\" VARCHAR, \"price\" DOUBLE, \"photoURL\" VARCHAR, \"numberOfVotes\" INTEGER DEFAULT 0, \"deleted\" BOOL DEFAULT 0)", [pollID intValue]];
    [db executeUpdate:query];
    query = [[NSString alloc] initWithFormat:@"CREATE TABLE \"Poll_%d_AudienceTable\" (\"audienceID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"voted\" BOOL DEFAULT (0), \"userID\" INTEGER )", [pollID intValue]];
    [db executeUpdate:query];
    [db executeUpdate:@"INSERT INTO EventTable (type, userID, pollID) VALUES ('new poll', ?, ?)", userID, pollID];
    [db close];
    [Utility setObject:pollID forKey:IDOfPollToBeShown];
}

-(void) addItems:(Item*)item toPoll:(NSNumber*) pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    db.traceExecution=YES; 
    db.logsErrors=YES; 
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO Poll_%@_ItemTable (description, price, photoURL) VALUES (\"%@\",%@,\"%@\")", pollID, item.description, item.price, [item.photoURL absoluteString]];
    [db executeUpdate:query];
    NSNumber *userID = [NSNumber numberWithInt:[db intForQuery:@"SELECT ownerID FROM PollTable WHERE pollID = ?", pollID]];
    query = [[NSString alloc] initWithFormat:@"SELECT max(itemID) FROM Poll_%@_ItemTable", pollID];
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
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO Poll_%@_AudienceTable (userID) VALUES (%@)", pollID, userID];
    [db executeUpdate:query];
    query = [[NSString alloc] initWithFormat:@"INSERT INTO User_%@_PollTable (pollID, type) VALUES (%@,'FOLLOWED')", userID, pollID];
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
    query = [[NSString alloc] initWithFormat:@"UPDATE Poll_%d_ItemTable SET numberOfVotes = %d WHERE itemID = %d", [pollID intValue],newNumberOfVotes, [itemID intValue]];
    [db executeUpdate:query];
    
    int maxVotesForSingleItem = [db intForQuery:@"SELECT maxVotesForSingleItem FROM PollTable WHERE pollID = ?", pollID];
    
    if (newNumberOfVotes > maxVotesForSingleItem){
        [db executeUpdate:@"UPDATE PollTable SET maxVotesForSingleItem = ? WHERE pollID = ?",[NSNumber numberWithInt: newNumberOfVotes], pollID];
    }
    
    int newTotalVotes = [db intForQuery:@"SELECT totalVotes FROM PollTable WHERE pollID = ?", pollID] + 1;
    [db executeUpdate:@"UPDATE PollTable SET totalVotes = ? WHERE pollID = ?", [NSNumber numberWithInt: newTotalVotes], pollID]; 

    query = [[NSString alloc] initWithFormat:@"UPDATE Poll_%d_AudienceTable SET voted = 1 WHERE userID = %d", [pollID intValue],[userID intValue]];
    [db executeUpdate:query];    
    NSNumber *voteeID = [NSNumber numberWithInt:[db intForQuery:@"SELECT ownerID FROM PollTable WHERE pollID = ?", pollID]];
    [db executeUpdate:@"INSERT INTO EventTable (type, userID, pollID, voteeID) VALUES ('vote', ?, ?, ?)", userID, pollID, voteeID];
    [db close];
    return YES;
}

-(NSArray*) getPollOfType:(NSString*) type forUser:(NSNumber*) userID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
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

-(BOOL) deleteItem:(NSNumber*)itemID inPoll:(NSNumber*)pollID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution=YES; 
    //db.logsErrors=YES; 
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:@"UPDATE Poll_%@_ItemTable SET deleted = 1 WHERE itemID = %@", pollID, itemID];
    BOOL success = [db executeUpdate:query];
    [db close];
    return success;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if [objectLoader ]
    // Login was successful
    User* user = [objects objectAtIndex:0];
    [Utility setObject:user.userID forKey:CURRENTUSERID];
    [Utility setObject:@"FALSE" forKey:NEWUSER];
    [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: non-existent user and wrong password
    [Utility showAlert:@"Error!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}*/
@end
