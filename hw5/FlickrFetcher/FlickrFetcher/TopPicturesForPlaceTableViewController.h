//
//  TopPicturesForPlaceTableViewController.h
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECENT_PICTURES @"RecentPictures1"

@interface TopPicturesForPlaceTableViewController : UITableViewController <UISplitViewControllerDelegate>
@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSArray *topPictures;
@end
