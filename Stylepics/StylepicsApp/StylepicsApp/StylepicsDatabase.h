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
#import "UserEvent.h"
#import "User.h"
#import "Poll.h"

@interface StylepicsDatabase : NSObject

//-(void) initDatabase;
-(BOOL) isLoggedInWithUsername:(NSString*) username
                      password:(NSString*) password;
-(BOOL) existUsername:(NSString*) username;
-(int) getUserCount;
//-(void) closeDatabase;
-(BOOL) addNewUserWithUsername:(NSString*) username
                      password:(NSString*) password;


//-(NSMutableArray *) getUserInfo;

-(NSMutableArray*) getMostRecentEventsNum:(NSNumber*) number;
-(User*) getUserWithID:(NSNumber *) userID;
-(Poll*) getPollWithID:(NSNumber*) pollID;
-(Item*) getItemWithID:(NSNumber*) itemID
                pollID:(NSNumber*) pollID;
-(void) newAPollCalled:(NSString*) name
              byUserID:(NSNumber*) userID;
@end
