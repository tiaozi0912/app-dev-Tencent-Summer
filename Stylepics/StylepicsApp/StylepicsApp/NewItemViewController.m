//
//  NewItemViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/15/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewItemViewController.h"
#import "Item.h"
#import "Utility.h"
#import "StylepicsDatabase.h"

@interface NewItemViewController ()
{
    StylepicsDatabase *database;
    BOOL itemAdded;
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
    self.navigationController.navigationBarHidden = YES;
    itemAdded = NO;
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    self.descriptionTextField.text = nil;
    self.priceTextField.text = nil;
    self.itemImage = nil;
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)TestOnSimulator:(id)sender {
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
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, 
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
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
-(IBAction) finishAddingNewItems{
    if (itemAdded) {
    database = [[StylepicsDatabase alloc] init];
    Item *item = [[Item alloc] init];
    item.photo = self.itemImage.image;
    item.description = self.descriptionTextField.text;
    item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
    [database addItems:item toPoll:[Utility getObjectForKey:IDOfPollToBeShown]];
    [self dismissModalViewControllerAnimated:YES];
    }else{
        [Utility showAlert:@"Sorry! You have not finished yet." message:@"You have to add one item before clicking on me."];
    }
}

- (IBAction)cancelButton{
    [self dismissModalViewControllerAnimated:YES];
}

@end
