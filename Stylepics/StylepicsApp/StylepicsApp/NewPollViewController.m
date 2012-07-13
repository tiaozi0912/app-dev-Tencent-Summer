//
//  NewPollViewController.m
//  BasicApp
//
//  Created by Yong Lin on 7/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewPollViewController.h"
#import "StylepicsDatabase.h"
#import "Utility.h"

@interface NewPollViewController ()

@end

@implementation NewPollViewController
@synthesize textField=_textField;

-(void)setTextField:(UITextField *)textField{
    _textField = textField;
    textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{  
    [self newPoll];
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
    [Utility showAlert:@"Please type something" message:@"Your new poll should have a name."];

}

- (IBAction)newPoll {
    if ([self.textField.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else{
        StylepicsDatabase *database = [[StylepicsDatabase alloc] init];
        NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
        NSNumber *currentUserID = [session objectForKey:@"currentUserID"];
        [database newAPollCalled:self.textField.text byUserID:currentUserID];
        [self performSegueWithIdentifier:@"showNewPoll" sender:self];
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
