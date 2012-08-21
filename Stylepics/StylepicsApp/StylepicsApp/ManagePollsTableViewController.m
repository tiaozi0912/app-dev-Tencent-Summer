//
//  ManagePollsTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ManagePollsTableViewController.h"
#define POLLCELLHEIGHT 46

@interface ManagePollsTableViewController ()
{
    User* user;
}

@property (nonatomic, strong) NSMutableArray *activePolls, *pastPolls, *followedPolls;
@end

@implementation ManagePollsTableViewController
@synthesize userPhoto;
@synthesize usernameLabel;

@synthesize activePolls, pastPolls, followedPolls;

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
    UIImage *navigationBarBackground =[[UIImage imageNamed:NAV_BAR_BACKGROUND_COLOR] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    self.userPhoto.image = [UIImage imageNamed:DEFAULT_USER_PROFILE_PHOTO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setUserPhoto:nil];
    [self setUsernameLabel:nil];
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
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = NO;
    
    self.activePolls = [NSMutableArray new];
    self.followedPolls = [NSMutableArray new];
    self.pastPolls = [NSMutableArray new];
    
    user = [User new];
    user.userID = [Utility getObjectForKey:CURRENTUSERID];
    [[RKObjectManager sharedManager] getObject:user delegate:self];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/poll_records" delegate:self];
}

#pragma User Actions
-(IBAction)newPoll
{
    [self performSegueWithIdentifier:@"new poll" sender:self];
}

- (void) dealloc
{
    [[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    if ([objectLoader wasSentToResourcePath:@"/poll_records"])
    {
        NSArray *pollRecords = objects;
        for (id obj in pollRecords){
            if ([obj isKindOfClass:[PollRecord class]]){
                PollRecord* pollRecord = (PollRecord*) obj;
                if ([pollRecord.pollRecordType isEqualToString:ACTIVE]){
                    [self.activePolls addObject:pollRecord];
                }else if ([pollRecord.pollRecordType isEqualToString:FOLLOWED]){
                    [self.followedPolls addObject:pollRecord];
                }else if ([pollRecord.pollRecordType isEqualToString:PAST]){
                    [self.pastPolls addObject:pollRecord];
                }
            }
        }
    }else{
        self.usernameLabel.text = user.username;
        self.userPhoto.url = [NSURL URLWithString:user.profilePhotoURL];
        [HJObjectManager manage:self.userPhoto];
    }
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{    
    [Utility showAlert:@"Error!" message:[error localizedDescription]];
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - Table view data source

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
        default: return nil;
    }
}/* to customize the font in headers, use the method below instead
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            NSLog(@"active polls' count: %u",self.activePolls.count);
            return self.activePolls.count;
        }
        case 1: {
            NSLog(@"followed polls' count: %u",self.followedPolls.count);
            return self.followedPolls.count;}
        case 2: {
            NSLog(@"past polls' count: %u",self.pastPolls.count);
            return self.pastPolls.count;
        }
        default:return 0;
            break;
    }// Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if (![NSThread isMainThread])
    {
        return [self performSelector:@selector(tableView: cellForRowAtIndexPath:) withObject:tableView withObject:indexPath];
       
    }*/
    switch (indexPath.section) {

        case 0:{
            static NSString *CellIdentifier = @"active poll cell";
            ActivePollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ActivePollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.activePolls.count){
                PollRecord* poll = [self.activePolls objectAtIndex:indexPath.row];
                cell.nameLabel.text = poll.title;
                cell.votesLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
                cell.stateLabel.text = poll.state;
                [cell.nameLabel sizeToFit];
            }
            return cell;
        } 
        case 1:{
            static NSString *CellIdentifier = @"followed poll cell";
            FollowedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FollowedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.followedPolls.count){
                PollRecord *poll = [self.followedPolls objectAtIndex:indexPath.row];
                cell.nameLabel.text = poll.title;
                cell.ownerLabel.text = poll.owner.username;
                cell.userPhoto.image = [UIImage imageNamed:@"default_profile_photo.jpeg"];
                cell.userPhoto.url = [NSURL URLWithString:poll.owner.profilePhotoURL];
                [HJObjectManager manage:cell.userPhoto];
                cell.stateLabel.text = poll.state;
                [cell.nameLabel sizeToFit];
                [cell.ownerLabel sizeToFit];
            }
            return cell;
        } 
        case 2:{
            static NSString *CellIdentifier = @"past poll cell";
            PastPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[PastPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (indexPath.row < self.pastPolls.count){
                PollRecord *poll = [self.pastPolls objectAtIndex:indexPath.row];
                cell.nameLabel.text = poll.title;
                cell.votesLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
                cell.dateLabel.text =[NSDateFormatter localizedStringFromDate:poll.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
                [cell.nameLabel sizeToFit];
                [cell.dateLabel sizeToFit];
            }
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
            Poll* poll = [self.activePolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case 1:{
            Poll* poll = [self.followedPolls objectAtIndex:indexPath.row];
            [Utility setObject:poll.pollID forKey:IDOfPollToBeShown];
            break;
        }
        case 2:{
            Poll* poll = [self.pastPolls objectAtIndex:indexPath.row];
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

#pragma NewPollViewController delegate method
-(void)newPollViewController:(id)sender didCreateANewPoll:(NSNumber *)pollID
{
    [Utility setObject:pollID forKey:IDOfPollToBeShown];
    [self dismissModalViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"show poll" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"new poll"]){
        ((NewPollViewController*)(segue.destinationViewController)).delegate = self;
    }

}
@end
