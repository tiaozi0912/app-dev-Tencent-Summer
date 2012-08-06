/*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "DomainList.h"
#import "AmazonClientManager.h"
#import "ItemListing.h"

@implementation DomainList

-(id)init
{
    return [super initWithNibName:@"DomainList" bundle:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    @try {
        SimpleDBListDomainsRequest  *listDomainsRequest  = [[[SimpleDBListDomainsRequest alloc] init] autorelease];
        SimpleDBListDomainsResponse *listDomainsResponse = [[AmazonClientManager sdb] listDomains:listDomainsRequest];

        if (domains == nil) {
            domains = [[NSMutableArray alloc] initWithCapacity:[listDomainsResponse.domainNames count]];
        }
        else {
            [domains removeAllObjects];
        }
        for (NSString *name in listDomainsResponse.domainNames) {
            [domains addObject:name];
        }

        [domains sortUsingSelector:@selector(compare:)];
    }
    @catch (AmazonClientException *exception)
    {
        if ([AmazonClientManager wipeCredentialsOnAuthError:exception])
        {
            [[Constants expiredCredentialsAlert] show];
        }
        
        NSLog(@"Exception = %@", exception);
    }

    [domainTableView reloadData];
}

-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [domains count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell...
    cell.textLabel.text                      = [domains objectAtIndex:indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemListing *itemList = [[ItemListing alloc] init];

    itemList.domain               = [domains objectAtIndex:indexPath.row];
    itemList.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:itemList animated:YES];
    [itemList release];
}

-(void)dealloc
{
    [domains release];
    [super dealloc];
}


@end

