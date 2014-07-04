//
//  DTSTripStoryEventGeneralCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripStoryEventGeneralCell.h"
#import "NSDate+Utilities.h"

@interface DTSTripStoryEventGeneralCell ()
@property (nonatomic, strong) DTSEvent *event;

@end

@implementation DTSTripStoryEventGeneralCell

- (void)awakeFromNib
{
    // Initialization code
	self.backgroundColor = [UIColor clearColor];
}

- (void)updateWithEvent:(DTSEvent *)event
{
	self.event = event;
	self.startTimelabel.text = [event.startDateTime stringWithFormat:@"hh:mm"];
	self.endTimeLabel.text = [event.endDateTime stringWithFormat:@"hh:mm"];
	
}


- (void)prepareForReuse
{
	self.startTimelabel.text = @"";
	self.endTimeLabel.text = @"";
}
@end
