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

@interface StylepicsDatabase : NSObject

//-(void) initDatabase;
-(BOOL) isLoggedInWithUsername:(NSString*) username
                      password:(NSString*) password;
-(BOOL) existUsername:(NSString*) username;
//-(void) closeDatabase;
-(BOOL) addNewUserWithUsername:(NSString*) username
                      password:(NSString*) password;


//-(NSMutableArray *) getUserInfo;

@end
