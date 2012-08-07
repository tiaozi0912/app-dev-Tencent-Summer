//
//  NewItemViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/15/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewItemViewController.h"



@interface NewItemViewController ()
{
    BOOL itemAdded;
    NSURL *photoURL;
    Item *item;
}
 
@end

@implementation NewItemViewController

@synthesize itemImage,descriptionTextField=_descriptionTextField, priceTextField=_priceTextField;

-(void) setDescriptionTextField:(UITextField *)descriptionTextField{
    _descriptionTextField = descriptionTextField;
    self.descriptionTextField.delegate= self;
}

-(void) setPriceTextField:(UITextField *)priceTextField{
    _priceTextField = priceTextField;
    self.priceTextField.delegate= self;
}

-(IBAction)backgroundTouched:(id)sender
{
    [self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
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
    itemAdded = NO;
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.descriptionTextField = nil;
    self.priceTextField = nil;
    photoURL = nil;
    item = nil;
    
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO]; 
    [UIView commitAnimations];
    self.navigationItem.hidesBackButton = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)TestOnSimulator:(id)sender
{
    self.itemImage.image = [UIImage imageNamed:@"item2.png"];
    itemAdded = YES;
}//when testing on devices, reconnect useCamera method below

- (IBAction)useCamera 
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

- (IBAction)useCameraRoll
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

-(IBAction) finishAddingNewItems
{
    if (itemAdded) {
        item = [Item new];
        item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
        [[RKObjectManager sharedManager] postObject:item delegate:self];
    }else{
        [Utility showAlert:@"Sorry!" message:@"You have to add one item before clicking on me."];
    }
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if ([objectLoader wasSentToResourcePath:@"/polls/:pollID/items" method:RKRequestMethodPOST]){
        NSString *imageName = [NSString stringWithFormat:@"Item_%@_in_Poll_%@", item.itemID, item.pollID];
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imageName inBucket:ITEM_PHOTOS_BUCKET_NAME];
        por.cannedACL = [S3CannedACL publicRead];
        por.contentType = @"image/jpeg";
        por.delegate = self;
        por.filename = [imageName stringByAppendingString:@".jpeg"];
        item.photoURL = [NSURL URLWithString:[IMAGE_HOST_BASE_URL stringByAppendingFormat:@"/%@/%@", ITEM_PHOTOS_BUCKET_NAME, por.filename]];
        NSData *imageData = UIImageJPEGRepresentation(self.itemImage.image, 0.8f);
        por.data = imageData;
        [self.uploadingSpin startAnimating];
        [[AmazonClientManager s3] putObject:por];
    
        NSLog(@"The new item has been added!");
        Event *newItemEvent = [Event new];
        newItemEvent.eventType = NEWITEMEVENT;
        newItemEvent.pollID = item.pollID;
        newItemEvent.itemID = item.itemID;
        newItemEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        [[RKObjectManager sharedManager] postObject:newItemEvent delegate:self];
    }else if ([objectLoader wasSentToResourcePath:@"/polls/:pollID/items/:itemID" method:RKRequestMethodPOST]){
        [self.uploadingSpin stopAnimating];
        [self backWithFlipAnimation];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
}

#pragma mark - AmazonServiceRequestDelegate Implementations

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    item.description = self.descriptionTextField.text;
    item.numberOfVotes = [NSNumber numberWithInt:0];
    item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
    item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] putObject:item delegate:self];
}


-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"%@", exception);
}

#pragma mark - Helper Methods

- (IBAction)cancelButton{
    [self backWithFlipAnimation];
}

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

- (NSString*) formatCurrencyWithString: (NSString *) string
{
    // alloc formatter
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    // set options.
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    // reset style to no style for converting string to number.
    [currencyStyle setNumberStyle:NSNumberFormatterNoStyle];
    
    //create number from string
    NSNumber * balance = [currencyStyle numberFromString:string];
    
    //now set to currency format
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setMaximumFractionDigits:2];
    [currencyStyle setMinimumFractionDigits:2];
    // get formatted string
    NSString* formatted = [currencyStyle stringFromNumber:balance];
    
    currencyStyle = nil;
    
    //return formatted string
    return formatted;
}
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


@end
