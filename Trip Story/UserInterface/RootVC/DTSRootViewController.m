//
//  DTSRootViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSRootViewController.h"
#import "HMSegmentedControl.h"
#import "DTSTimelineRootViewController.h"
#import "UIColor+Utilities.h"
#import "DTSTrip.h"
#import "DTSUserAuthHelper.h"
#import "DTSFollowFriendsViewController.h"
#import "DTSUserRootViewController.h"
#import "UIView+Utilities.h"
#import "DTSCreateTripViewController.h"

#define DTS_SEGMENT_HEIGHT 44

@interface DTSRootViewController ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *pagedViewControllers;
@property (nonatomic, strong) DTSTimelineRootViewController *timeLineVC;
@property (nonatomic, strong) DTSCreateTripViewController *addTripVC;
@property (nonatomic, strong) DTSUserRootViewController *userVC;

@end

@implementation DTSRootViewController

- (DTSTimelineRootViewController *)timeLineVC
{
	if (!_timeLineVC)
	{
		_timeLineVC = [[DTSTimelineRootViewController alloc] init];
	}
	return _timeLineVC;
}

- (DTSCreateTripViewController *)addTripVC
{
	if (!_addTripVC)
	{
		_addTripVC = [[DTSCreateTripViewController alloc] init];
		_addTripVC.isCreateTripMode = YES;
	}
	return _addTripVC;
}

- (DTSUserRootViewController *)userVC
{
	if (!_userVC)
	{
		_userVC = [[DTSUserRootViewController alloc] init];
	}
	return _userVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupPageViewController];
	[self setupSegmentControl];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	[self updateSegmentFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
	[[DTSUserAuthHelper sharedManager] presentLoginModalIfNotLoggedIn];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;
}

#pragma mark - segmentControl

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

- (void)setupSegmentControl
{
	NSArray *sectionIcons = @[[[UIImage imageNamed:@"explore"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate], [[UIImage imageNamed:@"addTrip"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"users"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:sectionIcons sectionSelectedImages:sectionIcons];
	[self updateSegmentFrame];
	self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	[self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	self.segmentedControl.backgroundColor = [UIColor clearColor];
	self.segmentedControl.textColor = [UIColor whiteColor];
	self.segmentedControl.font = [UIFont systemFontOfSize:12];
	self.segmentedControl.selectedTextColor = [UIColor whiteColor];
	self.segmentedControl.selectionIndicatorColor = [UIColor selectionColor];
	self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
	[self.segmentedControl addDarkBlurBackground];
	[self.view addSubview:self.segmentedControl];
	[self.segmentedControl addTopBorderWithColor:[UIColor colorWithWhite:1 alpha:0.1] borderHeight:0.4];
}

- (void)updateSegmentFrame
{
	self.segmentedControl.frame = CGRectMake(0, self.view.frame.size.height - DTS_SEGMENT_HEIGHT, self.view.frame.size.width, DTS_SEGMENT_HEIGHT);
	[self.view bringSubviewToFront:self.segmentedControl];
}

- (void)setupPageViewController
{
	self.pagedViewControllers = @[[self wrappedNavigationControllerVC:self.timeLineVC],[self wrappedNavigationControllerVC:self.addTripVC],[self wrappedNavigationControllerVC:self.userVC]];
	
	self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@1}];
	self.pageVC.delegate = self;
	self.pageVC.dataSource = self;
	[self.pageVC setViewControllers:@[self.pagedViewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){}];
	
	
	[self addChildViewController:self.pageVC];
	[self.view addSubview:self.pageVC.view];
	[self.pageVC didMoveToParentViewController:self];
	
	for (UINavigationController *vc in self.pagedViewControllers)
	{
		if ([vc.topViewController conformsToProtocol:@protocol(DTSViewLayoutProtocol)])
		{
			[vc.topViewController setValue:@(DTS_SEGMENT_HEIGHT) forKey:@"bottomLayoutGuideLength"];
		}
	}

}

- (UINavigationController *)wrappedNavigationControllerVC:(UIViewController *)viewController
{
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
	return navVC;
	
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



@end
