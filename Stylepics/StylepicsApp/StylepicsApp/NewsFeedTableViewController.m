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
    self.events = [[NSMutableArray alloc] init];
    
    //create one check-in event to events
    UserEvent *userEvent1 = [[UserEvent alloc] init];
    
    User *user1= [[User alloc] init];
    user1.name = @"Michael Wu";
    user1.photo = [UIImage imageNamed:@"user1.png"];
    User *votee1 = user1;
    
    Cart *cart1 = [[Cart alloc] init];
    cart1.name = @"Abercrombie & Fitch";
    
    Item *item1 = [[Item alloc] init];
    item1.description = @"Can I wear this to date my first dream girl?";
    item1.price = [NSNumber numberWithDouble:49.99];
    item1.photo = [UIImage imageNamed:@"item1.png"];
    [cart1.items addObject:item1];
    
    userEvent1.type = @"new cart";
    userEvent1.user = user1;
    userEvent1.cart = cart1;
    userEvent1.icon = [UIImage imageNamed:@"new cart.png"];
    userEvent1.votee = votee1;
    userEvent1.description = [@"Check-in to " stringByAppendingString:userEvent1.cart.name];
    [self.events addObject:userEvent1];
    
    //create one new-item event to events
    UserEvent *userEvent2 = [[UserEvent alloc] init];
    User *user2= [[User alloc] init];
    user2.name = @"Amanda Kao";
    user2.photo = [UIImage imageNamed:@"user2.png"];
    
    Cart *cart2 = [[Cart alloc] init];
    cart2.name = @"H&M";
    
    Item *item2 = [[Item alloc] init];
    item2.description = @"Does this match my style of a party girl?";
    item2.price = [NSNumber numberWithDouble:34.99];
    item2.photo = [UIImage imageNamed:@"item1.png"];
    [cart2.items addObject:item2];
    
    userEvent2.type = @"new item";
    userEvent2.user = user2;
    userEvent2.cart = cart2;
    userEvent2.icon = [UIImage imageNamed:@"new item.png"];
    userEvent2.votee = votee1;
    userEvent2.description = [@"Added one item to Cart " stringByAppendingString:userEvent2.cart.name];
    [self.events addObject:userEvent2];
    
    //create one vote event to events
    UserEvent *userEvent3 = [[UserEvent alloc] init];
    User *user3= [[User alloc] init];
    user3.name = @"Justine Goreux";
    user3.photo = [UIImage imageNamed:@"user3.png"];
    
    Cart *cart3 = [[Cart alloc] init];
    cart3.name = @"H&M";
    
    Item *item3 = [[Item alloc] init];
    item3.description = @"Does this match my style of a party girl?";
    item3.price = [NSNumber numberWithDouble:34.99];
    item3.photo = [UIImage imageNamed:@"item1.png"];
    
    [cart3.items addObject:item3];
    
    userEvent3.type = @"vote";
    userEvent3.user = user3;
    userEvent3.cart = cart3;
    userEvent3.icon = [UIImage imageNamed:@"vote.png"];
    userEvent3.votee = votee1;
    userEvent3.description = [@"Voted for " stringByAppendingString:userEvent3.votee.name];
    [self.events addObject:userEvent3];
    
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
        NewsFeedNewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsFeedNewItemCell alloc]
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...
        cell.userImage.image = event.user.photo;
        cell.userNameLabel.text = event.user.name;
        cell.iconImage.image = event.icon;
        cell.eventDescriptionLabel.text = event.description;
        cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.itemImage.image = [[event.cart.items lastObject] photo];
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
        cell.userImage.image = event.user.photo;
        cell.userNameLabel.text = event.user.name;
        cell.iconImage.image = event.icon;
        cell.eventDescriptionLabel.text = event.description;
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
