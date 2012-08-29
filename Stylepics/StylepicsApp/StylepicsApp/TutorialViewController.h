//
//  TutorialViewController.h
//  StylepicsApp
//
//  Created by Yong Lin on 8/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TutorialViewController : UIViewController<UIScrollViewDelegate>
{
   // NSArray *contentList;
    BOOL pageControlUsed;
}
//@property (nonatomic, strong) NSArray *contentList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

-(UIView*) view;
-(IBAction)changePage:(id)sender;
@end
