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
#import "TripStoryIconView.h"
#import "DTSSearchRootViewController.h"
#import "DTSActivityFeedViewController.h"
#import "DTSActivity.h"
#import "TLSpringFlowLayout.h"
#import "SFCarouselOnboardingViewController.h"
#import "DTSUtilities.h"
#import <Google/Analytics.h>

#define DTS_SEGMENT_HEIGHT 44
#ifdef DEBUG
#define IconCreation 0
#define TestOnboarding 1
#endif
@interface DTSRootViewController ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *pagedViewControllers;
@property (nonatomic, strong) DTSTimelineRootViewController *timeLineVC;
@property (nonatomic, strong) DTSCreateTripViewController *addTripVC;
@property (nonatomic, strong) DTSUserRootViewController *userVC;
@property (nonatomic, strong) DTSSearchRootViewController *searchVC;
@property (nonatomic, strong) DTSActivityFeedViewController *activityVC;

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

- (DTSSearchRootViewController *)searchVC
{
	if (!_searchVC)
	{
		_searchVC = [[DTSSearchRootViewController alloc] init];
	}
	return _searchVC;
}

- (DTSActivityFeedViewController *)activityVC
{
	if (!_activityVC)
	{
		_activityVC =[[DTSActivityFeedViewController alloc] initWithCollectionViewLayout:[[TLSpringFlowLayout alloc] init] className: [DTSActivity parseClassName]];
	}
	return _activityVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupPageViewController];
	[self setupSegmentControl];
#if TestOnboarding
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OnboardingDidShowToUser"];
#endif
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
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
#if IconCreation
	[self showTripStoryIconViewForIconCreation];
#endif
	[self performSelector:@selector(showOnboarding) withObject:nil afterDelay:0.2];
	
	[DKCRateFeedbackPrompt showPromptWithAppId:@"h986986896" showFeedbackPrompt:NO delegate:self];
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
	NSArray *selectedSectionIcons = @[[[UIImage imageNamed:@"timelineIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"searchIcon"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate], [[UIImage imageNamed:@"addTrip"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"users"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"activityIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	NSArray *sectionIcons = @[[[UIImage imageNamed:@"timelineIcon-lightGray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"searchIcon-lightGray"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate], [[UIImage imageNamed:@"addTrip-lightGray"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"users-lightGray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],[[UIImage imageNamed:@"activityIcon-lightGray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:sectionIcons sectionSelectedImages:selectedSectionIcons];
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
	self.pagedViewControllers = @[[self wrappedNavigationControllerVC:self.timeLineVC],[self wrappedNavigationControllerVC:self.searchVC],[self wrappedNavigationControllerVC:self.addTripVC],[self wrappedNavigationControllerVC:self.userVC],[self wrappedNavigationControllerVC:self.activityVC]];
	
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
#if IconCreation
-(void)showTripStoryIconViewForIconCreation
{
	TripStoryIconView *iconView = [TripStoryIconView dts_viewFromNibWithName:@"TripStoryIconView" bundle:[NSBundle mainBundle]];
	iconView.frame = CGRectMake(0, 0, 1200, 1200);
	[self.navigationController.view addSubview:iconView];
	
	UIGraphicsBeginImageContextWithOptions(iconView.bounds.size, YES, 3);
	[iconView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
}
#endif

- (void)showOnboarding
{
	if (![DTSUtilities isOnboardingShownToUser]) {
		SFCarouselOnboardingViewController *carousel = [[SFCarouselOnboardingViewController alloc] init];
		[self presentViewController:carousel animated:YES completion:nil];
	}
	
}

#define mark - dkcRatePromptDelegate

- (void)dkcRateFeedbackPrompt_didShow {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
															  action:@"dkcRateFeedbackPrompt_didShow"  // Event action (required)
															   label:@"dkcRateFeedbackPrompt_didShow"          // Event label
															   value:nil] build]];    // Event value
}

- (void)dkcRateFeedbackPrompt_didTapPositiveReview {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapPositiveReview"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapPositiveReview"          // Event label
														   value:nil] build]];    // Event value
	
}

- (void)dkcRateFeedbackPrompt_didTapNegativeReview {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapPositiveReview"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapPositiveReview"          // Event label
														   value:nil] build]];    // Event value
}

- (void)dkcRateFeedbackPrompt_didTapAppStoreReviewNotNow {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapNegativeReview"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapNegativeReview"          // Event label
														   value:nil] build]];    // Event value
}

- (void)dkcRateFeedbackPrompt_didTapAppStoreReviewRateApp {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapAppStoreReviewRateApp"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapAppStoreReviewRateApp"          // Event label
														   value:nil] build]];    // Event value
}

- (void)dkcRateFeedbackPrompt_didTapAppStoreReviewNoThanks {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapAppStoreReviewNoThanks"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapAppStoreReviewNoThanks"          // Event label
														   value:nil] build]];    // Event value
}

- (void)dkcRateFeedbackPrompt_didTapFeedbackPromptFeedback {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapFeedbackPromptFeedback"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapFeedbackPromptFeedback"          // Event label
														   value:nil] build]];    // Event value
}

- (void)dkcRateFeedbackPrompt_didTapFeedbackPromptNotNow {
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
														  action:@"dkcRateFeedbackPrompt_didTapFeedbackPromptNotNow"  // Event action (required)
														   label:@"dkcRateFeedbackPrompt_didTapFeedbackPromptNotNow"          // Event label
														   value:nil] build]];    // Event value
}


@end
