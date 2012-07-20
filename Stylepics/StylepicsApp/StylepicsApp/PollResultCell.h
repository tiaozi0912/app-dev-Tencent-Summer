//
//  PollResultCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface PollResultCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIProgressView *numberOfVotesIndicator;
@property (nonatomic, weak) IBOutlet UILabel *numberOfVotesLabel;
@end
