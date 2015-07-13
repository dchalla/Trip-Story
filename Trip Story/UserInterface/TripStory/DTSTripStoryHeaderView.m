//
//  DTSTripStoryHeaderView.m
//  Trip Story
//
//  Created by Dinesh Challa on 9/1/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripStoryHeaderView.h"
#import "MagicPieLayer.h"
#import "DTSCache.h"
#import "DTSUtilities.h"
#import "PFUser+DTSAdditions.h"

#define PieLayerHeight 150
#define	PierLayerWidth PieLayerHeight

@interface DTSTripStoryHeaderView()

@property (nonatomic, strong) PieLayer *pieLayer;
@property (nonatomic) BOOL isLikeSelected;
@property (nonatomic) BOOL isInEditMode;

@end

@implementation DTSTripStoryHeaderView

- (BOOL)isInEditMode
{
	if ([self.trip.user.username isEqualToString:[PFUser currentUser].username])
	{
		return YES;
	}
	return NO;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.likeSmileyImageView.tintColor = [UIColor colorWithRed:233/255.0 green:185/255.0 blue:42/255.0 alpha:1];
	self.likedLabel.textColor = [UIColor colorWithRed:233/255.0 green:185/255.0 blue:42/255.0 alpha:1];
	self.yearLabel.text = @"";
}

- (void)setTrip:(DTSTrip *)trip
{
	_trip = trip;
	[self updateView];
}

- (void)setViewAppeared:(BOOL)viewAppeared
{
	_viewAppeared = viewAppeared;
#ifdef DEBUG
	[self performSelector:@selector(updateView) withObject:nil afterDelay:0.2];
#else
	[self updateView];
#endif
}

- (void)updateView
{
	if (self.viewAppeared && self.trip)
	{
		[self updateLabels];
		[self updatePieView];
		[self updateLikesAndComment];
	}
	
}

- (void)updateLabels
{
	self.tripTitle.text = self.trip.tripName.length?self.trip.tripName:@"My Trip";
	self.tripDurationLabel.text = [self.trip tripDurationString];
	self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.trip.tripDescription];
	[self.byUserButton setTitle:[NSString stringWithFormat:@"by %@", [self.trip.user dts_displayName]] forState:UIControlStateNormal] ;
	self.yearLabel.text = [self.trip tripYearsString];
	if (self.isInEditMode)
	{
		self.editButton.hidden = NO;
	}
	else
	{
		self.editButton.hidden = YES;
	}
}

- (void)updatePieView
{
	if (self.pieLayer)
	{
		NSArray *eventsDuration = [self.trip eventsDurationArray:YES];
		int i = 0;
		for (NSNumber *duration in eventsDuration)
		{
			PieElement* pieElem = self.pieLayer.values[i];
			if (pieElem.val != duration.floatValue)
			{
				//[PieElement animateChanges:^{
					pieElem.val = duration.floatValue;
				//}];

			}
			i++;
		}

	}
	else
	{
		self.pieLayer = [[PieLayer alloc] initWithMaxRadius:70 minRadius:50];
		self.pieLayer.frame = CGRectMake((self.pieView.frame.size.width - PierLayerWidth)/2, (self.pieView.frame.size.height - PieLayerHeight)/2, PierLayerWidth, PieLayerHeight);
		[self.pieView.layer addSublayer:self.pieLayer];
		
		NSArray *eventsDuration = [self.trip eventsDurationArray:YES];
		NSMutableArray *pieElementsArray = [NSMutableArray array];
		int i = 0;
		for (NSNumber *duration in eventsDuration)
		{
			UIColor *eventTypeColor = [DTSEvent topColorForEventType:i];
			UIColor *eventTypeBottomColor = [DTSEvent bottomColorForEventType:i];
			PieElement *element = [PieElement pieElementWithValue:duration.floatValue color:eventTypeColor bottomColor:eventTypeBottomColor];
			[pieElementsArray addObject:element];
			i++;
		}
		[self.pieLayer addValues:pieElementsArray animated:YES];
	}
	
}

- (IBAction)editButtonTapped:(id)sender {
	if (self.delegate)
	{
		[self.delegate tripStoryHeaderViewEditButtonTapped];
	}
}

#pragma mark - like stuff

- (IBAction)likeButtonTapped:(id)sender {
	if ([PFUser currentUser] == nil)
	{
		return;
	}
	
	if (self.isLikeSelected)
	{
		self.likeSmileyImageView.image =  [[UIImage imageNamed:@"smileyLikeBlue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.likedLabel.text = @"Like";
		self.isLikeSelected = NO;
		[[DTSCache sharedCache] decrementLikerCountForTrip:self.trip];
		[[DTSCache sharedCache] setTripIsLikedByCurrentUser:self.trip liked:NO];
		[DTSUtilities unlikeTripInBackground:self.trip block:^(BOOL succeeded, NSError *error) {
			if (succeeded)
			{
				NSLog(@"success");
			}
		}];
		
		
	}
	else
	{
		self.likeSmileyImageView.image =  [[UIImage imageNamed:@"smileyLikeBlueFull.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.likedLabel.text = @"Liked";
		self.isLikeSelected = YES;
		[[DTSCache sharedCache] incrementLikerCountForTrip:self.trip];
		[[DTSCache sharedCache] setTripIsLikedByCurrentUser:self.trip liked:YES];
		[DTSUtilities likeTripInBackground:self.trip block:^(BOOL succeeded, NSError *error) {
			if (succeeded)
			{
				NSLog(@"success");
			}
		}];
	}
	[self updateLikeCommentCountWithAttribute:[[DTSCache sharedCache] attributesForTrip:self.trip]];
}


- (void)updateLikeButton
{
	if ([PFUser currentUser] == nil)
	{
		self.likeSmileyImageView.hidden = YES;
		self.likedLabel.hidden = YES;
	}
	else
	{
		self.likeSmileyImageView.hidden = NO;
		self.likedLabel.hidden = NO;
	}
	
	if (!self.isLikeSelected)
	{
		self.likeSmileyImageView.image =  [[UIImage imageNamed:@"smileyLikeBlue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.likedLabel.text = @"Like";
	}
	else
	{
		self.likeSmileyImageView.image =  [[UIImage imageNamed:@"smileyLikeBlueFull.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.likedLabel.text = @"Liked";
	}
}

- (void)updateLikesAndComment
{
	NSDictionary *attributesForTrip = [[DTSCache sharedCache] attributesForTrip:self.trip];
	
	if (attributesForTrip)
	{
		[self updateLikeCommentCountWithAttribute:attributesForTrip];
	}
	else
	{
		self.likeSmileyImageView.alpha = 0.0f;
		self.likedLabel.alpha = 0.0f;
		self.totalLikeCommentsLabel.alpha = 0.0f;
		
		@synchronized(self) {
			// check if we can update the cache
			{
				BlockWeakSelf wSelf = self;
				if (self.trip.objectId)
				{
					PFQuery *query = [DTSUtilities queryForActivitiesOnTrip:self.trip cachePolicy:kPFCachePolicyNetworkOnly];
					NSString *tripObjectID = [self.trip objectId];
					[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
						BlockStrongSelf strongSelf = wSelf;
						if (!strongSelf)
						{
							return;
						}
						@synchronized(strongSelf) {
							
							if (error) {
								return;
							}
							
							NSMutableArray *likers = [NSMutableArray array];
							NSMutableArray *commenters = [NSMutableArray array];
							
							BOOL isLikedByCurrentUser = NO;
							
							for (DTSActivity *activity in objects) {
								if ([activity.type isEqualToString:kDTSActivityTypeLike] && activity.fromUser)
								{
									[likers addObject:activity.fromUser];
								}
								else if ([activity.type isEqualToString:kDTSActivityTypeComment] && activity.fromUser)
								{
									[commenters addObject:activity.fromUser];
								}
								
								if ([[activity.fromUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
									if ([activity.type isEqualToString:kDTSActivityTypeLike]) {
										isLikedByCurrentUser = YES;
									}
								}
							}
							
							[[DTSCache sharedCache] setAttributesForTripObjectID:tripObjectID likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
							if ([[strongSelf.trip objectId] isEqualToString:tripObjectID])
							{
								[strongSelf updateLikeCommentCountWithAttribute:[[DTSCache sharedCache] attributesForTrip:strongSelf.trip]];
							}
							
						}
					}];
				}
			}
		}
	}
}

- (void)updateLikeCommentCountWithAttribute:(NSDictionary *)attributesForTrip
{
	if (!attributesForTrip)
	{
		return;
	}
	self.isLikeSelected = [[DTSCache sharedCache] isTripLikedByCurrentUser:self.trip];
	[self updateLikeButton];
	NSNumber *likersCount = [[DTSCache sharedCache] likeCountForTrip:self.trip];
	//NSNumber *commentCount = [[DTSCache sharedCache] commentCountForTrip:self.trip];
	self.totalLikeCommentsLabel.text = [NSString stringWithFormat:@"%ld like%@",(long)likersCount.integerValue,likersCount.integerValue>1?@"s":@""];
	if (self.likeSmileyImageView.alpha == 0)
	{
		self.likeSmileyImageView.alpha = 1.0f;
		self.likedLabel.alpha = 1.0f;
		self.totalLikeCommentsLabel.alpha = 1.0f;
	}
}

- (IBAction)byUserButtonTapped:(id)sender {
	[DTSUtilities openUserDetailsForUser:self.trip.user];
}


#pragma mark - share

- (IBAction)shareButtonTapped:(id)sender {
	[self.delegate shareButtonTapped];
}




@end
