//
//  SettingsTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/8/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController (){
    User* currentUser;
}

@end

@implementation SettingsTableViewController
@synthesize username=_username;
@synthesize profilePhoto=_profilePhoto;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setUsername:(UITextField *)username
{
    _username = username;
    _username.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.profilePhoto.image = [UIImage imageNamed:@"default_profile_photo.jpeg"];
    currentUser = [User new];
    currentUser.userID = [Utility getObjectForKey:CURRENTUSERID];
    [[RKObjectManager sharedManager] getObject:currentUser delegate:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setProfilePhoto:nil];
    [self setProfilePhoto:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma User Acitons

- (void)Logout {
    User* user = [User new];
    user.singleAccessToken = [Utility getObjectForKey:SINGLE_ACCESS_TOKEN_KEY];
    [[RKObjectManager sharedManager] postObject:user usingBlock:^(RKObjectLoader *loader) {
        loader.delegate = self;
        loader.resourcePath = @"/logout";
        loader.serializationMapping = [[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[User class]];
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma RKObjectLoaderDelegate Methods
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    if ([objectLoader wasSentToResourcePath:@"/logout"]){
        NSLog(@"Server side destroies session successfully!");
    }else if (objectLoader.method == RKRequestMethodGET){
        self.username.text = currentUser.username;
        self.profilePhoto.url = [NSURL URLWithString: currentUser.profilePhotoURL];
    }else if (objectLoader.method == RKRequestMethodPUT){
        [self.spinner stopAnimating];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 1)
            {
                [self showActionSheet];
            }
        }
            break;
        case 2:
        {
            [self Logout];
        }
            break;
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - UITextField delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:currentUser.username])
    {
        currentUser.username = textField.text;
        currentUser.email = [textField.text stringByAppendingString:@"@gmail.com"];
        [[RKObjectManager sharedManager] putObject:currentUser delegate:self];
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)showActionSheet
{
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture", @"Choose from photo library", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	popupQuery = nil;
}

- (void) uploadPhoto
{
    [self.spinner startAnimating];
    NSString *imageName = [NSString stringWithFormat:@"User_%@_%@.jpeg", [Utility getObjectForKey:CURRENTUSERID], [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle]];
    NSData *imageData = UIImageJPEGRepresentation(self.profilePhoto.image, 0.8f);
    @try {
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:imageName inBucket:USER_PROFILE_PHOTOS_BUCKET_NAME];
        por.contentType = @"image/jpeg";
        por.data = imageData;
        por.cannedACL = [S3CannedACL publicRead];
        [AmazonClientManager initializeS3];
        [[AmazonClientManager s3] putObject:por];
        NSLog(@"Image Uploaded");
    }
    @catch (AmazonClientException *exception) {
        NSLog(@"Failed to Create Object [%@]", exception);
    }
    currentUser.profilePhotoURL = [IMAGE_HOST_BASE_URL stringByAppendingFormat:@"/%@/%@", USER_PROFILE_PHOTOS_BUCKET_NAME, imageName];
    [[RKObjectManager sharedManager] putObject:currentUser delegate:self];
}
- (void) TestOnSimulator
{
    self.profilePhoto.image = [UIImage imageNamed:@"user3.png"];
    [self uploadPhoto];
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
        UIImage *original = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *small = [UIImage imageWithCGImage:original.CGImage scale:0.25 orientation:original.imageOrientation];
        
        self.profilePhoto.image = small;
        [self uploadPhoto];
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
        case 2://cancel;
            break;
        default:
            break;
    }
    [actionSheet resignFirstResponder];
}

@end
