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

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{  
    [aTextField resignFirstResponder];
    return YES;
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
        newMedia = YES;
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
        newMedia = NO;
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
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
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
        photoURL = [NSURL URLWithString:@"http://i.dailymail.co.uk/i/pix/2012/07/27/article-2180047-143F90C1000005DC-196_634x423.jpg"];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        [Utility showAlert:@"Save failed" message:@"Failed to save image"];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) finishAddingNewItems
{
    if (itemAdded) {
        Item *item = [Item new];
        item.photoURL = photoURL;
        item.description = self.descriptionTextField.text;
        item.numberOfVotes = [NSNumber numberWithInt:0];
        item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
        item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
        [[RKObjectManager sharedManager] postObject:item delegate:self];
        Event *newItemEvent = [Event new];
        newItemEvent.type = NEWITEMEVENT;
        newItemEvent.poll.pollID = item.pollID;
        newItemEvent.item = item;
        newItemEvent.user.userID = [Utility getObjectForKey:CURRENTUSERID];
        [[RKObjectManager sharedManager] postObject:newItemEvent delegate:self];
    }else{
        [Utility showAlert:@"Sorry!" message:@"You have to add one item before clicking on me."];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    NSLog(@"The new item has been added!");
    [self backWithFlipAnimation];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
}

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

@end
