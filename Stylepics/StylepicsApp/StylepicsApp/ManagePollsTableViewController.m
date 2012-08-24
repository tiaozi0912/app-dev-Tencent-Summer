//
//  ManagePollsTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ManagePollsTableViewController.h"
#define POLLCELLHEIGHT 46

@interface ManagePollsTableViewController ()
{
    User* user;
}

@property (nonatomic, strong) NSMutableArray *editingPolls, *openedPolls, *endedPolls, *votedPolls;
@end

@implementation ManagePollsTableViewController
@synthesize userPhoto;
@synthesize usernameLabel;

@synthesize editingPolls, openedPolls, endedPolls, votedPolls;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    self.userPhoto.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO];
    self.navigationItem.leftBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:SETTINGS_BUTTON andHighlightedStateImage:SETTINGS_BUTTON_HL target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItem = [Utility createSquareBarButtonItemWithNormalStateImage:NEW_POLL_BUTTON andHighlightedStateImage:NEW_POLL_BUTTON_HL target:self action:@selector(newPoll)];
}

- (void)viewDidUnload
{
    [self setUserPhoto:nil];
    [self setUsernameLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    self.editingPolls = [NSMutableArray new];
    self.votedPolls = [NSMutableArray new];
    self.openedPolls = [NSMutableArray new];
    self.endedPolls = [NSMutableArray new];
    
    user = [User new];
    user.userID = [Utility getObjectForKey:CURRENTUSERID];
    [[RKObjectManager sharedManager] getObject:user delegate:self];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/poll_records" delegate:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = NO;
}

#pragma User Actions
-(void)newPoll
{
    [self performSegueWithIdentifier:@"new poll" sender:self];
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"settings" sender:self];
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
    if ([objectLoader wasSentToResourcePath:@"/poll_records"])
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
                        break;
                }
            }
        }
    }else{
        self.usernameLabel.text = user.username;
        self.userPhoto.url = [NSURL URLWithString:user.profilePhotoURL];
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
    return 3;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){ 
        case 0: return @"EDITING POLLS";
        case 1: return @"OPENED POLLS";
        case 2: return @"ENDED POLLS";
        case 3: return @"VOTED POLLS";
        default: return nil;
    }
}/* to customize the font in headers, use the method below instead
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            NSLog(@"editingPolls' count: %u",self.editingPolls.count);
            return self.editingPolls.count;
        }
        case 1: {
            NSLog(@"opened polls' count: %u",self.openedPolls.count);
            return self.openedPolls.count;
        }
        case 2: {
            NSLog(@"ended polls' count: %u",self.endedPolls.count);
            return self.endedPolls.count;
        }
        case 3:{
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
    switch (indexPath.section) {

        case 0:{
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
        case 1:{
            static NSString *CellIdentifier = @"opened poll cell";
            OpenedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[OpenedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.openedPolls.count){
                PollRecord *poll = [self.votedPolls objectAtIndex:indexPath.row];
                cell.pollDescriptionLabel.text = poll.title;
                cell.votesCountLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
                cell.openTimeLabel.text = [Utility formatTimeWithDate:poll.openTime];
                [cell.pollDescriptionLabel setNeedsLayout];
                [cell.openTimeLabel setNeedsLayout];
            }
            return cell;
        } 
        case 2:{
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
        case 3:{
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
    switch (indexPath.section) {
        case 0:{
            Poll* poll = [self.editingPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case 1:{
            Poll* poll = [self.openedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case 2:{
            Poll* poll = [self.endedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        }
        case 3:{
            Poll* poll = [self.votedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        }
        default:
            break;
    }

    [self performSegueWithIdentifier:@"show poll" sender:self];

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
    }

}
@end
