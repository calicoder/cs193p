//
//  TopPicturesForPlaceTableViewController.m
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPicturesForPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrImageViewController.h"

@implementation TopPicturesForPlaceTableViewController
@synthesize place = _place;
@synthesize topPictures = _topPictures;

- (void) setPlace:(NSDictionary *)place {
  _place = place;
  self.topPictures = [FlickrFetcher photosInPlace:place maxResults:20];
  self.title = [self.place valueForKey:@"_content"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.topPictures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topPictureCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  NSString *title = [[self.topPictures objectAtIndex:indexPath.row] objectForKey:@"title"];
  if ([title isEqualToString:@""]) {
    cell.textLabel.text = @"Unknown";
  } else {
    cell.textLabel.text = title;
  }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showFlickrImageViewController"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *selectedPhoto = [self.topPictures objectAtIndex:indexPath.row];
    [segue.destinationViewController setPhoto:selectedPhoto];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPictures = [[defaults objectForKey:RECENT_PICTURES] mutableCopy];
    if (!recentPictures) recentPictures = [NSMutableArray array];
    [recentPictures addObject:selectedPhoto];    
    [defaults setObject:recentPictures forKey:RECENT_PICTURES];
    [defaults synchronize];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return true;
}



@end
