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
@synthesize toolbar = _toolbar;
@synthesize graphingView = _graphingView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {

  if (_splitViewBarButtonItem != splitViewBarButtonItem) {
    NSMutableArray *items = [self.toolbar.items mutableCopy];
    if(_splitViewBarButtonItem) [items removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [items insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = items;
    _splitViewBarButtonItem = splitViewBarButtonItem;    
  }  
}

- (void) setBrain:(CalculatorBrain *)brain {
    _brain = brain;
  self.equation.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
  [self.view setNeedsDisplay];
}

- (void) setGraphingView:(GraphingView *)graphingView {
  _graphingView = graphingView;
  self.graphingView.dataSource = self;
  
  //pinch
  UIPinchGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:graphingView action:@selector(pinch:)];
  [graphingView addGestureRecognizer:pinchgr];
  
  //pan
  UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:graphingView action:@selector(pan:)];
  [graphingView addGestureRecognizer:pangr];
  
  //triple tap
  UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:graphingView action:@selector(tripleTap:)];
  tapgr.numberOfTapsRequired = 3;
  [graphingView addGestureRecognizer:tapgr];
}

- (double)yForX:(double)X {
  return [CalculatorBrain runProgram:[self.brain program] usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:X], @"x", nil]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}
@end
