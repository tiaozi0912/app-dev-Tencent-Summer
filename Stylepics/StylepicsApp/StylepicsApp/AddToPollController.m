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
#define kOFFSET_FOR_KEYBOARD 216.0

@interface AddToPollController (){
    BOOL newPoll, backMark;
    UIActivityIndicatorView *spinner;
    NSMutableArray *pickerDataArray;
    NSMutableArray *activePolls;
    Poll *poll;
}
@end

@implementation AddToPollController
@synthesize brandLabel = _brandLabel;
@synthesize priceLabel = _priceLabel;
@synthesize itemImageView = _itemImageView;
@synthesize DescriptionLabel = _DescriptionLabel;
@synthesize chooseCategoryLabel = _chooseCategoryLabel;
@synthesize categoryPickerView = _categoryPickerView;
@synthesize categoryPickerParentView = _categoryPickerParentView;

@synthesize pickPollTitleTextField = _pickPollTitleTextField,capturedItemImage=_capturedItemImage, pickerView, item=_item;

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
    
    self.categoryPickerView.delegate = self;
    self.categoryPickerView.dataSource = self;

    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];

        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    

    //self.navigationItem.leftBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:BACK_BUTTON andHighlightedStateImage:BACK_BUTTON_HL target:self action:@selector(back)];
    
    //set back button
    UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
    UIImage *backIconImage = [UIImage imageNamed:BACK_BUTTON];
    UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [backButton  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:DONE_BUTTON andHighlightedStateImage:DONE_BUTTON_HL target:self action:@selector(addToPoll)];


    pickerDataArray=[NSMutableArray new];
    activePolls = [NSMutableArray new];
    backMark = NO;

    self.itemImageView.image = self.capturedItemImage;

    self.pickPollTitleTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.brandLabel.text = _item.brand;
    self.priceLabel.text = [Utility formatCurrencyWithNumber:_item.price];
    [self.brandLabel setNeedsLayout];
    [self.priceLabel setNeedsLayout];
    
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/user_profile_poll_records/%@", [Utility getObjectForKey:CURRENTUSERID]] delegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setChooseCategoryLabel:nil];
    [self setCategoryPickerView:nil];
    [self setDescriptionLabel:nil];
    [self setBrandLabel:nil];
    [self setPriceLabel:nil];
    [self setCategoryPickerParentView:nil];
    [super viewDidUnload];
    [self setItemImageView:nil];
    [self setPickerView:nil];
    [self setPickPollTitleTextField:nil];
    _item = nil;
    poll = nil;
    spinner = nil;
    // Release any retained subviews of the main view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    [self.pickPollTitleTextField resignFirstResponder];
        if (newPoll) {
            if (self.pickPollTitleTextField.text.length == 0)
            {
                [Utility showAlert:@"Please type something" message:@"Your new poll should have a description."];
                return;
            }
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
           // [Utility setObject:_item.pollID forKey:IDOfPollToBeShown];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner startAnimating];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            _item.pollID = ((PollRecord*)[activePolls objectAtIndex:[self.pickerView selectedRowInComponent:0]]).pollID;
            [[RKObjectManager sharedManager] postObject:_item delegate:self];
        }
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.pickPollTitleTextField resignFirstResponder];
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
    switch (thePickerView.tag) {
        case PollPicker:
        {
            return [pickerDataArray count] + 1;
        }
        case CategoryPicker:
        {
            return PollTypeCount;
        }
        default:
            return 0;
    }
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
    switch (thePickerView.tag) {
        case PollPicker:
        {
            if (row > 0) {
                tView.text = [pickerDataArray objectAtIndex:row - 1];
            }else{
                tView.text = @"New Poll ... ";
            }
            break;
        }
        case CategoryPicker:
        {
            tView.text = [Utility stringFromCategory:(PollCategory) row];
            break;
        }
        default:
            break;
    }
    tView.text = [@" " stringByAppendingString:tView.text];
    return tView;
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (thePickerView.tag) {
        case PollPicker:
        {
            if (row > 0) {
                _item.pollID = ((PollRecord*)[activePolls objectAtIndex:row - 1]).pollID;
                newPoll = NO;
                self.pickPollTitleTextField.hidden = YES;
                self.DescriptionLabel.hidden = YES;
                self.chooseCategoryLabel.hidden = YES;
                self.categoryPickerParentView.hidden = YES;
            }else{
                _item.pollID = nil;
                newPoll = YES;
                self.pickPollTitleTextField.hidden = NO;
                self.DescriptionLabel.hidden = NO;
                self.chooseCategoryLabel.hidden = NO;
                self.categoryPickerParentView.hidden = NO;
                
            }
            break;
        }
        case CategoryPicker:
        {
            break;
        }
    }

}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

#pragma mark - TextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardWillShow {
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
}
@end
