//
//  CenterButtonTabController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "CenterButtonTabController.h"
#import "AddNewItemController.h"

@interface CenterButtonTabController ()

@end

@implementation CenterButtonTabController

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
[self.tabBar setBackgroundImage:[UIImage imageNamed:TAB_BAR_BG]];

    [super viewDidLoad];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    [button addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)cameraButtonClicked:(UIButton*)sender
{
#if ENVIRONMENT == ENVIRONMENT_DEVELOPMENT
    [self TestOnSimulator];
#elif ENVIRONMENT == ENVIRONMENT_PRODUCTION
    [self useCamera];
#endif
}

- (void) TestOnSimulator
{
    AddNewItemController *addNewItemController = [self.storyboard  instantiateViewControllerWithIdentifier:@"add new item VC"];
    addNewItemController.capturedItemImage = [UIImage imageNamed:@"user3.png"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addNewItemController];
    [self presentModalViewController:nav animated:YES];
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
        AddNewItemController *addNewItemController = [self.storyboard  instantiateViewControllerWithIdentifier:@"add new item VC"];
        addNewItemController.capturedItemImage = image;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addNewItemController];
        [self presentModalViewController:nav animated:YES];
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
@end
