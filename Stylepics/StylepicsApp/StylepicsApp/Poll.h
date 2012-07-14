//
//  Poll.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poll : NSObject

@property (nonatomic, strong) NSNumber *pollID, *ownerID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;// state = "EDITING", "VOTING" or "FINISHED"
@property (nonatomic, strong) NSMutableArray *items, *audience;

@end
