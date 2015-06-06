//
//  DTSFriendsTimelineCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSFriendsTimelineCollectionViewController.h"

@interface DTSFriendsTimelineCollectionViewController ()

@end

@implementation DTSFriendsTimelineCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.requiresLogin = YES;
}

#pragma mark - PFQUERY

- (PFQuery *)queryForCollection
{
	if (![PFUser currentUser])
	{
		return nil;
	}
	
	// Query for the friends the current user is following
	PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[followingActivitiesQuery whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[followingActivitiesQuery whereKey:kDTSActivityFromUserKey equalTo:[PFUser currentUser]];
 
	// Using the activities from the query above, we find all of the photos taken by
	// the friends the current user is following
	PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	[photosFromFollowedUsersQuery whereKey:kDTSTripUserKey matchesKey:kDTSActivityToUserKey inQuery:followingActivitiesQuery];
 
	// We create a second query for the current user's photos
	PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	[photosFromCurrentUserQuery whereKey:kDTSTripUserKey equalTo:[PFUser currentUser]];
 
	// We create a final compound query that will find all of the photos that were
	// taken by the user's friends or by the user
	PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects: photosFromFollowedUsersQuery,photosFromCurrentUserQuery, nil]];
	
	[query includeKey:@"originalEventsList"];
	[query includeKey:@"originalEventsList.location"];
	[query includeKey:@"originalEventsList.location.dtsPlacemark"];
	[query includeKey:@"user"];
	[query whereKey:@"privacy" equalTo:@(DTSPrivacyPublic)];
	[query orderByDescending:@"createdAt"];
	
	if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
	
	return query;
}

@end
