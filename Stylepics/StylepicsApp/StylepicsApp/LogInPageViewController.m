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

-(void) setUsername:(UITextField *)usernameField
{
    _usernameField = usernameField;
    _usernameField.delegate = self;
    _usernameField.tag = UsernameField;
}


-(void) setPasswordField:(UITextField *)passwordField
{
    _passwordField = passwordField;
    _passwordField.delegate = self;
    _passwordField.tag = PasswordField;
}


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
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginNotification object:self];

}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: non-existent user and wrong password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
    self.loginButton.enabled = YES;
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    self.navigationController.toolbarHidden = YES;
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
}


- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.usernameField.text = nil;
    self.passwordField.text = nil;
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
