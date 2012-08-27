//
//  NewPollViewController.m
//  BasicApp
//
//  Created by Yong Lin on 7/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewPollViewController.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

@interface NewPollViewController ()
{
    Poll* poll;
    //BOOL eventCreated, recordCreated;
}
@end

@implementation NewPollViewController
@synthesize categoryPickerView = _categoryPickerView;
@synthesize categoryButton = _categoryButton;
@synthesize tips = _tips;
@synthesize pollNameTextField=_pollNameTextField;
@synthesize delegate = _delegate;

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
    self.tips.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.pollNameTextField.delegate = self;
    self.categoryPickerView.delegate = self;
    self.categoryPickerView.dataSource = self;
    self.categoryPickerView.frame = CGRectMake(0, 460, 320, 216);
    [self.categoryPickerView selectRow:2 inComponent:0 animated:NO];
    self.categoryPickerView.isOn = NO;

    self.categoryButton.titleLabel.textAlignment =  UITextAlignmentCenter;
    
    poll = [Poll new];
    //eventCreated = NO;
    //recordCreated = NO;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setPollNameTextField:nil];
    [self setTips:nil];
    [self setCategoryPickerView:nil];
    [self setCategoryButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.pollNameTextField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
}

- (void)alertForEmptyName {
    [Utility showAlert:@"Please type something" message:@"Your new poll should have a name."];
}

#pragma User Actions

- (IBAction)newPoll
{
    if ([self.pollNameTextField.text length] == 0)
    { 
        [self alertForEmptyName];  
    }else if ([self.categoryButton.titleLabel.text isEqualToString:@"Category..."]){
        [Utility showAlert:@"Choose a category" message:@"Please categorize this poll."];
    }else
    {
        poll = [Poll new];
        poll.title = self.pollNameTextField.text;
        poll.ownerID = [Utility getObjectForKey:CURRENTUSERID];
        poll.state = EDITING;
        poll.totalVotes = [NSNumber numberWithInt:0];
        poll.category = [NSNumber numberWithInt:[self.categoryPickerView selectedRowInComponent:0]];
        [[RKObjectManager sharedManager] postObject:poll delegate:self];
    }
}

-(IBAction)cancel
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(IBAction)categoryButtonPressed{
    if (self.categoryPickerView.isOn){
        [self.categoryPickerView dismissPickerView];
    }else{
        if ([self.categoryButton.titleLabel.text isEqualToString:@"Category..."]){
            [self.categoryButton setTitle:[Utility stringFromCategory:(PollCategory)[self.categoryPickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
        }
        [self.pollNameTextField resignFirstResponder];
        [self.categoryPickerView presentPickerView];
    }
}

#pragma helper function


#pragma RKObjectLoader delegate methods

-(void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if ([objectLoader wasSentToResourcePath:@"/polls"]){
        /*Event *newPollEvent = [Event new];
        newPollEvent.eventType = NEWPOLLEVENT;
        newPollEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        newPollEvent.pollID = poll.pollID;
        [[RKObjectManager sharedManager] postObject:newPollEvent delegate:self];*/
        
        PollRecord *pollRecord = [PollRecord new];
        pollRecord.pollID = poll.pollID;
        pollRecord.userID = [Utility getObjectForKey:CURRENTUSERID];
        pollRecord.pollRecordType = [NSNumber numberWithInt:EDITING_POLL];
        [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
    }else if ([objectLoader wasSentToResourcePath:@"/poll_records"]){
        [self.delegate newPollViewController:self didCreateANewPoll:poll.pollID]; 
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered Error: %@",[error localizedDescription]);
}
-(IBAction)backgroundTouched:(id)sender
{
    [self.pollNameTextField resignFirstResponder];
    if (self.categoryPickerView.isOn){
        [self.categoryPickerView dismissPickerView];
    }
}

#pragma mark - UIPickerView Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return PollTypeCount;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [Utility stringFromCategory:(PollCategory) row];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.categoryButton setTitle:[Utility stringFromCategory:(PollCategory)row] forState:UIControlStateNormal];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

#pragma UITextField delegate methods

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    poll.title = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self categoryButtonPressed];
    return YES;
}


@end
