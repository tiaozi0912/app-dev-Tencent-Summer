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

#define ROWHEIGHT 369

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
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_WITH_LOGO] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
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
    // Configure the cell...Add item event
    cell.userImage.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO];
    cell.userImage.url = [NSURL URLWithString:event.user.profilePhotoURL];
    [HJObjectManager manage:cell.userImage];
    
    [cell.thumbnail clear];
    [cell.thumbnail showLoadingWheel];
    for (int tag = 0; )
    cell.thumbnail.url = [NSURL URLWithString:event.poll.items.photoURL];
    [HJObjectManager manage:cell.thumbnail];
    // In current version, photo uploading is limited to one picture at a time
    
    cell.timeStampLabel.text = [Utility formatTimeWithDate:event.timeStamp];
    
    cell.categoryIcon.image = [Utility iconForCategory:(PollCategory)[event.poll.category intValue]];
    [HJObjectManager manage:cell.categoryIcon];
    
    [cell.usernameAndActionLabel updateNumberOfLabels:2];
    [cell.usernameAndActionLabel setText:event.user.username andFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0] forLabel:0];
    [cell.usernameAndActionLabel setText:@"started a poll:" andFont:[UIFont fontWithName:@"Helvetica" size:14.0] forLabel:1];
    cell.usernameAndActionLabel.clipsToBounds = YES;
    
    cell.eventDescriptionLabel.text = event.poll.title;
    cell.eventDescriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    [cell.eventDescriptionLabel sizeToFit];
    
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

@end
