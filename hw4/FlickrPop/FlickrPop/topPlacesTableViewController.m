//
//  topPlacesTableViewController.m
//  FlickrPop
//
//  Created by Andrew Shin on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "topPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPicturesTableViewController.h"

@implementation topPlacesTableViewController
@synthesize topPlaces = _topPlaces;

- (void)viewDidLoad
{
  self.topPlaces = [FlickrFetcher topPlaces];
//  NSLog(@"self.topPlaces is %@", self.topPlaces);
//  NSLog(@"photos in first place is %@", [FlickrFetcher photosInPlace:[self.topPlaces objectAtIndex:1] maxResults:20]);
  [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topPlacesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.topPlaces objectAtIndex:indexPath.row] objectForKey:@"_content"];
    return cell;
}
 
#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  NSLog(@"got here");
//  [self performSegueWithIdentifier:@"showListOfPictures" sender:self];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showListOfPictures"]) {
//    NSLog(@"segue for showTopPlaces hit");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
    [segue.destinationViewController setPlace:place];
//    NSLog(@"place is: %@", self.place);
//    UITableView *tableView = ([segue.destinationViewController]
//    [self performSegueWithIdentifier:@"showListOfPictures" sender:self];

  }
}

@end
