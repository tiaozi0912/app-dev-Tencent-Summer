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
    UIActivityIndicatorView* spinner;
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
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.tips.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.pollNameTextField.delegate = self;
    self.categoryPickerView.delegate = self;
    self.categoryPickerView.dataSource = self;
    self.categoryPickerView.frame = CGRectMake(0, 415, 320, 216);
    [self.categoryPickerView selectRow:0 inComponent:0 animated:NO];
    self.categoryPickerView.isOn = NO;

    self.categoryButton.titleLabel.textAlignment =  UITextAlignmentCenter;
    
    UIImage *navButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [self.navigationItem.leftBarButtonItem  setBackgroundImage:navButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem  setBackgroundImage:navButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = YES;
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = YES;
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
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
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [[RKObjectManager sharedManager] postObject:poll delegate:self];
    }
}

-(IBAction)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIView *)pickerView:(UIPickerView *)thePickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        tView.backgroundColor = [UIColor clearColor];
        tView.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:20.0];
    }
    // Fill the label text here
    tView.text = [@" " stringByAppendingString:[Utility stringFromCategory:(PollCategory) row]];
    return tView;
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.categoryPickerView.isOn){
        self.categoryPickerView.isOn = NO;
        [self.categoryPickerView dismissPickerView];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    poll.title = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_CHARACTER_NUMBER_FOR_POLL_DESCRIPTION) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self categoryButtonPressed];
    return YES;
}



@end
