//
//  DTSEventsEntryTableViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"
#import "DTSModalDismissProtocol.h"
#import "DTSEntryTableViewCellDelegate.h"

@interface DTSEventsEntryTableViewController : UITableViewController <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,DTSEntryTableViewCellDelegate,DTSModalDismissProtocol>

@property (nonatomic, strong) UIImage *blurredBackgroundImage;
@property (nonatomic, strong) DTSEvent *event;
@property (nonatomic, weak) id<DTSModalDismissProtocol> dismissDelegate;
@property (nonatomic, assign) BOOL presenting;

@end
