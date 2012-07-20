//
//  PollTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/9/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PollTableViewController.h"
#import "StylepicsDatabase.h"
#define  POLLITEMCELLHEIGHT 350
@interface PollTableViewController (){
    StylepicsDatabase *database;
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
    database =[[StylepicsDatabase alloc] init];
    self.navigationController.toolbarHidden = YES;
    
    //self.poll =[database getPollDetailsWithID:[Utility getObjectForKey:IDOfPollToBeShown]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)startOrEndVoting:(UIBarButtonItem *)sender {
    if ([self.poll.state isEqualToString:EDITING]){
        self.poll.state = VOTING;
        [database changeStateOfPoll:self.poll.pollID to:VOTING];
        [[self.toolbarItems objectAtIndex:0]setEnabled:NO];
        [[self.toolbarItems objectAtIndex:2] setTitle:@"End Voting"];
        [[self.toolbarItems objectAtIndex:3]setEnabled:YES];
    }else if([self.poll.state isEqualToString:VOTING]){
        self.poll.state = FINISHED;
        [database changeStateOfPoll:self.poll.pollID to:FINISHED];
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
        PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Item *item = [self.poll.items objectAtIndex:indexPath.row];
        if (![database voteForItem:item.itemID inPoll:self.poll.pollID byUser:[Utility getObjectForKey:CURRENTUSERID]]){
            [Utility showAlert:@"Sorry!" message:@"You cannot vote more than once in a poll."];
        }else {
            [Utility showAlert:@"Thank you!" message:@"We appreciate your vote."];
        }
    }
}

- (IBAction)deleteItem:(UIButton *)sender {
    if([self.poll.state isEqualToString:EDITING]&&[[Utility getObjectForKey:CURRENTUSERID] isEqualToNumber:self.poll.ownerID]){
        PollItemCell *cell = (PollItemCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Item *item = [self.poll.items objectAtIndex:indexPath.row];
        [database deleteItem:item.itemID inPoll:self.poll.pollID];
        [self.poll.items removeObjectAtIndex:indexPath.row];
        [Utility showAlert:@"Removed successfully!" message:@"This item has been removed from the poll."];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.poll =[database getPollDetailsWithID:[Utility getObjectForKey:IDOfPollToBeShown]];
    UIImage *navigationBarBackground =[[UIImage imageNamed:@"Custom-Tool-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault]; 
    self.title = self.poll.name;
    [self.tableView reloadData];
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
        if (![database user:[Utility getObjectForKey:CURRENTUSERID] isAudienceOfPoll:self.poll.pollID]){
            [database user:[Utility getObjectForKey:CURRENTUSERID] becomesAudienceOfPoll:self.poll.pollID];
        }
            
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UIImage *navigationBarBackground =[[UIImage imageNamed:@"Custom-Nav-Bar-BG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];

}

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
    cell.itemImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.itemImage setImage:item.photo forState:UIControlStateNormal];
    cell.descriptionOfItemLabel.text = item.description;
    cell.priceLabel.text = [[NSString alloc] initWithFormat:@"%@", item.price]; 
    [cell.descriptionOfItemLabel sizeToFit];
    [cell.priceLabel sizeToFit];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return POLLITEMCELLHEIGHT;
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
