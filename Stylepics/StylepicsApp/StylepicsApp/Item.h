//
//  Item.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *description, *brand;
@property (nonatomic, strong) NSNumber *price, *itemID, *numberOfVotes,*pollID;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSDate* addedTime;
//@property (nonatomic, strong) NSArray *comments;

@end
