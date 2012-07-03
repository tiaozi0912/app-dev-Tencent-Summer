//
//  BasicAppViewController.m
//  BasicApp
//
//  Created by Yong Lin on 7/2/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "BasicAppViewController.h"

@interface BasicAppViewController ()

@end

@implementation BasicAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
