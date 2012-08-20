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

typedef enum{
    Apparel = 0,
    Accessory = 1,
    Food = 2,
    Electronics = 3,
    Automotive = 4,
    Others = 5
}PollCategory;

@interface Poll : NSObject

@property (nonatomic, strong) NSNumber *pollID, *totalVotes, *ownerID, *followerCount;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *state;// state = "EDITING", "VOTING" or "FINISHED"
@property (nonatomic, strong) NSMutableArray *items, *audiences;
@property (nonatomic, strong) NSDate *startTime, *endTime;
@property (nonatomic) PollCategory category;

@end
