//
//  LogInPageViewController
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "LogInPageViewController.h"
#import "User.h"
#import "Utility.h"

@interface LogInPageViewController () {
    User* user;
}

@end

@implementation LogInPageViewController
@synthesize usernameField=_usernameField;
@synthesize passwordField=_passwordField;

-(void) setUsername:(UITextField *)usernameField
{
    _usernameField = usernameField;
    self.usernameField.delegate = self;
}


-(void) setPasswordField:(UITextField *)passwordField
{
    _passwordField = passwordField;
    self.passwordField.delegate = self;
}


- (IBAction)login {
    if ([self.usernameField.text length] == 0 ||[self.usernameField.text length] == 0 ){
        [Utility showAlert:@"Sorry!" message:@"Neither username nor password can be empty."];
    }else{
        user = [User new];
        user.username = self.usernameField.text;
        user.password = self.passwordField.text;
        user.email = [self.usernameField.text stringByAppendingString:@"@gmail.com"];
        [[RKObjectManager sharedManager] postObject:user usingBlock:^(RKObjectLoader* loader){
            loader.resourcePath = @"/login";
            loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[User class]];
            loader.serializationMapping =[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[User class]];
            loader.delegate = self;
        }];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id) object {
    // Login was successful
    [Utility setObject:user.singleAccessToken forKey:SINGLE_ACCESS_TOKEN_KEY];
    [Utility setObject:user.userID forKey:CURRENTUSERID];
    [Utility setObject:@"FALSE" forKey:NEWUSER];
    [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: non-existent user and wrong password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
} 


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    if ([aTextField isEqual:self.usernameField]){
        [self.passwordField becomeFirstResponder];
       // return NO;
    }else{
        [self login];
       // return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
}


- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.usernameField.text = nil;
    self.passwordField.text = nil;
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
