//
//  PollTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PollTableViewController.h"
#define  POLLITEMCELLHEIGHT 350
#define  OPEN_POLL_BUTTON_TITLE @"Open poll"
#define  END_POLL_BUTTON_TITLE  @"End poll"
#define  FOLLOW_POLL_BUTTON_TITLE @"Follow poll"
#define  UNFOLLOW_POLL_BUTTON_TITLE @"Unfollow poll"
#define  DELETE_POLL_BUTTON_TITLE   @"Delete poll"
#define  SHOW_POLL_RESULT_BUTTON_TITLE @"Show poll result"

@interface PollTableViewController (){
    NSUInteger audienceIndex;
    BOOL isOwnerView;
    PollRecord *pollRecord;
    UIAlertView *openPollAlertView, *endPollAlertView, *deletePollAlertView;
}
@end

@implementation PollTableViewController
@synthesize poll=_poll;
@synthesize loadingWheel = _loadingWheel;
@synthesize addItemButton = _addItemButton;
@synthesize actionButton = _actionButton;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize followerCount = _followerCount;

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
    [super viewDidLoad];
    self.tableView.rowHeight = POLLITEMCELLHEIGHT;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setLoadingWheel:nil];
    [self setAddItemButton:nil];
    [self setActionButton:nil];
    [self setStartTimeLabel:nil];
    [self setFollowerCount:nil];
    [super viewDidUnload];
    self.poll = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.poll = [Poll new];
    self.poll.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - User Actions

- (IBAction)goHomePage:(UIBarButtonItem *)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

- (IBAction)showActionSheet:(id)sender {
    NSString *pollOperation;
    NSString *deleteButton;
    if (isOwnerView)
    {
        deleteButton = DELETE_POLL_BUTTON_TITLE;
        if ([self.poll.state isEqualToString:EDITING]){
            pollOperation = OPEN_POLL_BUTTON_TITLE;
        } else if([self.poll.state isEqualToString:VOTING]){
            pollOperation = END_POLL_BUTTON_TITLE;
        } else {
            pollOperation = nil;
        }
    }else{
        deleteButton = nil;
        if (audienceIndex == NSNotFound ){
            pollOperation = FOLLOW_POLL_BUTTON_TITLE;
        } else {
            pollOperation = UNFOLLOW_POLL_BUTTON_TITLE;
        }
    }
   UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:deleteButton otherButtonTitles:pollOperation, SHOW_POLL_RESULT_BUTTON_TITLE, nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showFromBarButtonItem:self.actionButton animated:YES];
	popupQuery = nil;
}

- (IBAction)addNewItem:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"add new item" sender:self];
}

- (IBAction)deleteItem:(UIButton *)sender {
    if([self.poll.state isEqualToString:EDITING]&&[[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.user.userID]){
        PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Item *item = [self.poll.items objectAtIndex:indexPath.row];
        [[RKObjectManager sharedManager] deleteObject:item delegate:self];
    }
}

- (IBAction)vote:(UIButton *)sender {
    if([self.poll.state isEqualToString:VOTING]&&![[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.user.userID]){
        if ([[self.poll.audiences objectAtIndex:audienceIndex] hasVoted]){
            [Utility showAlert:@"Sorry!" message:@"You cannot vote more than once in a poll."];
        }else {
            PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Item *item = [self.poll.items objectAtIndex:indexPath.row];
            item.numberOfVotes = [NSNumber numberWithInt:[item.numberOfVotes intValue]+ 1];
            if (item.numberOfVotes > self.poll.maxVotesForSingleItem){
                self.poll.maxVotesForSingleItem = item.numberOfVotes;
            }
            self.poll.totalVotes = [NSNumber numberWithInt:[self.poll.totalVotes intValue]+ 1];
            [[RKObjectManager sharedManager] putObject:item delegate:self];
            
            Audience *audience = [self.poll.audiences objectAtIndex:audienceIndex];
            audience.hasVoted=YES;
            [[RKObjectManager sharedManager] putObject:audience delegate:self];
            
            [Utility showAlert:@"Thank you!" message:@"We appreciate your vote."];
            [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
            
            Event *votingEvent = [Event new];
            votingEvent.eventType = VOTINGEVENT;
            votingEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
            votingEvent.pollID = self.poll.pollID;
            [[RKObjectManager sharedManager] postObject:votingEvent delegate:self];
            
        }
    }
}

#pragma mark - UIActionSheetDelegate Methods


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:OPEN_POLL_BUTTON_TITLE]){
        [self confirmToOpenPoll];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:END_POLL_BUTTON_TITLE]){
        [self confirmToEndPoll];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:FOLLOW_POLL_BUTTON_TITLE]){
        [self followPoll];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:UNFOLLOW_POLL_BUTTON_TITLE]){
        [self unfollowPoll];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:SHOW_POLL_RESULT_BUTTON_TITLE]){
        [self performSegueWithIdentifier:@"show poll result" sender:self];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:DELETE_POLL_BUTTON_TITLE]){
        [self confirmToDeletePoll];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]){
        [actionSheet resignFirstResponder];
    }

}

-(void)confirmToOpenPoll
{
    openPollAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to open this poll now?" message:@"Note: Once you open this poll, your friends can vote in your poll. But you can not edit your poll any more." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [openPollAlertView show];
    openPollAlertView = nil;
}

-(void)confirmToEndPoll
{
    endPollAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to end this poll now?" message:@"Note: Once you end this poll, your friends can't vote in your poll anymore." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [endPollAlertView show];
    endPollAlertView = nil;
}
-(void)confirmToDeletePoll
{
    deletePollAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to delete poll?" message:@"Note: Once you delete this poll, you will delete the items in this poll as well." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [deletePollAlertView show];
    deletePollAlertView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"A voting state change was cancelled.");
    }
    if (buttonIndex == 1) {
        if (alertView == openPollAlertView) {
            [self openPoll];
        }else if (alertView == endPollAlertView){
            [self endPoll];
        }
    }
}

- (void)openPoll
{
    self.poll.state = VOTING;
    [self.tableView reloadData];
    [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
}

- (void)endPoll
{
    self.poll.state = FINISHED;
    self.poll.endTime = [NSDate date];
    [self.tableView reloadData];
    [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
    pollRecord = [PollRecord new];
    pollRecord.pollID = self.poll.pollID;
    pollRecord.pollRecordType = PAST;
    [[RKObjectManager sharedManager] putObject:pollRecord delegate:self];
}

- (void)deletePoll
{
    NSLog(@"delete request sent");
    [[RKObjectManager sharedManager] deleteObject:self.poll delegate:self];
}

-(void)followPoll
{
    Audience *newAudience = [Audience new];
    newAudience.pollID = self.poll.pollID;
    [[RKObjectManager sharedManager] postObject:newAudience delegate:self];
    
    pollRecord = [PollRecord new];
    pollRecord.pollID = self.poll.pollID;
    pollRecord.pollRecordType = FOLLOWED;
    [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
}

-(void)unfollowPoll
{    
    Audience *currentAudience = [self.poll.audiences objectAtIndex:audienceIndex];
    [[RKObjectManager sharedManager] deleteObject:currentAudience delegate:self];
    
    pollRecord = [PollRecord new];
    pollRecord.pollID = self.poll.pollID;
    pollRecord.pollRecordType = FOLLOWED;
    [[RKObjectManager sharedManager] deleteObject:pollRecord delegate:self];
}

#pragma mark - RKObjectLoaderDelegate Methods

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    NSString *getPollPath = [NSString stringWithFormat:@"/polls/%@", self.poll.pollID];
    //NSString *audiencePath = [NSString stringWithFormat:@"/audiences/", self.poll.pollID];
    
    //Successfully loaded a poll
    if ([objectLoader wasSentToResourcePath:getPollPath method:RKRequestMethodGET]){
        [self.loadingWheel stopAnimating];
        self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
        isOwnerView = [[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.user.userID];
        //if the current user owns this poll
        if (isOwnerView){
            self.addItemButton.enabled = YES;
        }else{
            self.addItemButton.enabled = NO;
        }
        self.followerCount.text = [NSString stringWithFormat:@"%d", self.poll.audiences.count];
        self.startTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.poll.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        [self.startTimeLabel sizeToFit];
        [self.followerCount sizeToFit];
        self.title = self.poll.title;
        //find whether the current user is among the audience of the poll
        audienceIndex = [self.poll.audiences indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
                         {
                             if ([obj userID] == [Utility getObjectForKey:CURRENTUSERID]){
                                 *stop = YES;
                                 return YES;
                             }else return NO;
                         }];
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"Updating of this poll has been done");
    }else if (objectLoader.method == RKRequestMethodPOST){
        [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    }else if (objectLoader.method == RKRequestMethodDELETE){
        NSLog(@"Deleted successfully!");
        [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    }
    [self.tableView reloadData];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
    if ([error.localizedDescription isEqualToString:@"This poll does not exist any more."]){
    self.addItemButton.enabled = NO;
    self.actionButton.enabled = NO;
    }
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
    return self.poll.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"poll item cell";
    PollItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PollItemCell alloc]
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    cell.voteButton.hidden = isOwnerView || (![self.poll.state isEqualToString:VOTING]);
    cell.deleteButton.hidden = !(isOwnerView && [self.poll.state isEqualToString:EDITING]);
    Item *item = [self.poll.items objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.itemImage.url = [NSURL URLWithString:item.photoURL];
    [HJObjectManager manage:cell.itemImage];
    cell.descriptionOfItemLabel.text = item.description;
    cell.priceLabel.text = [Utility formatCurrencyWithNumber:item.price];
    cell.voteCountLabel.text = [item.numberOfVotes stringValue];
    [cell.descriptionOfItemLabel sizeToFit];
    [cell.priceLabel sizeToFit];
    [cell.voteCountLabel sizeToFit];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
