//
//  DTSEventLocationEntryTableViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/24/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventLocationEntryTableViewCell.h"
#import "NSString+Utilities.h"
#import "UIColor+Utilities.h"

@implementation DTSEventLocationEntryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self updateLabel];
	self.suggestionMarkerView.backgroundColor = [UIColor dtsYellowColor];
	self.suggestionMarkerView.hidden = NO;
	
	self.backgroundColor = [UIColor clearColor];
	self.backgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setPlaceHolderValue:(NSString *)placeHolderValue
{
	_placeHolderValue = placeHolderValue;
	[self updateLabel];
	
}

- (void)setFieldValue:(DTSLocation *)fieldValue
{
	_fieldValue = fieldValue;
	[self updateLabel];
}

- (void)updateLabel
{
	self.suggestionMarkerView.hidden = NO;
	if (self.placeHolderValue.length > 0)
	{
		NSString *value = @"";
		if (self.fieldValue)
		{
			value = [NSString stringWithFormat:@" %@",self.fieldValue.locationName];
			self.suggestionMarkerView.hidden = YES;
		}
		self.label.attributedText = [NSString defaultColorAndFontAttributedString:self.placeHolderValue tailString:value];
	}
}

@end
