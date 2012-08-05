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
   // StylepicsDatabase *database;
    NSUInteger audienceIndex;
}
@end

@implementation PollTableViewController
@synthesize poll=_poll;

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
    self.navigationController.toolbarHidden = YES;
    self.tableView.rowHeight = POLLITEMCELLHEIGHT;
    self.poll = [Poll new];
    self.poll.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.poll = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)startOrEndVoting:(UIBarButtonItem *)sender {
    if ([self.poll.state isEqualToString:EDITING]){
        self.poll.state = VOTING;
        [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
        [[self.toolbarItems objectAtIndex:0]setEnabled:NO];
        [[self.toolbarItems objectAtIndex:2] setTitle:@"End Voting"];
        [[self.toolbarItems objectAtIndex:3]setEnabled:YES];
    }else if([self.poll.state isEqualToString:VOTING]){
        self.poll.state = FINISHED;
        self.poll.endTime = [NSDate date];
        [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
        PollListItem *pollListItem = [PollListItem new];
        pollListItem.pollID = self.poll.pollID;
        pollListItem.userID = self.poll.owner.userID;
        pollListItem.type = PAST;
        [[RKObjectManager sharedManager] putObject:pollListItem delegate:self];
        [[self.toolbarItems objectAtIndex:2] setTitle:@"Finished"];
        [[self.toolbarItems objectAtIndex:2] setEnabled:NO];
    }
}

- (IBAction)addNewItem:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"add new item" sender:self];
}

- (IBAction)showPollResult:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"show poll result" sender:self];
}

- (IBAction)goHomePage:(UIBarButtonItem *)sender {
    if ([[Utility getObjectForKey:NEWUSER] isEqualToString:@"TRUE"]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)vote:(UIButton *)sender {
    if([self.poll.state isEqualToString:VOTING]&&![[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.ownerID]){
        if ([[self.poll.audience objectAtIndex:audienceIndex] hasVoted]){
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
            [[self.poll.audience objectAtIndex:audienceIndex] setHasVoted:YES];
            [Utility showAlert:@"Thank you!" message:@"We appreciate your vote."];
            [[RKObjectManager sharedManager] putObject:self.poll delegate:self];
            
            Event *votingEvent = [Event new];
            votingEvent.type = VOTINGEVENT;
            votingEvent.user.userID = [Utility getObjectForKey:CURRENTUSERID];
            votingEvent.poll = self.poll;
            [[RKObjectManager sharedManager] postObject:votingEvent delegate:self];
            
        }
    }
}

- (IBAction)deleteItem:(UIButton *)sender {
    if([self.poll.state isEqualToString:EDITING]&&[[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.ownerID]){
        PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Item *item = [self.poll.items objectAtIndex:indexPath.row];
        [[RKObjectManager sharedManager] deleteObject:item delegate:self];
        [Utility showAlert:@"Removed successfully!" message:@"This item has been removed from the poll."];
        [self.tableView reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.poll.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    UIImage *navigationBarBackground =[[UIImage imageNamed:@"Custom-Tool-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault]; 
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UIImage *navigationBarBackground =[[UIImage imageNamed:@"Custom-Nav-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];

}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    //NSString *getPollPath = [NSString stringWithFormat:@"/poll/%@/audience", self.poll.pollID];
    //NSString *audiencePath = [NSString stringWithFormat:@"/poll/%@/audience", self.poll.pollID];
    
    //Successfully loaded a poll
    if ([objectLoader wasSentToResourcePath:@"/polls/:pollID"]){
        self.title = self.poll.title;
        //find whether the current user is among the audience of the poll
        audienceIndex = [self.poll.audience indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
                         {
                             if ([obj userID] == [Utility getObjectForKey:CURRENTUSERID]){
                                 *stop = YES;
                                 return YES;
                             }else return NO;
                         }];
        //if the current user owns this poll
        if ([[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.ownerID]){
            self.navigationController.toolbarHidden = NO;
            if ([self.poll.state isEqualToString:EDITING]){
                [[self.toolbarItems objectAtIndex:0]setEnabled:YES];
                [[self.toolbarItems objectAtIndex:2]setTitle:@"Start Voting"];
                [[self.toolbarItems objectAtIndex:3]setEnabled:YES];
            } else if([self.poll.state isEqualToString:VOTING]){
                [[self.toolbarItems objectAtIndex:0]setEnabled:NO];
                [[self.toolbarItems objectAtIndex:2]setTitle:@"End Voting"];
                [[self.toolbarItems objectAtIndex:3]setEnabled:YES];
            } else {
                [[self.toolbarItems objectAtIndex:0]setEnabled:NO];
                [[self.toolbarItems objectAtIndex:2]setTitle:@"Finished"];
                [[self.toolbarItems objectAtIndex:2]setEnabled:NO];
                [[self.toolbarItems objectAtIndex:3]setEnabled:YES];
            }
        }else{
            //if the current user is a new audience of this poll
            if  (audienceIndex == NSNotFound){
                Audience *newAudience = [Audience new];
                newAudience.userID = [Utility getObjectForKey:CURRENTUSERID];
                [[RKObjectManager sharedManager] postObject:newAudience delegate:self];
                PollListItem *followedPoll = [PollListItem new];
                followedPoll.pollID = self.poll.pollID;
                followedPoll.type = FOLLOWED;
                followedPoll.userID = [Utility getObjectForKey:CURRENTUSERID];
                [[RKObjectManager sharedManager] postObject:followedPoll delegate:self];
            }
        }
    }else if ([objectLoader wasSentToResourcePath:@"/polls/:pollID/audience"]) {
        NSLog(@"User[%@] has become one of the audience of this poll now.",[Utility getObjectForKey:CURRENTUSERID]);
    }else if ([objectLoader wasSentToResourcePath:@"/polls/:pollID" method:RKRequestMethodPUT]){
        NSLog(@"Updating of this poll has been done");
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
    Item *item = [self.poll.items objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.itemImage.url = item.photoURL;
    [HJObjectManager manage:cell.itemImage];
    cell.descriptionOfItemLabel.text = item.description;
    cell.priceLabel.text = [[NSString alloc] initWithFormat:@"%@", item.price]; 
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
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
