//
//  StyliepicsDatabase.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface StylepicsDatabase : NSObject{
    sqlite3 *db;
}

-(void) initDatabase;
-(BOOL) isLoggedInWithUsername:(NSString*) username
                      password:(NSString*) password;
-(BOOL) existUsername:(NSString*) username;
-(NSMutableArray *) getUserInfo;

@end
