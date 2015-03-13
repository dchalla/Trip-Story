//
//  DTSRootViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSRootViewController.h"
#import "HMSegmentedControl.h"
#import "DTSListOfTripsCollectionViewController.h"
#import "UIColor+Utilities.h"

#define DTS_SEGMENT_HEIGHT 44

@interface DTSRootViewController ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *pagedViewControllers;
@property (nonatomic, strong) DTSListOfTripsCollectionViewController *timeLineVC;
@property (nonatomic, strong) DTSListOfTripsCollectionViewController *addTripVC;
@property (nonatomic, strong) DTSListOfTripsCollectionViewController *userVC;

@end

@implementation DTSRootViewController

- (DTSListOfTripsCollectionViewController *)timeLineVC
{
	if (!_timeLineVC)
	{
		_timeLineVC = [[DTSListOfTripsCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
	}
	return _timeLineVC;
}

- (DTSListOfTripsCollectionViewController *)addTripVC
{
	if (!_addTripVC)
	{
		_addTripVC = [[DTSListOfTripsCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
	}
	return _addTripVC;
}

- (DTSListOfTripsCollectionViewController *)userVC
{
	if (!_userVC)
	{
		_userVC = [[DTSListOfTripsCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
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
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
	[self updateSegmentFrame];
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
	self.segmentedControl.backgroundColor = [UIColor blackColor];
	self.segmentedControl.textColor = [UIColor whiteColor];
	self.segmentedControl.font = [UIFont systemFontOfSize:12];
	self.segmentedControl.selectedTextColor = [UIColor whiteColor];
	self.segmentedControl.selectionIndicatorColor = [UIColor selectionColor];
	self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
	[self.view addSubview:self.segmentedControl];
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
	navVC.navigationBar.barTintColor = [UIColor blackColor];
	navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
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
