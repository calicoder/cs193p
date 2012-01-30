//
//  RecentPicturesTableViewController.m
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPicturesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPicturesForPlaceTableViewController.h"
#import "FlickrImageViewController.h"

@implementation RecentPicturesTableViewController

@synthesize cellItems = _cellItems;

- (void)viewWillAppear:(BOOL)animated {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  self.cellItems = [defaults objectForKey:RECENT_PICTURES];
  [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  cell.textLabel.text = [[self.cellItems objectAtIndex:indexPath.row] valueForKey:@"title"];
  cell.detailTextLabel.text = [[self.cellItems objectAtIndex:indexPath.row] valueForKeyPath:@"description._content"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
  NSDictionary *selectedPhoto = [self.cellItems objectAtIndex:indexPath.row];
  [segue.destinationViewController setPhoto:selectedPhoto];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *recentPictures = [[defaults objectForKey:RECENT_PICTURES] mutableCopy];
  if (!recentPictures) recentPictures = [NSMutableArray array];
  [recentPictures addObject:selectedPhoto];    
  [defaults setObject:recentPictures forKey:RECENT_PICTURES];
  [defaults synchronize];
}
@end
