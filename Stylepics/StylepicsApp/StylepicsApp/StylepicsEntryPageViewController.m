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
    NSMutableArray *userInfoTable;
}

@end

@implementation StylepicsEntryPageViewController

#define CURRENTUSER @"currentUser"
@synthesize username=_username;
@synthesize password=_password;
@synthesize status=_status;

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

-(NSUInteger) indexOfUserWithUsername:(NSString *)username {
    for (id obj in userInfoTable){
        if ([obj isKindOfClass:[User class]]) {
            if ([((User*)obj).name isEqualToString:username]) {
                return [userInfoTable indexOfObject:obj];
            }
        }
    }
    return -1;
}

- (IBAction)login {
    if ([self.username.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else {
        NSUInteger index = [self indexOfUserWithUsername:self.username.text];
        if (index == -1) {
            [self alertForInvalidUsername];
        }else if ([[[userInfoTable objectAtIndex:index] password] isEqualToString:self.password.text]){
            [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
        }else{
            [self alertForWrongPassword];
        }
    }
}

- (void)alertForEmptyName {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please type something" message:@"Your username can not be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

-(void) alertForInvalidUsername{
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
    StylepicsDatabase *database = [[StylepicsDatabase alloc] init];
    userInfoTable = database.getUserInfo;
    
}


- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [self setStatus:nil];
    userInfoTable = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
