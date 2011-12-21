//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Andrew Shin on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, retain) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

- (NSMutableArray *)programStack 
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand: (double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];   
}

- (void)pushVariable:(NSString *)variable 
{
    [self.programStack addObject:variable];
}

+ (BOOL)isOperation:(NSString *)operation {
    NSSet *operations =  [NSSet setWithObjects: @"π", @"sin", @"cos", @"sqrt", @"+", @"*", @"/", @"-", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isZeroOperation:(NSString *)operation {
    NSSet *operations =  [NSSet setWithObjects: @"π", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isSingleOperation:(NSString *)operation {
    NSSet *operations =  [NSSet setWithObjects: @"sin", @"cos", @"sqrt", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isDoubleOperation:(NSString *)operation {
    NSSet *operations =  [NSSet setWithObjects: @"+", @"*", @"/", @"-", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isVariable:(NSString *)operation {
    NSSet *operations =  [NSSet setWithObjects: @"x", @"y", @"z", nil];
    return [operations containsObject:operation];
}

+ (double)popOperandOffStack: (NSMutableArray *)stack {
    double result;
    
    id topOfStack = [stack lastObject];
    
    if (topOfStack) {
        [stack removeLastObject];
        
        if ([topOfStack isKindOfClass:[NSNumber class]]) {
            result = [topOfStack doubleValue];            
        } 
        else if ([topOfStack isKindOfClass:[NSString class]]) {
            
            if([topOfStack isEqualToString:@"+"]) {
                result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
            }
            else if([topOfStack isEqualToString:@"*"]){
                result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
            }
            else if([topOfStack isEqualToString:@"/"]){
                double firstDivisor = [self popOperandOffStack:stack];
                result = [self popOperandOffStack:stack] / firstDivisor ;
            }
            else if([topOfStack isEqualToString:@"-"]){
                double firstMinuser = [self popOperandOffStack:stack];
                result = [self popOperandOffStack:stack] - firstMinuser;
            }
            else if([topOfStack isEqualToString:@"sin"]){
                result = sin([self popOperandOffStack:stack]);
            }
            else if([topOfStack isEqualToString:@"cos"]){
                result = cos([self popOperandOffStack:stack]);
            }
            else if([topOfStack isEqualToString:@"π"]){
                result = 3.1415;
            }
            else if([topOfStack isEqualToString:@"sqrt"]){
                result = sqrt([self popOperandOffStack:stack]);
            }
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
{
    id newProgram = [program mutableCopy];
    
    for (int i=0; i < [newProgram count]; i++) 
    {
        id operand = [newProgram objectAtIndex:i];        
        if([operand isKindOfClass:[NSString class]]) {
            if(![self isOperation:operand]) {
                [newProgram replaceObjectAtIndex:i withObject:[variableValues valueForKey:operand]];
            }    
        }
    }
    return [CalculatorBrain runProgram:newProgram];
}

+ (double)runProgram:(id)program
{    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

- (double)performOperation: (NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program
                   usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"x", [NSNumber numberWithInt:0], @"y", [NSNumber numberWithInt:0], @"z", nil]];
}
            
- (id)program 
{
    return [self.programStack copy];
}

+ (NSString *) descriptionOfTopOfStack:(id)program {
    NSString *result = @"";
    id topOfStack = [program lastObject];
    if (topOfStack) {
        [program removeLastObject];
        
        if ([topOfStack isKindOfClass:[NSNumber class]]) {
            result = [result stringByAppendingString:[topOfStack stringValue]];
        } 
        else if ([topOfStack isKindOfClass:[NSString class]]) {
            if ([self isVariable:topOfStack]) {
                result = [[[result stringByAppendingString:[self descriptionOfTopOfStack:program]] stringByAppendingString:@","] stringByAppendingString:topOfStack];
            } else if ([self isZeroOperation:topOfStack]) {
                result = [[[result stringByAppendingString:[self descriptionOfTopOfStack:program]] stringByAppendingString:@","] stringByAppendingString:topOfStack];

//                result = [result stringByAppendingString:topOfStack]; 
            } else if ([self isSingleOperation:topOfStack]) {
                result = [[[topOfStack stringByAppendingString:@"("] stringByAppendingString:[CalculatorBrain descriptionOfTopOfStack:program]] stringByAppendingString:@")"]; 
            } else if ([self isDoubleOperation:topOfStack]) {
                NSString *second = [self descriptionOfTopOfStack:program];
                NSString *first = [self descriptionOfTopOfStack:program];
                result = [[[[[result stringByAppendingString:@"("] stringByAppendingString:first] stringByAppendingString:topOfStack] stringByAppendingString:second] stringByAppendingString:@")"]; 
            } 
        }
    }
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program 
{
    NSMutableArray *stack = [program mutableCopy];
    NSLog(@"this is stack: %@", stack);
    return [self descriptionOfTopOfStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program 
{
    NSMutableArray *variables = [NSMutableArray arrayWithCapacity:0];
    
    for (id operand in program) 
    {
        if ([operand isKindOfClass:[NSString class]] && ![self isOperation:operand])
        {
            [variables addObject:operand];   
        }
    }

    if ([variables count] == 0) {
        return nil;
    }
    else {
        return variables;
    }
}

- (void)clearOperands {
    [self.programStack removeAllObjects];
}

@end
