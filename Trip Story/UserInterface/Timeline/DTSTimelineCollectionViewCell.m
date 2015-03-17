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

@interface DTSTimelineCollectionViewCell()

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
		self.startDateTimeLabel.text = [[self.trip startTimeOfTrip] stringWithFormat:@"dd/MM\nHH:mm"];
		self.endDateTimeLabel.text = [[self.trip endTimeOfTrip] stringWithFormat:@"dd/MM\nHH:mm"];
		[self updateDurationLabel];
		//self.tripTitleLabel.text = self.trip.tripName;
		//self.descriptionLabel.text = self.trip.tripDescription;
		self.tripTagsLabel.text = [self.trip tripTagsString];
		self.byUserLabel.text = [NSString stringWithFormat:@"by %@", [self.trip.user dts_displayName]];
		[self updateColorViews];
		
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

- (void)setupSpringboard
{
	
}

- (void)prepareForReuse
{
	[self clearOutData];
}

- (void)clearOutData
{
	self.startDateTimeLabel.text = @"";
	self.endDateTimeLabel.text = @"";
	//self.descriptionLabel.text = @"";
	//self.tripTitleLabel.text = @"";
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
}

@end
