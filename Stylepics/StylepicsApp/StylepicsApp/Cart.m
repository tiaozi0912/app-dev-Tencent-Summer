//
//  Cart.m
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Cart.h"

@implementation Cart

@synthesize name=_name;
@synthesize items=_items;

-(void) addItem:(Item *) item {
    [self.items addObject:item];
}

@end
