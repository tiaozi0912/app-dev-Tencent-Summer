//
//  AddNewItemController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AddNewItemController.h"

@interface AddNewItemController ()
{
    NSURL *photoURL;
    UIActivityIndicatorView *spinner;
    Item *item;
    NSMutableArray *pickerDataArray;
    NSMutableArray *activePolls;
}
@end


@implementation AddNewItemController
@synthesize pickerView = _pickerView;
@synthesize pickedPollTitleLabel = _pickedPollTitleLabel;
@synthesize itemImage=_itemImage,descriptionTextField=_descriptionTextField, priceTextField=_priceTextField, capturedItemImage=_capturedItemImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionTextField.delegate= self;
    self.priceTextField.delegate= self;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.frame = CGRectMake(0, 416, 320, 216);
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    
    self.title = @"Add New Item";
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    pickerDataArray=[NSMutableArray new];
    activePolls = [NSMutableArray new];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/poll_records" delegate:self];
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setPickedPollTitleLabel:nil];
    [super viewDidUnload];
    self.descriptionTextField = nil;
    self.priceTextField = nil;
    photoURL = nil;
    item = nil;
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
    [self performSegueWithIdentifier:@"choose poll to add to" sender:self];

    /*item = [Item new];
    item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] postObject:item delegate:self];*/
}

- (IBAction)cancelButton{
    [self backWithFlipAnimation];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self dismissPickerView];
}

- (IBAction)pickPoll:(id)sender {
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -216);
    self.pickerView.transform = transform;
    [UIView commitAnimations];
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
            item.photoURL = [IMAGE_HOST_BASE_URL stringByAppendingFormat:@"/%@/%@", ITEM_PHOTOS_BUCKET_NAME, imageName];
            item.description = self.descriptionTextField.text;
            item.numberOfVotes = [NSNumber numberWithInt:0];
            item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
            item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
            [[RKObjectManager sharedManager] putObject:item delegate:self];
        }
        @catch (AmazonClientException *exception) {
            NSLog(@"Failed to Create Object [%@]", exception);
        }
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"The new item has been added!");
        Event *newItemEvent = [Event new];
        newItemEvent.eventType = NEWITEMEVENT;
        newItemEvent.pollID = item.pollID;
        newItemEvent.itemID = item.itemID;
        newItemEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        [[RKObjectManager sharedManager] postObject:newItemEvent delegate:self];
    }else if ([objectLoader wasSentToResourcePath:@"/poll_records" method:RKRequestMethodGET]){
        for (id obj in objects){
            PollRecord *pollRecord = (PollRecord*) obj;
                if ([pollRecord.pollRecordType isEqualToString:ACTIVE]){
                    [activePolls addObject:pollRecord];
                    [pickerDataArray addObject:pollRecord.title];
                    NSLog(@"%@", pollRecord.title);
            }
        }
        [self.pickerView reloadAllComponents];
    }else{
        [spinner stopAnimating];
        spinner = nil;
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
    
    return [pickerDataArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerDataArray objectAtIndex:row];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"Selected Poll: %@. Index of selected poll: %i", [pickerDataArray objectAtIndex:row], row);
    self.pickedPollTitleLabel.text = [pickerDataArray objectAtIndex:row];
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

@end