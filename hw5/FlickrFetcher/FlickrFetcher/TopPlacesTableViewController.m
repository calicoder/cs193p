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
#import "SplitViewBarButtonItemProtocol.h"

@implementation TopPlacesTableViewController  
@synthesize topPlaces = _topPlaces;

- (id <SplitViewBarButtonItemProtocol>) splitViewBarButtonItemProtocol {
  id detailedVC = [self.splitViewController.viewControllers lastObject];
  if (![detailedVC conformsToProtocol:@protocol(SplitViewBarButtonItemProtocol)]) {
    detailedVC = nil;
  } 
  return detailedVC;
}

//when you wake up from a storyboard, try to make this controller the split view delegate
- (void)awakeFromNib {
  [super awakeFromNib];
  self.splitViewController.delegate = self;
}

- (void)viewDidLoad
{
  self.topPlaces = [FlickrFetcher topPlaces];
  self.title = @"Top Places";
  [super viewDidLoad];
}

//should the master view controller be hidden?
- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
  return [self splitViewBarButtonItemProtocol] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

//master view controller has been hidden. what should the barButtonItem do?
- (void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
  barButtonItem.title = self.title;
  [self splitViewBarButtonItemProtocol].splitViewBarButtonItem = barButtonItem;
}

//master view controller is unhidden.  
- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  [self splitViewBarButtonItemProtocol].splitViewBarButtonItem = nil;
}

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  NSDictionary *selectedCell = [self.topPlaces objectAtIndex:indexPath.row];
  cell.textLabel.text = [selectedCell objectForKey:@"_content"];
  cell.detailTextLabel.text = [selectedCell objectForKey:@"place_url"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
  if ([segue.identifier isEqualToString:@"showNext"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [segue.destinationViewController setPlace:[self.topPlaces objectAtIndex:indexPath.row]];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
}

@end
