//
//  DTSListOfTripsCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 2/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSListOfTripsCollectionViewController.h"
#import <Parse/Parse.h>
#import "DTSTrip.h"
#import "DTSTripDetailsViewController.h"
#import "DTSTripCollectionViewCell.h"
#import "DTSUserAuthHelper.h"
#import "UIColor+Utilities.h"

@interface DTSListOfTripsCollectionViewController ()

@property (nonatomic, strong) NSArray *tripsList;

@end

@implementation DTSListOfTripsCollectionViewController
@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;

static NSString * const reuseIdentifier = @"DTSTripCollectionViewCell";

- (void)viewDidLoad {
    
    // Register cell classes
    [self.collectionView registerClass:[DTSTripCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self.collectionView registerNib:[UINib nibWithNibName:@"DTSTripCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.view.backgroundColor = [UIColor secondaryColor];
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.title = @"Trip Story";
	self.collectionView.contentInset = UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.bottomLayoutGuideLength, 0);
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[DTSUserAuthHelper sharedManager] presentLoginModalIfNotLoggedIn];
	[self fetchTripsList];
	
}

- (void)fetchTripsList
{	
	PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	if ([DTSUser currentUser])
	{
		[query whereKey:@"user" equalTo:[DTSUser currentUser]];
	}
	
	[query includeKey:@"originalEventsList"];
	[query includeKey:@"originalEventsList.location"];
	[query includeKey:@"originalEventsList.location.dtsPlacemark"];
	[query orderByDescending:@"createdAt"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error)
		{
			self.tripsList = objects;
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
			});
		}
	}];

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tripsList.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	DTSTrip *trip = nil;
	if (indexPath.row == self.tripsList.count)
	{
		
	}
	else
	{
		trip = dynamic_cast_oc(self.tripsList[indexPath.row], DTSTrip);
	}
    DTSTripCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor primaryColor];
	[trip fillInPlaceholderEvents];
	[cell updateViewWithTrip:trip];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake(self.view.frame.size.width, 300);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DTSTrip *trip = nil;
	if (indexPath.row == self.tripsList.count)
	{
		
	}
	else
	{
		trip = dynamic_cast_oc(self.tripsList[indexPath.row], DTSTrip);
	}
	
	DTSTripDetailsViewController *vc = [[DTSTripDetailsViewController alloc] init];
	vc.trip = trip;
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:vc animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
