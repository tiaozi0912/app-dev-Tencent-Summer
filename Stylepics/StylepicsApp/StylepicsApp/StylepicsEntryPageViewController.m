//
//  StylepicsEntryPageViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsEntryPageViewController.h"
#import "User.h"

@interface StylepicsEntryPageViewController () {
    StylepicsDatabase *database;
}

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
    }else if ([database isLoggedInWithUsername:self.username.text password:self.password.text]){
        [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
    }else if ([database existUsername:self.username.text]){
        [self alertForWrongPassword];
    }else {
        [self alertForNonexistentUsername];
    }
}

- (void)alertForEmptyName {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please type something" message:@"Your username can not be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

-(void) alertForNonexistentUsername{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oooops..." message:@"This username does not exist." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

-(void) alertForWrongPassword{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oooops..." message:@"This password does not match this username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewsFeed"]) 
    {
        NSUserDefaults* session = [NSUserDefaults standardUserDefaults];
        [session setObject:self.username.text forKey:CURRENTUSER];
        [session synchronize];
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
     database = [[StylepicsDatabase alloc] init];    
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
