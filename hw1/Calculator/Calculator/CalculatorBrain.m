//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Andrew Shin on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, retain) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;
- (NSMutableArray *)operandStack 
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (double)popOperand 
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
} 

- (void)pushOperand: (double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];   
}

- (double)performOperation: (NSString *)operation
{
    double result = 0;
    double first = 0;
 
    if([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    }
    else if([operation isEqualToString:@"*"]){
        result = [self popOperand] * [self popOperand];
    }
    else if([operation isEqualToString:@"/"]){
        first = [self popOperand];
        result = [self popOperand] / first ;
    }
    else if([operation isEqualToString:@"-"]){
        first = [self popOperand];
        result = [self popOperand] - first;
    }
    else if([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    }
    else if([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
    }
    else if([operation isEqualToString:@"π"]){
        result = 3.1415;
    }
    else if([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    }
    
    [self pushOperand:result];
    
    return result;
}

- (void)clearOperands {
    [self.operandStack removeAllObjects];
}

@end
