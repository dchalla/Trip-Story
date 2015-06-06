//
//  DTSTimelineRootViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTimelineRootViewController.h"
#import "DTSTimelineCollectionViewController.h"
#import "DTSFriendsTimelineCollectionViewController.h"
#import "DTSTrip.h"

@interface DTSTimelineRootViewController ()
@property (nonatomic, strong) DTSTimelineCollectionViewController *exploreTimelineVC;
@property (nonatomic, strong) DTSFriendsTimelineCollectionViewController *friendsTimelineVC;

@end

@implementation DTSTimelineRootViewController


- (DTSTimelineCollectionViewController *)exploreTimelineVC
{
	if (!_exploreTimelineVC)
	{
		_exploreTimelineVC = [[DTSTimelineCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [DTSTrip parseClassName]];
	}
	return _exploreTimelineVC;
}

- (DTSFriendsTimelineCollectionViewController *)friendsTimelineVC
{
	if (!_friendsTimelineVC)
	{
		_friendsTimelineVC = [[DTSFriendsTimelineCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [DTSTrip parseClassName]];
	}
	return _friendsTimelineVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"theTripStory Feed";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (NSArray *)segmentNamesList
{
	return @[@"Explore", @"Friends I Follow"];
}

- (NSArray *)pagedViewControllersList
{
	return @[self.exploreTimelineVC,self.friendsTimelineVC];
}


@end
