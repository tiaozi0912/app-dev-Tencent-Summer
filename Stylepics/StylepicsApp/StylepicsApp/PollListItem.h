//
//  PollListItem.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface PollListItem : NSObject

@property (nonatomic, strong) NSNumber *pollID, *userID, *totalVotes;
@property (nonatomic, strong) NSString *type, *title, *state;
@property (nonatomic, strong) User *owner;
@property (nonatomic, strong) NSDate *startTime, *endTime;

@end
