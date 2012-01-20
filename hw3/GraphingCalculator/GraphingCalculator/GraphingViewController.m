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
#import "FavoritesViewController.h"

@implementation GraphingViewController

@synthesize program = _program;
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

- (void) setProgram:(NSArray *)program {
  NSLog(@"set program called with program: %@",program);
  _program = program;
  self.equation.text = [CalculatorBrain descriptionOfProgram:self.program];
  self.graphingView.dataSource = self;
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

#define FAVORITES_KEY @"GraphingViewController.Favorites"

- (IBAction)pressAddToFavorites:(id)sender {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
  if(!favorites) favorites = [NSMutableArray array];
  if(self.program) [favorites addObject:self.program];
  [defaults setObject:favorites forKey:FAVORITES_KEY];
  [defaults synchronize]; 
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"ShowFavorites"]) {
    [[segue destinationViewController] setPrograms:[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY]];
    [[segue destinationViewController] setDelegate:self];
  }
}

- (void)favoritesViewControllerDelegate:(FavoritesViewController *)sender choseProgram:(id)program {
  self.program = program;
}

- (double)yForX:(double)X {
  return [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:X], @"x", nil]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

@end