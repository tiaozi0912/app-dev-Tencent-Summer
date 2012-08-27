//
//  NewsFeedTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "AddNewItemController.h"
#import "Utility.h"
#import "ManagePollsTableViewController.h"


#define ROWHEIGHT 369

#define TimeStampLabelFrame CGRectMake(48,9,74,9)
#define UserImageFrame CGRectMake(5,9,40,40)
#define UsernameAndActionLabelFrame CGRectMake(47,17,236,16)
#define EventDescriptionLabelFrame CGRectMake(47,33,236,16)
#define CategoryIconFrame CGRectMake(292,9,23,23)
#define ItemImageFrame CGRectMake(5,57,310,310)
#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

@interface NewsFeedTableViewController (){
    User* userToBePassed;
}
@property (nonatomic, strong) NSArray* events;
@end

@implementation NewsFeedTableViewController

@synthesize events=_events;

- (void)viewDidLoad
{
    NSLog(@"Home loaded");
    //set color of text in UITabBarItem
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor, 
      [UIFont fontWithName:@"Helvetica" size:11], UITextAttributeFont, 
      nil] 
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], UITextAttributeTextColor, 
      [UIFont fontWithName:@"Helvetica" size:11], UITextAttributeFont, 
      nil] 
                                             forState:UIControlStateHighlighted];
    //custom tab bar icons
    
    UIImage *selectedImage1 = [UIImage imageNamed:FEEDS_ICON_HL];
    UIImage *unselectedImage1 = [UIImage imageNamed:FEEDS_ICON];
    
    UIImage *selectedImage2 = [UIImage imageNamed:PROFILE_ICON_HL];
    UIImage *unselectedImage2 = [UIImage imageNamed:PROFILE_ICON];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];

    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_WITH_LOGO] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:NEW_POLL_BUTTON andHighlightedStateImage:NEW_POLL_BUTTON_HL target:self action:@selector(newPoll)];
}

- (void)viewDidUnload
{
    self.events = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_WITH_LOGO] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = NO;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/events" delegate:self];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.events = nil;
}

- (void) dealloc
{
    [[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    if ([objectLoader wasSentToResourcePath:@"/events"]){
        self.events = objects;
        NSLog(@"%u", self.events.count);
        [self.tableView reloadData];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.events objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"feeds cell";
    FeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedsCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.thumbnail1.hidden = YES;
    cell.thumbnail2.hidden = YES;
    cell.thumbnail3.hidden = YES;
    cell.thumbnail4.hidden = YES;
    // Configure the cell...Add item event
    cell.userImage.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO_SMALL];
    cell.userImage.url = [NSURL URLWithString:event.user.profilePhotoURL];
    [HJObjectManager manage:cell.userImage];
    
    [cell.thumbnail0 clear];
    [cell.thumbnail0 showLoadingWheel];
    cell.thumbnail0.url = [NSURL URLWithString:((Item*)[event.items objectAtIndex:0]).photoURL];

    cell.thumbnail0.transform = CGAffineTransformIdentity;
    cell.thumbnail0.transform = CGAffineTransformMakeRotation(degreesToRadians(30));
    cell.thumbnail0.bounds = CGRectMake(0,0, 200, 200);
    
    if (event.items.count > 1) {
        [cell.thumbnail1 clear];
        [cell.thumbnail1 showLoadingWheel];
        cell.thumbnail1.url = [NSURL URLWithString:((Item*)[event.items objectAtIndex:1]).photoURL];
        cell.thumbnail1.hidden = NO;
    }
    if (event.items.count > 2) {
        [cell.thumbnail2 clear];
        [cell.thumbnail2 showLoadingWheel];
        cell.thumbnail2.url = [NSURL URLWithString:((Item*)[event.items objectAtIndex:2]).photoURL];
        cell.thumbnail2.hidden = NO;
    }
    if (event.items.count > 3) {
        [cell.thumbnail3 clear];
        [cell.thumbnail3 showLoadingWheel];
        cell.thumbnail3.url = [NSURL URLWithString:((Item*)[event.items objectAtIndex:3]).photoURL];
        cell.thumbnail3.hidden = NO;
    }
    if (event.items.count > 4) {
        [cell.thumbnail4 clear];
        [cell.thumbnail4 showLoadingWheel];
        cell.thumbnail4.url = [NSURL URLWithString:((Item*)[event.items objectAtIndex:4]).photoURL];
        cell.thumbnail4.hidden = NO;
    }
    
    [HJObjectManager manage:cell.thumbnail0];
    [HJObjectManager manage:cell.thumbnail1];
    [HJObjectManager manage:cell.thumbnail2];
    [HJObjectManager manage:cell.thumbnail3];
    [HJObjectManager manage:cell.thumbnail4];
    
    // In current version, photo uploading is limited to one picture at a time
    
    cell.timeStampLabel.text = [Utility formatTimeWithDate:event.timeStamp];
    
    cell.categoryIcon.image = [Utility iconForCategory:(PollCategory)[event.poll.category intValue]];
    [HJObjectManager manage:cell.categoryIcon];
    
    [cell.usernameAndActionLabel updateNumberOfLabels:2];
    [cell.usernameAndActionLabel setText:event.user.username andFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] forLabel:0];
    [cell.usernameAndActionLabel setText:@" would like your vote" andFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:14.0] forLabel:1];
    cell.usernameAndActionLabel.clipsToBounds = YES;
    
    cell.eventDescriptionLabel.text = event.poll.title;
    cell.eventDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    [cell.eventDescriptionLabel setNeedsLayout];
    
    /*cell.timeStampLabel.frame = TimeStampLabelFrame;
     cell.userImage.frame = UserImageFrame;
     cell.usernameAndActionLabel.frame = UsernameAndActionLabelFrame;
     cell.eventDescriptionLabel.frame = EventDescriptionLabelFrame;
     cell.categoryIcon.frame = CategoryIconFrame;
     cell.itemImage.frame = ItemImageFrame;*/
    return cell;

}


//Set up cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT;
}


#pragma mark - Table view delegate

- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath{
   // cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.events objectAtIndex:indexPath.row];
    [Utility setObject:event.poll.pollID forKey:IDOfPollToBeShown];
    [self performSegueWithIdentifier:@"show poll" sender:self];
}

- (IBAction)showUserProfile:(id)sender {
    FeedsCell *cell = (FeedsCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Event* event = [self.events objectAtIndex:indexPath.row];
    userToBePassed = event.user;
    [self performSegueWithIdentifier:@"show profile" sender:self];
}

#pragma User Actions

-(void)newPoll
{
    [self performSegueWithIdentifier:@"new poll" sender:self];
}

#pragma NewPollViewController delegate method

-(void)newPollViewController:(id)sender didCreateANewPoll:(NSNumber *)pollID
{
    [Utility setObject:pollID forKey:IDOfPollToBeShown];
    [self dismissModalViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"show poll" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"new poll"]){
        ((NewPollViewController*)(segue.destinationViewController)).delegate = self;
    }else if ([segue.identifier isEqualToString:@"show profile"])
    {
        ((ManagePollsTableViewController*)segue.destinationViewController).user = userToBePassed;
    }
    
}
@end
