//
//  ProfileTableViewController.m
//  MuseMe
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ProfileTableViewController.h"
#define EDITING_POLL_CELL_HEIGHT 65
#define OPENED_POLL_CELL_HEIGHT 65
#define VOTED_POLL_CELL_HEIGHT 65
#define ContentTypeEditingPoll 0
#define ContentTypeOpenedPoll 1
#define ContentTypeVotedPoll 2

@interface ProfileTableViewController (){
    int ContentType;
    BOOL isOwnProfile;
}

@property (nonatomic, strong) NSMutableArray *editingPolls, *openedPolls, *votedPolls;
@end

@implementation ProfileTableViewController
@synthesize userPhoto;
@synthesize usernameLabel;
@synthesize user = _user;
@synthesize editingPollCountLabel;
@synthesize openedPollCountLabel;
@synthesize votedPollCountLabel;
@synthesize editingPollButton;
@synthesize activePollButton;
@synthesize votedPollButton;

@synthesize editingPolls, openedPolls, votedPolls;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.userPhoto.backgroundColor =[UIColor colorWithWhite:1 alpha:0];
    self.userPhoto.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO_LARGE];
    [Utility renderView:self.userPhoto withCornerRadius:SMALL_CORNER_RADIUS andBorderWidth:SMALL_BORDER_WIDTH];
    if (_user.userID == nil)
    {
        isOwnProfile = YES;
        _user = [User new];
        _user.userID = [Utility getObjectForKey: CURRENTUSERID];
        
        //set UIBarButtonItem background image
        UIImage *settingButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
        UIImage *settingIconImage = [UIImage imageNamed:SETTINGS_BUTTON];
        //UIImage *settingButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
        UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithImage:settingIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
        
        [settingButton  setBackgroundImage:settingButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        //[settingButton  setBackgroundImage:settingButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = settingButton;
       
        
    }else{
        isOwnProfile = NO;
        self.navigationItem.title = @"Profile";
    
        //set UIBarButtonItem background image
        UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
        UIImage *backIconImage = [UIImage imageNamed:BACK_BUTTON];
        //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        
        [backButton  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        //[backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
}

- (void)viewDidUnload
{
    [self setUserPhoto:nil];
    [self setUsernameLabel:nil];
    [self setEditingPollCountLabel:nil];
    [self setOpenedPollCountLabel:nil];
    [self setVotedPollCountLabel:nil];
    [self setEditingPollButton:nil];
    [self setActivePollButton:nil];
    [self setVotedPollButton:nil];
    [super viewDidUnload];
    _user = nil;
    self.editingPolls = nil;
    self.openedPolls = nil;
    self.votedPolls = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_WITH_LOGO] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    self.editingPolls = [NSMutableArray new];
    self.votedPolls = [NSMutableArray new];
    self.openedPolls = [NSMutableArray new];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = NO;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/user_profile_poll_records/%@",_user.userID] delegate:self];
    [[RKObjectManager sharedManager] getObject:_user delegate:self];
}

#pragma User Actions
- (IBAction)changeProfile:(id)sender {
    [self showSettings];
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"settings" sender:self];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchContentType:(UIButton *)sender {
    ContentType = sender.tag;
    [sender setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON_HL] forState:UIControlStateNormal];
    switch (ContentType) {
        case ContentTypeEditingPoll: {
            [self.activePollButton setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON] forState:UIControlStateNormal];
            [self.votedPollButton setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON] forState:UIControlStateNormal];
            break;
        }
        case ContentTypeOpenedPoll: {
            [self.editingPollButton setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON] forState:UIControlStateNormal];
            [self.votedPollButton setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON] forState:UIControlStateNormal];
            break;
        }
        case ContentTypeVotedPoll:{
            [self.editingPollButton setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON] forState:UIControlStateNormal];
            [self.activePollButton setImage:[UIImage imageNamed:PROFILE_TAB_CONTROL_BUTTON] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
}


- (void) dealloc
{
    [[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
}

#pragma RKObjectLoader Delegate Method

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    if ([objectLoader.resourcePath hasPrefix:@"/user_profile_poll_records"])
    {
        NSArray *pollRecords = objects;
        for (id obj in pollRecords){
            if ([obj isKindOfClass:[PollRecord class]]){
                PollRecord* pollRecord = (PollRecord*) obj;
                NSLog(@"%@", pollRecord.pollRecordType);
                switch ([pollRecord.pollRecordType intValue]) {
                    case EDITING_POLL:[self.editingPolls addObject:pollRecord];
                        break;
                    case OPENED_POLL:[self.openedPolls addObject:pollRecord];
                        break;
                    case VOTED_POLL:[self.votedPolls addObject:pollRecord];
                        break;
                }
            }
        }
        self.editingPollCountLabel.text = [NSString stringWithFormat:@"%d", editingPolls.count];
        self.openedPollCountLabel.text = [NSString stringWithFormat:@"%d", openedPolls.count];
        self.votedPollCountLabel.text = [NSString stringWithFormat:@"%d", votedPolls.count];
    }else{
        self.usernameLabel.text = _user.username;
        self.userPhoto.url = [NSURL URLWithString:_user.profilePhotoURL];
        [HJObjectManager manage:self.userPhoto];
    }
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{    
    [Utility showAlert:@"Error!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 4;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (ContentType) {
        case ContentTypeEditingPoll: {
            NSLog(@"editingPolls' count: %u",self.editingPolls.count);
            return self.editingPolls.count;
        }
        case ContentTypeOpenedPoll: {
            NSLog(@"opened polls' count: %u",self.openedPolls.count);
            return self.openedPolls.count;
        }
        case ContentTypeVotedPoll:{
            NSLog(@"voted polls' count: %u",self.votedPolls.count);
            return self.votedPolls.count;
        }
        default:return 0;
            break;
    }// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if (![NSThread isMainThread])
    {
        return [self performSelector:@selector(tableView: cellForRowAtIndexPath:) withObject:tableView withObject:indexPath];
       
    }*/
    switch (ContentType) {

        case ContentTypeEditingPoll:{
            static NSString *CellIdentifier = @"editing poll cell";
            EditingPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EditingPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.editingPolls.count){
                PollRecord* poll = [self.editingPolls objectAtIndex:indexPath.row];
                cell.pollDescriptionLabel.text = poll.title;
                cell.itemCountLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.itemsCount];
                cell.startTimeLabel.text = [Utility formatTimeWithDate:poll.startTime];
                [cell.pollDescriptionLabel setNeedsLayout];
                [cell.startTimeLabel setNeedsLayout];
            }
            if (isOwnProfile) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            return cell;
        } 
        case ContentTypeOpenedPoll:{
            static NSString *CellIdentifier = @"opened poll cell";
            OpenedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[OpenedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.openedPolls.count){
                PollRecord *poll = [self.openedPolls objectAtIndex:indexPath.row];
                cell.pollDescriptionLabel.text = poll.title;
                cell.votesCountLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
                cell.openTimeLabel.text = [Utility formatTimeWithDate:poll.openTime];
                [cell.pollDescriptionLabel setNeedsLayout];
                [cell.openTimeLabel setNeedsLayout];
            }
            return cell;
        }
        case ContentTypeVotedPoll:{
            static NSString *CellIdentifier = @"voted poll cell";
            VotedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[VotedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.votedPolls.count){
                PollRecord *poll = [self.votedPolls objectAtIndex:indexPath.row];
                cell.pollDescriptionLabel.text = poll.title;
                cell.votesCountLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
                cell.username.text = poll.owner.username;
                [Utility renderView:cell.userPhoto withCornerRadius:SMALL_CORNER_RADIUS andBorderWidth:SMALL_BORDER_WIDTH];
                cell.userPhoto.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO_SMALL];
                cell.userPhoto.url = [NSURL URLWithString:poll.owner.profilePhotoURL];
                [HJObjectManager manage:cell.userPhoto];
                [cell.pollDescriptionLabel setNeedsLayout];
            }
            return cell;
        }
    }
    // Configure the cell...
    return nil;
}

//Set up cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (ContentType) {
        case ContentTypeEditingPoll: {
            return EDITING_POLL_CELL_HEIGHT;
        }
        case ContentTypeOpenedPoll: {
            return OPENED_POLL_CELL_HEIGHT;
        }
        case ContentTypeVotedPoll:{
            return VOTED_POLL_CELL_HEIGHT;
        }
        default:return 0;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (ContentType) {
        case ContentTypeEditingPoll:{
            if (indexPath.row < self.editingPolls.count){
            Poll* poll = [self.editingPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            }
            break;
        }
        case ContentTypeOpenedPoll:{
            if (indexPath.row < self.openedPolls.count){
            Poll* poll = [self.openedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            }
            break;
        }
        case ContentTypeVotedPoll:{
            if (indexPath.row < self.votedPolls.count){
            Poll* poll = [self.votedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            }
            break;
        }
        default:
            break;
    }
    if (!(ContentType == ContentTypeEditingPoll && !isOwnProfile)){
    [self performSegueWithIdentifier:@"show poll" sender:self];
    }

}


@end
