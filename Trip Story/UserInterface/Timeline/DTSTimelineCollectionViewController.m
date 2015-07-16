//
//  DTSTimelineCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/16/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTimelineCollectionViewController.h"

#import "DTSRequiresLoginView.h"
#import "UIView+Utilities.h"
#import "DKCRateFeedbackPrompt.h"
#import "theTripStory-Swift.h"

@interface DTSTimelineCollectionViewController ()

@property (nonatomic) BOOL pullRefreshSetupDone;


@end

@implementation DTSTimelineCollectionViewController
@synthesize topLayoutGuideLength =  _topLayoutGuideLength;
@synthesize bottomLayoutGuideLength = _bottomLayoutGuideLength;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
								   className:(PFUI_NULLABLE NSString *)className {
	self = [super initWithCollectionViewLayout:layout className:className];
	if (self) {
		self.pullToRefreshEnabled = NO;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Register cell classes
	[self.collectionView registerClass:[DTSTimelineCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSTimelineCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	
	[self.collectionView registerClass:[DTSTimelineCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierWithMap];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSTimelineCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifierWithMap];
	
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.title = @"theTripStory";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kDTSRefreshTrips object:nil];
}

- (void)setTopLayoutGuideLength:(CGFloat)topLayoutGuideLength
{
	_topLayoutGuideLength = topLayoutGuideLength;
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
}

- (void)setBottomLayoutGuideLength:(CGFloat)bottomLayoutGuideLength
{
	_bottomLayoutGuideLength = bottomLayoutGuideLength;
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshView
{
	[self loadObjects];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateLoginHUD];
	[self.collectionView reloadData];
	[self trackScreenView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self setupPullToRefreshView];
}

- (void)setupPullToRefreshView {
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

- (void)trackScreenView
{
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	NSString *name = NSStringFromClass([self class]);
	if ([self conformsToProtocol:@protocol(DTSAnalyticsProtocol)])
	{
		name = [self dts_analyticsScreenName];
	}
	if (name.length > 0)
	{
		[tracker set:kGAIScreenName value:name];
		[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
	}
}

- (void)updateLoginHUD
{
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	if (self.requiresLogin)
	{
		if ([PFUser currentUser] == nil)
		{
			MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
			hud.mode = MBProgressHUDModeCustomView;
			hud.labelText = @"";
			hud.detailsLabelText = @"";
			hud.customView = [DTSRequiresLoginView dts_viewFromNibWithName:@"DTSRequiresLoginView" bundle:[NSBundle mainBundle]];
			hud.dimBackground = YES;
			hud.backgroundColor = [UIColor primaryColor];
			hud.margin = 0.0;
			hud.color = [UIColor clearColor];
			return;
			
		}
	}
	
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
	[query orderByDescending:@"createdAt"];
	
	if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
	else
	{
		query.cachePolicy = kPFCachePolicyNetworkOnly;
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
	return [self dtsCellForRowAtIndexPath:indexPath];
}

- (UICollectionViewCell *)dtsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTSTrip *trip = dynamic_cast_oc(self.objects[indexPath.row], DTSTrip);
	[trip fillInPlaceholderEvents];
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

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DTSTrip *trip = dynamic_cast_oc(self.objects[indexPath.row], DTSTrip);
	[trip fillInPlaceholderEvents];
	NSArray *eventsWithLocation = trip.eventsWithLocationList;
	CGFloat height = DTSTimelineCellHeight;
	if (eventsWithLocation.count > 0)
	{
		height = DTSTimelineCellWithMapHeight;
	}
	return [self dtsDefaultItemSizeWithHeight:height];
	
}

- (CGSize)dtsDefaultItemSizeWithHeight:(CGFloat)height
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		return CGSizeMake(self.view.frame.size.width, height);
	}
	else
	{
		return CGSizeMake(self.view.frame.size.width/2-DTSTimelineCellIpadSpacer, height);
	}
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self dtsDidSelectItemAtIndexPath:indexPath];
}

- (void)dtsDidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DTSTrip * trip = dynamic_cast_oc(self.objects[indexPath.row], DTSTrip);
	
	DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
	vc.trip = trip;
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
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
		self.noResultsHUD.labelText = [self noResultsHUDString];
	}
}

- (NSString *)noResultsHUDString {
	return @"No Results";
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
	return @"Explore Trips";
}


@end
