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

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
  if (!_scale) {
    return DEFAULT_SCALE; // don't allow zero scale
  } else {
    return _scale;
  }
}

- (void)viewDidLoad
{
  NSLog(@"VIEW DID LOAD");
}

- (void)setScale:(CGFloat)scale
{
  if (scale != _scale) {
    _scale = scale;
    [self setNeedsDisplay]; // any time our scale changes, call for redraw
  }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
  if ((gesture.state == UIGestureRecognizerStateChanged) ||
      (gesture.state == UIGestureRecognizerStateEnded)) {
    self.scale *= gesture.scale; // adjust our scale
    gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
  }
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
  UIGraphicsPushContext(context);
  CGContextBeginPath(context);
  CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); // 360 degree (0 to 2pi) arc
  CGContextStrokePath(context);
  UIGraphicsPopContext();
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

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGPoint midPoint; // center of our bounds in our coordinate system
  midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
  midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;

  CGFloat size = self.bounds.size.width;  
  if (self.bounds.size.height > self.bounds.size.width) {
    size = self.bounds.size.height;
  } 
  size *=size * self.scale;

  [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:size];
  
  double upperXBound = 100.0;  
  for (double i = 0.0; i < upperXBound; i++) {  
    NSLog(@"i is %f", i);
    NSLog(@"y for i is %f", [self.dataSource yForX:i]);
  }

  CGContextBeginPath(context);
  CGContextSetLineWidth(context, 2.0);
  [[UIColor blueColor] setStroke];
  CGContextMoveToPoint(context, midPoint.x, midPoint.y);
  CGContextAddLineToPoint(context, 1, 1);
  CGContextStrokePath(context);
}

@end
