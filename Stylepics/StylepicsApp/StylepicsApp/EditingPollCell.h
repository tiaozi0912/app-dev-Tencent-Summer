//
//  EditingPollCell.h
//  MuseMe
//
//  Created by Yong Lin on 8/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface EditingPollCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AppFormattedLabel *pollDescriptionLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *startTimeLabel;

@end
