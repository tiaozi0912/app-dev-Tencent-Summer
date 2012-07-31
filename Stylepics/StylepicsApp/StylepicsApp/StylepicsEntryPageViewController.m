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
    }else if ([self.password.text length] == 0)
    {
        [self alertForEmptyPassword];
    }else{
        User* user = [User new];
        user.username = self.username.text;
        user.password = self.password.text;
        [[RKObjectManager sharedManager].router routeClass:[User class] toResourcePath:@"/login" forMethod:RKRequestMethodPOST];
        [[RKObjectManager sharedManager] postObject:user delegate:self];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    // Login was successful
    User* user = [objects objectAtIndex:0];
    [Utility setObject:user.userID forKey:CURRENTUSERID];
    [Utility setObject:@"FALSE" forKey:NEWUSER];
    [self performSegueWithIdentifier:@"showNewsFeed" sender:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: non-existent user and wrong password
    [Utility showAlert:@"Error!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

- (void)alertForEmptyName
{
    [Utility showAlert:@"Warning!" message:@"Please type in your username."];
}

- (void)alertForEmptyPassword
{
    [Utility showAlert:@"Warning!" message:@"Please type in your password."];
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
  //database = [[StylepicsDatabase alloc] init];
    UIImage *navigationBarBackground =[[UIImage imageNamed:@"Custom-Nav-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    UIImage *toolBarBackground =[[UIImage imageNamed:@"Custom-Tool-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.toolbar setBackgroundImage:toolBarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault]; 
}


- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.username.text = nil;
    self.password.text = nil;
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
