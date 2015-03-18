//
//  DTSTimelineCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/16/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTimelineCollectionViewController.h"
#import "DTSTrip.h"
#import "DTSTripDetailsViewController.h"
#import "DTSUserAuthHelper.h"
#import "UIColor+Utilities.h"
#import "DTSTimelineCollectionViewCell.h"
#import "DTSActivity.h"

#define DTSTimelineCellHeight 250
#define DTSTimelineCellIpadSpacer 5

static NSString * const reuseIdentifier = @"DTSTripCollectionViewCell";

@interface DTSTimelineCollectionViewController ()

@end

@implementation DTSTimelineCollectionViewController
@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Register cell classes
	[self.collectionView registerClass:[DTSTimelineCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSTimelineCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.title = @"Trip Story";
	self.collectionView.contentInset = UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.bottomLayoutGuideLength, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
	[query orderByDescending:@"createdAt"];
	
	//[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	
	return query;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.objects.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DTSTrip *trip = nil;
	if (indexPath.row == self.objects.count)
	{
		
	}
	else
	{
		trip = dynamic_cast_oc(self.objects[indexPath.row], DTSTrip);
	}
	DTSTimelineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor primaryColor];
	[trip fillInPlaceholderEvents];
	[cell updateViewWithTrip:trip];
	return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		return CGSizeMake(self.view.frame.size.width, DTSTimelineCellHeight);
	}
	else
	{
		return CGSizeMake(self.view.frame.size.width/2-DTSTimelineCellIpadSpacer, DTSTimelineCellHeight);
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DTSTrip *trip = nil;
	if (indexPath.row == self.objects.count)
	{
		
	}
	else
	{
		trip = dynamic_cast_oc(self.objects[indexPath.row], DTSTrip);
	}
	
	DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
	vc.trip = trip;
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Responding to Events

- (void)objectsWillLoad {
	[super objectsWillLoad];
	[self stylePFLoadingViewTheHardWay];
}

- (void)objectsDidLoad:(NSError *)error {
	[super objectsDidLoad:error];
}


#pragma mark - custom styling

- (void)stylePFLoadingViewTheHardWay
{
	UIColor *labelTextColor = [UIColor whiteColor];
	UIColor *labelShadowColor = [UIColor clearColor];
	UIActivityIndicatorViewStyle activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	
	// go through all of the subviews until you find a PFLoadingView subclass
	for (UIView *subview in self.collectionView.subviews)
	{
		if ([subview class] == NSClassFromString(@"PFLoadingView"))
		{
			// find the loading label and loading activity indicator inside the PFLoadingView subviews
			for (UIView *loadingViewSubview in subview.subviews) {
				if ([loadingViewSubview isKindOfClass:[UILabel class]])
				{
					UILabel *label = (UILabel *)loadingViewSubview;
					{
						label.textColor = labelTextColor;
						label.shadowColor = labelShadowColor;
					}
				}
				
				if ([loadingViewSubview isKindOfClass:[UIActivityIndicatorView class]])
				{
					UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)loadingViewSubview;
					activityIndicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
				}
			}
		}
	}
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (bottomEdge >= scrollView.contentSize.height && scrollView.contentSize.height > scrollView.frame.size.height)
	{
		NSInteger lastCountLoad;
		@try
		{
			lastCountLoad =((NSNumber *)[self valueForKey:@"_lastLoadCount"]).integerValue;
		}
		@catch (NSException* exc){}
		
		if ((lastCountLoad == -1 || lastCountLoad >= (NSInteger)self.objectsPerPage))
		{
			[self loadNextPage];
		}
	}
}


@end
