//
//  Event.h
//  MuseMe
//
//  Created by Yong Lin on 8/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Poll.h"
#import "Item.h"

/*#define VOTINGEVENT @"vote"
#define NEWPOLLEVENT @"new poll"
#define NEWITEMEVENT @"new item"*/

@interface Event : NSObject

@property (nonatomic, strong) NSNumber *eventID, *pollID, *userID;
//@property (nonatomic, strong) NSString* eventType;
@property (nonatomic, strong) Poll *poll;
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSDate *timeStamp;

@end
