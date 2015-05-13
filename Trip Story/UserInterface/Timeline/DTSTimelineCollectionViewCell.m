//
//  DTSTimelineCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/14/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTimelineCollectionViewCell.h"
#import "NSDate+Utilities.h"
#import "PFUser+DTSAdditions.h"
#import "DTSCache.h"
#import "DTSUtilities.h"

@interface DTSTimelineCollectionViewCell()
@property (nonatomic) BOOL isLikeSelected;

@end

@implementation DTSTimelineCollectionViewCell

- (void)awakeFromNib {
	// Initialization code
	self.leftCircleView.layer.cornerRadius = self.leftCircleView.frame.size.width/2;
	self.rightCircleView.layer.cornerRadius = self.rightCircleView.frame.size.width/2;
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	self.colorViewsArray = @[self.colorView1,self.colorView2,self.colorView3,self.colorView4,self.colorView5,self.colorView6,self.colorView7,self.colorView8,self.colorView9,self.colorView10,self.colorView11];
	self.colorImageViewsArray = @[self.colorImageView1,self.colorImageView2,self.colorImageView3,self.colorImageView4,self.colorImageView5,self.colorImageView6,self.colorImageView7,self.colorImageView8,self.colorImageView9,self.colorImageView10,self.colorImageView11];
	for (UIView *colorView in self.colorViewsArray)
	{
		colorView.layer.cornerRadius = colorView.frame.size.width/2;
	}
	self.likeSmileyImageView.tintColor = [UIColor colorWithRed:233/255.0 green:185/255.0 blue:42/255.0 alpha:1];
	self.likedLabel.textColor = [UIColor colorWithRed:233/255.0 green:185/255.0 blue:42/255.0 alpha:1];
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)updateViewWithTrip:(DTSTrip *)trip
{
	_trip = trip;
	[self clearOutData];
	if (trip)
	{
		self.trip = trip;
		self.startDateTimeLabel.text = [[self.trip startTimeOfTrip] stringWithFormat:@"d MMM\nHH:mm"];
		self.endDateTimeLabel.text = [[self.trip endTimeOfTrip] stringWithFormat:@"d MMM\nHH:mm"];
		[self updateDurationLabel];
		self.tripTitleLabel.text = self.trip.tripName;
		self.descriptionLabel.text = self.trip.tripDescription;
		
		//testing
		if (self.trip.tripName.length == 0)
		{
			self.tripTitleLabel.text = @"My Trip";
			self.descriptionLabel.text = @"My beautifull trip to Hawaii. This is pure heaven. My beautifull trip to Hawaii. This is pure heaven.";
		}
		//end testing
		self.tripTagsLabel.text = [self.trip tripTagsString];
		self.byUserLabel.text = [NSString stringWithFormat:@"by %@", [self.trip.user dts_displayName]];
		[self updateColorViews];
		[self updateLikesAndComment];
	}
	
}

- (void)updateDurationLabel
{
	NSString *durationString = [self.trip tripDurationString];
	if ([durationString componentsSeparatedByString:@"\n"].count < 1)
	{
		durationString = [NSString stringWithFormat:@"%@\n ",durationString];
	}
	NSMutableAttributedString *attributedDurationString = [[NSMutableAttributedString alloc] initWithString:durationString];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = 5.0f;
	[attributedDurationString addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, attributedDurationString.length)];
	self.durationLabel.attributedText = attributedDurationString;
}

- (void)updateColorViews
{
	NSDictionary *eventTypeColorDict = [self.trip tripEventTypeColorDict];
	__block int i = 0;
	[eventTypeColorDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *eventType, UIColor *color, BOOL *stop){
		if (i < self.colorViewsArray.count)
		{
			((UIView *)self.colorViewsArray[i]).backgroundColor = color;
			((UIView *)self.colorViewsArray[i]).hidden = NO;
			((UIImageView *)self.colorImageViewsArray[i]).hidden = YES;
			if (eventType.integerValue == DTSEventTypeTravelByRoad)
			{
				((UIImageView *)self.colorImageViewsArray[i]).hidden = NO;
				((UIImageView *)self.colorImageViewsArray[i]).image = [[UIImage imageNamed:@"car88.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			else if (eventType.integerValue == DTSEventTypeTravelByAir)
			{
				((UIImageView *)self.colorImageViewsArray[i]).hidden = NO;
				((UIImageView *)self.colorImageViewsArray[i]).image = [[UIImage imageNamed:@"airplane21.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			else if (eventType.integerValue == DTSEventTypeTravelByWater)
			{
				((UIImageView *)self.colorImageViewsArray[i]).hidden = NO;
				((UIImageView *)self.colorImageViewsArray[i]).image = [[UIImage imageNamed:@"waterTravel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			}
			i = i+1;
		}
		
	}];
}
- (IBAction)likeButtonTapped:(id)sender {
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


- (void)prepareForReuse
{
	[self clearOutData];
}

- (void)clearOutData
{
	self.startDateTimeLabel.text = @"";
	self.endDateTimeLabel.text = @"";
	self.descriptionLabel.text = @"";
	self.tripTitleLabel.text = @"";
	self.byUserLabel.text = @"";
	self.tripTagsLabel.text = @"";
	self.durationLabel.text = @"";
	int i =0;
	for (UIView *colorView in self.colorViewsArray)
	{
		colorView.hidden = YES;
		((UIImageView *)self.colorImageViewsArray[i]).tintColor = [UIColor whiteColor];
		((UIImageView *)self.colorImageViewsArray[i++]).hidden = YES;
		
	}
	
	self.likeSmileyImageView.image =  [[UIImage imageNamed:@"smileyLikeBlue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	self.likedLabel.text = @"Like";
	self.isLikeSelected = NO;
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

@end
