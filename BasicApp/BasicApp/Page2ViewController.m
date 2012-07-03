//
//  Page2ViewController.m
//  BasicApp
//
//  Created by Yong Lin on 7/2/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Page2ViewController.h"

@interface Page2ViewController ()

@end

@implementation Page2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)returnToFirstPage:(id)sender {  
    [self dismissViewControllerAnimated:YES completion:^{}];  
} 

@end
