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
    BOOL textboxOn;
    NSURL *photoURL;
    UIActivityIndicatorView *spinner;
}
 
@end

@implementation SingleItemViewController
@synthesize brandTextField = _brandTextField;
@synthesize itemImageView = _itemImageView;
//@synthesize cameraButton = _cameraButton;
@synthesize singleItemViewOption, item = _item;
//@synthesize descriptionTextField=_descriptionTextField;
@synthesize priceTextField=_priceTextField;


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

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    //self.descriptionTextField.delegate= self;
    self.priceTextField.delegate= self;
    self.brandTextField.delegate = self;
    //self.descriptionTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.priceTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.brandTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.priceTextField.hidden = YES;
    self.brandTextField.hidden = YES;
    textboxOn = NO;
    
    
    if (!singleItemViewOption == SingleItemViewOptionNew){
        //self.descriptionTextField.text = self.item.description;
        self.priceTextField.text = [Utility formatCurrencyWithNumber:self.item.price];
        self.brandTextField.text = self.item.brand;
        self.itemImageView.url = [NSURL URLWithString:self.item.photoURL];
        [HJObjectManager manage:self.itemImageView];
    }else{
        self.itemImageView.image = self.capturedImage;
    }
    if (singleItemViewOption == SingleItemViewOptionView)
    {
        //self.descriptionTextField.enabled = NO;
        self.priceTextField.enabled = NO;
        self.brandTextField.enabled = NO;
        //self.descriptionTextField.borderStyle = UITextBorderStyleNone;
        self.priceTextField.borderStyle = UITextBorderStyleNone;
        self.brandTextField.borderStyle = UITextBorderStyleNone;
    }else{
        //self.descriptionTextField.enabled = YES;
        self.priceTextField.enabled = YES;
        self.brandTextField.enabled = YES;
        //self.descriptionTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.priceTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.brandTextField.borderStyle = UITextBorderStyleRoundedRect;
        //self.descriptionTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
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
    [self setBrandTextField:nil];
    [self setItemImageView:nil];
    [super viewDidUnload];
    //self.descriptionTextField = nil;
    self.priceTextField = nil;
    photoURL = nil;
    self.item = nil;
    spinner = nil;
    self.capturedImage = nil;
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
    //[self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.brandTextField resignFirstResponder];
    switch (self.singleItemViewOption) {
        case SingleItemViewOptionView:
            [self backWithFlipAnimation];
            break;
        case SingleItemViewOptionEdit:
        {
            //self.item.description = self.descriptionTextField.text;
            self.item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
            [[RKObjectManager sharedManager] putObject:self.item delegate:self];
            break;
        }
        case SingleItemViewOptionNew:
        {
                spinner =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
                self.navigationItem.leftBarButtonItem.enabled = NO;
                self.item = [Item new];
                self.item.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
                [[RKObjectManager sharedManager] postObject:self.item delegate:self];
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
    if (textboxOn) {
        self.brandTextField.hidden = YES;
        self.priceTextField.hidden = YES;

        [self.priceTextField resignFirstResponder];
        [self.brandTextField resignFirstResponder];
    }else {
        self.brandTextField.hidden = NO;
        self.priceTextField.hidden = NO;
    }
    textboxOn = !textboxOn;
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
            NSData *imageData = UIImageJPEGRepresentation(self.capturedImage, 0.8f);
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
            //self.item.description = self.descriptionTextField.text;
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


@end
