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
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation FlickrImageViewController 
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;
@synthesize toolbar = _toolbar;
@synthesize imageTitle = _imageTitle;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

-(void) setScrollView:(UIScrollView *)scrollView {
  if (_scrollView != scrollView) {
    _scrollView = scrollView;
    self.scrollView.delegate = self;
  }
}

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

- (void)setInitialZoom
{
	CGSize scrollSize = self.scrollView.bounds.size;
	CGFloat widthRatio = scrollSize.width / self.imageView.image.size.width;
	CGFloat heightRatio = scrollSize.height / self.imageView.image.size.height;
	CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
	self.scrollView.minimumZoomScale = initialZoom;
	self.scrollView.maximumZoomScale = 2.0;
	self.scrollView.zoomScale = 1;
  self.scrollView.contentSize = self.imageView.image.size;
	self.scrollView.zoomScale = initialZoom;
  self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (UIImage *)imageFromCacheOrFlickr {
  //gets image from flickr if it does not exist
  NSFileManager *manager = [[NSFileManager alloc] init];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths lastObject]; 
  NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, [self.photo valueForKey:@"id"]]; 
  UIImage *image = nil;
  
  if ([manager fileExistsAtPath:path]) {
    //get file and set image
    image = [UIImage imageWithData:[manager contentsAtPath:path]];
  }
  else {
    //download file, save file, and set image
    NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];        
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [imageData writeToFile:path atomically:NO];
  }
  return image;
}

- (void) getAndSetImage {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];  
  NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
  [toolbarItems addObject:[[UIBarButtonItem alloc]initWithCustomView:spinner]];
  self.toolbar.items = toolbarItems;
  
  dispatch_queue_t downloadQueue = dispatch_queue_create("imageDownloader", NULL);
  dispatch_async(downloadQueue, ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [spinner stopAnimating];
      [toolbarItems removeLastObject];
      self.toolbar.items = toolbarItems;
      self.imageView.image = [self imageFromCacheOrFlickr];
      [self setInitialZoom];
    });
  });
  dispatch_release(downloadQueue);
}

- (void) setPhoto:(NSDictionary *)photo {
  if(_photo !=photo) {
    _photo = photo;
    self.title = [photo valueForKey:@"title"];
    self.imageTitle.text = [self.photo objectForKey:@"title"]; 
    [self getAndSetImage];
  }
}

- (void) viewWillAppear:(BOOL)animated {
  [self getAndSetImage];
  [self setInitialZoom];
  [super viewWillAppear:animated];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView  {
  return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
}

- (void)viewDidUnload {
  [self setImageView:nil];
  [self setScrollView:nil];
  [self setToolbar:nil];
  [super viewDidUnload];
}
@end
