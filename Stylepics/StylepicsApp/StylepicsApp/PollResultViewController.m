//
//  PollResultViewController.m
//  StylepicsApp
//
//  Created by Yong Lin on 7/17/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "PollResultViewController.h"

@interface PollResultViewController (){
    double maxVotesForSingleItem;
}
@property (nonatomic, strong) Poll *poll;
@end

@implementation PollResultViewController
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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:BACKGROUND_COLOR]];
    
    self.poll = [Poll new];
    self.poll.pollID = [Utility getObjectForKey:IDOfPollToBeShown];
    [[RKObjectManager sharedManager] getObject:self.poll delegate:self];
    self.navigationItem.titleView = [Utility formatTitleWithString:self.navigationItem.title];
    
    UIImage *backButtonImage = [[UIImage imageNamed:NAV_BAR_BUTTON_BG] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    //UIImage *backButtonPressedImage = [UIImage imageNamed:NAV_BAR_BUTTON_BG_HL];
    [self.navigationItem.leftBarButtonItem  setBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[self.navigationItem.leftBarButtonItem  setBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.poll = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    ((CenterButtonTabController*)self.tabBarController).cameraButton.hidden = YES;
}

-(void)dealloc
{
    [[RKClient sharedClient].requestQueue cancelRequestsWithDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)request:(RKRequest*)request didLoadResponse:
(RKResponse*)response {
    if ([response isJSON]) {
        NSLog(@"Got a JSON, %@", response.bodyAsString);
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
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
    static NSString *CellIdentifier = @"poll result cell";
    PollResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PollResultCell alloc]
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    Item* item = [self.poll.items objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.itemImage.url= [NSURL URLWithString:item.photoURL];
    [HJObjectManager manage:cell.itemImage];
    cell.descriptionLabel.text = item.description;
    cell.priceLabel.text = [[NSString alloc] initWithFormat:@"%@", item.price];    
    cell.numberOfVotesIndicator.progress = item.numberOfVotes.floatValue/self.poll.totalVotes.floatValue;
    cell.numberOfVotesLabel.text = [NSString stringWithFormat:@"%d%%",item.numberOfVotes.intValue*100/self.poll.totalVotes.intValue];
    [cell.descriptionLabel sizeToFit];
    [cell.priceLabel sizeToFit];
    return cell;
}

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
