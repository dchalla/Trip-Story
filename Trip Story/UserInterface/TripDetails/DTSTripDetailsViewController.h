//
//  DKCViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/2/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSModalDismissProtocol.h"
#import "DTSAddEventDelegate.h"
#import "DTSTripDetailsContainerDelegate.h"
#import "DTSViewLayoutProtocol.h"
#import "DTSTripDetailsProtocol.h"
#import "DTSTrip.h"
#import "DTSCreateTripViewController.h"
#import "DTSEventsEntryTableViewController.h"
#import "DTSAnalyticsProtocol.h"
#import <Google/Analytics.h>


@interface DTSTripDetailsViewController : UIViewController<DTSModalDismissProtocol, DTSAddEventDelegate,DTSTripDetailsContainerDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,DTSCreateTripViewControllerProtocol, DTSEventsEntryTableViewControllerDelegate, DTSAnalyticsProtocol>

@property (nonatomic, strong) DTSTrip *trip;

- (void)refreshView;

@end
