//
//  FeedsCell.h
//  MuseMe
//
//  Created by Yong Lin on 8/23/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface FeedsCell : UITableViewCell
@property (nonatomic, weak) IBOutlet HJManagedImageV *userImage;
@property (nonatomic, weak) IBOutlet UILabel *eventDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalVotes;
@property (nonatomic, weak) IBOutlet SmallFormattedLabel *timeStampLabel;
@property (nonatomic, weak) IBOutlet HJManagedImageV
*categoryIcon;

@property (weak, nonatomic) IBOutlet MultipartLabel *usernameAndActionLabel;

@property (nonatomic, weak) IBOutlet HJManagedImageV *thumbnail0;
@property (nonatomic, weak) IBOutlet HJManagedImageV *thumbnail1;
@property (nonatomic, weak) IBOutlet HJManagedImageV *thumbnail2;
@property (nonatomic, weak) IBOutlet HJManagedImageV *thumbnail3;
@property (nonatomic, weak) IBOutlet HJManagedImageV *thumbnail4;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picContainerImageView;
@property (weak, nonatomic) IBOutlet UIView *picContainer;
@property (weak, nonatomic) IBOutlet UIView *seperator;

//@property (weak, nonatomic) IBOutlet UIImageView *picFrameImageView;
@end
