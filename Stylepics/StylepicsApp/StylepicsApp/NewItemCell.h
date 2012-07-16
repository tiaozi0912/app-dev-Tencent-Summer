//
//  NewItemCell.h
//  StylepicsApp
//
//  Created by Yong Lin on 7/14/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (nonatomic, retain) UITapGestureRecognizer *tap;
@end
