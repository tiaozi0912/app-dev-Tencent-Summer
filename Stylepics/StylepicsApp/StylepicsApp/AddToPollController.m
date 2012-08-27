//
//  AddToPollController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/26/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AddToPollController.h"
#define PollPicker 0
#define CategoryPicker 1

@interface AddToPollController (){
    BOOL newPoll, backMark;
    UIActivityIndicatorView *spinner;
    NSMutableArray *pickerDataArray;
    NSMutableArray *activePolls;
    Poll *poll;
}
@end

@implementation AddToPollController
@synthesize itemImageView = _itemImageView;

@synthesize pickPollTitleTextField = _pickPollTitleTextField,capturedItemImage=_capturedItemImage, pickerView, pickPollButton, item=_item;

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
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.frame = CGRectMake(0, 416, 320, 216);
    
    self.pickPollButton.enabled = NO;
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.navigationItem.leftBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:BACK_BUTTON andHighlightedStateImage:BACK_BUTTON_HL target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:DONE_BUTTON andHighlightedStateImage:DONE_BUTTON_HL target:self action:@selector(addToPoll)];

    pickerDataArray=[NSMutableArray new];
    activePolls = [NSMutableArray new];
    backMark = NO;
    self.pickerView.isOn = NO;
    self.pickPollTitleTextField.enabled = NO;
    self.itemImageView.image = self.capturedItemImage;
    
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidUnload
{
    [self setItemImageView:nil];
    [super viewDidUnload];
    [self setPickPollButton:nil];
    [self setPickerView:nil];
    [self setPickPollTitleTextField:nil];
    _item = nil;
    poll = nil;
    spinner = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addToPoll
{
    //[self.descriptionTextField resignFirstResponder];
    if (self.pickPollTitleTextField.text.length) {
        if (newPoll) {
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            poll = [Poll new];
            poll.title = self.pickPollTitleTextField.text;
            poll.ownerID = [Utility getObjectForKey:CURRENTUSERID];
            poll.state = EDITING;
            poll.totalVotes = [NSNumber numberWithInt:0];
            [[RKObjectManager sharedManager] postObject:poll delegate:self];
        }else{
            [Utility setObject:_item.pollID forKey:IDOfPollToBeShown];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [[RKObjectManager sharedManager] postObject:_item delegate:self];
        }
    }else{
        [Utility showAlert:@"Please type something" message:@"Your new poll should have a name."];
    }
    
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.pickPollTitleTextField resignFirstResponder];
    [self.pickerView dismissPickerView];
}

- (IBAction)pickPoll:(id)sender {
    if (!self.pickerView.isOn)
    {
        [self.pickerView presentPickerView];
        if ([self.pickerView selectedRowInComponent:0] != pickerDataArray.count){
            self.pickPollTitleTextField.borderStyle = UITextBorderStyleNone;
            self.pickPollTitleTextField.enabled = NO;
            if (self.pickPollTitleTextField.text.length == 0){
                self.pickPollTitleTextField.text = [pickerDataArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
                _item.pollID = ((PollRecord*)[activePolls objectAtIndex:[self.pickerView selectedRowInComponent:0]]).pollID;
            }
        }else{
            self.pickPollTitleTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.pickPollTitleTextField.enabled = YES;
        }
    }else{
        [self.pickerView dismissPickerView];
    }
}

-(void)backWithFlipAnimation{
    [UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    [[self.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
}

#pragma RKObjectLoaderDelegate Methods

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([objectLoader wasSentToResourcePath:@"/items" method:RKRequestMethodPOST] ){
        // Having got an item ID, we use the id to name the item image and upload it to amazon S3. And then we flesh the item object in the database with what we want to add
        @try {
            NSString *imageName = [NSString stringWithFormat:@"Item_%@.jpeg", _item.itemID];
            NSData *imageData = UIImageJPEGRepresentation(self.capturedItemImage, 0.8f);
            @try {
                S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imageName inBucket:ITEM_PHOTOS_BUCKET_NAME];
                por.contentType = @"image/jpeg";
                por.data = imageData;
                por.cannedACL = [S3CannedACL publicRead];
                [AmazonClientManager initializeS3];
                [[AmazonClientManager s3] putObject:por];
            }
            @catch (AmazonClientException *exception) {
                NSLog(@"Failed to Create Object [%@]", exception);
            }
            
            
            //update item values
            _item.photoURL = [IMAGE_HOST_BASE_URL stringByAppendingFormat:@"/%@/%@", ITEM_PHOTOS_BUCKET_NAME, imageName];
            //item.description = self.descriptionTextField.text;
            _item.numberOfVotes = [NSNumber numberWithInt:0];

            _item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
            [[RKObjectManager sharedManager] putObject:_item delegate:self];
        }
        @catch (AmazonClientException *exception) {
            NSLog(@"Failed to Create Object [%@]", exception);
        }
    }else if ([objectLoader wasSentToResourcePath:@"/polls" method:RKRequestMethodPOST] ){
        //Having created a new poll, we can post a new event and add the item to the new poll
        [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        
        //post a new poll event
        /*Event *newPollEvent = [Event new];
         newPollEvent.eventType = NEWPOLLEVENT;
         newPollEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
         newPollEvent.pollID = poll.pollID;
         [[RKObjectManager sharedManager] postObject:newPollEvent delegate:self];*/
        
        //post a new poll record
        PollRecord *pollRecord = [PollRecord new];
        pollRecord.pollID = poll.pollID;
        pollRecord.userID = [Utility getObjectForKey:CURRENTUSERID];
        pollRecord.pollRecordType = [NSNumber numberWithInt:EDITING_POLL];
        [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
        
        //add new item to the new poll
        _item.pollID = poll.pollID;
        [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        [[RKObjectManager sharedManager] postObject:_item delegate:self];
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"The new item has been added!");
        //post a new item event
        /*Event *newItemEvent = [Event new];
         newItemEvent.eventType = NEWITEMEVENT;
         newItemEvent.pollID = item.pollID;
         newItemEvent.itemID = item.itemID;
         newItemEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
         [[RKObjectManager sharedManager] postObject:newItemEvent delegate:self];*/
        backMark = YES;
    }else if ([objectLoader.resourcePath hasPrefix:@"/user_profile_poll_records"]){
        // extract all the active polls in editing state of the current user
        for (id obj in objects){
            PollRecord *pollRecord = (PollRecord*) obj;
            if ([pollRecord.pollRecordType intValue] == EDITING_POLL){
                [activePolls addObject:pollRecord];
                [pickerDataArray addObject:pollRecord.title];
            }
        }
        [self.pickerView reloadAllComponents];
        self.pickPollButton.enabled = YES;
    }
    if (backMark){
        [spinner stopAnimating];
        [self backWithFlipAnimation];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
}

#pragma mark - UIPickerView Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerDataArray count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row < [pickerDataArray count]) {
        return [pickerDataArray objectAtIndex:row];
    }else{
        return @"New Poll";
    }
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row < [pickerDataArray count]) {
        _item.pollID = ((PollRecord*)[activePolls objectAtIndex:row]).pollID;
        newPoll = NO;
        self.pickPollTitleTextField.text = [pickerDataArray objectAtIndex:row];
        self.pickPollTitleTextField.enabled = NO;
        self.pickPollTitleTextField.borderStyle = UITextBorderStyleNone;
    }else{
        _item.pollID = nil;
        newPoll = YES;
        self.pickPollTitleTextField.text = @"";
        self.pickPollTitleTextField.placeholder = @"Name your new poll here";
        self.pickPollTitleTextField.enabled = YES;
        self.pickPollTitleTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
@end
