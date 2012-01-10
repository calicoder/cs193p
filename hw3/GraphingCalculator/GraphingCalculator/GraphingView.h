//
//  GraphingView.h
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphingView;

@protocol GraphingViewDataSource
- (double)yForX:(double)X;
@end

@interface GraphingView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@property (nonatomic, weak) IBOutlet id <GraphingViewDataSource> dataSource;

@end
