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

@interface DTSListOfTripsCollectionViewController ()

@property (nonatomic, strong) NSArray *tripsList;

@end

@implementation DTSListOfTripsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fetchTripsList];
}

- (void)fetchTripsList
{
	PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	[query includeKey:@"originalEventsList"];
	[query includeKey:@"eventsList"];
	[query includeKey:@"eventsList.location"];
	[query includeKey:@"eventsList.location.dtsPlacemark"];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

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
	[self.navigationController pushViewController:vc animated:YES];
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
