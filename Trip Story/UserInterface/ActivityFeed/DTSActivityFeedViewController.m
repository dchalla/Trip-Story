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
#import "DTSActivityFeedLikeCollectionViewCell.h"
#import "UIColor+Utilities.h"
#import "DTSConstants.h"
#import "DTSUtilities.h"
#import "PFUser+DTSAdditions.h"
#import "MBProgressHUD.h"


#define CellHeight 60

static NSString * const likeCellReuseIdentifier = @"DTSActivityFeedLikeCollectionViewCell";

@interface DTSActivityFeedViewController ()
@property (nonatomic, strong) MBProgressHUD *noResultsHUD;
@end

@implementation DTSActivityFeedViewController

@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self.collectionView registerClass:[DTSActivityFeedLikeCollectionViewCell class] forCellWithReuseIdentifier:likeCellReuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSActivityFeedLikeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:likeCellReuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
	self.title = @"Activity";
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
}

#pragma mark - PFQUERY


- (PFQuery *)queryForCollection
{
	if ([PFUser currentUser] == nil)
	{
		return nil;
	}
	
	PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[query whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeLike];
	[query whereKey:kDTSActivityToUserKey equalTo:[PFUser currentUser]];
	[query whereKey:kDTSActivityFromUserKey notEqualTo:[PFUser currentUser]];
	[query includeKey:@"trip.originalEventsList"];
	[query includeKey:@"trip.originalEventsList.location"];
	[query includeKey:@"trip.originalEventsList.location.dtsPlacemark"];
	[query includeKey:@"trip.user"];
	[query includeKey:kDTSActivityFromUserKey];
	
	[query orderByDescending:@"createdAt"];
	
	[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	
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
	DTSActivityFeedLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:likeCellReuseIdentifier forIndexPath:indexPath];
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
