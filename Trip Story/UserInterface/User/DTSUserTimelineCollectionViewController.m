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
	[query includeKey:@"user"];
	[query orderByDescending:@"createdAt"];
	
	[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	
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
		if ([self.user.username isEqualToString:[PFUser currentUser].username])
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
		return [self dtsDefaultItemSize];
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
		
		DTSTimelineCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
		cell.backgroundColor = [UIColor primaryColor];
		[trip fillInPlaceholderEvents];
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


@end
