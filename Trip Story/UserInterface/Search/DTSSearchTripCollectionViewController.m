//
//  DTSSearchTripCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 6/2/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSearchTripCollectionViewController.h"

@interface DTSSearchTripCollectionViewController ()
@property (nonatomic, strong) NSString *searchString;

@end

@implementation DTSSearchTripCollectionViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.requiresLogin = NO;
}

- (void)searchWithString:(NSString *)searchString
{
	self.searchString = searchString;
	[self loadObjects];
}

#pragma mark - PFQUERY

- (PFQuery *)queryForCollection
{
	PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	
	[query includeKey:@"originalEventsList"];
	[query includeKey:@"originalEventsList.location"];
	[query includeKey:@"originalEventsList.location.dtsPlacemark"];
	[query includeKey:@"user"];
	[query includeKey:@"ACL"];
	[query whereKey:@"privacy" equalTo:@(DTSPrivacyPublic)];
	if (self.searchString.length > 0)
	{
		[query whereKey:@"tripTagsForSearch" containsString:self.searchString];
	}
	else
	{
		[query whereKey:@"tripTagsForSearch" equalTo:@"noTags"];
	}
	
	
	[query orderByDescending:@"createdAt"];
	
	[query setCachePolicy:kPFCachePolicyNetworkOnly];
	
	return query;
}

- (BFTask *)loadObjects
{
	if (self.searchString.length > 0)
	{
		return [super loadObjects];
	}
	return nil;
}

#pragma mark - analytics

- (NSString *)dts_analyticsScreenName
{
	return @"Search Trips";
}



@end
