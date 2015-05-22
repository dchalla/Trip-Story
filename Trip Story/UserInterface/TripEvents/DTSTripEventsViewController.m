//
//  DTSEventsViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 10/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripEventsViewController.h"


#define kEventsCellReuseIdentifier @"kEventsCellReuseIdentifier"

@interface DTSTripEventsViewController ()

@property (nonatomic, assign) BOOL isInEditMode;

@end

@implementation DTSTripEventsViewController
@synthesize topLayoutGuideLength = _topLayoutGuideLength;
@synthesize bottomLayoutGuideLength = _bottomLayoutGuideLength;
@synthesize trip = _trip;

- (BOOL)isInEditMode
{
	if ([self.trip.user.username isEqualToString:[PFUser currentUser].username])
	{
		return YES;
	}
	return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor colorWithRed:15/255.0 green:17/255.0 blue:22/255.0 alpha:1];
	self.collectionView.backgroundColor = [UIColor colorWithRed:15/255.0 green:17/255.0 blue:22/255.0 alpha:1];
	self.stackedLayout.fillHeight = YES;
	self.stackedLayout.alwaysBounce = YES;
	
	[self.collectionView registerClass:[DTSTripEventsCollectionViewCell class] forCellWithReuseIdentifier:kEventsCellReuseIdentifier];
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.collectionView reloadData];
}

#pragma mark - CollectionViewDataSource protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return self.trip.originalEventsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	DTSTripEventsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEventsCellReuseIdentifier forIndexPath:indexPath];
	cell.delegate = self;
	cell.eventsCollectionViewCellDelegate = self;
	cell.isInEditMode = self.isInEditMode;
	[cell updateViewWithEvent:self.trip.originalEventsList[indexPath.row]];
	if ([cell conformsToProtocol:@protocol(DTSCollectionCardsViewControllerProtocol)])
	{
		if (self.exposedItemIndexPath && self.exposedItemIndexPath.row == indexPath.row && self.exposedItemIndexPath.section == indexPath.section)
		{
			cell.isExposed = YES;
		}
		else
		{
			cell.isExposed = NO;
		}
	}
	return cell;
}

- (void)editButtonTapped:(DTSEvent *)event
{
	[self.containerDelegate showEditEventEntry:event];
}

- (void)refreshView {
	if (self.exposedItemIndexPath)
	{
		[self collapseCurrentlyExposedItem];
	}
	
	[self.collectionView reloadData];
}

#pragma mark - opening event details
- (void)openEvent:(DTSEvent *)inEvent
{
	[self.collectionView reloadData];
	[self collapseCurrentlyExposedItem];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		int i =0;
		for (DTSEvent *event in self.trip.originalEventsList)
		{
			if ([event.eventID isEqualToString:inEvent.eventID])
			{
				[self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
				break;
			}
			i++;
		}
	});
	
}



@end
