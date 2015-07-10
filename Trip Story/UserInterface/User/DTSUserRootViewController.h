//
//  DTSUserRootViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSegmentedViewController.h"
#import <Parse/Parse.h>

@interface DTSUserRootViewController : DTSSegmentedViewController<UIActionSheetDelegate>
@property (nonatomic, strong) PFUser *user;
@end
