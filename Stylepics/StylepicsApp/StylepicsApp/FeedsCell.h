//
//  FeedsCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface FeedsCell : UITableViewCell
@property (nonatomic, weak) IBOutlet HJManagedImageV *userImage;
@property (nonatomic, weak) IBOutlet UILabel *eventDescriptionLabel;
@property (nonatomic, weak) IBOutlet HJManagedImageV *thumbnail;
@property (nonatomic, weak) IBOutlet SmallFormattedLabel *timeStampLabel;
@property (nonatomic, weak) IBOutlet HJManagedImageV
*categoryIcon;
@property (weak, nonatomic) IBOutlet MultipartLabel *usernameAndActionLabel;
@end
