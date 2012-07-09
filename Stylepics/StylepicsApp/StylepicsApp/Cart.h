//
//  Cart.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Cart : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *items;

-(void) addItem:(Item *) item;
@end
