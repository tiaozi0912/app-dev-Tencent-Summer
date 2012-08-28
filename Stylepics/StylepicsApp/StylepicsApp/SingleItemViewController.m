//
//  SingleItemViewController.m
//  
//
//  Created by Yong Lin on 7/15/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "SingleItemViewController.h"


@interface SingleItemViewController ()
{
    BOOL itemAdded;
    NSURL *photoURL;
    UIImage* itemImage;
    UIActivityIndicatorView *spinner;
}
 
@end

@implementation SingleItemViewController
@synthesize brandTextField = _brandTextField;
@synthesize cameraButton = _cameraButton;
@synthesize singleItemViewOption, item = _item;
@synthesize descriptionTextField=_descriptionTextField, priceTextField=_priceTextField;

-(void) setDescriptionTextField:(UITextField *)descriptionTextField{
    _descriptionTextField = descriptionTextField;
    self.descriptionTextField.delegate= self;
}

-(void) setPriceTextField:(UITextField *)priceTextField{
    _priceTextField = priceTextField;
    self.priceTextField.delegate= self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
    UIImage *backIconImage = [UIImage imageNamed:BACK_BUTTON];
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButton)];
    
    [backButton  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIImage *addToPollButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
    UIBarButtonItem *addToPollButton = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    [addToPollButton  setBackgroundImage:addToPollButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = addToPollButton;
    
    NSArray *titles = [[NSArray alloc] initWithObjects:@"Add New Item", @"Edit Item", @"View Item",nil];
    self.title = [titles objectAtIndex:singleItemViewOption];
    if (singleItemViewOption == SingleItemViewOptionNew){
        [self.cameraButton setImage:[UIImage imageNamed:ADD_ITEM_HINT] forState:UIControlStateNormal];
    }
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    itemAdded = NO;
    if (!singleItemViewOption == SingleItemViewOptionNew){
        self.descriptionTextField.text = self.item.description;
        self.priceTextField.text = [self.item.price stringValue];
        self.brandTextField.text = self.item.brand;
        itemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.item.photoURL]]];
        [self.cameraButton setBackgroundImage:itemImage forState:UIControlStateNormal];
        self.cameraButton.enabled = NO;
    }
    if (singleItemViewOption == SingleItemViewOptionView)
    {
        self.descriptionTextField.enabled = NO;
        self.priceTextField.enabled = NO;
        self.brandTextField.enabled = NO;
        self.descriptionTextField.borderStyle = UITextBorderStyleNone;
        self.priceTextField.borderStyle = UITextBorderStyleNone;
        self.brandTextField.borderStyle = UITextBorderStyleNone;
    }else{
        self.descriptionTextField.enabled = YES;
        self.priceTextField.enabled = YES;
        self.brandTextField.enabled = YES;
        self.descriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.priceTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.brandTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.descriptionTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
        self.priceTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
        self.brandTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    }
    [UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [self setCameraButton:nil];
    [self setBrandTextField:nil];
    [super viewDidUnload];
    self.descriptionTextField = nil;
    self.priceTextField = nil;
    photoURL = nil;
    self.item = nil;
    spinner = nil;
    [AmazonClientManager clearCredentials];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = YES;
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

-(IBAction)done
{
    [self backgroundTouched:nil];
    switch (self.singleItemViewOption) {
        case SingleItemViewOptionView:
            [self backWithFlipAnimation];
            break;
        case SingleItemViewOptionEdit:
        {
            self.item.description = self.descriptionTextField.text;
            self.item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
            [[RKObjectManager sharedManager] putObject:self.item delegate:self];
            break;
        }
        case SingleItemViewOptionNew:
        {
            if (itemAdded) {
                [self.descriptionTextField resignFirstResponder];
                [self.priceTextField resignFirstResponder];
                spinner =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
                self.navigationItem.leftBarButtonItem.enabled = NO;
                self.item = [Item new];
                self.item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
                [[RKObjectManager sharedManager] postObject:self.item delegate:self];
            }else{
                [Utility showAlert:@"Sorry!" message:@"You have to add one item before clicking on me."];
            }
            break;
        }
        default:
            break;
    }

}

- (IBAction)cancelButton{
    [self backWithFlipAnimation];
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
}

-(IBAction)showActionSheet:(id)sender {
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture", @"Choose from existing", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	popupQuery = nil;
}
- (void) TestOnSimulator
{
    itemImage = [UIImage imageNamed:@"user3.png"];
    [self.cameraButton setBackgroundImage:itemImage forState:UIControlStateNormal];
    itemAdded = YES;
}//when testing on devices, reconnect useCamera method below

- (void)useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker 
                                animated:YES];
        //newMedia = YES;
    }
}

- (void)useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
        //newMedia = NO;
    } 
}


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info 
                          objectForKey:UIImagePickerControllerEditedImage];
        itemImage = image;
        [self.cameraButton setImage:image forState:UIControlStateNormal];
        itemAdded = YES;
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}

/*-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        [Utility showAlert:@"Save failed" message:@"Failed to save image"];
    }
}*/

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma RKObjectLoaderDelegate Methods

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if ([objectLoader wasSentToResourcePath:@"/items" method:RKRequestMethodPOST] ){
        @try {
            NSString *imageName = [NSString stringWithFormat:@"Item_%@_%@.jpeg", self.item.itemID, [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle]];
            NSData *imageData = UIImageJPEGRepresentation(itemImage, 0.8f);
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
            self.item.photoURL = [IMAGE_HOST_BASE_URL stringByAppendingFormat:@"/%@/%@", ITEM_PHOTOS_BUCKET_NAME, [Utility formatURLFromDateString:imageName]];
            self.item.description = self.descriptionTextField.text;
            self.item.numberOfVotes = [NSNumber numberWithInt:0];
            self.item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
            self.item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
            self.item.brand = self.brandTextField.text;
            [[RKObjectManager sharedManager] putObject:self.item delegate:self];
        }
        @catch (AmazonClientException *exception) {
            NSLog(@"Failed to Create Object [%@]", exception);
        }
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"The new item has been added!");
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
    [self.navigationController popViewControllerAnimated:NO];
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

#pragma mark - UIActionSheetDelegate Methods


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     switch (buttonIndex) {
         case 0:
#if ENVIRONMENT == ENVIRONMENT_DEVELOPMENT
             [self useCamera];
#elif ENVIRONMENT == ENVIRONMENT_STAGING
             [self useCamera];
#elif ENVIRONMENT == ENVIRONMENT_PRODUCTION
             [self useCamera];
#endif
     break;
         case 1:[self useCameraRoll];
     break;
         case 2:[actionSheet resignFirstResponder];
     break;
     default:
     break;
     }
}
@end
