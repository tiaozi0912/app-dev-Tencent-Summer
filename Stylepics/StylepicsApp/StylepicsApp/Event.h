//
//  Event.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Poll.h"
#import "Item.h"

#define VOTINGEVENT @"vote"
#define NEWPOLLEVENT @"new poll"
#define NEWITEMEVENT @"new item"

@interface Event : NSObject

@property (nonatomic, strong) NSNumber* eventID;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) Poll* poll;
@property (nonatomic, strong) Item* item;
@property (nonatomic, strong) User* user;

@end
