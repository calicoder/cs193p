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
@end

//class
@implementation CalculatorViewController

//public/private setters and getters
@synthesize equation = _equation;
@synthesize display = _display; 
@synthesize history = _history;
@synthesize userIsInTheMiddleOfTypingADigit = _userIsInTheMiddleOfTypingADigit;
@synthesize brain = _brain;
@synthesize userHasTypedADecimal = _userHasTypedADecimal;

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

- (void)dealloc {
    [_equation release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEquation:nil];
    [super viewDidUnload];
}
@end
