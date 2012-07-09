//
//  CheckInViewController.m
//  BasicApp
//
//  Created by Yong Lin on 7/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "CheckInViewController.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController
@synthesize textField=_textField;

-(void)setTextField:(UITextField *)textField{
    _textField = textField;
    textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{  
    [self newCart];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)alertForEmptyName {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please type something" message:@"Your new cart should have a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

- (IBAction)newCart {
    if ([self.textField.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else{
        [self performSegueWithIdentifier:@"showNewCart" sender:self];
    }
}

         
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    [segue.destinationViewController setTitle:self.textField.text];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.textField resignFirstResponder];
}  

@end
