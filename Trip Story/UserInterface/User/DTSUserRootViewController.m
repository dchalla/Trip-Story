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

@interface DTSUserRootViewController ()
@property (nonatomic, strong) DTSUserTimelineCollectionViewController *userTimelineVC;
@property (nonatomic, strong) DTSFollowFriendsViewController *friendsVC;

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

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = @"Trip Story Feed";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (NSArray *)segmentNamesList
{
	return @[@"Profile", @"Friends"];
}

- (NSArray *)pagedViewControllersList
{
	return @[self.userTimelineVC,self.friendsVC];
}


@end
