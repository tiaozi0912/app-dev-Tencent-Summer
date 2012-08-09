//
//  ManagePollsTableViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/13/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ManagePollsTableViewController.h"

#define POLLCELLHEIGHT 46

@interface ManagePollsTableViewController (){
    dispatch_queue_t downloadQueue;
}

@property (nonatomic, strong) NSMutableArray *activePolls, *pastPolls, *followedPolls;
@end

@implementation ManagePollsTableViewController

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    dispatch_release(downloadQueue);
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    self.activePolls = [NSMutableArray new];
    self.followedPolls = [NSMutableArray new];
    self.pastPolls = [NSMutableArray new];
    /*downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/poll_records" delegate:self];
    });*/
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/poll_records" delegate:self];
}


- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
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
    }
    return nil;
}/* to customize the font in headers, use the method below instead
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.activePolls.count;
        case 1: return self.followedPolls.count;
        case 2: return self.pastPolls.count;
    }// Return the number of rows in the section.
    return 0;
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
            PollRecord* poll = [self.activePolls objectAtIndex:indexPath.row];
            cell.nameLabel.text = poll.title;
            cell.votesLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
            cell.stateLabel.text = poll.state;
            [cell.nameLabel sizeToFit];
            return cell;
        } 
        case 1:{
            static NSString *CellIdentifier = @"followed poll cell";
            FollowedPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FollowedPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            PollRecord *poll = [self.followedPolls objectAtIndex:indexPath.row];
            cell.nameLabel.text = poll.title;
            cell.ownerLabel.text = poll.owner.username;
            cell.userPhoto.image = [UIImage imageNamed:@"default_profile_photo.jpeg"];
            cell.userPhoto.url = [NSURL URLWithString:poll.owner.profilePhotoURL];
            [HJObjectManager manage:cell.userPhoto];
            cell.stateLabel.text = poll.state;
            [cell.nameLabel sizeToFit];
            [cell.ownerLabel sizeToFit];
            return cell;
        } 
        case 2:{
            static NSString *CellIdentifier = @"past poll cell";
            PastPollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[PastPollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            PollRecord *poll = [self.pastPolls objectAtIndex:indexPath.row];
            cell.nameLabel.text = poll.title;
            cell.votesLabel.text = [[NSString alloc] initWithFormat:@"%@", poll.totalVotes];
            cell.dateLabel.text = @"7/17/2012";
            [cell.nameLabel sizeToFit];
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


@end
