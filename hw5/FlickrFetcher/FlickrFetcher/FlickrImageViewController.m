//
//  FlickrImageViewController.m
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrImageViewController.h"
#import "FlickrFetcher.h"

@interface FlickrImageViewController()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation FlickrImageViewController

@synthesize scrollView;
@synthesize imageView;
@synthesize photo = _photo;
@synthesize toolbar = _toolbar;
@synthesize imageTitle = _imageTitle;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

-(void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
  if (_splitViewBarButtonItem != splitViewBarButtonItem) {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem)  {
      [toolbarItems insertObject:splitViewBarButtonItem atIndex:0]; 
    }
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
  }
}

- (void) getAndSetImage {
  NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
  imageView.image = image;
}

- (void) setPhoto:(NSDictionary *)photo {
  _photo = photo;
  self.title = [photo valueForKey:@"title"];
  [self.view setNeedsDisplay];
}

- (void)setInitialZoom
{
	CGSize scrollSize = self.scrollView.bounds.size;
	CGFloat widthRatio = scrollSize.width / self.imageView.image.size.width;
	CGFloat heightRatio = scrollSize.height / self.imageView.image.size.height;
	CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
	self.scrollView.minimumZoomScale = initialZoom;
	self.scrollView.maximumZoomScale = 2.0;
	self.scrollView.zoomScale = initialZoom;
}
  
- (void) viewDidLoad {
    NSLog(@"view did load for flickr image view controller");
  [super viewDidLoad];
  self.imageTitle.text = [self.photo objectForKey:@"title"]; 
  [self getAndSetImage];
  scrollView.contentSize = imageView.image.size;
  imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
} 

- (void) viewWillAppear:(BOOL)animated {
  NSLog(@"view will appear");
  [self setInitialZoom];
  [super viewWillAppear:animated];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView  {
  return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return true;
}

- (void)viewDidUnload {
  [self setImageView:nil];
  [self setScrollView:nil];
  [self setToolbar:nil];
  [super viewDidUnload];
}
@end
