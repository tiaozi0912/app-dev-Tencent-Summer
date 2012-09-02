//
//  OpenedPollCell.h
//  MuseMe
//
//  Created by Yong Lin on 8/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@interface OpenedPollCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AppFormattedLabel *pollDescriptionLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *votesCountLabel;
@property (weak, nonatomic) IBOutlet AppFormattedLabel *openTimeLabel;
@end
