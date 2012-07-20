//
//  ActivePollCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ActivePollCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *votesLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@end
