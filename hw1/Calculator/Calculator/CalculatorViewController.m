//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Andrew Shin on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

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

//instance methods
- (void)appendHistory:(NSString *)newHistory {
    self.history.text = [self.history.text stringByAppendingString:@" "];
    self.history.text = [self.history.text stringByAppendingString:newHistory];
}

- (void)printVariables {
    NSSet *possibleVariables = [CalculatorBrain variablesUsedInProgram:[self.brain program]];
    NSLog(@"possibleVariables is: %@", possibleVariables);
    NSLog(@"possibleVariables a: %@", [possibleVariables class]);

    NSString *result = @"";
    
    for (id possibleVariable in possibleVariables) {
        NSLog(@"possibleVariable is: %@", possibleVariable);
        NSLog(@"possibleVariable a: %@", [possibleVariable class]);
        NSNumber *value = [self.testVariableValues valueForKey:possibleVariable];
        
        if (!value) {
            value = [NSNumber numberWithInt:0];
        }
            NSLog(@"result is a: %@", [value class]);  
        
        result = [[[[result stringByAppendingString:possibleVariable] stringByAppendingString:@"="] stringByAppendingString:[value stringValue]] stringByAppendingString:@" "];
    }
    NSLog(@"result is: %@", result);
    NSLog(@"result is a: %@", [result class]);    
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

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self appendHistory:self.display.text];
    self.userIsInTheMiddleOfTypingADigit = NO;
    self.userHasTypedADecimal = NO;
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTypingADigit) [self enterPressed];
    self.display.text = sender.currentTitle;
    [self.brain pushVariable:sender.currentTitle];
    [self appendHistory:sender.currentTitle];
    self.userIsInTheMiddleOfTypingADigit = NO;
    self.userHasTypedADecimal = NO;    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTypingADigit) [self enterPressed];
    
    double result = [self.brain performOperation: sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    
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
    NSString *test = sender.currentTitle;
    if ([test isEqualToString:@"Test 1"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"x", [NSNumber numberWithInt:2], @"y", [NSNumber numberWithInt:0], @"z", nil];
    } else if ([test isEqualToString:@"Test 2"]) {
        self.testVariableValues = nil;
    } 
        
    self.brain.variableValues = self.testVariableValues;
    [self printVariables];
}

@end
