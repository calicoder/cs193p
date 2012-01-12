//
//  CalculatorViewController.h
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate> {
  UILabel *display;
  UILabel *equation;
  UILabel *variables;
  UILabel *history;
}

@property (nonatomic, retain) IBOutlet UILabel *history;
@property (nonatomic, retain) IBOutlet UILabel *display;
@property (nonatomic, retain) IBOutlet UILabel *equation;
@property (nonatomic, retain) IBOutlet UILabel *variables;
@end
