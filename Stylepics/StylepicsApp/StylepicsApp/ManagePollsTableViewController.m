//
//  ManagePollsTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ManagePollsTableViewController.h"
#define POLLCELLHEIGHT 46
#define ContentTypeEditingPoll 0
#define ContentTypeOpenedPoll 1
#define ContentTypeEndedPoll 2
#define ContentTypeVotedPoll 3

@interface ManagePollsTableViewController (){
    int ContentType;
}

@property (nonatomic, strong) NSMutableArray *editingPolls, *openedPolls, *endedPolls, *votedPolls;
@end

@implementation ManagePollsTableViewController
@synthesize userPhoto;
@synthesize usernameLabel;
@synthesize user = _user;
@synthesize editingPollCountLabel;
@synthesize openedPollCountLabel;
@synthesize endedPollCountLabel;
@synthesize votedPollCountLabel;

@synthesize editingPolls, openedPolls, endedPolls, votedPolls;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.userPhoto.backgroundColor =[UIColor colorWithWhite:1 alpha:0];
    self.userPhoto.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO_LARGE];
    if (_user.userID == nil)
    {
        _user = [User new];
        _user.userID = [Utility getObjectForKey: CURRENTUSERID];
        //self.navigationItem.rightBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:SETTINGS_BUTTON andHighlightedStateImage:SETTINGS_BUTTON_HL target:self action:@selector(showSettings)];
        
        //set UIBarButtonItem background image
        UIImage *settingButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
        UIImage *settingIconImage = [UIImage imageNamed:SETTINGS_BUTTON];
        UIImage *settingButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
        UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithImage:settingIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
        
        [settingButton  setBackgroundImage:settingButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [settingButton  setBackgroundImage:settingButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = settingButton;
       
        
    }else{
        self.navigationItem.title = @"Profile";
        //self.navigationItem.leftBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:BACK_BUTTON andHighlightedStateImage:BACK_BUTTON_HL target:self action:@selector(back)];
        
        //set UIBarButtonItem background image
        UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]; 
        UIImage *backIconImage = [UIImage imageNamed:BACK_BUTTON];
        UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL]; 
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backIconImage style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        
        [backButton  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [backButton  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
}

- (void)viewDidUnload
{
    [self setUserPhoto:nil];
    [self setUsernameLabel:nil];
    [self setEditingPollCountLabel:nil];
    [self setOpenedPollCountLabel:nil];
    [self setEndedPollCountLabel:nil];
    [self setVotedPollCountLabel:nil];
    [super viewDidUnload];
    _user = nil;
    self.editingPolls = nil;
    self.openedPolls = nil;
    self.endedPolls = nil;
    self.votedPolls = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"User profile's user ID: %@",  _user.userID);
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    self.editingPolls = [NSMutableArray new];
    self.votedPolls = [NSMutableArray new];
    self.openedPolls = [NSMutableArray new];
    self.endedPolls = [NSMutableArray new];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = NO;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/user_profile_poll_records/%@",_user.userID] delegate:self];
    [[RKObjectManager sharedManager] getObject:_user delegate:self];
}

#pragma User Actions

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
                switch ([pollRecord.pollRecordType intValue]) {
                    case EDITING_POLL:[self.editingPolls addObject:pollRecord];
                        break;
                    case OPENED_POLL:[self.openedPolls addObject:pollRecord];
                        break;
                    case ENDED_POLL:[self.endedPolls addObject:pollRecord];
                        break;
                    case VOTED_POLL:[self.votedPolls addObject:pollRecord];
                        break;
                }
            }
        }
        self.editingPollCountLabel.text = [NSString stringWithFormat:@"%d", editingPolls.count];
        self.openedPollCountLabel.text = [NSString stringWithFormat:@"%d", openedPolls.count];
        self.endedPollCountLabel.text = [NSString stringWithFormat:@"%d", endedPolls.count];
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

/*-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){
        case 0: return @"EDITING POLLS";
        case 1: return @"OPENED POLLS";
        case 2: return @"ENDED POLLS";
        case 3: return @"VOTED POLLS";
        default: return nil;
    }
}*/
/* to customize the font in headers, use the method below instead
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section*/

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
        case ContentTypeEndedPoll: {
            NSLog(@"ended polls' count: %u",self.endedPolls.count);
            return self.endedPolls.count;
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
        case ContentTypeEndedPoll:{
            static NSString *CellIdentifier = @"ended poll cell";
            EndedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EndedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.endedPolls.count){
                PollRecord *poll = [self.endedPolls objectAtIndex:indexPath.row];
                cell.pollDescriptionLabel.text = poll.title;
                cell.votesCountLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
                cell.endTimeLabel.text = [Utility formatTimeWithDate:poll.endTime];
                [cell.pollDescriptionLabel setNeedsLayout];
                [cell.endTimeLabel setNeedsLayout];
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
                cell.stateLabel.text = [Utility stringFromPollState:[poll.state intValue]];
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
    return POLLCELLHEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (ContentType) {
        case ContentTypeEditingPoll:{
            Poll* poll = [self.editingPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case ContentTypeOpenedPoll:{
            Poll* poll = [self.openedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case ContentTypeEndedPoll:{
            Poll* poll = [self.endedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        }
        case ContentTypeVotedPoll:{
            Poll* poll = [self.votedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        }
        default:
            break;
    }

    [self performSegueWithIdentifier:@"show poll" sender:self];

}


@end
