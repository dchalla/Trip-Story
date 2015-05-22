//
//  DTSUserLikedTripsCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/23/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserLikedTripsCollectionViewController.h"
#import "DTSTrip.h"
#import "DTSActivity.h"

@interface DTSUserLikedTripsCollectionViewController ()

@end

@implementation DTSUserLikedTripsCollectionViewController

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
	
	PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[query whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeLike];
	[query whereKey:kDTSActivityFromUserKey equalTo:self.user];
	[query includeKey:@"trip.originalEventsList"];
	[query includeKey:@"trip.originalEventsList.location"];
	[query includeKey:@"trip.originalEventsList.location.dtsPlacemark"];
	[query includeKey:@"trip.user"];
	if (![self.user.username isEqualToString:[PFUser currentUser].username])
	{
		PFQuery *innerQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
		[innerQuery whereKey:@"privacy" equalTo:@(DTSPrivacyPublic)];
		[query whereKey:@"trip" matchesQuery:innerQuery];
	}
	else
	{
		PFQuery *innerQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
		[innerQuery whereKeyExists:@"privacy"];
		[query whereKey:@"trip" matchesQuery:innerQuery];
	}
	[query orderByDescending:@"createdAt"];
	
	[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	
	return query;
}

- (UICollectionViewCell *)dtsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTSActivity *activity = dynamic_cast_oc(self.objects[indexPath.row], DTSActivity);
	
	DTSTimelineCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor primaryColor];
	[activity.trip fillInPlaceholderEvents];
	[cell updateViewWithTrip:activity.trip];
	return cell;
}


- (void)dtsDidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DTSActivity *activity = dynamic_cast_oc(self.objects[indexPath.row], DTSActivity);
	
	DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
	vc.trip = activity.trip;
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
}

@end
