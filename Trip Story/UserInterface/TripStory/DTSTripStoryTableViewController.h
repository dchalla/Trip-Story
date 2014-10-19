//
//  DTSTripStoryTableViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/2/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"
#import "DTSTripDetailsViewControllerProtocol.h"
#import "DTSTripDetailsContainerDelegate.h"
#import "DTSViewLayoutProtocol.h"
#import "DTSTripDetailsProtocol.h"

@interface DTSTripStoryTableViewController : UITableViewController<DTSTripDetailsViewControllerProtocol, DTSViewLayoutProtocol, DTSTripDetailsProtocol>

@property (nonatomic, weak) id<DTSTripDetailsContainerDelegate> containerDelegate;
- (void)refreshView;
@end
