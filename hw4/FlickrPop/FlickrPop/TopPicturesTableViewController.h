//
//  TopPicturesTableViewController.h
//  FlickrPop
//
//  Created by Andrew Shin on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopPicturesTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSArray *photos;
@end
