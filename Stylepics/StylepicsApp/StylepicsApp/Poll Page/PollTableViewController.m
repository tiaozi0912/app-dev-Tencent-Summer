//
//  PollTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PollTableViewController.h"
#define  POLLITEMCELLHEIGHT 350
@interface PollTableViewController (){
    NSUInteger audienceIndex;
    BOOL isOwnerView;
    PollRecord *pollRecord;
}
@end

@implementation PollTableViewController
@synthesize poll=_poll;
@synthesize loadingWheel = _loadingWheel;
@synthesize addItemButton = _addItemButton;
@synthesize actionButton = _actionButton;

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

- (IBAction)refresh:(UIBarButtonItem *)sender {
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    [self.loadingWheel startAnimating];
}

- (void)viewDidUnload
{
    [self setLoadingWheel:nil];
    [self setAddItemButton:nil];
    [self setActionButton:nil];
    [super viewDidUnload];
    self.poll = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.poll = [Poll new];
    self.poll.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (IBAction)showActionSheet:(id)sender {
    NSString *pollOperation;
    NSString *deleteButton;
    if (isOwnerView)
    {
        deleteButton = @"Delete this poll";
        if ([self.poll.state isEqualToString:EDITING]){
            pollOperation = @"Open Poll";
        } else if([self.poll.state isEqualToString:VOTING]){
            pollOperation = @"End Poll";
        } else {
            pollOperation = nil;
        }
    }else{
        deleteButton = nil;
        if (audienceIndex == NSNotFound ){
            pollOperation = @"Follow this poll";
        } else {
            pollOperation = @"Unfollow this poll";
        }
    }
   UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:deleteButton otherButtonTitles:pollOperation, @"Show Poll Result", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showFromBarButtonItem:self.actionButton animated:YES];
	popupQuery = nil;
}


#pragma mark - UIActionSheetDelegate Methods


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open Poll"]){
        self.poll.state = VOTING;
        [self.tableView reloadData];
        [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"End Poll"]){
        self.poll.state = FINISHED;
        self.poll.endTime = [NSDate date];
        [self.tableView reloadData];
        [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
        pollRecord = [PollRecord new];
        pollRecord.pollID = self.poll.pollID;
        pollRecord.pollRecordType = PAST;
        [[RKObjectManager sharedManager] putObject:pollRecord delegate:self];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Follow this poll"]){
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Unfollow this poll"]){
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Show Poll Result"]){
        [self performSegueWithIdentifier:@"show poll result" sender:self];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete this poll"]){
        NSLog(@"delete request sent");
        [[RKObjectManager sharedManager] deleteObject:self.poll delegate:self];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]){
        [actionSheet resignFirstResponder];
    }

}

- (void)askForConfirmationOfPollOperation
{
    if ([self.poll.state isEqualToString:EDITING]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to ask for votes now?" message:@"Note: Once you start to ask for votes, your friends can vote in your poll. But you can not edit your poll any more." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView show];
        alertView = nil;
    }else if ([self.poll.state isEqualToString:VOTING]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to end this poll now?" message:@"Note: Once you start to ask for votes, your friends can vote in your poll. But you can not edit your poll any more." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView show];
        alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"A voting state change was cancelled.");
    }
    if (buttonIndex == 1) {
        [self startOrEndVoting];
    }
}

- (void)startOrEndVoting
{
    if ([self.poll.state isEqualToString:EDITING]){

    }else if([self.poll.state isEqualToString:VOTING]){

    }
}

- (IBAction)addNewItem:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"add new item" sender:self];
}

- (IBAction)showPollResult:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"show poll result" sender:self];
}

- (IBAction)goHomePage:(UIBarButtonItem *)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (IBAction)deleteItem:(UIButton *)sender {
    if([self.poll.state isEqualToString:EDITING]&&[[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.user.userID]){
        PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Item *item = [self.poll.items objectAtIndex:indexPath.row];
        [[RKObjectManager sharedManager] deleteObject:item delegate:self];
    }
}

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
        self.title = self.poll.title;
        //find whether the current user is among the audience of the poll
        audienceIndex = [self.poll.audiences indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
                         {
                             if ([obj userID] == [Utility getObjectForKey:CURRENTUSERID]){
                                 *stop = YES;
                                 return YES;
                             }else return NO;
                         }];
        //if the current user owns this poll
     /*   if (isOwnerView){
            self.addItemButton.enabled = YES;
        }else{
            self.addItemButton.enabled = NO;
            //if the current user is a new audience of this poll
            if  (audienceIndex == NSNotFound){
                Audience *newAudience = [Audience new];
                newAudience.userID = [Utility getObjectForKey:CURRENTUSERID];
                newAudience.pollID = self.poll.pollID;
                [[RKObjectManager sharedManager] postObject:newAudience delegate:self];
                pollRecord = [PollRecord new];
                pollRecord.pollID = self.poll.pollID;
                pollRecord.pollRecordType = FOLLOWED;
                [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
            }
        }*/
    }else if ([objectLoader wasSentToResourcePath:@"/audiences" method: RKRequestMethodPOST]) {
        NSLog(@"User[%@] has become one of the audience of this poll now.",[Utility getObjectForKey:CURRENTUSERID]);
        [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    }else if ([objectLoader wasSentToResourcePath:@"/poll_list_items" method: RKRequestMethodPOST]) {
        NSLog(@"User[%@] has become one of the audience of this poll now.",[Utility getObjectForKey:CURRENTUSERID]);
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"Updating of this poll has been done");
    }else if (objectLoader.method == RKRequestMethodDELETE){
        [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
        [Utility showAlert:@"Deleted!" message:@"One item has been removed from this poll."];
    }
    [self.tableView reloadData];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
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
    [cell.descriptionOfItemLabel sizeToFit];
    [cell.priceLabel sizeToFit];
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
