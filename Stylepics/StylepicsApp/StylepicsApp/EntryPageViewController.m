//
//  EntryPageViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "EntryPageViewController.h"

@interface EntryPageViewController ()

@end

@implementation EntryPageViewController

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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHome:) name:UserLoginNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)signup
{
    [self performSegueWithIdentifier:@"signup" sender:self];
}

-(void)showHome:(NSNotification *)notification
{
    if ([notification.name isEqualToString:UserLoginNotification])
    {
        [self performSegueWithIdentifier:@"show home" sender:self];
    }
}

- (IBAction)login
{
    [self performSegueWithIdentifier:@"login" sender:self];
}


@end
