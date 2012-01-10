//
//  GraphingViewController.m
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import "GraphingViewController.h"
#import "GraphingView.h"

@interface GraphingViewController() <GraphingViewDataSource>
@property (nonatomic, weak) IBOutlet GraphingView *graphingView;
@end

@implementation GraphingViewController

@synthesize brain = _brain;
@synthesize equation = _equation;
@synthesize graphingView = _graphingView;

- (void) setGraphingView:(GraphingView *)graphingView {
  _graphingView = graphingView;
  self.graphingView.dataSource = self;
  self.equation.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}

- (double)yForX:(double)X {
  return [CalculatorBrain runProgram:[self.brain program] usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:X], @"x", nil]];
}

@end
