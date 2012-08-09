//
//  NewsFeedTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "Utility.h"

#define NUMBEROFEVENTSLOADED 200
#define HEIGHTOFNEWPOLLCELL 60
#define HEIGHTOFNEWITEMCELL 295
#define HEIGHTOFVOTECELL 60

@interface NewsFeedTableViewController (){
}
@property (nonatomic, strong) NSArray* events;
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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    self.events = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.events = nil;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/events" delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    if ([objectLoader wasSentToResourcePath:@"/events"]){
        self.events = objects;
        NSLog(@"%u", self.events.count);
        [self.tableView reloadData];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [Utility showAlert:@"Sorry!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
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
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.events objectAtIndex:indexPath.row];
    NSString *eventType = event.eventType;
    if ([eventType isEqualToString:@"new poll"]) {
        static NSString *CellIdentifier = @"new poll cell";
        NewsFeedNewPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[NewsFeedNewPollCell alloc]
     initWithStyle:UITableViewCellStyleDefault 
     reuseIdentifier:CellIdentifier];
     }
        // Configure the cell...
        cell.userImage.image = [UIImage imageNamed:@"default_profile_photo.jpeg"];
        cell.userImage.url = (event.user.profilePhotoURL == nil? nil:[NSURL URLWithString:event.user.profilePhotoURL]);
        [HJObjectManager manage:cell.userImage];
        cell.userNameLabel.text = event.user.username;
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Created a new poll '%@'. ", event.poll.title];
        [cell.userNameLabel sizeToFit];
        [cell.eventDescriptionLabel sizeToFit];
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
        cell.userImage.image = [UIImage imageNamed:@"default_profile_photo.jpeg"];
        cell.userImage.url = (event.user.profilePhotoURL == nil? nil:[NSURL URLWithString:event.user.profilePhotoURL]);
        [HJObjectManager manage:cell.userImage];
        cell.userNameLabel.text = event.user.username;
        cell.eventDescriptionLabel.text = [NSString stringWithFormat:@"Added one item to Poll '%@'.", event.poll.title];
        cell.itemImage.url = [NSURL URLWithString:event.item.photoURL];
        [HJObjectManager manage:cell.itemImage];
        // In current version, photo uploading is limited to one picture at a time
        [cell.userNameLabel sizeToFit];
        [cell.eventDescriptionLabel sizeToFit];
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
        cell.userImage.image = [UIImage imageNamed:@"default_profile_photo.jpeg"];
        cell.userImage.url = (event.user.profilePhotoURL == nil? nil:[NSURL URLWithString:event.user.profilePhotoURL]);
        [HJObjectManager manage:cell.userImage];
        cell.userNameLabel.text = event.user.username;
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Voted in %@'s Poll '%@'. ", event.poll.user.username, event.poll.title];
        [cell.userNameLabel sizeToFit];
        [cell.eventDescriptionLabel sizeToFit];
        return cell;
    }
    return nil;
}


//Set up cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.events objectAtIndex:indexPath.row];
    NSString *eventType = event.eventType;
    if ([eventType isEqualToString:@"new poll"]) {
        return HEIGHTOFNEWPOLLCELL;
    }else if ([eventType isEqualToString:@"new item"]){
     return HEIGHTOFNEWITEMCELL;
    }else if ([eventType isEqualToString:@"vote"]){
      return HEIGHTOFVOTECELL;
     }
    return HEIGHTOFNEWPOLLCELL;
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

- (void)tableView: (UITableView*)tableView
  willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath{
   // cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.events objectAtIndex:indexPath.row];
    [Utility setObject:event.poll.pollID forKey:IDOfPollToBeShown];
    [self performSegueWithIdentifier:@"show a poll from news feed" sender:self];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/*-(void)loadUserWithID:(NSNumber*)userID
{
    loaderKey = 1;
    NSString *path = [NSString stringWithFormat:@"/user/%@", userID];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path delegate:self];
}

-(void)loadPollWithID:(NSNumber*)pollID
{
    loaderKey = 2;
    NSString *path = [NSString stringWithFormat:@"/poll/%@", pollID];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path delegate:self];
}

-(void)loadItemWithID:(NSNumber*)itemID
               inPoll:(NSNumber*)pollID
{
    loaderKey = 3;
    NSString *path = [NSString stringWithFormat:@"/poll/%@/items/%@", pollID, itemID];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path delegate:self];
}*/



@end
