//
//  Item.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSNumber *price, *itemID, *pollID, *numberOfVotes;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSMutableArray *comments;

@end
