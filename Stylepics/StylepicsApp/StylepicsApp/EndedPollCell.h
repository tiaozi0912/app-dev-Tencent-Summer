//
//  EndedPollCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface EndedPollCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AppFormattedLabel *pollDescriptionLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *votesCountLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *endTimeLabel;
@end
