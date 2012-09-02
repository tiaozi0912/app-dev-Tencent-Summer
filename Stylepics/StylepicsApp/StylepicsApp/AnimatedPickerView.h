//
//  AnimatedPickerView.h
//  MuseMe
//
//  Created by Yong Lin on 8/20/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedPickerView : UIPickerView
@property (nonatomic) BOOL isOn;
-(void)presentPickerView;
-(void)dismissPickerView;
@end
