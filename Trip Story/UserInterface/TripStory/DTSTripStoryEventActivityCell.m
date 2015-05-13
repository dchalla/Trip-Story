//
//  DTSTripStoryEventActivityCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripStoryEventActivityCell.h"
#import "NSDate+Utilities.h"
#import "UIView+Utilities.h"

@interface DTSTripStoryEventActivityCell()
@property (nonatomic, strong) DTSEvent *event;
@property (nonatomic, strong) CAGradientLayer *backgroundLayer;

@end

@implementation DTSTripStoryEventActivityCell


- (CAGradientLayer *)backgroundLayer
{
	if (!_backgroundLayer)
	{
		_backgroundLayer = [UIView gradientLayerWithTopColor:self.event.eventTopColor bottomColor:self.event.eventBottomColor];
		_backgroundLayer.masksToBounds = YES;
	}
	return _backgroundLayer;
}

- (void)awakeFromNib
{
    // Initialization code
	self.bubbleView.layer.cornerRadius = 8;
	self.backgroundColor = [UIColor clearColor];
	self.placeLabel.text =@"";
	self.eventNameLabel.text = @"";
	self.startTimelabel.text = @"";
	self.endTimeLabel.text = @"";
	self.descriptionLabel.text = @"";
	self.placeLabel.text =@"";
}

- (void)updateWithEvent:(DTSEvent *)event isFirstCell:(BOOL)isFirstCell
{
	self.event = event;
	self.eventNameLabel.text = event.eventName;
	self.startTimelabel.text = @"";
	if (isFirstCell)
	{
		self.startTimelabel.text = [event.startDateTime stringWithFormat:@"HH:mm\nd MMM"];
	}
	
	self.endTimeLabel.text = [event.endDateTime stringWithFormat:@"HH:mm\nd MMM"];
	if (event.eventDescription.length > 0)
	{
		self.descriptionLabel.text = event.eventDescription;
	}
	
	if (event.location.displayLocationCityState.length > 0)
	{
		self.placeLabel.text = event.location.displayLocationCityState;
	}
	
	
	self.bubbleView.layer.masksToBounds = YES;
	[self.bubbleView.layer insertSublayer:self.backgroundLayer atIndex:0];
	[self updateBackgroundLayerFrame];
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)updateBackgroundLayerFrame
{
	CGRect frame = self.bubbleView.bounds;
	frame.origin.x = 0;
	frame.origin.y = 0;
	frame.size.height = self.event.tripStoryCellHeight;
	self.backgroundLayer.frame = frame;
}

- (void)prepareForReuse
{
	if (_backgroundLayer)
	{
		[self.backgroundLayer removeFromSuperlayer];
		_backgroundLayer = nil;
	}
	self.eventNameLabel.text = @"";
	self.startTimelabel.text = @"";
	self.endTimeLabel.text = @"";
	self.descriptionLabel.text = @"";
	self.placeLabel.text =@"";
}


@end
