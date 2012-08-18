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

#define OpenPollAlertView 1
#define EndPollAlertView 2
#define DeletePollAlertView 3
@interface PollTableViewController (){
    NSUInteger audienceIndex;
    BOOL isOwnerView;
    PollRecord *pollRecord;
    SingleItemViewOption singleItemViewOption;
    Item *itemToBeShown;
    NSNumber *isLoadedBefore;
    HintView *emptyPollHint, *emptyPollHintInAudienceView, *addItemHint;
}
@end

@implementation PollTableViewController
@synthesize poll=_poll;
@synthesize loadingWheel = _loadingWheel;
@synthesize addItemButton = _addItemButton;
@synthesize actionButton = _actionButton;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize followerCount = _followerCount;
@synthesize stateIndicator = _stateIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = POLLITEMCELLHEIGHT;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    CGRect frameOfEmptyPollHint = CGRectMake(20, 150, 280, 60);

    CGRect frameOfAddItemHint = CGRectMake(115 , 335, 200, 30);
    
    CGRect frameOfEmptyPollHintInAudienceView = CGRectMake(20, 60, 280, 60);
    
    
    emptyPollHint = [HintView new];
    emptyPollHint = [emptyPollHint initWithFrame:frameOfEmptyPollHint];
    emptyPollHint.label.text = @"This poll is empty. You can add more items to stuff this poll.";
    emptyPollHint.label.numberOfLines = 2;
    emptyPollHint.hidden = YES;
   
    addItemHint = [HintView new];
    addItemHint = [addItemHint initWithFrame:frameOfAddItemHint];
    addItemHint.label.text = @"Add items from this plus button";
    addItemHint.label.numberOfLines = 1;
    addItemHint.hidden = YES;
    
    emptyPollHintInAudienceView = [HintView new];
    emptyPollHintInAudienceView = [emptyPollHintInAudienceView initWithFrame:frameOfEmptyPollHintInAudienceView];
    emptyPollHintInAudienceView.label.text = @"This poll is empty. You can add more items to stuff this poll.";
    emptyPollHintInAudienceView.label.numberOfLines = 2;
    emptyPollHintInAudienceView.hidden = YES;

    [self.view addSubview:emptyPollHint];
    [self.view addSubview:addItemHint];
    [self.view addSubview:emptyPollHintInAudienceView];
    self.clearsSelectionOnViewWillAppear = NO;
 
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
    pollRecord = nil;
    itemToBeShown = nil;
    isLoadedBefore = nil;
    emptyPollHint = nil;
    addItemHint = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.poll = [Poll new];
    self.poll.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    dispatch_queue_t loadingQueue = dispatch_queue_create("loading queue", NULL);
    dispatch_async(loadingQueue, ^{
        [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    });
    dispatch_release(loadingQueue);


   // [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
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
        Audience *currentUser = [self.poll.audiences objectAtIndex:audienceIndex];
        NSLog(@"audience userID = %@",currentUser.userID);
        if (![currentUser.isFollowing boolValue]){
            pollOperation = FOLLOW_POLL_BUTTON_TITLE;
        } else {
            pollOperation = UNFOLLOW_POLL_BUTTON_TITLE;
        }
    }
   UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:deleteButton otherButtonTitles: SHOW_POLL_RESULT_BUTTON_TITLE, pollOperation, nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showFromBarButtonItem:self.actionButton animated:YES];
	popupQuery = nil;
}

- (IBAction)addNewItem:(UIBarButtonItem *)sender {
    singleItemViewOption = SingleItemViewOptionNew;
    [self performSegueWithIdentifier:@"show single item view" sender:self];
}

- (IBAction)deleteItem:(UIButton *)sender {
    if([self.poll.state isEqualToString:EDITING]&&[[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.user.userID]){
        PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Item *item = [self.poll.items objectAtIndex:indexPath.row];
        [[RKObjectManager sharedManager] deleteObject:item delegate:self];
    }
}

- (IBAction)vote:(UIButton *)sender
{
    PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Item *item = [self.poll.items objectAtIndex:indexPath.row];
    Audience *audience = [self.poll.audiences objectAtIndex:audienceIndex];
    
    if ([[[self.poll.audiences objectAtIndex:audienceIndex] hasVoted] boolValue]){
        // if the current user has voted for an item in this poll, then undo the voting
        self.poll.totalVotes = [NSNumber numberWithInt:[self.poll.totalVotes intValue] - 1];
        [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
        
        item.numberOfVotes = [NSNumber numberWithInt:[item.numberOfVotes intValue] - 1];
        [[RKObjectManager sharedManager] putObject:item delegate:self];
        
        audience.hasVoted= [NSNumber numberWithInt:0];
        [[RKObjectManager sharedManager] putObject:audience delegate:self];
        
    }else {
        //if the current user has not voted for an item in this poll, then vote for this item
        item.numberOfVotes = [NSNumber numberWithInt:[item.numberOfVotes intValue]+ 1];
        [[RKObjectManager sharedManager] putObject:item delegate:self];
        
        audience.hasVoted=item.itemID;
        [[RKObjectManager sharedManager] putObject:audience delegate:self];
        
        //[Utility showAlert:@"Thank you!" message:@"We appreciate your vote."];
        self.poll.totalVotes = [NSNumber numberWithInt:[self.poll.totalVotes intValue]+ 1];
        [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
        
        Event *votingEvent = [Event new];
        votingEvent.eventType = VOTINGEVENT;
        votingEvent.userID = [Utility getObjectForKey:CURRENTUSERID];
        votingEvent.pollID = self.poll.pollID;
        [[RKObjectManager sharedManager] postObject:votingEvent delegate:self];
        
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
    UIAlertView *openPollAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to open this poll now?" message:@"Note: Once you open this poll, your friends can vote in your poll. But you can not edit your poll any more." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    openPollAlertView.tag = OpenPollAlertView;
    [openPollAlertView show];
    openPollAlertView = nil;
}

-(void)confirmToEndPoll
{
    UIAlertView *endPollAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to end this poll now?" message:@"Note: Once you end this poll, your friends can't vote in your poll anymore." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    endPollAlertView.tag = EndPollAlertView;
    [endPollAlertView show];
    endPollAlertView = nil;
}
-(void)confirmToDeletePoll
{
    UIAlertView *deletePollAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to delete this poll?" message:@"Note: Once you delete this poll, you will delete the items in this poll as well." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [deletePollAlertView show];
    deletePollAlertView.tag = DeletePollAlertView;
    deletePollAlertView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"A voting state change was cancelled.");
    }
    if (buttonIndex == 1) {
        if (alertView.tag == OpenPollAlertView) {
            [self openPoll];
        }else if (alertView.tag == EndPollAlertView){
            [self endPoll];
        }else if (alertView.tag == DeletePollAlertView){
            [self deletePoll];
        }
    }
}

- (void)openPoll
{
    self.poll.state = VOTING;
    [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
    [self.tableView reloadData];
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
    
    pollRecord = [PollRecord new];
    pollRecord.pollID = self.poll.pollID;
    [[RKObjectManager sharedManager] deleteObject:pollRecord delegate:self];
    [self goHomePage:nil];
}

-(void)followPoll
{
    Audience *currentAudience = [self.poll.audiences objectAtIndex:audienceIndex];
    currentAudience.isFollowing = [NSNumber numberWithBool:YES];
    [[RKObjectManager sharedManager] putObject:currentAudience delegate:self];
    
    pollRecord = [PollRecord new];
    pollRecord.pollID = self.poll.pollID;
    pollRecord.pollRecordType = FOLLOWED;
    [[RKObjectManager sharedManager] postObject:pollRecord delegate:self];
}

-(void)unfollowPoll
{    
    Audience *currentAudience = [self.poll.audiences objectAtIndex:audienceIndex];
    currentAudience.isFollowing = [NSNumber numberWithBool:NO];
    [[RKObjectManager sharedManager] putObject:currentAudience delegate:self];
    
    pollRecord = [PollRecord new];
    pollRecord.pollID = self.poll.pollID;
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

        self.title = self.poll.title;
        self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
        isOwnerView = [[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.user.userID];
        
        //
        if (self.poll.items.count == 0){
            if (isOwnerView) {
                addItemHint.hidden = NO;
                emptyPollHint.hidden = NO;
            }else {
                emptyPollHintInAudienceView.hidden = NO;
            }
        }else {
            addItemHint.hidden = YES;
            emptyPollHint.hidden = YES;
            emptyPollHintInAudienceView.hidden = YES;
        }
        
        
        //if the current user owns this poll
        if (isOwnerView){
            //self.addItemButton.enabled = (self.poll.state == EDITING);
            self.navigationController.toolbarHidden = !([self.poll.state isEqualToString:EDITING]);
            if ([self.poll.state isEqualToString:EDITING]){
                self.stateIndicator.text = @"Poll State: Editing \nYou can add and edit items in the poll.";
            }else if ([self.poll.state isEqualToString:VOTING]){
                self.stateIndicator.text = @"Poll State: Voting \nPlease wait for your friends' votes until you want to end this poll.";
            }else {
                self.stateIndicator.text = @"Poll State: Finished \nThis poll is ended. You can check the result by clicking the action button in the top right corner.";
            }
        }else{
            self.navigationController.toolbarHidden = YES;
            //NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
           // [toolbarItems removeObject:self.addItemButton];
            //self.toolbarItems = [toolbarItems copy];
            if ([self.poll.state isEqualToString:EDITING]){
                self.stateIndicator.text = @"Poll State: Editing \nThis is being edited. You can track this poll by following it.";
            }else if ([self.poll.state isEqualToString:VOTING]){
                self.stateIndicator.text = @"Poll State: Voting \nPlease vote on the item in the poll by clicking the checkbox in the picture. You can also undo the vote by clicking on the checked checkbox.";    
            }else {
                self.stateIndicator.text = @"Poll State: Finished \nThis poll is ended. You can check the result by clicking the action button in the top right corner.";    
            }
        }
        self.followerCount.text = [NSString stringWithFormat:@"%@", self.poll.followerCount];
        self.startTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.poll.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        [self.startTimeLabel sizeToFit];
        [self.followerCount sizeToFit];

        //find whether the current user is among the audience of the poll
        audienceIndex = [self.poll.audiences indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
                         {
                             if ([obj userID] == [Utility getObjectForKey:CURRENTUSERID]){
                                 *stop = YES;
                                 return YES;
                             }else return NO;
                         }];
        NSLog(@"audience index  = %u", audienceIndex);
        if ((!isOwnerView) && (audienceIndex == NSNotFound))
        {
            Audience *newAudience = [Audience new];
            newAudience.pollID = self.poll.pollID;
            newAudience.isFollowing = [NSNumber numberWithBool:NO];
            [[RKObjectManager sharedManager] postObject:newAudience delegate:self];
        }
    }else if (objectLoader.method == RKRequestMethodPUT){
        NSLog(@"Updating of this poll has been done");
        [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
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
    if (objectLoader.method == RKRequestMethodGET){
    [Utility showAlert:@"Sorry!" message:error.localizedDescription];
    }
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
    Audience *currentUser = (audienceIndex == NSNotFound? nil:[self.poll.audiences objectAtIndex:audienceIndex]);
    Item *item = [self.poll.items objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.voteButton.hidden = YES;
    // if the current user has voted for the item
    if ([currentUser.hasVoted isEqualToNumber:item.itemID]){
        cell.voteButton.hidden = NO;
        [cell.voteButton setBackgroundImage:[UIImage imageNamed:@"vote icon.png"] forState:UIControlStateNormal];
    }
    if ((!isOwnerView) && ([self.poll.state isEqualToString:VOTING]) && ([currentUser.hasVoted intValue] == 0)){
        cell.voteButton.hidden = NO;
        [cell.voteButton setBackgroundImage:[UIImage imageNamed:@"empty vote icon.png"] forState:UIControlStateNormal];
    }
    cell.deleteButton.hidden = !(isOwnerView && [self.poll.state isEqualToString:EDITING]);
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


/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    itemToBeShown = [self.poll.items objectAtIndex:indexPath.row];
    if ((isOwnerView)&&([self.poll.state isEqualToString:EDITING])){
        singleItemViewOption = SingleItemViewOptionEdit;
    }else{
        singleItemViewOption = SingleItemViewOptionView;
    }
    [self performSegueWithIdentifier:@"show single item view" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"show single item view"]){
        SingleItemViewController* nextViewController = (SingleItemViewController*) segue.destinationViewController;
        nextViewController.singleItemViewOption = singleItemViewOption;
        if (!singleItemViewOption == SingleItemViewOptionNew){
            nextViewController.item = itemToBeShown;
        }
    }
}
@end
