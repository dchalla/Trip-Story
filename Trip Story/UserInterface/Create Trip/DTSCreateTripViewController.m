//
//  DTSCreateTripViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/26/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSCreateTripViewController.h"
#import "UIView+Utilities.h"
#import "UIColor+Utilities.h"
#import "DTSTripDetailsViewController.h"
#import "UIViewController+Utilities.h"
#import "MBProgressHUD.h"
#import "DTSRequiresLoginView.h"

@interface DTSCreateTripViewController ()

@end

@implementation DTSCreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	DTSCreateEditTripView *createTripView = [DTSCreateEditTripView dts_viewFromNibWithName:@"DTSCreateEditTripView" bundle:[NSBundle mainBundle]];
	createTripView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	createTripView.delegate = self;
	createTripView.isCreateTripMode = self.isCreateTripMode;
	createTripView.trip = self.isCreateTripMode?[DTSTrip object]:self.trip;
	self.view.backgroundColor = [UIColor primaryColor];
	createTripView.backgroundColor = [UIColor primaryColor];
	[self.view addSubview:createTripView];
	self.title = self.isCreateTripMode? @"Create Trip" : @"Update Trip";
	[self configureCancelButton];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateLoginHUD];
}

- (void)updateLoginHUD
{
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	if ([PFUser currentUser] == nil)
	{
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeCustomView;
		hud.labelText = @"";
		hud.detailsLabelText = @"";
		hud.customView = [DTSRequiresLoginView dts_viewFromNibWithName:@"DTSRequiresLoginView" bundle:[NSBundle mainBundle]];
		hud.dimBackground = YES;
		hud.color = [UIColor clearColor];
		hud.backgroundColor = [UIColor primaryColor];
		hud.margin = 0.0;
		return;
	}
	
}

- (void)configureCancelButton
{
	if (!self.isCreateTripMode)
	{
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissCreateTripView)];
		self.navigationItem.leftBarButtonItem = cancelButton;
	}
}

- (void)updateCreateTripTappedForTrip:(DTSTrip *)trip
{
	DTSTripDetailsViewController *vc;
	if (self.isCreateTripMode)
	{
		vc = [[DTSTripDetailsViewController alloc] init];
		vc.trip = trip;
#ifdef DEBUG
		//Testing
		//[trip createDummyEventsList];
		//End testing
#endif
		[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
	}
	else
	{
		[self dismissCreateTripView];
	}
	
	[trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			// The object has been saved.
			if (vc)
			{
				[vc refreshView];
			}
			NSLog(@"Succeeded");
		} else {
			// There was a problem, check error.description
			NSLog(@"Failed");
		}
	}];
	
	// May return nil if a tracker has not already been initialized with a property
	// ID.
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	if (self.isCreateTripMode)
	{
		[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
															  action:@"createTrip_button_press"  // Event action (required)
															   label:@"createTrip"          // Event label
															   value:nil] build]];    // Event value
	}
	else
	{
		[tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
															  action:@"updateTrip_button_press"  // Event action (required)
															   label:@"updateTrip"          // Event label
															   value:nil] build]];    // Event value
	}
	
	
	
}

- (void)deleteTripTapped:(DTSTrip *)trip
{
	[trip deleteEventually];
	[self dismissViewControllerAnimated:YES completion:^{
		if (self.delegate)
		{
			[self.delegate deletedTrip];
		}
	}];	
}

- (void)dismissCreateTripView
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIViewControllerAnimatedTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	self.presenting = YES;
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.presenting = NO;
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return [self dts_transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	[self dts_animateTransition:transitionContext presenting:self.presenting];
}

#pragma mark - analytics

- (NSString *)dts_analyticsScreenName
{
	return self.isCreateTripMode? @"Create Trip" : @"Update Trip";
}


@end
