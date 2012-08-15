//
//  Event.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize eventID=_eventID, userID = _userID, pollID = _pollID, itemID = _itemID, timeStamp = _timeStamp;
@synthesize eventType=_eventType;
@synthesize poll=_poll, pollOwner=_pollOwner;
@synthesize user=_user;
@synthesize item=_item;
@end
