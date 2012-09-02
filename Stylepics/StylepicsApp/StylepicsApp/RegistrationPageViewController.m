//
//  RegistrationPageViewController.m
//  MuseMe
//
//  Created by Yong Lin on 7/10/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "RegistrationPageViewController.h"
#import "Utility.h"
#define EmailField 0
#define PasswordField 1
#define PasswordConfirmationField 2

#define OpacityOfDimissButton 0.15
static NSUInteger kNumberOfPages = 6;

@interface RegistrationPageViewController (){
    User* user;
    BOOL choiceMade;
    BOOL loginMode;
    UIImageView* tutorialPage;
    int currentPage;
}
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

@implementation RegistrationPageViewController
@synthesize dismissButton = _dismissButton;
@synthesize logoImage = _logoImage;

@synthesize emailField=_emailField;
@synthesize passwordField=_passwordField;
@synthesize passwordConfirmationField=_passwordConfirmationField;
@synthesize signupButton = _signupButton;
@synthesize spinner = _spinner;
@synthesize loginButton = _loginButton;
@synthesize background = _background;
@synthesize scrollView = _scrollView;
//@synthesize pageControl = _pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    _emailField.delegate = self;
    _emailField.returnKeyType = UIReturnKeyNext;
    _emailField.tag = EmailField;
    _emailField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _emailField.alpha = 0;

    
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _passwordField.tag = PasswordField;
    _passwordField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _passwordField.alpha = 0;

    
    _passwordConfirmationField.delegate = self;
    _passwordConfirmationField.returnKeyType =UIReturnKeyDone;
    _passwordConfirmationField.tag = PasswordConfirmationField;
    _passwordConfirmationField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _passwordConfirmationField.alpha = 0;

    
    /*_emailField.inputAccessoryView = [Utility keyboardAccessoryToolBarWithButton:@"Dismiss" target:self action:@selector(dismissAll)];
    _passwordField.inputAccessoryView = [Utility keyboardAccessoryToolBarWithButton:@"Dismiss" target:self action:@selector(dismissAll)];    choiceMade = NO;
    _passwordConfirmationField.inputAccessoryView = [Utility keyboardAccessoryToolBarWithButton:@"Dismiss" target:self action:@selector(dismissAll)];*/
    
    self.loginButton.alpha = 0;
    self.signupButton.alpha = 0;
    self.dismissButton.alpha = 0;
    [self.spinner startAnimating];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * kNumberOfPages, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;

    //_pageControl.numberOfPages = kNumberOfPages;
    //_pageControl.currentPage = 0;
    currentPage = 0;
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    _scrollView.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[Utility setObject:nil forKey:IS_OLD_USER];//For testing purpose
    if (![Utility getObjectForKey:IS_OLD_USER]){
        [self showTutorial];
        [Utility setObject:[NSNumber numberWithBool:YES] forKey:IS_OLD_USER];
    }else if ([Utility getObjectForKey:CURRENTUSERID]){
        [self performSegueWithIdentifier:@"show home" sender:self];
    }else{
        [self animateOpening];
    }
    [self.spinner stopAnimating];
    /*[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -216);
    self.transform = transform;
    [UIView commitAnimations];*/
}

-(void)animateOpening
{
    CGRect frame = CGRectMake(65, 175, 196, 73);
    self.logoImage.frame = frame;
    self.logoImage.image = [UIImage imageNamed:LOGO_IN_LANDING_PAGE];
    frame.origin.y = 125;
    CGFloat transitionDuration = 0.8;
    [UIView animateWithDuration:transitionDuration delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        self.logoImage.frame = frame;
        self.logoImage.alpha = 0;
    } completion:^(BOOL finished){
        CGRect frame1 = self.logoImage.frame;
        frame1.origin.y = 50;
        self.logoImage.frame = frame1;
        frame1.origin.y = 0;
        [UIView animateWithDuration:transitionDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            self.logoImage.frame = frame1;
            self.logoImage.alpha = 1;
        } completion:^(BOOL finished){
            self.logoImage.image = [UIImage imageNamed:LOGO_IN_LANDING_PAGE_GLOW];
        }];
    }];
    
    
    
    [UIView animateWithDuration:0.5 delay:transitionDuration*2 options:UIViewAnimationCurveEaseInOut animations:^{
        self.loginButton.alpha = 1;
        self.signupButton.alpha = 1;
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.emailField.text=nil;
    self.passwordField.text=nil;
    self.passwordConfirmationField.text=nil;
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
}

- (void)viewDidUnload
{
    self.emailField = nil;
    [self setPasswordField:nil];
    [self setPasswordConfirmationField:nil];
    [self setSignupButton:nil];
    [self setSpinner:nil];
    [self setLoginButton:nil];
    [self setBackground:nil];
    [self setScrollView:nil];
    //[self setPageControl:nil];
    [self setDismissButton:nil];
    [self setLogoImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma User Actions

- (IBAction)loginButtonPressed {
    if (choiceMade){
        [self login];
    }else{
        loginMode = YES;
        choiceMade = YES;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.signupButton.alpha = 0;
            self.emailField.alpha = 1;
            self.passwordField.alpha = 1;
            self.dismissButton.alpha = OpacityOfDimissButton;
        } completion:nil];
        [self.emailField becomeFirstResponder];
    }
}

- (IBAction)signupButtonPressed:(id)sender {
    if (choiceMade){
        [self signup];
    }else{
        loginMode = NO;
        choiceMade = YES;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.loginButton.alpha = 0;
            self.emailField.alpha = 1;
            self.passwordField.alpha = 1;
            self.passwordConfirmationField.alpha = 1;
            self.dismissButton.alpha = OpacityOfDimissButton;
        } completion:nil];
        [self.emailField becomeFirstResponder];
    }
}

-(IBAction)backgroundTouched:(id)sender
{
    if (choiceMade){
        [self dismissAll];
    }
}

-(void)dismissAll
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordConfirmationField resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.emailField.alpha = 0;
        self.passwordField.alpha = 0;
        self.passwordConfirmationField.alpha = 0;
        self.dismissButton.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.loginButton.alpha = 1;
        self.signupButton.alpha = 1;
    } completion:nil];
    choiceMade = NO;
}

- (void)signup {
    /*if ([_emailField.text rangeOfString:@"@"].location == NSNotFound){
        [Utility showAlert:@"Invalid email address" message:@"Please double check your email address"];
    }else */
    if (_passwordField.text.length < 6){
        [Utility showAlert:@"Password is too short!" message:@"Password should be longer than 6 characters"];
    }else if (![_passwordConfirmationField.text isEqualToString:_passwordField.text]){
        [Utility showAlert:@"Password Confirmation Mismatch!" message:@"Your password and password confirmation should be exactly the same."];
    }else {
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self.passwordConfirmationField resignFirstResponder];
        user = [User new];
        if ([self.emailField.text rangeOfString:@"@"].location != NSNotFound){
            user.username = [self.emailField.text substringToIndex:[self.emailField.text rangeOfString:@"@"].location];
        }
        user.email = self.emailField.text;
        user.password = self.passwordField.text;
        user.passwordConfirmation = self.passwordConfirmationField.text;
        [self lockUI];
        [self.spinner startAnimating];
        [[RKObjectManager sharedManager] postObject:user delegate:self];
    }
}

- (void)login {
    if ([self.emailField.text length] == 0 ||[self.emailField.text length] == 0 ){
        [Utility showAlert:@"Sorry!" message:@"Neither email nor password can be empty."];
    }else{
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        user = [User new];
        user.email = self.emailField.text;
        user.password = self.passwordField.text;
        [self lockUI];
        [self.spinner startAnimating];
        [[RKObjectManager sharedManager] postObject:user usingBlock:^(RKObjectLoader* loader){
            loader.resourcePath = @"/login";
            loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[User class]];
            loader.serializationMapping =[[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[User class]];
            loader.delegate = self;
        }];
    }
}

-(void)lockUI
{
    self.background.enabled = NO;
    self.emailField.enabled = NO;
    self.passwordField.enabled = NO;
    self.passwordConfirmationField.enabled = NO;
    self.loginButton.enabled = NO;
    self.signupButton.enabled = NO;
}

-(void)unlockUI
{
    self.background.enabled = YES;
    self.emailField.enabled = YES;
    self.passwordField.enabled = YES;
    self.passwordConfirmationField.enabled = YES;
    self.loginButton.enabled = YES;
    self.signupButton.enabled = YES;
}

#pragma RKObjectLoader Delegate Methods
- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    // signup was successful
    if ([objectLoader wasSentToResourcePath:@"/signup"]){
        [Utility showAlert:@"Congratulations!" message:@"Welcome to Muse Me!"];
        NSLog(@"userID:%@, email:%@, password:%@", user.userID, user.email, user.password);
        [Utility setObject:user.singleAccessToken forKey:SINGLE_ACCESS_TOKEN_KEY];
        [Utility setObject:user.userID forKey:CURRENTUSERID];
        [self performSegueWithIdentifier:@"show home" sender:self];
        
    }else if ([objectLoader wasSentToResourcePath:@"/login"]){
        [Utility setObject:user.singleAccessToken forKey:SINGLE_ACCESS_TOKEN_KEY];
        [Utility setObject:user.userID forKey:CURRENTUSERID];
        [self performSegueWithIdentifier:@"show home" sender:self];
    }
    [self unlockUI];
    [self.spinner stopAnimating];
    [self dismissAll];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: existent email and invalid password
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
    [self unlockUI];
    [self.spinner stopAnimating];
}

#pragma UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!loginMode){
        switch (textField.tag) {
            case EmailField:{
                [_passwordField becomeFirstResponder];
                return NO;
            }
            case PasswordField:{
                [self.passwordConfirmationField becomeFirstResponder];
                return NO;
            }
            case PasswordConfirmationField:{
                [self signup];
                return NO;
            }
            default:
                break;
        }
    }else{
        if (textField.tag == EmailField)
        {
            [_passwordField becomeFirstResponder];
            return NO;
        }else {
            [self login];
            return NO;
        }
    }
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)showTutorial
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        _scrollView.alpha = 1;
    } completion:nil];
    //[self performSegueWithIdentifier:@"show tutorial" sender:self];
}

-(void)endTutorial
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-320, 0);
    _scrollView.transform = transform;
    [UIView commitAnimations];
    NSLog(@"tutorial ended");
    
    [self animateOpening];
}
- (void)loadScrollViewWithPage:(int)page
{

    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    tutorialPage = nil;
    tutorialPage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"instruction-page-%d", page]]];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    tutorialPage.frame = frame;
        
    [self.scrollView addSubview:tutorialPage];
    if (page == kNumberOfPages - 1){
        UIButton* endTutorialButton= [UIButton buttonWithType:UIButtonTypeCustom];
        endTutorialButton.frame = CGRectMake(frame.origin.x + 50, frame.origin.y + 106, 224, 61);
        [endTutorialButton addTarget:self action:@selector(endTutorial) forControlEvents:UIControlEventTouchDown];
        [self.scrollView addSubview:endTutorialButton];
    }else{
        UIButton* nextPageButton= [UIButton buttonWithType:UIButtonTypeCustom];
        nextPageButton.frame = CGRectMake(frame.origin.x + 276, frame.origin.y + 226, 43, 37);
        [nextPageButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchDown];
        [self.scrollView addSubview:nextPageButton];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
   // _pageControl.currentPage = page;
    currentPage = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

-(void)nextPage
{
	NSLog(@"go to the next page");
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:currentPage + 1];
    [self loadScrollViewWithPage:currentPage + 2];
    
	// update the scroll view to the appropriate page
    currentPage += 1;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * currentPage;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

/*- (IBAction)changePage:(id)sender
{
    int page = _pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}*/

@end
