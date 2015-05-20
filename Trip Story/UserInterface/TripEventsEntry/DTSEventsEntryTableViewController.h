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
#import "DTSAddEventDelegate.h"
#import "DTSEventsEntryDeleteView.h"

@protocol DTSEventsEntryTableViewControllerDelegate <NSObject>

- (void)eventDeleteButtonTapped:(DTSEvent *)event;

@end

@interface DTSEventsEntryTableViewController : UITableViewController <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,DTSEntryTableViewCellDelegate,DTSModalDismissProtocol,DTSEventsEntryDeleteViewProtocol>

@property (nonatomic, strong) UIImage *blurredBackgroundImage;
@property (nonatomic, strong) DTSEvent *event;
@property (nonatomic, weak) id<DTSModalDismissProtocol> dismissDelegate;
@property (nonatomic, weak) id<DTSAddEventDelegate> addEventDelegate;
@property (nonatomic, weak) id<DTSEventsEntryTableViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) BOOL isNewEvent;

@end
