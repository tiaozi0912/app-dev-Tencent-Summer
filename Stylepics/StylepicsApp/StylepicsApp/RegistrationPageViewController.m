//
//  RegistrationPageViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "RegistrationPageViewController.h"
#import "Utility.h"

@interface RegistrationPageViewController (){
    StylepicsDatabase *database;
}
@end

@implementation RegistrationPageViewController

#define CURRENTUSER @"currentUser"
@synthesize username=_username;
@synthesize password=_password;
@synthesize passwordAgain=_passwordAgain;


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

-(void) setPasswordAgain:(UITextField *)passwordAgain
{
    _passwordAgain = passwordAgain;
    self.passwordAgain.delegate = self;
}


- (IBAction)signup {
    if ([self.username.text length] < 4)
    { 
        [self alertForShortName];  
    }else if ([database existUsername:self.username.text]){
        [self alertForExistentUsername];
    }else if ([self.password.text length] < 6){
        [self alertForShortPassword];
    }else if (![self.passwordAgain.text isEqualToString:self.password.text]){
        [self alertForPasswordNotMatch];
    }else {
        if ([database addNewUserWithUsername:self.username.text password:self.password.text]){
            [Utility showAlert:@"Congratulations!" message:@"Welcome to Stylepics!"];
            [Utility setObject:self.username.text forKey:CURRENTUSER];
            [Utility setObject:@"TRUE" forKey:NEWUSER];
            [self performSegueWithIdentifier:@"show news feed page" sender:self];

        }
    }
}

- (void)alertForShortName {
    [Utility showAlert:@"Make your username longer" message:@"Your username should contain at least 4 characters."];
}

- (void)alertForShortPassword {
    [Utility showAlert:@"Make your password longer" message:@"Your password should contain at least 6 characters."];
}

-(void) alertForExistentUsername{
    [Utility showAlert:@"Oooops..." message:@"This username already exists."];
}

-(void) alertForPasswordNotMatch{
    [Utility showAlert:@"Passwords mismatch!" message:@"Make sure the passwords you typed are the same one."];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
} 

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{  
    [self signup];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    database = [[StylepicsDatabase alloc] init];

    //self.navigationController.toolbarHidden = YES;
}


- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [self setPasswordAgain:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
