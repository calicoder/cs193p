//
//  GraphingViewController.h
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphingViewController : UIViewController <SplitViewBarButtonItemPresenter> 

@property (nonatomic, weak) CalculatorBrain *brain; 
@property (weak, nonatomic) IBOutlet UILabel *equation;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end