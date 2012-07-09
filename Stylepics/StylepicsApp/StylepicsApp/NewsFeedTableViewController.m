//
//  NewsFeedTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "UserEvent.h"
#import "User.h"
#import "Cart.h"
#import "Item.h"

@interface NewsFeedTableViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.events = [[NSMutableArray alloc] init];
    
    //create one check-in event to events
    UserEvent *userEvent = [[UserEvent alloc] init];
    
    User *user= [[User alloc] init];
    user.name = @"Michael Wu";
    user.photo = [UIImage imageNamed:@"user1.png"];
    User *votee = user;
    
    Cart *cart = [[Cart alloc] init];
    cart.name = @"Abercrombie & Fitch";
    
    Item *item = [[Item alloc] init];
    item.description = @"Can I wear this to date my first dream girl?";
    item.price = [NSNumber numberWithDouble:49.99];
    item.photo = [UIImage imageNamed:@"item1.png"];
    [cart addItem:item];
    
    userEvent.type = @"new cart";
    userEvent.user = user;
    userEvent.cart = cart;
    userEvent.icon = [UIImage imageNamed:@"new cart.png"];
    userEvent.votee = votee;
    userEvent.description = [@"Check in for " stringByAppendingString:userEvent.cart.name];
    [self.events addObject:userEvent];
    
    /*//create one new-item event to events
    user.name = @"Amanda Kao";
    user.photo = [UIImage imageNamed:@"user2.png"];
    
    cart.name = @"H&M";
    
    item.description = @"I'd like to buy a vacation dress. What about this?";
    item.price = [NSNumber numberWithDouble:44.99];
    [cart addItem:item];
    
    userEvent.type = @"new item";
    userEvent.user = user;
    userEvent.cart = cart;
    userEvent.icon = [UIImage imageNamed:@"new item.png"];
    userEvent.votee = votee;
    userEvent.description = [@"Added one item to Cart" stringByAppendingString:userEvent.cart.name];
    [self.events addObject:userEvent];
    
    //create one vote event to events
    
    user.name = @"Justine Goreux";
    user.photo = [UIImage imageNamed:@"user3.png"];
    
    cart.name = @"H&M";
    
    [cart addItem:item];
    
    userEvent.type = @"vote";
    userEvent.user = user;
    userEvent.cart = cart;
    userEvent.icon = [UIImage imageNamed:@"vote.png"];
    userEvent.votee = votee;
    userEvent.description = [@"Voted for " stringByAppendingString:userEvent.votee.name];
    [self.events addObject:userEvent];*/
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEvent *event = [self.events objectAtIndex:indexPath.row];
    NSString *eventType = event.type;
    if ([eventType isEqualToString:@"new cart"]) {
        static NSString *CellIdentifier = @"new cart cell";
        NewsFeedNewCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[NewsFeedNewCartCell alloc]
     initWithStyle:UITableViewCellStyleDefault 
     reuseIdentifier:CellIdentifier];
     }
        // Configure the cell...
        cell.userImage.image = event.user.photo;
        cell.userNameLabel.text = event.user.name;
        cell.iconImage.image = event.icon;
        cell.eventDescriptionLabel.text = event.description;
        return cell;
    }else if ([eventType isEqualToString:@"new item"]) {
        static NSString *CellIdentifier = @"new item cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
        // Configure the cell...
        return cell;
    }else if ([eventType isEqualToString:@"vote"]) {
        static NSString *CellIdentifier = @"vote cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    // Configure the cell...
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
