//
//  StylepicsAppDelegate.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Utility.h"
#import "HJObjManager.h"

HJObjManager *HJObjectManager;

@interface StylepicsAppDelegate : UIResponder 

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;

-(void) createAndCheckDatabase;

@end
