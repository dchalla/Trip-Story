//
//  DTSTripCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 2/28/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripCollectionViewCell.h"
#import "NSDate+Utilities.h"

@implementation DTSTripCollectionViewCell

- (void)awakeFromNib {
	// Initialization code
	self.topCircleView.layer.cornerRadius = self.topCircleView.frame.size.width/2;
	self.bottomCircleView.layer.cornerRadius = self.bottomCircleView.frame.size.width/2;
	self.middleCircleView.layer.cornerRadius = self.middleCircleView.frame.size.width/2;
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	self.addressLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.informationBackgroundView.frame);
	self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.informationBackgroundView.frame);
}

- (void)updateViewWithTrip:(DTSTrip *)trip
{
	[self clearOutData];
	if (trip)
	{
		self.trip = trip;
		self.startDateTimeLabel.text = [[self.trip startTimeOfTrip] stringWithFormat:@"dd/MM HH:mm"];
		self.endDateTimeLabel.text = [[self.trip endTimeOfTrip] stringWithFormat:@"dd/MM HH:mm"];
		self.durationLabel.text = [self.trip tripDurationString];
		self.addressLabel.text = self.trip.tripName;
		self.descriptionLabel.text = self.trip.tripDescription;
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
	self.durationLabel.text = @"";
	self.addressLabel.text = @"";
	self.descriptionLabel.text = @"";
}

@end
