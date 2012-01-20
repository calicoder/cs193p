//
//  FavoritesViewController.h
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesViewController;

@protocol FavoritesViewControllerDelegate <NSObject>
- (void) favoritesViewControllerDelegate:(FavoritesViewController *)sender 
                            choseProgram:(id)program;

@end

@interface FavoritesViewController : UITableViewController
@property (nonatomic, strong) NSArray *programs;
@property (nonatomic, weak) id  <FavoritesViewControllerDelegate> delegate;
@end
