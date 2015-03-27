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

@interface DTSCreateTripViewController ()

@end

@implementation DTSCreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	DTSCreateEditTripView *createTripView = [DTSCreateEditTripView dts_viewFromNibWithName:@"DTSCreateEditTripView" bundle:[NSBundle mainBundle]];
	createTripView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	createTripView.delegate = self;
	createTripView.isCreateTripMode = YES;
	createTripView.trip = [DTSTrip object];
	self.view.backgroundColor = [UIColor primaryColor];
	createTripView.backgroundColor = [UIColor primaryColor];
	[self.view addSubview:createTripView];
	self.title = @"Create Trip";
}

- (void)updateCreateTripTappedForTrip:(DTSTrip *)trip
{
	DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
	vc.trip = trip;
	//Testing
	[trip createDummyEventsList];
	//End testing
	[trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			// The object has been saved.
			NSLog(@"Succeeded");
		} else {
			// There was a problem, check error.description
			NSLog(@"Failed");
		}
	}];
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
	
}

- (void)dismissCreateTripView
{
	
}



@end
