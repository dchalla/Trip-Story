//
//  DTSSearchPeopleCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 6/3/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSearchPeopleCollectionViewController.h"
#import "PFUser.h"
#import "DTSCache.h"
#import "DTSFollowFriendsCollectionViewCell.h"
#import "UIColor+Utilities.h"
#import "DTSConstants.h"
#import "DTSUtilities.h"
#import "PFUser+DTSAdditions.h"
#import "MBProgressHUD.h"

#define DTSFollowFriendsCellHeight 60

static NSString * const reuseIdentifier = @"DTSFollowFriendsCollectionViewCell";

@interface DTSSearchPeopleCollectionViewController ()
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) MBProgressHUD *noResultsHUD;
@end

@implementation DTSSearchPeopleCollectionViewController

@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self.collectionView registerClass:[DTSFollowFriendsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSFollowFriendsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
}

- (void)searchWithString:(NSString *)searchString
{
	self.searchString = searchString;
	[self loadObjects];
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
		self.noResultsHUD.labelText = @"No Results";
	}
}

#pragma mark - PFQUERY

- (PFQuery *)queryForCollection
{
	PFQuery *query = [PFUser query];
	[query whereKey:DTSUser_Search_Name containsString:self.searchString];
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
	PFUser *user = dynamic_cast_oc(self.objects[indexPath.row], PFUser);
	[DTSUtilities openUserDetailsForUser:user];
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
