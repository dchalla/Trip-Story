//
//  DTSActivityFeedViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 6/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSActivityFeedViewController.h"
#import "PFUser.h"
#import "DTSCache.h"
#import "DTSActivityFeedCollectionViewCell.h"
#import "UIColor+Utilities.h"
#import "DTSConstants.h"
#import "DTSUtilities.h"
#import "PFUser+DTSAdditions.h"
#import "MBProgressHUD.h"
#import "DTSTripDetailsViewController.h"
#import "DTSRequiresLoginView.h"
#import "UIView+Utilities.h"
#import "theTripStory-Swift.h"


#define CellHeight 70

static NSString * const cellReuseIdentifier = @"DTSActivityFeedCollectionViewCell";

@interface DTSActivityFeedViewController ()
@property (nonatomic, strong) MBProgressHUD *noResultsHUD;
@property (nonatomic, strong) MBProgressHUD *loginHud;
@property (nonatomic) BOOL pullRefreshSetupDone;
@property (nonatomic, strong) PullToMakeFlight *pullToRefresh;
@end

@implementation DTSActivityFeedViewController

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
	[self.collectionView registerClass:[DTSActivityFeedCollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSActivityFeedCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellReuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
	self.title = @"Activity";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kDTSUserAuthenticated object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateLoginHUD];
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
		self.pullToRefresh = [[PullToMakeFlight alloc] init];
		BlockWeakSelf wSelf = self;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.collectionView addPullToRefresh:self.pullToRefresh action:^{
				[wSelf loadObjects];
			}];
		});
		self.pullRefreshSetupDone = YES;
	}
}

- (void)refreshView
{
	if ([PFUser currentUser])
	{
		[self loadObjects];
	}
}


- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.pullToRefresh removeScrollViewObserving];
}

- (void)updateLoginHUD
{
	[self.loginHud hide:YES];
	if ([PFUser currentUser] == nil)
	{
		self.loginHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		self.loginHud.mode = MBProgressHUDModeCustomView;
		self.loginHud.labelText = @"";
		self.loginHud.detailsLabelText = @"";
		self.loginHud.customView = [DTSRequiresLoginView dts_viewFromNibWithName:@"DTSRequiresLoginView" bundle:[NSBundle mainBundle]];
		self.loginHud.dimBackground = YES;
		self.loginHud.margin = 0.0;
		self.loginHud.backgroundColor = [UIColor primaryColor];
		self.loginHud.color = [UIColor clearColor];
		return;
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
	if (!self.objects || self.objects.count ==0)
	{
		self.noResultsHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		self.noResultsHUD.mode = MBProgressHUDModeText;
		self.noResultsHUD.labelText = @"No Activity";
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.collectionView endRefresing];
	});
}

#pragma mark - PFQUERY


- (PFQuery *)queryForCollection
{
	if ([PFUser currentUser] == nil)
	{
		return nil;
	}
	
	PFQuery *queryLike = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryLike whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeLike];
	[queryLike whereKey:kDTSActivityToUserKey equalTo:[PFUser currentUser]];
	[queryLike whereKey:kDTSActivityFromUserKey notEqualTo:[PFUser currentUser]];
	
	PFQuery *queryFollow = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryFollow whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[queryFollow whereKey:kDTSActivityToUserKey equalTo:[PFUser currentUser]];
	
	PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryLike,queryFollow]];
	
	[query includeKey:@"trip.originalEventsList"];
	[query includeKey:@"trip.originalEventsList.location"];
	[query includeKey:@"trip.originalEventsList.location.dtsPlacemark"];
	[query includeKey:@"trip.user"];
	[query includeKey:kDTSActivityFromUserKey];
	[query orderByDescending:@"createdAt"];
	
	if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
	
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
	DTSActivity *activity = dynamic_cast_oc(self.objects[indexPath.row], DTSActivity);
	DTSActivityFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
	[cell updateUIWithActivity:activity];
	cell.backgroundColor = [UIColor primaryColor];
	
	return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		return CGSizeMake(self.view.frame.size.width, CellHeight);
	}
	else
	{
		return CGSizeMake(self.view.frame.size.width/2-5, CellHeight);
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DTSActivity *activity = dynamic_cast_oc(self.objects[indexPath.row], DTSActivity);
	
	if ([activity.type isEqualToString:kDTSActivityTypeLike])
	{
		DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
		vc.trip = activity.trip;
		[vc.trip fillInPlaceholderEvents];
		[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
	}
	else if([activity.type isEqualToString:kDTSActivityTypeFollow])
	{
		PFUser *user = dynamic_cast_oc(activity.fromUser, PFUser);
		[DTSUtilities openUserDetailsForUser:user];
	}
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
	return @"ActivityFeed";
}

@end
