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
	self.parallaxView.layer.cornerRadius = self.parallaxView.frame.size.height/2;
	self.parallaxView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.parallaxView.layer.borderWidth = 0;
	
}

- (void)updateWithEvent:(DTSEvent *)event isFirstCell:(BOOL)isFirstCell
{
	
	self.event = event;
	self.startTimelabel.text = @"";
	if (isFirstCell)
	{
		self.startTimelabel.text = [event.startDateTime stringWithFormat:@"HH:mm\nd MMM"];
	}
	
	self.endTimeLabel.text = [event.endDateTime stringWithFormat:@"HH:mm\nd MMM"];
	
	if (event.isPlaceHolderEvent)
	{
		self.eventLineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
	}
	else
	{
		self.eventLineView.backgroundColor = [UIColor lightGrayColor];
	}
	
	if (event.isTravelEvent)
	{
		self.parallaxView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
		self.parallaxView.layer.borderColor = [UIColor whiteColor].CGColor;
		UIImage *icon = nil;
		switch (self.event.eventType)
		{
			case DTSEventTypeTravelByRoad:
				icon = [[UIImage imageNamed:@"car88.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				break;
			case DTSEventTypeTravelByAir:
				icon = [[UIImage imageNamed:@"airplane21.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				break;
			case DTSEventTypeTravelByWater:
				icon = [[UIImage imageNamed:@"waterTravel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				break;
				
			default:
				break;
		}
		
		self.parallaxImageView.image = icon;
		self.parallaxImageView.tintColor = [UIColor blackColor];
	}
	else
	{
		self.parallaxView.backgroundColor = [UIColor clearColor];
		self.parallaxView.layer.borderColor = [UIColor clearColor].CGColor;
		self.parallaxImageView.image = nil;
	}
}


- (void)prepareForReuse
{
	self.startTimelabel.text = @"";
	self.endTimeLabel.text = @"";
	self.parallaxImageView.image = nil;
}


- (void)didScrollOnTableView:(UITableView *)tableView
{
	NSIndexPath *indexPath = [tableView indexPathForCell:self];
	CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
	CGFloat parallaxableHeight = self.frame.size.height - self.parallaxView.frame.size.height;
	CGFloat tableViewFrameHeight = tableView.frame.size.height;
	CGFloat tableViewContentOffsetY = tableView.contentOffset.y;
	CGFloat amountToMoveForChangeInTableViewOffset = parallaxableHeight/tableViewFrameHeight;
	CGFloat tableViewPosition = tableViewFrameHeight + tableViewContentOffsetY+tableView.contentInset.top;
	float offset = (tableViewPosition - cellFrameInTableView.origin.y) * amountToMoveForChangeInTableViewOffset;
    
    self.parallaxImageViewOriginYConstraint.constant =  MIN(MAX(offset,0),self.frame.size.height-self.parallaxView.frame.size.height);
}



@end
