//
//  DTSSearchRootViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 6/2/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSegmentedViewController.h"
#import <Parse/Parse.h>

@interface DTSSearchRootViewController : DTSSegmentedViewController <UISearchBarDelegate>
@property (nonatomic, strong) PFUser *user;
@end
