//
//  DTSUserTimelineCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserTimelineCollectionViewController.h"

@interface DTSUserTimelineCollectionViewController ()

@end

@implementation DTSUserTimelineCollectionViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - PFQUERY

- (PFQuery *)queryForCollection
{
	if (!self.user)
	{
		return nil;
	}
 
	// We create a second query for the current user's photos
	PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	[photosFromCurrentUserQuery whereKey:kDTSTripUserKey equalTo:self.user];
 
	// We create a final compound query that will find all of the photos that were
	// taken by the user's friends or by the user
	PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromCurrentUserQuery, nil]];
	
	[query includeKey:@"originalEventsList"];
	[query includeKey:@"originalEventsList.location"];
	[query includeKey:@"originalEventsList.location.dtsPlacemark"];
	[query includeKey:@"user"];
	[query orderByDescending:@"createdAt"];
	
	[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	
	return query;
}

@end
