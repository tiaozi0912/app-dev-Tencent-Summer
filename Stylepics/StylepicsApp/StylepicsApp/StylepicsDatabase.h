//
//  StyliepicsDatabase.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Utility.h"


@interface StylepicsDatabase : NSObject//<RKObjectLoaderDelegate>

/*//-(void) initialize;
-(BOOL) isLoggedInWithUsername:(NSString*) username
                      password:(NSString*) password;
-(BOOL) existUsername:(NSString*) username;
-(int) getUserCount;
//-(void) closeDatabase;
-(BOOL) addNewUserWithUsername:(NSString*) username
                      password:(NSString*) password;


//-(NSMutableArray *) getUserInfo;

+(NSArray*) getMostRecentEventsNum:(NSNumber*) number;
+(User*) getUserWithID:(NSNumber *) userID;
+(Poll*) getPollWithID:(NSNumber*) pollID;
+(Poll*) getPollDetailsWithID:(NSNumber *)pollID;
+(Poll*) getPollResultWithID:(NSNumber *)pollID;
+(Item*) getItemWithID:(NSNumber*) itemID
                pollID:(NSNumber*) pollID;
+(void) newAPollCalled:(NSString*) name
              byUserID:(NSNumber*) userID;
+(void) addItems:(Item*)item toPoll:(NSNumber*) pollID;
+(void) changeStateOfPoll:(NSNumber*) pollID
                       to:(NSString*) state;
+(BOOL) voteForItem:(NSNumber*) itemID
             inPoll:(NSNumber*) PollID 
             byUser:(NSNumber*) userID;
+(BOOL) user:(NSNumber*) userID isAudienceOfPoll:(NSNumber*) pollID;
+(void) user:(NSNumber*) userID becomesAudienceOfPoll:(NSNumber*) pollID;
+(NSArray*) getPollOfType:(NSString*) type forUser:(NSNumber*) userID;
+(BOOL) deleteItem:(NSNumber*)itemID inPoll:(NSNumber*)pollID;*/
@end
