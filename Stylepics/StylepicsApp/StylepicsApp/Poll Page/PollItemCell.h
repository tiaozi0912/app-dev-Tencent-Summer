//
//  PollItemCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Utility.h"

@interface PollItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet HJManagedImageV *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *descriptionOfItemLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@end
