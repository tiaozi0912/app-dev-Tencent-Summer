//
//  Utility.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import "StylepicsAppDelegate.h" 
#import "StylepicsDatabase.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"

#define IDOfPollToBeShown @"IDOfPollToBeShown"
#define CURRENTUSERID @"currentUserID"
#define NEWUSER @"newUser"
#define EDITING @"EDITING"
#define VOTING @"VOTING"
#define FINISHED @"FINISHED"
#define ACTIVE @"ACTIVE"
#define PAST @"PAST"
#define FOLLOWED @"FOLLOWED"

@interface Utility : NSObject
{
    
}

+(NSString *) getDatabasePath; 
+(void) showAlert:(NSString *) title message:(NSString *) msg; 
+(void) setObject:(id) obj forKey:(NSString*) key;
+(id) getObjectForKey:(NSString*) key;
@end
