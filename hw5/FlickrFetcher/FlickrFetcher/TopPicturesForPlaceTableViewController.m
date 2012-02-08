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
#import "SplitViewBarButtonItemProtocol.h"

@implementation TopPicturesForPlaceTableViewController 
@synthesize place = _place;
@synthesize topPictures = _topPictures;

- (void)setTopPictures:(NSArray *)topPictures {
  if (_topPictures != topPictures) {
    _topPictures = topPictures;
    [self.tableView reloadData];
  }
}

//when you wake up from a storyboard, try to make this controller the split view delegate
- (void)awakeFromNib {
  [super awakeFromNib];
  self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemProtocol>) splitViewBarButtonItemViewController {
  id detailedVC = [self.splitViewController.viewControllers lastObject];
  if (![detailedVC conformsToProtocol:@protocol(SplitViewBarButtonItemProtocol)]) {
    detailedVC = nil;
  } 
  return detailedVC;
}

- (void) setPlace:(NSDictionary *)place {
  if(_place != place) {
    _place = place;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloader = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloader, ^{
      NSArray *pictures = [FlickrFetcher photosInPlace:place maxResults:50];
      dispatch_async(dispatch_get_main_queue(), ^{
        [spinner stopAnimating];
        self.topPictures = pictures;
        self.title = [self.place valueForKey:@"_content"];
      });
    });
    dispatch_release(downloader);
  }
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
    static NSString *CellIdentifier = @"Cell";
    
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

- (void)addPictureToFavorites:(NSDictionary *)photo {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *recentPictures = [[defaults objectForKey:RECENT_PICTURES] mutableCopy];
  if (!recentPictures) recentPictures = [NSMutableArray array];
  [recentPictures addObject:photo];    
  [defaults setObject:recentPictures forKey:RECENT_PICTURES];
  [defaults synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *selectedPhoto = [self.topPictures objectAtIndex:indexPath.row];
  FlickrImageViewController *detailViewController = [self.splitViewController.viewControllers objectAtIndex:1];
  [self addPictureToFavorites:selectedPhoto];
  detailViewController.photo = [self.topPictures objectAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showNext"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *selectedPhoto = [self.topPictures objectAtIndex:indexPath.row];
    [self addPictureToFavorites:selectedPhoto];
    [segue.destinationViewController setPhoto:selectedPhoto];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return true;
}



@end
