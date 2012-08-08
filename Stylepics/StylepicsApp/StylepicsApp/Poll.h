//
//  Poll.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define EDITING @"EDITING"
#define VOTING @"VOTING"
#define FINISHED @"FINISHED"

@interface Poll : NSObject

@property (nonatomic, strong) NSNumber *pollID, *totalVotes, *maxVotesForSingleItem, *ownerID;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *state;// state = "EDITING", "VOTING" or "FINISHED"
@property (nonatomic, strong) NSArray *items, *audiences;
@property (nonatomic, strong) NSDate *startTime, *endTime;

@end
