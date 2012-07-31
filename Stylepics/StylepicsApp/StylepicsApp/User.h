//
//  User.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *username, *password;
@property (nonatomic, strong) UIImage *profilePhoto;
@property (nonatomic, strong) NSURL *profilePhotoURL;

@end
