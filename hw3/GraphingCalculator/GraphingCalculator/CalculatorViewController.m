//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Andrew Shin on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphingViewController.h"

//private properties interface
@interface CalculatorViewController()
@property (nonatomic, retain) CalculatorBrain *brain;
@property (nonatomic) BOOL userIsInTheMiddleOfTypingADigit; 
@property (nonatomic) BOOL userHasTypedADecimal;
@property (nonatomic, retain) NSDictionary *testVariableValues;
@end

//class
@implementation CalculatorViewController

//public/private setters and getters
@synthesize equation = _equation;
@synthesize variables = _variables;
@synthesize display = _display; 
@synthesize history = _history;
@synthesize userIsInTheMiddleOfTypingADigit = _userIsInTheMiddleOfTypingADigit;
@synthesize brain = _brain;
@synthesize userHasTypedADecimal = _userHasTypedADecimal;
@synthesize testVariableValues = _testVariableValues;

//setters and getters overrides
- (CalculatorBrain *) brain {
  if (!_brain) _brain = [[CalculatorBrain alloc] init];
  return _brain;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [segue.destinationViewController setBrain:self.brain];   
}

//instance methods
- (void)appendHistory:(NSString *)newHistory {
  self.history.text = [[self.history.text stringByAppendingString:@" "] stringByAppendingString:newHistory];
}

- (void)printVariables {
  NSString *result = @"";
  NSSet *possibleVariables = [CalculatorBrain variablesUsedInProgram:[self.brain program]];
  
  for (id possibleVariable in possibleVariables) {
    NSNumber *value = [self.testVariableValues valueForKey:possibleVariable];
    
    if (!value) {
      value = [NSNumber numberWithInt:0];
    }
    result = [[[[result stringByAppendingString:possibleVariable] stringByAppendingString:@"="] stringByAppendingString:[value stringValue]] stringByAppendingString:@" "];
  }
  self.variables.text = result;
}

- (IBAction)decimalPressed {
  if (!self.userHasTypedADecimal) 
  {
    if (self.userIsInTheMiddleOfTypingADigit) {
      self.display.text = [self.display.text stringByAppendingString:@"."];
    } 
    else {
      self.display.text = @"0.";
    }
  }
  
  self.userIsInTheMiddleOfTypingADigit = YES;
  self.userHasTypedADecimal = YES;
}

- (IBAction)clearPressed {
  self.display.text = @"0";
  self.history.text = @"";
  self.equation.text = @"";
  self.userHasTypedADecimal = NO;
  self.userIsInTheMiddleOfTypingADigit = NO;
  [self.brain clearOperands];
}

- (IBAction)undoPressed:(UIButton *)sender {
  if (self.userIsInTheMiddleOfTypingADigit) {
    if ( [self.display.text length] > 0) {
      self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    }
    else {
      self.userIsInTheMiddleOfTypingADigit = NO;
      self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues]];
    }
  }
  else {
    [self.brain popOperand];
    self.equation.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
  }
}

- (IBAction)enterPressed {
  [self.brain pushOperand:[self.display.text doubleValue]];
  [self appendHistory:self.display.text];
  self.userIsInTheMiddleOfTypingADigit = NO;
  self.userHasTypedADecimal = NO;
  [self printVariables];
}

- (IBAction)variablePressed:(UIButton *)sender {
  if (self.userIsInTheMiddleOfTypingADigit) [self enterPressed];
  self.display.text = sender.currentTitle;
  [self.brain pushVariable:sender.currentTitle];
  [self appendHistory:sender.currentTitle];
  self.userIsInTheMiddleOfTypingADigit = NO;
  self.userHasTypedADecimal = NO;    
}

- (IBAction)graphPressed {
    [self performSegueWithIdentifier:@"ShowGraph" sender:self];
}

- (IBAction)operationPressed:(UIButton *)sender {
  if (self.userIsInTheMiddleOfTypingADigit) [self enterPressed];
  
  [self.brain performOperation: sender.currentTitle];
  NSString *resultString = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues]];
  
  [self appendHistory:sender.currentTitle];
  self.display.text = resultString;
  self.equation.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
  [self printVariables];
}

- (IBAction)digitPressed:(UIButton *)sender {
  NSString *digit = sender.currentTitle;
  
  if(self.userIsInTheMiddleOfTypingADigit) {
    self.display.text = [self.display.text stringByAppendingString:digit];
  }
  else {
    self.display.text = digit;
  }
  self.userIsInTheMiddleOfTypingADigit = YES;
}

- (IBAction)testPressed:(UIButton *)sender {
  if ([sender.currentTitle isEqualToString:@"Test 1"]) {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"x", [NSNumber numberWithInt:2], @"y", [NSNumber numberWithInt:0], @"z", nil];
  } else if ([sender.currentTitle isEqualToString:@"Test 2"]) {
    self.testVariableValues = nil;
  } else if ([sender.currentTitle isEqualToString:@"Test 3"]) {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1.41], @"x", [NSNumber numberWithInt:2], @"y", [NSNumber numberWithDouble:1.4], @"z", nil];
  }
  self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues]];
  [self printVariables];
}

@end
