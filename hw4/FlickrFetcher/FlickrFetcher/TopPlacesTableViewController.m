//
//  TopPlacesTableViewController.m
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "TopPicturesForPlaceTableViewController.h"
#import "FlickrFetcher.h"

@implementation TopPlacesTableViewController
@synthesize topPlaces = _topPlaces;

- (void)viewDidLoad
{
  self.topPlaces = [FlickrFetcher topPlaces];
  [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topPlaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  cell.textLabel.text = [[self.topPlaces objectAtIndex:indexPath.row] objectForKey:@"_content"];
    return cell;
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
  if ([segue.identifier isEqualToString:@"showTopPicturesForPlaceTableViewController"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [segue.destinationViewController setPlace:[self.topPlaces objectAtIndex:indexPath.row]];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return true;
}

@end
