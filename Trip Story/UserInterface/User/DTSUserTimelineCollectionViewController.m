//
//  DTSUserTimelineCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserTimelineCollectionViewController.h"
#import "DTSUserProfileCollectionViewCell.h"

#define DTSProfileHeight 320
#define DTSProfileHeightCurrentUser 280

static NSString * const reuseIdentifierProfile = @"DTSUserProfileCollectionViewCell";

@interface DTSUserTimelineCollectionViewController ()

@end

@implementation DTSUserTimelineCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	// Register cell classes
	[self.collectionView registerClass:[DTSUserProfileCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierProfile];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSUserProfileCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifierProfile];

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
	[query includeKey:@"tripPhotosList"];
	[query includeKey:@"tripPhotosList.location"];
	[query includeKey:@"tripPhotosList.location.dtsPlacemark"];
	[query includeKey:@"user"];
	[query orderByDescending:@"createdAt"];
	
	if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
	
	return query;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.objects.count+1;//for profile cell
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == 0 && indexPath.section == 0)
	{
		if ([self.user.username isEqualToString:[PFUser currentUser].username] || [PFUser currentUser] == nil)
		{
			return CGSizeMake(self.view.frame.size.width, DTSProfileHeightCurrentUser);
		}
		else
		{
			return CGSizeMake(self.view.frame.size.width, DTSProfileHeight);
		}
		
	}
	else
	{
		DTSTrip *trip = dynamic_cast_oc(self.objects[indexPath.row-1], DTSTrip);
		if (trip.eventsList == nil) {
			[trip fillInPlaceholderEvents];
		}
		
		NSArray *eventsWithLocation = trip.eventsWithLocationList;
		CGFloat height = DTSTimelineCellHeight;
		if (eventsWithLocation.count > 0)
		{
			height = DTSTimelineCellWithMapHeight;
		}
		return [self dtsDefaultItemSizeWithHeight:height];
	}
	
	
}

- (UICollectionViewCell *)dtsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == 0 && indexPath.section == 0)
	{
		DTSUserProfileCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierProfile forIndexPath:indexPath];
		cell.backgroundColor = [UIColor primaryColor];
		[cell updateUIWithUser:self.user];
		
		return cell;
	}
	else
	{
		DTSTrip *trip = dynamic_cast_oc(self.objects[indexPath.row-1], DTSTrip);
		if (trip.eventsList == nil) {
			[trip fillInPlaceholderEvents];
		}
		NSArray *eventsWithLocation = trip.eventsWithLocationList;
		DTSTimelineCollectionViewCell *cell = nil;
		if (eventsWithLocation.count > 0)
		{
			cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierWithMap forIndexPath:indexPath];
		}
		else
		{
			cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
		}
		
		cell.backgroundColor = [UIColor primaryColor];
		
		[cell updateViewWithTrip:trip];
		return cell;
	}
}

- (void)dtsDidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item == 0 && indexPath.section == 0)
	{
		//do nothing;
	}
	else
	{
		DTSTrip * trip = dynamic_cast_oc(self.objects[indexPath.row-1], DTSTrip);
		
		DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
		vc.trip = trip;
		[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
	}
}

# pragma mark - 3D Touch Delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
	
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
	if (indexPath.item == 0 && indexPath.section == 0)
	{
		//do nothing;
		return nil;
	}
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	
	DTSTrip * trip = dynamic_cast_oc(self.objects[indexPath.row-1], DTSTrip);
	if (!trip) {
		trip = dynamic_cast_oc(self.objects[indexPath.row-1], DTSActivity).trip;
	}
	
	DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
	vc.trip = trip;
	
	// Set the source rect to the cell frame, so surrounding elements are blurred.
	previewingContext.sourceRect = cell.frame;
	
	
	return vc;
	
}


- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
	[self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - overrides
- (void)showNoResultsHUD
{
	//dont do anything for user timeLine.
}

#pragma mark - analytics

- (NSString *)dts_analyticsScreenName
{
	return @"User Home";
}



@end
