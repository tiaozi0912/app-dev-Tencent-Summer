//
//  AddToPollController.m
//  MuseMe
//
//  Created by Yong Lin on 8/26/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AddToPollController.h"
#import "CenterButtonTabController.h"
#define PollPicker 0
//#define CategoryPicker 1
//#define kOFFSET_FOR_KEYBOARD 216.0

@interface AddToPollController (){
    BOOL newPoll, backMark;
    UIActivityIndicatorView *spinner;
    NSMutableArray *pickerDataArray;
    NSArray *draftPolls;
    Poll *poll;
}
@end

@implementation AddToPollController
//@synthesize brandLabel = _brandLabel;
//@synthesize priceLabel = _priceLabel;
@synthesize itemImageView = _itemImageView;


@synthesize capturedItemImage=_capturedItemImage, pickerView, item=_item;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];

    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    
    //set back button
    UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL];
    [self.navigationItem.leftBarButtonItem  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    UIImage *addToPollButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
    UIBarButtonItem *addToPollButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(addToPoll)];
    [addToPollButton  setBackgroundImage:addToPollButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = addToPollButton;

    pickerDataArray=[NSMutableArray new];
    draftPolls = [NSMutableArray new];
    backMark = NO;
    newPoll = YES;

    self.itemImageView.image = self.capturedItemImage;

    /*self.brandLabel.text = _item.brand;
    self.priceLabel.text = [Utility formatCurrencyWithNumber:_item.price];
    [self.brandLabel setNeedsLayout];
    [self.priceLabel setNeedsLayout];*/
    
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/draft_polls" delegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    //[self setBrandLabel:nil];
    //[self setPriceLabel:nil];
    [super viewDidUnload];
    [self setItemImageView:nil];
    [self setPickerView:nil];
    _item = nil;
    poll = nil;
    spinner = nil;
    // Release any retained subviews of the main view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];*/
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    /*[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addToPoll
{
    //[self.pickPollTitleTextField resignFirstResponder];
        if (newPoll) {
            NewPollViewController* newPOllVC = [self.storyboard  instantiateViewControllerWithIdentifier:@"new poll VC"];;
            newPOllVC.delegate = self;
            [self.navigationController pushViewController:newPOllVC animated:YES];
        }else{
           // [Utility setObject:_item.pollID forKey:IDOfPollToBeShown];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            _item.pollID = ((PollRecord*)[draftPolls objectAtIndex:[self.pickerView selectedRowInComponent:0]-1]).pollID;
            [[RKObjectManager sharedManager] postObject:_item delegate:self];
        }
}

-(IBAction)backgroundTouched:(id)sender
{
   // [self.pickPollTitleTextField resignFirstResponder];
}

/*- (IBAction)pickPoll:(id)sender {
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
}*/

-(void)backWithFlipAnimation{
    [Utility setObject:self.item.pollID forKey:IDOfPollToBeShown];
    id VC = ((UINavigationController*)((CenterButtonTabController*)[self.navigationController presentingViewController]).selectedViewController).topViewController;
    [VC performSegueWithIdentifier:@"show poll" sender:VC];
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
            [Utility getObjectForKey:IDOfPollToBeShown];
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
        [Utility showAlert:@"Item added!" message:@""];
        //post a new item event
        /*Event *newItemEvent = [Event new];
         newItemEvent.eventType = NEWITEMEVENT;
         newItemEvent.pollID = item.pollID;
         newItemEvent.itemID = item.itemID;
         newItemEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
         [[RKObjectManager sharedManager] postObject:newItemEvent delegate:self];*/
        backMark = YES;
    }else if ([objectLoader.resourcePath hasPrefix:@"/draft_polls"]){
        // extract all the active polls in editing state of the current user
        draftPolls = objects;
        for (id obj in objects){
            PollRecord *pollRecord = (PollRecord*) obj;
            if ([pollRecord.pollRecordType intValue] == EDITING_POLL){
                //[draftPolls addObject:pollRecord];
                [pickerDataArray addObject:pollRecord.title];
            }
        }
        [self.pickerView reloadAllComponents];
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

- (UIView *)pickerView:(UIPickerView *)thePickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        tView.backgroundColor = [UIColor clearColor];
        tView.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:14.0];
    }
    // Fill the label text here
    if (row > 0) {
        tView.text = [pickerDataArray objectAtIndex:row - 1];
    }else{
        tView.text = @"New Poll ... ";
    }
    tView.text = [@" " stringByAppendingString:tView.text];
    return tView;
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row > 0) {
        _item.pollID = ((PollRecord*)[draftPolls objectAtIndex:row - 1]).pollID;
        [Utility setObject:_item.pollID forKey:IDOfPollToBeShown];
        newPoll = NO;
    }else{
        _item.pollID = nil;
        newPoll = YES;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

#pragma mark - NewPollViewController Delegate Method

-(void)newPollViewController:(id)sender didCreateANewPoll:(NSNumber *)pollID
{
    _item.pollID = pollID;
    [[RKObjectManager sharedManager] postObject:_item delegate:self];
}

/*-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}*/
@end
