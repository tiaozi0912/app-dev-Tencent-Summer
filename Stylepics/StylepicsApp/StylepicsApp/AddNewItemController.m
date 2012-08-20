//
//  AddNewItemController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AddNewItemController.h"
#define PollPicker 0
#define CategoryPicker 1

@interface AddNewItemController ()
{
    UIActivityIndicatorView *spinner;
    Item *item;
    NSMutableArray *pickerDataArray;
    NSMutableArray *activePolls;
    BOOL newPoll, backMark;
    Poll *poll;
}
@end


@implementation AddNewItemController
@synthesize pickerView = _pickerView;
@synthesize pickPollTitleTextField = _pickPollTitleTextField;
@synthesize brandTextField = _brandTextField;
@synthesize categoryButton = _categoryButton;
@synthesize itemImage=_itemImage,descriptionTextField=_descriptionTextField, priceTextField=_priceTextField, capturedItemImage=_capturedItemImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionTextField.delegate= self;
    self.priceTextField.delegate= self;
    self.pickPollTitleTextField.enabled = NO;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.frame = CGRectMake(0, 416, 320, 216);
    
    
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    
    self.title = @"Add New Item";
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    item = [Item new];
    pickerDataArray=[NSMutableArray new];
    activePolls = [NSMutableArray new];
    backMark = NO;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/poll_records" delegate:self];
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setPickPollTitleTextField:nil];
    [self setBrandTextField:nil];
    [self setCategoryButton:nil];
    [super viewDidUnload];
    self.descriptionTextField = nil;
    self.priceTextField = nil;
    item = nil;
    poll = nil;
    spinner = nil;
    [AmazonClientManager clearCredentials];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    self.itemImage.image = self.capturedItemImage;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma User Action

-(IBAction)addToPoll
{
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    if (self.pickPollTitleTextField.text.length) {
        if (newPoll) {
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            poll = [Poll new];
            poll.title = self.pickPollTitleTextField.text;
            poll.ownerID = [Utility getObjectForKey:CURRENTUSERID];
            poll.state = EDITING;
            poll.totalVotes = [NSNumber numberWithInt:0];
            [[RKObjectManager sharedManager] postObject:poll delegate:self];
        }else{
            [Utility setObject:item.pollID forKey:IDOfPollToBeShown];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [[RKObjectManager sharedManager] postObject:item delegate:self];
        }
    }else{
        [Utility showAlert:@"Please type something" message:@"Your new poll should have a name."];
    }

}

- (IBAction)cancelButton{
    [self backWithFlipAnimation];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.pickPollTitleTextField resignFirstResponder];
    [self dismissPickerView];
}

- (IBAction)pickPoll:(id)sender {
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.pickPollTitleTextField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -216);
    self.pickerView.transform = transform;
    [UIView commitAnimations];
    self.pickPollTitleTextField.text = [pickerDataArray objectAtIndex:0];
    item.pollID = ((PollRecord*)[activePolls objectAtIndex:0]).pollID;
}

-(IBAction)dismissPickerView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 216);
    self.pickerView.transform = transform;
    [UIView commitAnimations];
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
            NSString *imageName = [NSString stringWithFormat:@"Item_%@.jpeg", item.itemID];
            NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.8f);
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
            item.photoURL = [IMAGE_HOST_BASE_URL stringByAppendingFormat:@"/%@/%@", ITEM_PHOTOS_BUCKET_NAME, imageName];
            item.description = self.descriptionTextField.text;
            item.numberOfVotes = [NSNumber numberWithInt:0];
            item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
            item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
            item.brand =self.brandTextField.text;
            [[RKObjectManager sharedManager] putObject:item delegate:self];
        }
        @catch (AmazonClientException *exception) {
            NSLog(@"Failed to Create Object [%@]", exception);
        }
    }else if ([objectLoader wasSentToResourcePath:@"/polls" method:RKRequestMethodPOST] ){
        //Having created a new poll, we can post a new event and add the item to the new poll
        [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        
        //post a new poll event
        Event *newPollEvent = [Event new];
        newPollEvent.eventType = NEWPOLLEVENT;
        newPollEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        newPollEvent.pollID = poll.pollID;
        [[RKObjectManager sharedManager] postObject:newPollEvent delegate:self];
        
        //post a new poll record
        PollRecord *pollRecord = [PollRecord new];
        pollRecord.pollID = poll.pollID;
        pollRecord.userID = [Utility getObjectForKey:CURRENTUSERID];
        pollRecord.pollRecordType = ACTIVE;
        [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
        
        
        //add new item to the new poll
        item.pollID = poll.pollID;
        [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        [[RKObjectManager sharedManager] postObject:item delegate:self];
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"The new item has been added!");
        //post a new item event
        Event *newItemEvent = [Event new];
        newItemEvent.eventType = NEWITEMEVENT;
        newItemEvent.pollID = item.pollID;
        newItemEvent.itemID = item.itemID;
        newItemEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        [[RKObjectManager sharedManager] postObject:newItemEvent delegate:self];
        backMark = YES;
    }else if ([objectLoader wasSentToResourcePath:@"/poll_records" method:RKRequestMethodGET]){
        // extract all the active polls in editing state of the current user
        for (id obj in objects){
            PollRecord *pollRecord = (PollRecord*) obj;
                if ([pollRecord.pollRecordType isEqualToString:ACTIVE] && [pollRecord.state isEqualToString:EDITING]){
                    [activePolls addObject:pollRecord];
                    [pickerDataArray addObject:pollRecord.title];
            }
        }
        [self.pickerView reloadAllComponents];
    }else if (backMark){
        [spinner stopAnimating];
        [self backWithFlipAnimation];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
}

#pragma mark - Helper Methods

-(void)backWithFlipAnimation{
    [UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    [[self.navigationController presentingViewController] dismissModalViewControllerAnimated:YES];
}

/*-(void)doneButton{
 [self.priceTextField resignFirstResponder];
 }*/


#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*- (void)textFieldDidBeginEditing:(UITextField *)textField
 {
 if (textField == self.priceTextField) {
 // create custom button
 UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
 doneButton.frame = CGRectMake(0, 163, 106, 53);
 doneButton.adjustsImageWhenHighlighted = NO;
 [doneButton setImage:[UIImage imageNamed:@"doneNormal.png"] forState:UIControlStateNormal];
 [doneButton setImage:[UIImage imageNamed:@"doneHighlighted.png"] forState:UIControlStateHighlighted];
 [doneButton addTarget:self action:@selector(doneButton) forControlEvents:UIControlEventTouchUpInside];
 
 // locate keyboard view
 UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
 for (UIView *keyboard in tempWindow.subviews) {
 if ([[keyboard description] hasPrefix:@"<UIKeyboard"]) {
 [keyboard addSubview:doneButton];
 break;
 }
 }
 }
 }*/

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
        item.pollID = ((PollRecord*)[activePolls objectAtIndex:row]).pollID;
        newPoll = NO;
        self.pickPollTitleTextField.text = [pickerDataArray objectAtIndex:row];
        self.pickPollTitleTextField.enabled = NO;
        self.pickPollTitleTextField.borderStyle = UITextBorderStyleNone;
    }else{
        item.pollID = nil;
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