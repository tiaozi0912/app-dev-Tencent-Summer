//
//  User.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject 

@property (nonatomic, assign) NSNumber *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *photo;

@end
