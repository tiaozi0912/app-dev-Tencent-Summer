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
    Item *item;
    UIActivityIndicatorView *spinner;
}
 
@end

@implementation SingleItemViewController
@synthesize cameraButton;
@synthesize singleItemViewOption, item;
@synthesize itemImage,descriptionTextField=_descriptionTextField, priceTextField=_priceTextField;

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
    NSArray *titles = [[NSArray alloc] initWithObjects:@"Add New Item", @"Edit Item", @"View Item",nil];
    self.title = [titles objectAtIndex:singleItemViewOption];
    if (singleItemViewOption == SingleItemViewOptionView)
    {
        self.descriptionTextField.enabled = NO;
        self.priceTextField.enabled = NO;
    }
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    itemAdded = NO;
    if (item){
        self.descriptionTextField.text = item.description;
        self.priceTextField.text = [item.price stringValue];
        self.itemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.photoURL]]];
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
    self.navigationController.toolbarHidden = !(self.singleItemViewOption == SingleItemViewOptionNew);
    self.navigationItem.hidesBackButton = YES;
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
    switch (self.singleItemViewOption) {
        case SingleItemViewOptionView:
            [self backWithFlipAnimation];
            break;
        case SingleItemViewOptionEdit:
        {
            item.description = self.descriptionTextField.text;
            item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
            [[RKObjectManager sharedManager] putObject:item delegate:self];
            break;
        }
        case SingleItemViewOptionNew:
        {
            if (itemAdded) {
                [self.descriptionTextField resignFirstResponder];
                [self.priceTextField resignFirstResponder];
                spinner =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
                self.navigationItem.rightBarButtonItem.enabled = NO;
                item = [Item new];
                item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
                [[RKObjectManager sharedManager] postObject:item delegate:self];
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
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture", @"Choose from photo library", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showFromBarButtonItem:self.cameraButton animated:YES];
	popupQuery = nil;
}
- (void) TestOnSimulator
{
    self.itemImage.image = [UIImage imageNamed:@"user3.png"];
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
        imagePicker.allowsEditing = NO;
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
        imagePicker.allowsEditing = NO;
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
                          objectForKey:UIImagePickerControllerOriginalImage];
        self.itemImage.image = image;
        itemAdded = YES;
     /*   ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (newMedia)
            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    NSLog(@"error");
                } else {
                    NSLog(@"url %@", assetURL);
                    //photoURL = assetURL;
                }  
            }];
        library = nil;
        photoURL = [NSURL URLWithString:@"http://i.dailymail.co.uk/i/pix/2012/07/27/article-2180047-143F90C1000005DC-196_634x423.jpg"];*/
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
    }else {
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
             [self TestOnSimulator];
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
