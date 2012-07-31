//
//  NewsFeedTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "StylepicsDatabase.h"

#define NUMBEROFEVENTSLOADED 200
#define HEIGHTOFNEWPOLLCELL 60
#define HEIGHTOFNEWITEMCELL 295
#define HEIGHTOFVOTECELL 60
@interface NewsFeedTableViewController (){
    //StylepicsDatabase *database;
    int loaderKey;
}
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) Poll* poll;
@property (nonatomic, strong) Item* item; 
@end

@implementation NewsFeedTableViewController


@synthesize events=_events, user = _user, poll = _poll, item = _item;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)logout:(UIBarButtonItem *)sender 
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // database = [[StylepicsDatabase alloc] init];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    [self loadEvents];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    UserEvent *event = [self.events objectAtIndex:indexPath.row];
    [self loadUserWithID:event.userID];//self.user=[database getUserWithID:event.userID];
    [self loadPollWithID:event.pollID];
    UIImage *profilePhoto = (self.user.profilePhoto==nil? [UIImage imageNamed:@"default_profile_photo.jpeg"]:_user.profilePhoto);
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
        cell.userImage.image = profilePhoto;
        cell.userNameLabel.text = _user.username;
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Created a new poll '%@'. ", _poll.name];
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
        cell.userImage.image = profilePhoto;
        cell.userNameLabel.text = _user.username;
        [self loadItemWithID:event.itemID inPoll:event.pollID];
        cell.eventDescriptionLabel.text = [NSString stringWithFormat:@"Added one item to Poll '%@'.", _poll.name];
        cell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.itemImage.url = _item.photoURL;
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
        cell.userImage.image = profilePhoto;
        cell.userNameLabel.text = _user.username;
        [self loadUserWithID:event.voteeID];
        cell.eventDescriptionLabel.text = [[NSString alloc] initWithFormat:@"Voted in %@'s Poll '%@'. ", _user.username, _poll.name];
        [cell.userNameLabel sizeToFit];
        [cell.eventDescriptionLabel sizeToFit];
        return cell;
    }
    return nil;
}


//Set up cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEvent *event = [self.events objectAtIndex:indexPath.row];
    NSString *eventType = event.type;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEvent *event = [self.events objectAtIndex:indexPath.row];
    [Utility setObject:event.pollID forKey:IDOfPollToBeShown];
    [self performSegueWithIdentifier:@"show a poll from news feed" sender:self];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)loadEvents
{
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateModel) name:NewEventNotification object:nil];*/
    loaderKey = 0;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/event" delegate:self];
}

-(void)loadUserWithID:(NSNumber*)userID
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
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    switch (loaderKey) {
        case 0:
        {
            _events = objects;
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            _user = [objects objectAtIndex:0];
        }
            break;
        case 2:
        {
            _poll = [objects objectAtIndex:0];
        }
            break;
        case 3:
        {
            _item = [objects objectAtIndex:0];
        }
            break;
        default:
            break;
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    //show errors: existent username and invalid password
    [Utility showAlert:@"Error!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

@end
