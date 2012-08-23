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

#define UsernameField 0
#define PasswordField 1

@interface LogInPageViewController () {
    User* user;
}

@end

@implementation LogInPageViewController
@synthesize usernameField=_usernameField;
@synthesize passwordField=_passwordField;
@synthesize loginButton = _loginButton;
@synthesize spinner = _spinner;

- (IBAction)login {
    if ([self.usernameField.text length] == 0 ||[self.usernameField.text length] == 0 ){
        [Utility showAlert:@"Sorry!" message:@"Neither username nor password can be empty."];
    }else{
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        user = [User new];
        user.username = self.usernameField.text;
        user.password = self.passwordField.text;
        user.email = [self.usernameField.text stringByAppendingString:@"@gmail.com"];
        self.loginButton.enabled = NO;
        [self.spinner startAnimating];
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
    [self performSegueWithIdentifier:@"show home" sender:self];
    self.loginButton.enabled = YES;
    [self.spinner stopAnimating];

}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: non-existent user and wrong password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
    self.loginButton.enabled = YES;
    [self.spinner stopAnimating];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
} 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == UsernameField)
    {
        [_passwordField becomeFirstResponder];
        return NO;
    }else {
        [self login];
        return NO;
    }
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    _usernameField.delegate = self;
    _usernameField.tag = UsernameField;
    _usernameField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    
    _passwordField.delegate = self;
    _passwordField.tag = PasswordField;
    _passwordField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
}


- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.usernameField.text = nil;
    self.passwordField.text = nil;
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([Utility getObjectForKey:IDOfPollToBeShown]){
        NSLog(@"%@", [Utility getObjectForKey:IDOfPollToBeShown]);
        [self performSegueWithIdentifier:@"show home" sender:self];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
