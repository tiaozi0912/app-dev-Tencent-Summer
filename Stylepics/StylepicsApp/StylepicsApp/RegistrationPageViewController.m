//
//  RegistrationPageViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "RegistrationPageViewController.h"
#import "Utility.h"
#define EmailField 0
#define PasswordField 1
#define PasswordConfirmationField 2
@interface RegistrationPageViewController (){
    User* user;
    BOOL choiceMade;
    BOOL loginMode;
}
@end

@implementation RegistrationPageViewController

@synthesize emailField=_emailField;
@synthesize passwordField=_passwordField;
@synthesize passwordConfirmationField=_passwordConfirmationField;
@synthesize signupButton = _signupButton;
@synthesize spinner = _spinner;
@synthesize loginButton = _loginButton;
@synthesize background = _background;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    _emailField.delegate = self;
    _emailField.returnKeyType = UIReturnKeyNext;
    _emailField.tag = EmailField;
    _emailField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _emailField.alpha = 0;

    
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _passwordField.tag = PasswordField;
    _passwordField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _passwordField.alpha = 0;

    
    _passwordConfirmationField.delegate = self;
    _passwordConfirmationField.returnKeyType =UIReturnKeyDone;
    _passwordConfirmationField.tag = PasswordConfirmationField;
    _passwordConfirmationField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _passwordConfirmationField.alpha = 0;

    
    /*_emailField.inputAccessoryView = [Utility keyboardAccessoryToolBarWithButton:@"Dismiss" target:self action:@selector(dismissAll)];
    _passwordField.inputAccessoryView = [Utility keyboardAccessoryToolBarWithButton:@"Dismiss" target:self action:@selector(dismissAll)];    choiceMade = NO;
    _passwordConfirmationField.inputAccessoryView = [Utility keyboardAccessoryToolBarWithButton:@"Dismiss" target:self action:@selector(dismissAll)];*/
    
    self.loginButton.alpha = 0;
    self.signupButton.alpha = 0;
    [self.spinner startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([Utility getObjectForKey:IDOfPollToBeShown]){
     [self performSegueWithIdentifier:@"show home" sender:self];
     }
    [self.spinner stopAnimating];
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationCurveEaseInOut animations:^{
        self.loginButton.alpha = 1;
        self.signupButton.alpha = 1;
    } completion:nil];
}

- (void)viewDidUnload
{
    self.emailField = nil;
    [self setPasswordField:nil];
    [self setPasswordConfirmationField:nil];
    [self setSignupButton:nil];
    [self setSpinner:nil];
    [self setLoginButton:nil];
    [self setBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.emailField.text=nil;
    self.passwordField.text=nil;
    self.passwordConfirmationField.text=nil;
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
}

#pragma User Actions

- (IBAction)loginButtonPressed {
    if (choiceMade){
        [self login];
    }else{
        loginMode = YES;
        choiceMade = YES;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.signupButton.alpha = 0;
            self.emailField.alpha = 1;
            self.passwordField.alpha = 1;
        } completion:^(BOOL success){
            if (success){
                [self.emailField becomeFirstResponder];
            }
        }];
    }
}

- (IBAction)signupButtonPressed:(id)sender {
    if (choiceMade){
        [self signup];
    }else{
        loginMode = NO;
        choiceMade = YES;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.loginButton.alpha = 0;
            self.emailField.alpha = 1;
            self.passwordField.alpha = 1;
            self.passwordConfirmationField.alpha = 1;
        } completion:^(BOOL success){
            if (success){
                [self.emailField becomeFirstResponder];
            }
        }];
    }
}

-(IBAction)backgroundTouched:(id)sender
{
    if (choiceMade){
        [self dismissAll];
    }
}

-(void)dismissAll
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordConfirmationField resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.emailField.alpha = 0;
        self.passwordField.alpha = 0;
        self.passwordConfirmationField.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseInOut animations:^{
        self.loginButton.alpha = 1;
        self.signupButton.alpha = 1;
    } completion:nil];
    choiceMade = NO;
}

- (void)signup {
    /*if ([_emailField.text rangeOfString:@"@"].location == NSNotFound){
        [Utility showAlert:@"Invalid email address" message:@"Please double check your email address"];
    }else */
    if (_passwordField.text.length < 6){
        [Utility showAlert:@"Password is too short!" message:@"Password should be longer than 6 characters"];
    }else if (![_passwordConfirmationField.text isEqualToString:_passwordField.text]){
        [Utility showAlert:@"Password Confirmation Mismatch!" message:@"Your password and password confirmation should be exactly the same."];
    }else {
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self.passwordConfirmationField resignFirstResponder];
        user = [User new];
        user.username = [self.emailField.text substringToIndex:[self.emailField.text rangeOfString:@"@"].location];
        user.email = self.emailField.text;
        user.password = self.passwordField.text;
        user.passwordConfirmation = self.passwordConfirmationField.text;
        [self lockUI];
        [self.spinner startAnimating];
        [[RKObjectManager sharedManager] postObject:user delegate:self];
    }
}

- (void)login {
    if ([self.emailField.text length] == 0 ||[self.emailField.text length] == 0 ){
        [Utility showAlert:@"Sorry!" message:@"Neither email nor password can be empty."];
    }else{
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        user = [User new];
        user.email = self.emailField.text;
        user.password = self.passwordField.text;
        [self lockUI];
        [self.spinner startAnimating];
        [[RKObjectManager sharedManager] postObject:user usingBlock:^(RKObjectLoader* loader){
            loader.resourcePath = @"/login";
            loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[User class]];
            loader.serializationMapping =[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[User class]];
            loader.delegate = self;
        }];
    }
}

-(void)lockUI
{
    self.background.enabled = NO;
    self.emailField.enabled = NO;
    self.passwordField.enabled = NO;
    self.passwordConfirmationField.enabled = NO;
    self.loginButton.enabled = NO;
    self.signupButton.enabled = NO;
}

-(void)unlockUI
{
    self.background.enabled = YES;
    self.emailField.enabled = YES;
    self.passwordField.enabled = YES;
    self.passwordConfirmationField.enabled = YES;
    self.loginButton.enabled = YES;
    self.signupButton.enabled = YES;
}

#pragma RKObjectLoader Delegate Methods
- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    // signup was successful
    if ([objectLoader wasSentToResourcePath:@"/signup"]){
        [Utility showAlert:@"Congratulations!" message:@"Welcome to Stylepics!"];
        NSLog(@"userID:%@, email:%@, password:%@", user.userID, user.email, user.password);
        [Utility setObject:user.singleAccessToken forKey:SINGLE_ACCESS_TOKEN_KEY];
        [Utility setObject:user.userID forKey:CURRENTUSERID];
        [Utility setObject:@"TRUE" forKey:NEWUSER];
        [self performSegueWithIdentifier:@"show home" sender:self];
        
    }else if ([objectLoader wasSentToResourcePath:@"/login"]){
        [Utility setObject:user.singleAccessToken forKey:SINGLE_ACCESS_TOKEN_KEY];
        [Utility setObject:user.userID forKey:CURRENTUSERID];
        [Utility setObject:@"FALSE" forKey:NEWUSER];
        [self performSegueWithIdentifier:@"show home" sender:self];
    }
    [self unlockUI];
    [self.spinner stopAnimating];
    [self dismissAll];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: existent email and invalid password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
    [self unlockUI];
    [self.spinner stopAnimating];
}

#pragma UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!loginMode){
        switch (textField.tag) {
            case EmailField:{
                [_passwordField becomeFirstResponder];
                return NO;
            }
            case PasswordField:{
                [self.passwordConfirmationField becomeFirstResponder];
                return NO;
            }
            case PasswordConfirmationField:{
                [self signup];
                return NO;
            }
            default:
                break;
        }
    }else{
        if (textField.tag == EmailField)
        {
            [_passwordField becomeFirstResponder];
            return NO;
        }else {
            [self login];
            return NO;
        }
    }
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
