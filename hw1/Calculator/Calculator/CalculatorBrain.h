//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Andrew Shin on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand: (double)operand;
- (double)performOperation: (NSString *)operation;
- (void)clearOperands;

@end
