//
//  AddNewItemController.m
//  StylepicsApp
//
//  Created by Yong Lin on 8/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "AddNewItemController.h"
#import "AddToPollController.h"

@interface AddNewItemController ()
{
    BOOL textboxOn;
}
@end


@implementation AddNewItemController

@synthesize brandTextField = _brandTextField;
@synthesize itemImage=_itemImage, priceTextField=_priceTextField, capturedItemImage=_capturedItemImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.descriptionTextField.delegate= self;
    self.priceTextField.delegate= self;
    self.brandTextField.delegate = self;
    //self.descriptionTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.priceTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.brandTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    

    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    /*self.navigationItem.leftBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:CANCEL_BUTTON andHighlightedStateImage:CANCEL_BUTTON_HL target:self action:@selector(cancelButton)];
    self.navigationItem.rightBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:NEXT_BUTTON andHighlightedStateImage:NEXT_BUTTON_HL target:self action:@selector(next)];*/
    
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    
    self.title = @"Add New Item";
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    self.priceTextField.hidden = YES;
    self.brandTextField.hidden = YES;
    textboxOn = NO;
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    
    [self setBrandTextField:nil];
    //[self setCategoryButton:nil];

    [super viewDidUnload];
   // self.descriptionTextField = nil;
    self.priceTextField = nil;

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



- (IBAction)cancelButton{
    [self backWithFlipAnimation];
}

-(IBAction)backgroundTouched:(id)sender
{
    //[self.descriptionTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.brandTextField resignFirstResponder];
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

- (IBAction)tapPicture:(UIControl *)sender {
    if (!textboxOn) {
        self.brandTextField.hidden = NO;
        self.priceTextField.hidden = NO;
        textboxOn = YES;
    }else{
        [self.priceTextField resignFirstResponder];
        [self.brandTextField resignFirstResponder];
        textboxOn = NO;
    }
    
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    [self next];
}

-(void)next
{
    [self.priceTextField resignFirstResponder];
    [self.brandTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"next" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"next"])
    {
        AddToPollController* nextVC = (AddToPollController*)(segue.destinationViewController);
        nextVC.item = [Item new];
        nextVC.item.brand = self.brandTextField.text;
        nextVC.item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
        nextVC.capturedItemImage = self.capturedItemImage;
    }
}
@end