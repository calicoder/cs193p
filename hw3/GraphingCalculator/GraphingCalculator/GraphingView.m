//
//  GraphingView.m
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphingView.h"
#import "AxesDrawer.h"

@implementation GraphingView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

#define DEFAULT_SCALE 10.0

- (CGPoint)origin {
  if (!(_origin.x && _origin.y)) {
    return CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
  }
  else {
    return _origin;
  }
}

- (void)setOrigin:(CGPoint)origin {
  if (origin.x != _origin.x && origin.y != _origin.y) {
    _origin = origin;
  } 
  [self setNeedsDisplay];
}

- (CGFloat)scale
{
  if (!_scale) {
    return DEFAULT_SCALE; // don't allow zero scale
  } else {
    return _scale;
  }
}

- (void)setScale:(CGFloat)scale
{
  if (scale != _scale) {
    _scale = scale;
    [self setNeedsDisplay]; // any time our scale changes, call for redraw
  }
}

- (void)setup
{
  self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
  [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
  }
  return self;
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
    self.scale *= recognizer.scale;
    recognizer.scale = 1.0;
  }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
  
  if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
    CGPoint translation = [recognizer translationInView:self];
    self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self];
  }
}

- (void)tripleTap:(UITapGestureRecognizer *)recognizer {
  if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
    self.origin = [recognizer locationInView:self];
  }
}

- (double)cartesianXFromViewX:(double)viewX {
  double half_width = self.bounds.size.width / 2;
  double xOffset = self.origin.x - half_width;
  return (viewX - half_width - xOffset)/self.scale;  
}

- (double)viewYFromCartesianY:(double)cartesianY {
  double half_height = self.bounds.size.height / 2;  
  double yOffset = self.origin.y - half_height;
  return half_height + yOffset - cartesianY*self.scale;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];

  CGContextBeginPath(context);
  [[UIColor blueColor] setStroke];
  CGContextSetLineWidth(context, 2.0);
  double width = self.bounds.size.width * self.contentScaleFactor;  
  double half_width = width/2;  
  
  CGContextMoveToPoint(context, 0, [self.dataSource yForX:-half_width]);  
  for (double x = 0.0; x < width; x++) {
    double cartesianX = [self cartesianXFromViewX:x];    
    CGContextAddLineToPoint(context, x, [self viewYFromCartesianY:[self.dataSource yForX:cartesianX]]);
  }
  CGContextStrokePath(context);
}


@end
