//
//  GraphingViewController.h
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphingViewController : UIViewController {
  UILabel *equation;
}

@property (nonatomic, weak) CalculatorBrain *brain; 
@property (retain, nonatomic) IBOutlet UILabel *equation;

@end