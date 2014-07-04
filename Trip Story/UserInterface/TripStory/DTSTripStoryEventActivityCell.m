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
}

- (void)updateWithEvent:(DTSEvent *)event
{
	self.event = event;
	self.eventNameLabel.text = event.eventName;
	self.startTimelabel.text = [event.startDateTime stringWithFormat:@"hh:mm"];
	self.endTimeLabel.text = [event.endDateTime stringWithFormat:@"hh:mm"];
	
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
}


@end
