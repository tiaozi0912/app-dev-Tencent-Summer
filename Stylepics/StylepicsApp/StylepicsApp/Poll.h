//
//  Poll.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define EDITING 0
#define VOTING 1
//#define FINISHED 2

#define PollTypeCount 12

typedef enum{
    Art = 0,
    Automotive = 1,
    Beauty = 2,
    Cuteness = 3,
    Electronics = 4,
    Events = 5,
    Fashion = 6,
    Food = 7,
    Humor = 8,
    Media = 9,
    Travel = 10,
    Other= 11,
}PollCategory;

@interface Poll : NSObject

@property (nonatomic, strong) NSNumber *pollID, *totalVotes, *ownerID, *followerCount;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *state;// state = EDITING, VOTING or FINISHED
@property (nonatomic, strong) NSMutableArray *items, *audiences;
@property (nonatomic, strong) NSDate *startTime, *endTime, *openTime;
@property (nonatomic) NSNumber* category;

@end
