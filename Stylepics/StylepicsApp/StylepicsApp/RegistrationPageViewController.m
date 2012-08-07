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
    User* user;
}
@end

@implementation RegistrationPageViewController

@synthesize usernameField=_usernameField;
@synthesize passwordField=_passwordField;
@synthesize passwordConfirmationField=_passwordConfirmationField;


-(void) setUsername:(UITextField *)usernameField
{
    _usernameField = usernameField;
    _usernameField.delegate = self;
    _usernameField.returnKeyType = UIReturnKeyNext;
}


-(void) setPassword:(UITextField *)passwordField
{
    _passwordField = passwordField;
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyNext;
}

-(void) setPasswordConfirmationField:(UITextField *)passwordConfirmationField
{
    _passwordConfirmationField = passwordConfirmationField;
    _passwordConfirmationField.delegate = self;
    _passwordConfirmationField.returnKeyType =UIReturnKeyDone;
}


- (IBAction)signup {
    user = [User new];
    user.username = self.usernameField.text;
    user.email = [self.usernameField.text stringByAppendingString:@"@gmail.com"];
    user.password = self.passwordField.text;
    user.passwordConfirmation = self.passwordConfirmationField.text;
    [[RKObjectManager sharedManager] postObject:user delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    // signup was successful
    [Utility showAlert:@"Congratulations!" message:@"Welcome to Stylepics!"];
    NSLog(@"userID:%@, username:%@, password:%@", user.userID, user.username, user.password);
    [Utility setObject:user.singleAccessToken forKey:SINGLE_ACCESS_TOKEN_KEY];
    [Utility setObject:user.userID forKey:CURRENTUSERID];
    [Utility setObject:@"TRUE" forKey:NEWUSER];
    [self performSegueWithIdentifier:@"show news feed page" sender:self];
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: existent username and invalid password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordConfirmationField resignFirstResponder];
} 

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    if ([aTextField isEqual: _usernameField]){
        [_passwordField becomeFirstResponder];
       // return NO;
    }else if ([aTextField isEqual: _passwordField]){
        [_passwordConfirmationField becomeFirstResponder];
      //  return NO;
    }else {
        [self signup];
      //  return NO;
    } 
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
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setPasswordConfirmationField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.usernameField.text=nil;
    self.passwordField.text=nil;
    self.passwordConfirmationField.text=nil;
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
