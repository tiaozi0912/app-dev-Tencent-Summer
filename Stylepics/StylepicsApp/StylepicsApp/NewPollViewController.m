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
        //[database newAPollCalled:self.textField.text byUserID:[Utility getObjectForKey:CURRENTUSERID]];
        [self performSegueWithIdentifier:@"showNewPoll" sender:self];
    }
}


-(IBAction)backgroundTouched:(id)sender
{
    [self.textField resignFirstResponder];
}  

@end
