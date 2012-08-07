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
{
    Poll* poll;
}
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
        poll = [Poll new];
        poll.title = self.textField.text;
        poll.ownerID = [Utility getObjectForKey:CURRENTUSERID];
        poll.state = EDITING;
        poll.totalVotes = [NSNumber numberWithInt:0];
        poll.maxVotesForSingleItem = [NSNumber numberWithInt:1];
        [[RKObjectManager sharedManager] postObject:poll delegate:self];
    }
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if ([objectLoader wasSentToResourcePath:@"/polls"]){
        [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        
        Event *newPollEvent = [Event new];
        newPollEvent.type = NEWPOLLEVENT;
        newPollEvent.user.userID = [Utility getObjectForKey:CURRENTUSERID];
        newPollEvent.poll.pollID = poll.pollID;
        [[RKObjectManager sharedManager] postObject:newPollEvent delegate:self];
        
        PollListItem *pollListItem = [PollListItem new];
        pollListItem.pollID = poll.pollID;
        pollListItem.userID = [Utility getObjectForKey:CURRENTUSERID];
        pollListItem.type = ACTIVE;
        [[RKObjectManager sharedManager] postObject:pollListItem delegate:self];
        [self performSegueWithIdentifier:@"showNewPoll" sender:self];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered Error: %@",[error localizedDescription]);
}
-(IBAction)backgroundTouched:(id)sender
{
    [self.textField resignFirstResponder];
}  

@end
