//
//  DTSEventDetailsInfoTableViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 11/20/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventDetailsInfoTableViewCell.h"
#import "NSDate+Utilities.h"
#import "NSString+Utilities.h"

@implementation DTSEventDetailsInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
	self.topCircleView.layer.cornerRadius = self.topCircleView.frame.size.width/2;
	self.bottomCircleView.layer.cornerRadius = self.bottomCircleView.frame.size.width/2;
	self.middleCircleView.layer.cornerRadius = self.middleCircleView.frame.size.width/2;
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	
}

- (void)updateViewWithEvent:(DTSEvent *)event
{
	self.event = event;
	self.startDateTimeLabel.text = [self.event.startDateTime stringWithFormat:@"dd/MM HH:mm"];
	self.endDateTimeLabel.text = [self.event.endDateTime stringWithFormat:@"dd/MM HH:mm"];
	self.durationLabel.text = [NSString durationStringForHours:self.event.eventHours];
	self.addressLabel.text = self.event.location.displayFullAddress;
	self.descriptionLabel.text = self.event.eventDescription;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	self.addressLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.informationBackgroundView.frame);
	self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.informationBackgroundView.frame);
}

@end
