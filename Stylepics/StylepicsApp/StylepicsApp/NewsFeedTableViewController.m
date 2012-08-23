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

#define HEIGHTOFNEWPOLLCELL 55
#define HEIGHTOFNEWITEMCELL 369
#define HEIGHTOFVOTECELL 369

#define TimeStampLabelFrame CGRectMake(48,9,74,9)
#define UserImageFrame CGRectMake(5,9,40,40)
#define UsernameAndActionLabelFrame CGRectMake(47,17,236,16)
#define EventDescriptionLabelFrame CGRectMake(47,33,236,16)
#define CategoryIconFrame CGRectMake(292,9,23,23)
#define ItemImageFrame CGRectMake(5,57,310,310)

@interface NewsFeedTableViewController (){
}
@property (nonatomic, strong) NSArray* events;
@end

@implementation NewsFeedTableViewController

@synthesize events=_events;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    NSLog(@"Home loaded");
    //custom tab bar
    
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
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    self.events = nil;
    self.tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
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
    NSString *eventType = event.eventType;
    if ([eventType isEqualToString:@"new poll"]) {
        static NSString *CellIdentifier = @"new poll cell";
        NewsFeedNewPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[NewsFeedNewPollCell alloc]
     initWithStyle:UITableViewCellStyleDefault 
     reuseIdentifier:CellIdentifier];
     }
        // Configure the cell...New poll event
        cell.userImage.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO];
        cell.userImage.url = [NSURL URLWithString:event.user.profilePhotoURL];
        [HJObjectManager manage:cell.userImage];
        
        
        [cell.usernameAndActionLabel updateNumberOfLabels:2];
        [cell.usernameAndActionLabel setText:event.user.username andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] forLabel:0];
        [cell.usernameAndActionLabel setText:@" created a new poll:" andFont:[UIFont fontWithName:@"Helvetica" size:14.0] forLabel:1];
        
        cell.eventDescriptionLabel.text = event.poll.title;
        [cell.eventDescriptionLabel sizeToFit];
        
        cell.timeStampLabel.text = [Utility formatTimeWithDate:event.timeStamp];
        
        cell.categoryIcon.image = [Utility iconForCategory:event.poll.category];
        [HJObjectManager manage:cell.categoryIcon];
        
        cell.usernameAndActionLabel.clipsToBounds = YES;

        /*cell.timeStampLabel.frame = TimeStampLabelFrame;
        cell.userImage.frame = UserImageFrame;
        cell.usernameAndActionLabel.frame = UsernameAndActionLabelFrame;
        cell.eventDescriptionLabel.frame = EventDescriptionLabelFrame;
        cell.categoryIcon.frame = CategoryIconFrame;*/
        return cell;
    }else if ([eventType isEqualToString:@"new item"]) {
        static NSString *CellIdentifier = @"new item cell";
        NewsFeedNewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsFeedNewItemCell alloc]
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...Add item event
        cell.userImage.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO];
        cell.userImage.url = [NSURL URLWithString:event.user.profilePhotoURL];
        [HJObjectManager manage:cell.userImage];
        
        cell.eventDescriptionLabel.text = event.poll.title;
        [cell.eventDescriptionLabel sizeToFit];
        
        [cell.itemImage clear];
        [cell.itemImage showLoadingWheel];
        cell.itemImage.url = [NSURL URLWithString:event.item.photoURL];
        [HJObjectManager manage:cell.itemImage];
        // In current version, photo uploading is limited to one picture at a time
        
        cell.timeStampLabel.text = [Utility formatTimeWithDate:event.timeStamp];
        
        cell.categoryIcon.image = [Utility iconForCategory:event.poll.category];
        [HJObjectManager manage:cell.categoryIcon];
        
        [cell.usernameAndActionLabel updateNumberOfLabels:2];
        [cell.usernameAndActionLabel setText:event.user.username andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] forLabel:0];
        [cell.usernameAndActionLabel setText:@" added a item to poll:" andFont:[UIFont fontWithName:@"Helvetica" size:14.0] forLabel:1];
        cell.usernameAndActionLabel.clipsToBounds = YES;
        

        /*cell.timeStampLabel.frame = TimeStampLabelFrame;
        cell.userImage.frame = UserImageFrame;
        cell.usernameAndActionLabel.frame = UsernameAndActionLabelFrame;
        cell.eventDescriptionLabel.frame = EventDescriptionLabelFrame;
        cell.categoryIcon.frame = CategoryIconFrame;
        cell.itemImage.frame = ItemImageFrame;*/
        return cell;
    }else /*if ([eventType isEqualToString:@"vote"]) */{
        static NSString *CellIdentifier = @"vote cell";
        NewsFeedVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
        if (cell == nil) {
            cell = [[NewsFeedVoteCell alloc]
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...Vote event
        cell.userImage.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO];
        cell.userImage.url = [NSURL URLWithString:event.user.profilePhotoURL];
        [HJObjectManager manage:cell.userImage];
        
        [cell.itemImage clear];
        cell.itemImage.loadingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [cell.itemImage showLoadingWheel];
        cell.itemImage.url = [NSURL URLWithString:event.item.photoURL];
        [HJObjectManager manage:cell.itemImage];
        
        cell.eventDescriptionLabel.text = event.poll.title;
        [cell.eventDescriptionLabel sizeToFit];
        
        cell.timeStampLabel.text = [Utility formatTimeWithDate:event.timeStamp];
        
        cell.categoryIcon.image = [Utility iconForCategory:event.poll.category];
        [HJObjectManager manage:cell.categoryIcon];
        
        [cell.usernameAndActionLabel updateNumberOfLabels:4];
        [cell.usernameAndActionLabel setText:event.user.username andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] forLabel:0];
        [cell.usernameAndActionLabel setText:@" voted for " andFont:[UIFont fontWithName:@"Helvetica" size:14.0] forLabel:1];
        [cell.usernameAndActionLabel setText:event.pollOwner.username andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] forLabel:2];
        [cell.usernameAndActionLabel setText:@"'s poll:" andFont:[UIFont fontWithName:@"Helvetica" size:14.0] forLabel:3];
        cell.usernameAndActionLabel.clipsToBounds = YES;
        

        /*cell.timeStampLabel.frame = TimeStampLabelFrame;
        cell.userImage.frame = UserImageFrame;
        cell.usernameAndActionLabel.frame = UsernameAndActionLabelFrame;
        cell.eventDescriptionLabel.frame = EventDescriptionLabelFrame;
        cell.categoryIcon.frame = CategoryIconFrame;
        cell.itemImage.frame = ItemImageFrame;*/
        return cell;
    }
    return nil;
}


//Set up cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.events objectAtIndex:indexPath.row];
    NSString *eventType = event.eventType;
    if ([eventType isEqualToString:@"new poll"]) {
        return HEIGHTOFNEWPOLLCELL;
    }else if ([eventType isEqualToString:@"new item"]){
     return HEIGHTOFNEWITEMCELL;
    }else if ([eventType isEqualToString:@"vote"]){
      return HEIGHTOFVOTECELL;
     }
    return HEIGHTOFNEWPOLLCELL;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
