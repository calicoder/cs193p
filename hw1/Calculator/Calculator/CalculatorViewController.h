//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Andrew Shin on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//public interface
@interface CalculatorViewController : UIViewController {
    UILabel *display;
    UILabel *history;
}

@property (nonatomic, retain) IBOutlet UILabel *display;
@property (nonatomic, retain) IBOutlet UILabel *history;

@end 