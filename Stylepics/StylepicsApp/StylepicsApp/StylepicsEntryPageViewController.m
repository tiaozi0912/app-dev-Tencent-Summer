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
    //StylepicsDatabase *database;
    User* user;
}

@end

@implementation StylepicsEntryPageViewController
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
    user = [User new];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = [self.usernameField.text stringByAppendingString:@"@gmail.com"];
    [[RKObjectManager sharedManager] postObject:user usingBlock:^(RKObjectLoader* loader){
        loader.resourcePath = @"/login";
        loader.serializationMapping =[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[User class]];
    }];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    // Login was successful
    [Utility setObject:user.userID forKey:CURRENTUSERID];
    [Utility setObject:@"FALSE" forKey:NEWUSER];
    [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: non-existent user and wrong password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
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
  //database = [[StylepicsDatabase alloc] init];
    UIImage *navigationBarBackground =[[UIImage imageNamed:@"Custom-Nav-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    UIImage *toolBarBackground =[[UIImage imageNamed:@"Custom-Tool-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.toolbar setBackgroundImage:toolBarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault]; 
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
