//
//  StylepicsEntryPageViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsEntryPageViewController.h"
#import "UserEvent.h"
#import "User.h"
#import "Cart.h"
#import "Item.h"

@interface StylepicsEntryPageViewController ()

@end

@implementation StylepicsEntryPageViewController

#define CURRENTUSER @"currentUser"
@synthesize username=_username;
@synthesize password=_password;

-(void) setUsername:(UITextField *)username
{
    _username = username;
    username.delegate = self;
}


-(void) setPassword:(UITextField *)password
{
    _password = password;
    password.delegate = self;
}


- (IBAction)login {
    if ([self.username.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else{
        [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
    }
}

- (void)alertForEmptyName {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please type something" message:@"Your username can not be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewsFeed"]) 
    {
        NSUserDefaults* database = [NSUserDefaults standardUserDefaults];
        [database setObject:self.username.text forKey:CURRENTUSER];
        [database synchronize];
    }
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
} 

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{  
    [self login];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
