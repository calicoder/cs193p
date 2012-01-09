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
@synthesize graphingView = _graphingView;

- (void) setBrain:(CalculatorBrain *)brain {
  _brain = brain;

  NSLog(@"self is %@", self);
  NSLog(@"self.graphingView is %@", self.graphingView);
  NSLog(@"self.graphingView.data soruce is %@", self.graphingView.dataSource);
}

- (void) setGraphingView:(GraphingView *)graphingView {
    self.graphingView.dataSource = self;
  NSLog(@"SETTING THE GRAPHING VIEW NOW");
  _graphingView = graphingView;
  self.graphingView.dataSource = self;
}

- (double)yForX:(double)X {
  NSLog(@"got to yForX %f", X);
  return [CalculatorBrain runProgram:[self.brain program] usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:X], @"x", nil]];
}

@end
