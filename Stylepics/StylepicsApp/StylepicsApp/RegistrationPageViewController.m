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
    //StylepicsDatabase *database;
}
@end

@implementation RegistrationPageViewController

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
    if ([self.username.text length] < 3)
    { 
        [self alertForShortName];  
    }else if ([self.password.text length] < 0){
        [self alertForShortPassword];
    }else if (![self.passwordAgain.text isEqualToString:self.password.text]){
        [self alertForPasswordNotMatch];
    }else {
        User* user = [User new];
        user.username = self.username.text;
        user.password = self.password.text;
        [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/signup" forMethod:RKRequestMethodPOST];
        [[RKObjectManager sharedManager] postObject:user delegate:self];
    }
}

- (void)alertForShortName {
    [Utility showAlert:@"Make your username longer" message:@"Your username should contain at least 4 characters."];
}

- (void)alertForShortPassword {
    [Utility showAlert:@"Make your password longer" message:@"Your password should contain at least 6 characters."];
}


-(void) alertForPasswordNotMatch{
    [Utility showAlert:@"Passwords mismatch!" message:@"Make sure the passwords you typed are the same one."];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    // signup was successful
    User* user = [objects objectAtIndex:0];
    [Utility showAlert:@"Congratulations!" message:@"Welcome to Stylepics!"];
    [Utility setObject:user.userID forKey:CURRENTUSERID];
    [Utility setObject:@"TRUE" forKey:NEWUSER];
    [self performSegueWithIdentifier:@"show news feed page" sender:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: existent username and invalid password
    [Utility showAlert:@"Error!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
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
    //database = [[StylepicsDatabase alloc] init];

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

- (void)viewDidDisappear:(BOOL)animated
{
    self.username.text=nil;
    self.password.text=nil;
    self.passwordAgain.text=nil;
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
