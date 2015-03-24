//
//  DTSUserRootViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserRootViewController.h"
#import "DTSUserTimelineCollectionViewController.h"
#import "DTSFollowFriendsViewController.h"
#import "PFUser+DTSAdditions.h"
#import "DTSUserLikedTripsCollectionViewController.h"

@interface DTSUserRootViewController ()
@property (nonatomic, strong) DTSUserTimelineCollectionViewController *userTimelineVC;
@property (nonatomic, strong) DTSFollowFriendsViewController *friendsVC;
@property (nonatomic, strong) DTSUserLikedTripsCollectionViewController *userLikedTripsVC;

@end

@implementation DTSUserRootViewController

- (PFUser *)user
{
	if (_user)
	{
		return _user;
	}
	else
	{
		return [PFUser currentUser];
	}
}


- (DTSUserTimelineCollectionViewController *)userTimelineVC
{
	if (!_userTimelineVC)
	{
		_userTimelineVC = [[DTSUserTimelineCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [DTSTrip parseClassName]];
		_userTimelineVC.user = self.user;
	}
	return _userTimelineVC;
}

- (DTSFollowFriendsViewController *)friendsVC
{
	if (!_friendsVC)
	{
		_friendsVC = [[DTSFollowFriendsViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [PFUser parseClassName]];
	}
	return _friendsVC;
}

- (DTSUserLikedTripsCollectionViewController *)userLikedTripsVC
{
	if (!_userLikedTripsVC)
	{
		_userLikedTripsVC = [[DTSUserLikedTripsCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [DTSActivity parseClassName]];
		_userLikedTripsVC.user = self.user;
	}
	return _userLikedTripsVC;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = [self.user dts_displayName];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;
}

- (NSArray *)segmentNamesList
{
	if ([self.user.username isEqualToString:[PFUser currentUser].username])
	{
		return @[@"Profile", @"Liked Trips", @"Facebook Friends"];
	}
	else
	{
		return @[@"Profile", @"Liked Trips",];
	}
	
}

- (NSArray *)pagedViewControllersList
{
	if ([self.user.username isEqualToString:[PFUser currentUser].username])
	{
		return @[self.userTimelineVC,self.userLikedTripsVC, self.friendsVC];
	}
	else
	{
		return @[self.userTimelineVC,self.userLikedTripsVC];
	}
}


@end
