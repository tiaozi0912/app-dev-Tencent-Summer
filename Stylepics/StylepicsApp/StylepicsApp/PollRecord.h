//
//  PollRecord.h
//  MuseMe
//
//  Created by Yong Lin on 8/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define EDITING_POLL 0
#define OPENED_POLL 1
#define ENDED_POLL 2
#define VOTED_POLL 3

@interface PollRecord : NSObject


@property (nonatomic, strong) NSNumber *pollID, *userID, *totalVotes,*pollRecordType, *state, *itemsCount;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) User *owner;
@property (nonatomic, strong) NSDate *startTime, *endTime, *openTime;

@end
