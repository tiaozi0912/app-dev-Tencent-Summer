//
//  NewPollViewController.m
//  BasicApp
//
//  Created by Yong Lin on 7/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewPollViewController.h"
#import "Utility.h"
#import<QuartzCore/QuartzCore.h>

@interface NewPollViewController ()
{
    Poll* poll;
}
@end

@implementation NewPollViewController
@synthesize tips = _tips;
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

-(void)setTips:(UILabel *)tips
{
    _tips = tips;
    _tips.backgroundColor =[UIColor clearColor];
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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setTips:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
}
- (void)alertForEmptyName {
    [Utility showAlert:@"Please type something" message:@"Your new poll should have a name."];
}

- (IBAction)newPoll
{
    if ([self.textField.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else{
        poll = [Poll new];
        poll.title = self.textField.text;
        poll.ownerID = [Utility getObjectForKey:CURRENTUSERID];
        poll.state = EDITING;
        poll.totalVotes = [NSNumber numberWithInt:0];
        [[RKObjectManager sharedManager] postObject:poll delegate:self];
    }
}

-(IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
        newPollEvent.eventType = NEWPOLLEVENT;
        newPollEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        newPollEvent.pollID = poll.pollID;
        [[RKObjectManager sharedManager] postObject:newPollEvent delegate:self];
        
        PollRecord *pollRecord = [PollRecord new];
        pollRecord.pollID = poll.pollID;
        pollRecord.userID = [Utility getObjectForKey:CURRENTUSERID];
        pollRecord.pollRecordType = ACTIVE;
        [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
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
