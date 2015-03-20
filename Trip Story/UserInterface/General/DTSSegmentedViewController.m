//
//  DTSSegmentedViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSegmentedViewController.h"
#import "UIColor+Utilities.h"
#import "UIView+Utilities.h"

#define DTS_SEGMENT_HEIGHT 44

@interface DTSSegmentedViewController ()

@end

@implementation DTSSegmentedViewController

@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	if (self.topLayoutGuideLength == 0)
	{
		if (self.navigationController)
		{
			self.topLayoutGuideLength = self.navigationController.navigationBar.frame.size.height;
		}
	}
	[self setupPageViewController];
	[self setupSegmentControl];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
	self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:[self segmentNamesList]];
	[self updateSegmentFrame];
	self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	[self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	self.segmentedControl.backgroundColor = [UIColor clearColor];
	self.segmentedControl.textColor = [UIColor whiteColor];
	self.segmentedControl.font = [UIFont systemFontOfSize:12];
	self.segmentedControl.selectedTextColor = [UIColor whiteColor];
	self.segmentedControl.selectionIndicatorColor = [UIColor selectionColor];
	self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
	[self.segmentedControl addDarkBlurBackground];
	[self.view addSubview:self.segmentedControl];
	[self.segmentedControl addBottomBorderWithColor:[UIColor colorWithWhite:1 alpha:0.1] borderHeight:0.4];
}

- (void)updateSegmentFrame
{
	self.segmentedControl.frame = CGRectMake(0, self.topLayoutGuideLength, self.view.frame.size.width, [self segmentHeight]);
	[self.view bringSubviewToFront:self.segmentedControl];
}

- (void)setupPageViewController
{
	self.pagedViewControllers = [self pagedViewControllersList];
	
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
			[vc setValue:@(self.topLayoutGuideLength+[self segmentHeight]) forKey:@"topLayoutGuideLength"];
			[vc setValue:@(self.bottomLayoutGuideLength) forKey:@"bottomLayoutGuideLength"];
		}
	}
}

- (NSInteger)segmentHeight
{
	if (self.pagedViewControllers.count > 1)
	{
		return DTS_SEGMENT_HEIGHT;
	}
	else
	{
		return 0;
	}
}

- (NSArray *)segmentNamesList
{
	return @[];
}

- (NSArray *)pagedViewControllersList
{
	return @[];
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
