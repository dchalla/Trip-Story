//
//  DTSUserFriendsViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/19/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserFriendsViewController.h"
#import "DTSActivity.h"
#import "DTSCache.h"
#import "DTSFollowFriendsCollectionViewCell.h"
#import "UIColor+Utilities.h"
#import "DTSConstants.h"
#import "DTSUtilities.h"
#import "PFUser+DTSAdditions.h"
#import "MBProgressHUD.h"
#import "theTripStory-Swift.h"

#define DTSFollowFriendsCellHeight 60

static NSString * const reuseIdentifier = @"DTSFollowFriendsCollectionViewCell";

@interface DTSUserFriendsViewController ()
@property (nonatomic, strong) MBProgressHUD *noResultsHUD;
@property (nonatomic) BOOL pullRefreshSetupDone;
@end

@implementation DTSUserFriendsViewController
@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout * __nonnull)layout className:(nullable NSString *)className {
	self = [super initWithCollectionViewLayout:layout className:className];
	if (self) {
		self.pullToRefreshEnabled = NO;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self.collectionView registerClass:[DTSFollowFriendsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSFollowFriendsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.title = [self navigationTitle];
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
}

- (NSString *)navigationTitle
{
	return [NSString stringWithFormat:@"%@ %@",[self.user dts_displayName],self.forFollowers?@"Followers":@"Following"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self setupPullToRefreshView];
}

- (void)setupPullToRefreshView {
	self.collectionView.alwaysBounceVertical = YES;
	if (!self.pullRefreshSetupDone)
	{
		PullToMakeFlight *pullToRefresh = [[PullToMakeFlight alloc] init];
		BlockWeakSelf wSelf = self;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.collectionView addPullToRefresh:pullToRefresh action:^{
				[wSelf loadObjects];
			}];
		});
		self.pullRefreshSetupDone = YES;
	}
}

#pragma mark -
#pragma mark Responding to Events

- (void)objectsWillLoad {
	[super objectsWillLoad];
	[self stylePFLoadingViewTheHardWay];
	[self.noResultsHUD hide:YES];
}

- (void)objectsDidLoad:(NSError *)error {
	[super objectsDidLoad:error];
	[self.noResultsHUD hide:YES];
	[self showNoResultsHUD];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.collectionView endRefresing];
	});
}

- (void)showNoResultsHUD
{
	if (!self.objects || self.objects.count ==0)
	{
		self.noResultsHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		self.noResultsHUD.mode = MBProgressHUDModeText;
		self.noResultsHUD.labelText = self.forFollowers?@"No Followers":@"You Are Not Following Anyone";
	}
}

#pragma mark - PFQUERY

- (PFQuery *)queryForCollection
{
	PFQuery *queryFollowing = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryFollowing whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[queryFollowing whereKey:self.forFollowers?kDTSActivityToUserKey:kDTSActivityFromUserKey equalTo:self.user];
	if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
		queryFollowing.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
	
	[queryFollowing orderByAscending:DTSUser_Facebook_NAME];
	[queryFollowing includeKey:self.forFollowers?kDTSActivityFromUserKey:kDTSActivityToUserKey];
	
	return queryFollowing;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DTSActivity *activity = dynamic_cast_oc(self.objects[indexPath.row], DTSActivity);
	DTSFollowFriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	[cell updateUIWithUser:self.forFollowers?activity.fromUser:activity.toUser];
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
	DTSActivity *activity = dynamic_cast_oc(self.objects[indexPath.row], DTSActivity);
	[DTSUtilities openUserDetailsForUser:self.forFollowers?activity.fromUser:activity.toUser];
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

#pragma mark - analytics

- (NSString *)dts_analyticsScreenName
{
	return @"User Friends";
}

@end
