//
//  StylepicsEntryPageViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "StylepicsEntryPageViewController.h"
#import "User.h"
#import "Utility.h"

@interface StylepicsEntryPageViewController () {
    StylepicsDatabase *database;
}

@end

@implementation StylepicsEntryPageViewController
@synthesize username=_username;
@synthesize password=_password;


-(void) setUsername:(UITextField *)username
{
    _username = username;
    self.username.delegate = self;
}


-(void) setPassword:(UITextField *)password
{
    _password = password;
    self.password.delegate = self;
}


- (IBAction)login {
    if ([self.username.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else if ([database isLoggedInWithUsername:self.username.text password:self.password.text]){
        [Utility setObject:@"FALSE" forKey:NEWUSER];
        [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
    }else if ([database existUsername:self.username.text]){
        [self alertForWrongPassword];
    }else {
        [self alertForNonexistentUsername];
    }
}

- (void)alertForEmptyName {
    [Utility showAlert:@"Please type something" message:@"Your username can not be empty."];
}

-(void) alertForNonexistentUsername{
    [Utility showAlert:@"Oooops..." message:@"This username does not exist."];
}

-(void) alertForWrongPassword{
    [Utility showAlert:@"Oooops..." message:@"This password does not match this username."];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNewsFeed"]) 
    {
        //
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
    [database getUserCount];
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
