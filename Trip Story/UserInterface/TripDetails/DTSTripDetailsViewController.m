//
//  DKCViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/2/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripDetailsViewController.h"
#import "DTSTripStoryTableViewController.h"
#import "DTSEvent.h"
#import "DTSLocation.h"
#import "NSDate+Utilities.h"
#import "DTSTrip.h"
#import "DTSEventsEntryTableViewController.h"
#import "UIView+Utilities.h"

@interface DTSTripDetailsViewController ()

@property (nonatomic, strong) DTSTripStoryTableViewController *tripStoryVC;
@property (nonatomic, strong) DTSTrip *trip;

@end

@implementation DTSTripDetailsViewController

- (DTSTripStoryTableViewController *)tripStoryVC
{
	if (!_tripStoryVC)
	{
		_tripStoryVC = [[DTSTripStoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	return _tripStoryVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEventButtonTapped)];
	[self.navigationItem setRightBarButtonItem:addBarButton];
	
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
	self.view.backgroundColor = [UIColor colorWithRed:15/255.0 green:17/255.0 blue:22/255.0 alpha:1];
	[self.view addSubview:self.tripStoryVC.view];
	[self addChildViewController:self.tripStoryVC];
	//Testing
	self.trip = [[DTSTrip alloc] init];
	[self. trip createDummyEventsList];
	//End testing
	self.tripStoryVC.trip = self.trip;
	self.tripStoryVC.view.frame = self.view.frame;
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	self.title = @"My Trip";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.tripStoryVC.view.frame = self.view.frame;
}

#pragma mark - add event

- (void)addEventButtonTapped
{
	
	DTSEventsEntryTableViewController *eventsEntryVC = [[DTSEventsEntryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	eventsEntryVC.dismissDelegate = self;
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:eventsEntryVC];
	[navVC.navigationBar setBarTintColor:[UIColor blackColor]];
	navVC.transitioningDelegate = eventsEntryVC;
	eventsEntryVC.blurredBackgroundImage = [self.view dts_darkBlurredSnapshotImage];
	[self presentViewController:navVC animated:YES completion:^{
		
	}];
	
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

@end
