//
//  CraigskitWebViewController.m
//  GraphingCalculator
//
//  Created by Andrew Shin on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CraigskitWebViewController.h"

@interface CraigskitWebViewController()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation CraigskitWebViewController 

@synthesize webView = _webView;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.webView.scalesPageToFit = YES;
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
}

@end
