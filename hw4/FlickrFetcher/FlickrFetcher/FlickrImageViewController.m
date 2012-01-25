//
//  FlickrImageViewController.m
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrImageViewController.h"
#import "FlickrFetcher.h"

@interface FlickrImageViewController() <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FlickrImageViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize photo = _photo;
@synthesize imageTitle = _imageTitle;

- (void) setPhoto:(NSDictionary *)photo {
  _photo = photo;
  self.title = [photo valueForKey:@"title"];
}

- (void) getAndSetImage {
  NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
  imageView.image = image;
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
  [super viewDidLoad];
    [self getAndSetImage];
  self.imageTitle.text = [self.photo objectForKey:@"title"];
  scrollView.contentSize = imageView.image.size;
  imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    scrollView.delegate = self;
} 

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setInitialZoom];
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
  [super viewDidUnload];
}
@end
