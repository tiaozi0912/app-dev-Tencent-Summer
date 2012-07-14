//
//  PollItemCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PollItemCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *descriptionOfItemLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *commentIconImage;
@property (nonatomic, weak) IBOutlet UILabel *countOfCommentsLabel;

@end
