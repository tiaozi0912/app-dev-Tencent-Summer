//
//  PollResultCell.h
//  MuseMe
//
//  Created by Yong Lin on 7/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Utility.h"

@interface PollResultCell : UITableViewCell
@property (nonatomic, weak) IBOutlet HJManagedImageV *itemImage;
//@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIProgressView *numberOfVotesIndicator;
@property (nonatomic, weak) IBOutlet UILabel *numberOfVotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
//@property (weak, nonatomic) IBOutlet AppFormattedLabel *brandPreLabel;
@end
