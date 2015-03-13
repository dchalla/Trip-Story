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
#import "DTSTripDetailsMapViewController.h"
#import "HMSegmentedControl.h"
#import "DTSTripEventsViewController.h"
#import "UIColor+Utilities.h"


@interface DTSTripDetailsViewController ()

@property (nonatomic, strong) DTSTripStoryTableViewController *tripStoryVC;
@property (nonatomic, strong) DTSTripDetailsMapViewController *tripMapVC;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *pagedViewControllers;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) DTSTripEventsViewController *tripEventsVC;

@end

@implementation DTSTripDetailsViewController

- (DTSTripStoryTableViewController *)tripStoryVC
{
	if (!_tripStoryVC)
	{
		_tripStoryVC = [[DTSTripStoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
		_tripStoryVC.containerDelegate = self;
	}
	return _tripStoryVC;
}

- (DTSTripDetailsMapViewController *)tripMapVC
{
	if (!_tripMapVC)
	{
		_tripMapVC = [[DTSTripDetailsMapViewController alloc] init];
	}
	return _tripMapVC;
}

- (DTSTripEventsViewController *)tripEventsVC
{
	if (!_tripEventsVC)
	{
		_tripEventsVC = [[DTSTripEventsViewController alloc] initWithCollectionViewLayout:[[TGLStackedLayout alloc] init]];
		_tripEventsVC.stackedLayout.layoutMargin = UIEdgeInsetsZero;
		_tripEventsVC.exposedLayoutMargin = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
	}
	return _tripEventsVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupBackBarButton];
	UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEventButtonTapped)];
	[self.navigationItem setRightBarButtonItem:addBarButton];
	
	// Do any additional setup after loading the view, typically from a nib.
	//self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
	self.view.backgroundColor = [UIColor primaryColor];
	
	[self setupSegmentControl];
	
	self.pagedViewControllers = @[self.tripStoryVC,self.tripEventsVC,self.tripMapVC];
	self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@1}];
	self.pageVC.delegate = self;
	self.pageVC.dataSource = self;
	[self.pageVC setViewControllers:@[self.pagedViewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){}];
	
	
	[self addChildViewController:self.pageVC];
	[self.view addSubview:self.pageVC.view];
	[self.pageVC didMoveToParentViewController:self];
	
	for (UIViewController *vc in self.pagedViewControllers)
	{
		if ([vc conformsToProtocol:@protocol(DTSViewLayoutProtocol)])
		{
			
			[vc setValue:@(self.navigationController.navigationBar.frame.size.height) forKey:@"topLayoutGuideLength"];
			[vc setValue:@0 forKey:@"bottomLayoutGuideLength"];
		}
	}
	
	if (!self.trip)
	{
		//Testing
		self.trip = [DTSTrip object];
		[self.trip createDummyEventsList];
		[self saveTripToParse];
		//End testing
	}
	
	for (UIViewController *vc in self.pagedViewControllers)
	{
		if ([vc conformsToProtocol:@protocol(DTSTripDetailsProtocol)])
		{
			[vc setValue:self.trip forKey:@"trip"];
		}
	}
}

- (void)setupSegmentControl
{
	self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Story", @"Events", @"Map"]];
	self.segmentedControl.frame = CGRectMake(0, 0, 200, 30);
	self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	[self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	self.segmentedControl.backgroundColor = [UIColor clearColor];
	self.segmentedControl.textColor = [UIColor whiteColor];
	self.segmentedControl.font = [UIFont systemFontOfSize:12];
	self.segmentedControl.selectedTextColor = [UIColor whiteColor];
	self.segmentedControl.selectionIndicatorColor = [UIColor selectionColor];
	self.navigationItem.titleView = self.segmentedControl;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.tripStoryVC.view.frame = self.view.frame;
}

#pragma mark - add event

- (void)addEventButtonTapped
{
	
	DTSEvent *event = [self.trip newEvent];
	[self showUpdateEventWithEvent:event isNew:YES];
	
}

- (void)showUpdateEventWithEvent:(DTSEvent *)event isNew:(BOOL)isNew
{
	DTSEventsEntryTableViewController *eventsEntryVC = [[DTSEventsEntryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	eventsEntryVC.event = event;
	eventsEntryVC.dismissDelegate = self;
	eventsEntryVC.addEventDelegate = self;
	eventsEntryVC.isNewEvent = isNew;
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:eventsEntryVC];
	[navVC.navigationBar setBarTintColor:[UIColor blackColor]];
	navVC.transitioningDelegate = eventsEntryVC;
	eventsEntryVC.blurredBackgroundImage = [self.view dts_darkBlurredSnapshotImage];
	[self presentViewController:navVC animated:YES completion:^{
		
	}];
}

- (void)didAddEvent:(DTSEvent *)event isNew:(BOOL)isNew
{
	if (isNew)
	{
		[self.trip addEvent:event];
	}
	else
	{
		[self.trip fillInPlaceholderEvents];
	}
	[self.tripStoryVC refreshView];
	[self saveTripToParse];
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

#pragma mark - containerDelegate
- (void)showNewEventEntry
{
	
}

- (void)showEditEventEntryAtIndex:(NSInteger)index
{
	DTSEvent *event = self.trip.eventsList[index];
	BOOL isNew = event.isPlaceHolderEvent;
	[self showUpdateEventWithEvent:event isNew:isNew];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	int afterVCIndex = -1;
	int i =0;
	for (UIViewController *vc in self.pagedViewControllers)
	{
		if (vc == viewController)
		{
			afterVCIndex = i+1;
			break;
		}
		i++;
	}
	if (afterVCIndex >=0 && afterVCIndex < self.pagedViewControllers.count)
	{
		return self.pagedViewControllers[afterVCIndex];
	}
	return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	int beforeVCIndex = -1;
	int i =0;
	for (UIViewController *vc in self.pagedViewControllers)
	{
		if (vc == viewController)
		{
			beforeVCIndex = i-1;
			break;
		}
		i++;
	}
	if (beforeVCIndex >=0 && beforeVCIndex < self.pagedViewControllers.count)
	{
		return self.pagedViewControllers[beforeVCIndex];
	}
	return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	if (completed)
	{
		[self.segmentedControl setSelectedSegmentIndex:[self currentPageVCIndex] animated:YES];
	}
}

- (NSInteger)currentPageVCIndex
{
	NSInteger i =0;
	for (UIViewController *vc in self.pagedViewControllers)
	{
		if (vc == self.pageVC.viewControllers.firstObject)
		{
			break;
		}
		i++;
	}
	return i;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
	if (segmentedControl.selectedSegmentIndex > self.pagedViewControllers.count-1)
	{//dont do anything if wrong index is given
		return;
	}
	NSInteger i = [self currentPageVCIndex];
	UIPageViewControllerNavigationDirection direction;
	if (i > segmentedControl.selectedSegmentIndex)
	{
		direction = UIPageViewControllerNavigationDirectionReverse;
	}
	else if (i < segmentedControl.selectedSegmentIndex)
	{
		direction = UIPageViewControllerNavigationDirectionForward;
	}
	else
	{
		return;
	}
	
	
	[self.pageVC setViewControllers:@[self.pagedViewControllers[segmentedControl.selectedSegmentIndex]] direction:direction animated:YES completion:^(BOOL finished){}];
}

#pragma mark - saveTrip

- (void)saveTripToParse
{
	self.trip.user = [PFUser currentUser];
	
	PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
	[photoACL setPublicReadAccess:YES];
	self.trip.ACL = photoACL;
	
	[self.trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			// The object has been saved.
			NSLog(@"Succeeded");
		} else {
			// There was a problem, check error.description
			NSLog(@"Failed");
		}
	}];
}

#pragma mark - backBarButton
- (void)setupBackBarButton
{
	UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
								initWithTitle:@""
								style:UIBarButtonItemStylePlain
								target:nil
								action:nil];
	//[self.navigationItem setBackBarButtonItem:btnBack];
}

@end
