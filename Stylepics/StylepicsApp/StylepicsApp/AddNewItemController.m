//
//  AddNewItemController.m
//  MuseMe
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
@synthesize tapHintView = _tapHintView;

@synthesize brandTextField = _brandTextField;
@synthesize itemImage=_itemImage,capturedItemImage=_capturedItemImage;
//@synthesize priceTextField=_priceTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.descriptionTextField.delegate= self;
    //self.priceTextField.delegate= self;
    self.brandTextField.delegate = self;
    //self.descriptionTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    //self.priceTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.brandTextField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    //self.priceTextField.alpha = 0;
    self.brandTextField.alpha = 0;
    textboxOn = NO;

    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL];
    [self.navigationItem.leftBarButtonItem  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    UIImage *nextButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
    UIImage *nextIconImage = [UIImage imageNamed:NEXT_BUTTON];
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:nextIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(next)];
    
    [nextButton  setBackgroundImage:nextButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    
    self.title = @"Add New Item";
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    

	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    
    [self setBrandTextField:nil];
    //[self setCategoryButton:nil];

    [self setTapHintView:nil];
    [super viewDidUnload];
   // self.descriptionTextField = nil;
    //self.priceTextField = nil;

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
    if (textboxOn) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.brandTextField.alpha = 0;
            //self.priceTextField.alpha = 0;
            self.tapHintView.alpha = 1;
            
        } completion:nil];
        //[self.priceTextField resignFirstResponder];
        [self.brandTextField resignFirstResponder];
    }else {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.brandTextField.alpha = 1;
            //self.priceTextField.alpha = 1;
            self.tapHintView.alpha = 0;
            
        } completion:nil];
    }
    textboxOn = !textboxOn;
}

#pragma mark - Helper Methods

-(void)backWithFlipAnimation{
    /*[UIView beginAnimations:@"animation2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];*/
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_CHARACTER_NUMBER_FOR_ITEM_DESCRIPTION) ? NO : YES;
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
    if (textboxOn) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.brandTextField.alpha = 0;
            //self.priceTextField.alpha = 0;
            self.tapHintView.alpha = 1;
            
        } completion:nil];
        //[self.priceTextField resignFirstResponder];
        [self.brandTextField resignFirstResponder];
    }else {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.brandTextField.alpha = 1;
            //self.priceTextField.alpha = 1;
            self.tapHintView.alpha = 0;
            
        } completion:nil];
    }
    textboxOn = !textboxOn;
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    [self next];
}

-(void)next
{
    //[self.priceTextField resignFirstResponder];
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
        //nextVC.item.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
        nextVC.capturedItemImage = self.capturedItemImage;
    }
}
@end