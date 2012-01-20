//
//  GraphingViewController.h
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "FavoritesViewController.h"
#import "GraphingView.h"

@interface GraphingViewController : UIViewController <GraphingViewDataSource,SplitViewBarButtonItemPresenter>   

@property (nonatomic, weak) IBOutlet GraphingView *graphingView;
@property (nonatomic, strong) NSArray *program; 
@property (weak, nonatomic) IBOutlet UILabel *equation;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end