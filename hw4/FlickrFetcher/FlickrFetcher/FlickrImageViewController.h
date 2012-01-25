//
//  FlickrImageViewController.h
//  FlickrFetcher
//
//  Created by Andrew Shin on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrImageViewController : UIViewController {
  UILabel *imageTitle;
}

@property (nonatomic, strong) NSDictionary *photo;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@end
