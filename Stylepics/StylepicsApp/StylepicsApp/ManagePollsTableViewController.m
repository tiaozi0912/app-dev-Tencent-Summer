//
//  ManagePollsTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ManagePollsTableViewController.h"
#import "ActivePollCell.h"
#import "FollowedPollCell.h"
#import "PastPollCell.h"
#import "StylepicsDatabase.h"
#define POLLCELLHEIGHT 46

@interface ManagePollsTableViewController ()
{
    StylepicsDatabase *database;
    NSArray *activePolls, *pastPolls, *followedPolls;
}

@end

@implementation ManagePollsTableViewController

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
    database = [[StylepicsDatabase alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    activePolls = [database getPollOfType:ACTIVE forUser:[Utility getObjectForKey:CURRENTUSERID]];
    pastPolls = [database getPollOfType:PAST forUser:[Utility getObjectForKey:CURRENTUSERID]];
    followedPolls = [database getPollOfType:FOLLOWED forUser:[Utility getObjectForKey:CURRENTUSERID]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){ 
        case 0: return @"ACTIVE POLLS";
        case 1: return @"FOLLOWED POLLS";
        case 2: return @"PAST POLLS";
    }
    return nil;
}/* to customize the font in headers, use the method below instead
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return activePolls.count;
        case 1: return followedPolls.count;
        case 2: return pastPolls.count;
    }// Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {

        case 0:{
            static NSString *CellIdentifier = @"active poll cell";
            ActivePollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ActivePollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            Poll* poll = [activePolls objectAtIndex:indexPath.row];
            cell.nameLabel.text = poll.name;
        NSLog(@"%@", poll.name);
            cell.votesLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
            cell.stateLabel.text = poll.state;
            return cell;
        } 
        case 1:{
            static NSString *CellIdentifier = @"followed poll cell";
            FollowedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FollowedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            Poll *poll = [followedPolls objectAtIndex:indexPath.row];
            cell.nameLabel.text = poll.name;
            User *owner = [database getUserWithID:poll.ownerID];
            cell.ownerLabel.text = owner.name;
            cell.stateLabel.text = poll.state;
            return cell;
        } 
        case 2:{
            static NSString *CellIdentifier = @"past poll cell";
            PastPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[PastPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            Poll *poll = [pastPolls objectAtIndex:indexPath.row];
            cell.nameLabel.text = poll.name;
            cell.votesLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
            cell.dateLabel.text = @"7/17/2012";
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
    switch (indexPath.section) {
        case 0:{
            Poll* poll = [activePolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case 1:{
            Poll* poll = [followedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case 2:{
            Poll* poll = [pastPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
        }
        default:
            break;
    }

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
