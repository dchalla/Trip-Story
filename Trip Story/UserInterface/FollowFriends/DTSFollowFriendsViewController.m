//
//  DTSFollowFriendsViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSFollowFriendsViewController.h"
#import "DTSActivity.h"
#import "DTSCache.h"
#import "DTSFollowFriendsCollectionViewCell.h"
#import "UIColor+Utilities.h"
#import "DTSConstants.h"

#define DTSFollowFriendsCellHeight 60

static NSString * const reuseIdentifier = @"DTSFollowFriendsCollectionViewCell";

@interface DTSFollowFriendsViewController ()

@end

@implementation DTSFollowFriendsViewController

@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.collectionView registerClass:[DTSFollowFriendsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSFollowFriendsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.title = @"Find Friends";
	self.collectionView.contentInset = UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.bottomLayoutGuideLength, 0);
}

#pragma mark -
#pragma mark Responding to Events

- (void)objectsWillLoad {
	[super objectsWillLoad];
	[self stylePFLoadingViewTheHardWay];
}

- (void)objectsDidLoad:(NSError *)error {
	[super objectsDidLoad:error];
	
	PFQuery *isFollowingQuery = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[isFollowingQuery whereKey:kDTSActivityFromUserKey equalTo:[PFUser currentUser]];
	[isFollowingQuery whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[isFollowingQuery whereKey:kDTSActivityToUserKey containedIn:self.objects];
	[isFollowingQuery setCachePolicy:kPFCachePolicyNetworkOnly];
	
	[isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
		if (!error)
		{
			if (number == self.objects.count) {
				self.followStatus = DTSFindFriendsFollowingAll;
				//[self configureUnfollowAllButton];
				for (PFUser *user in self.objects) {
					[[DTSCache sharedCache] setFollowStatus:YES user:user];
				}
			} else if (number == 0) {
				self.followStatus = DTSFindFriendsFollowingNone;
				//[self configureFollowAllButton];
				for (PFUser *user in self.objects) {
					[[DTSCache sharedCache] setFollowStatus:NO user:user];
				}
			} else {
				self.followStatus = DTSFindFriendsFollowingSome;
				//[self configureFollowAllButton];
			}
			[self.collectionView reloadData];
		}
		
		if (self.objects.count == 0) {
			self.navigationItem.rightBarButtonItem = nil;
		}
	}];
	
	if (self.objects.count == 0) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

#pragma mark - PFQUERY

- (PFQuery *)queryForCollection
{
	// Use cached facebook friend ids
	NSArray *facebookFriends = [[DTSCache sharedCache] facebookFriends];
	
	// Query for all friends you have on facebook and who are using the app
	PFQuery *friendsQuery = [PFUser query];
	[friendsQuery whereKey:DTSUser_Facebook_ID containedIn:facebookFriends];
	
	PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:friendsQuery, nil]];
	query.cachePolicy = kPFCachePolicyNetworkOnly;
	
	if (self.objects.count == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
	
	[query orderByAscending:DTSUser_Facebook_NAME];
	
	return query;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	PFUser *user = dynamic_cast_oc(self.objects[indexPath.row], PFUser);
	DTSFollowFriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	[cell updateUIWithUser:user];
	cell.backgroundColor = [UIColor primaryColor];
	
	return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		return CGSizeMake(self.view.frame.size.width, DTSFollowFriendsCellHeight);
	}
	else
	{
		return CGSizeMake(self.view.frame.size.width/2-5, DTSFollowFriendsCellHeight);
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
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
