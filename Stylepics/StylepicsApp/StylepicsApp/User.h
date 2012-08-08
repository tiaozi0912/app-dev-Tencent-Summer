//
//  User.h
//  BasicApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *username, *password, *passwordConfirmation, *email, *singleAccessToken;
@property (nonatomic, strong) NSString *profilePhotoURL;
@end
