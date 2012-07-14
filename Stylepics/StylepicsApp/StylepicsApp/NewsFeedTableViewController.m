//
//  NewsFeedTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "StylepicsDatabase.h"
#import "UserEvent.h"
#import "User.h"
#import "Poll.h"
#import "Item.h"
#define NUMBEROFEVENTSLOADED 20

@interface NewsFeedTableViewController (){
    StylepicsDatabase *database;
}
@end

@implementation NewsFeedTableViewController


@synthesize events=_events;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)logout:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    database = [[StylepicsDatabase alloc] init];
    self.events = [database getMostRecentEventsNum:[NSNumber numberWithInt:NUMBEROFEVENTSLOADED]];
    
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

#pragma mark - Table view data source

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

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
    
    UserEvent *event = [self.events objectAtIndex:indexPath.row];
    NSString *eventType = event.type;
    if ([eventType isEqualToString:@"new poll"]) {
        static NSString *CellIdentifier = @"new poll cell";
        NewsFeedNewPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[NewsFeedNewPollCell alloc]
     initWithStyle:UITableViewCellStyleDefault 
     reuseIdentifier:CellIdentifier];
     }
        // Configure the cell...
        User *user=[database getUserWithID:event.userID];
        cell.userImage.image = (user.photo==nil? [UIImage imageNamed:@"default_profile_photo.jpeg"]:user.photo);
        cell.userNameLabel.text = user.name;
        cell.iconImage.image = [UIImage imageNamed:@"new poll icon.png"];
        Poll *poll=[database getPollWithID:event.pollID];
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Created a new poll '%@'. ", poll.name];
        return cell;
    }else if ([eventType isEqualToString:@"new item"]) {
        static NSString *CellIdentifier = @"new item cell";
        NewsFeedNewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsFeedNewItemCell alloc]
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...
        User *user=[database getUserWithID:event.userID];
        cell.userImage.image = (user.photo==nil? [UIImage imageNamed:@"default_profile_photo.jpeg"]:user.photo);
        cell.userNameLabel.text = user.name;
        cell.iconImage.image = [UIImage imageNamed:@"new item icon.png"];
        Poll *poll=[database getPollWithID:event.pollID];
        Item *item=[database getItemWithID:event.itemID pollID:event.pollID];
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Added one item to Poll '%@'.", poll.name];
        cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.itemImage.image = item.photo;
        // In current version, photo uploading is limited to one picture at a time
        return cell;
    }else if ([eventType isEqualToString:@"vote"]) {
        static NSString *CellIdentifier = @"vote cell";
        NewsFeedVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
        if (cell == nil) {
            cell = [[NewsFeedVoteCell alloc]
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...
        User *user=[database getUserWithID:event.userID];
        cell.userImage.image = (user.photo==nil? [UIImage imageNamed:@"default_profile_photo.jpeg"]:user.photo);
        cell.userNameLabel.text = user.name;
        cell.iconImage.image = [UIImage imageNamed:@"vote icon.png"];
        Poll *poll=[database getPollWithID:event.pollID];
        User *votee =[database getUserWithID:event.voteeID];
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Voted in %@'s Poll '%@'. ", votee.name, poll.name];
        return cell;
    }
    return nil;
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
