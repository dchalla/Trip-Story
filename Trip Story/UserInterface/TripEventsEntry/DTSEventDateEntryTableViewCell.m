//
//  DTSEventDateEntryTableViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventDateEntryTableViewCell.h"
#import "NSDate+Utilities.h"
#import "NSString+Utilities.h"

@implementation DTSEventDateEntryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	if (self.dateValue)
	{
		[self.pickerView setDate:self.dateValue];
		[self updateLabel];
	}
	[self.pickerView addTarget:self
			   action:@selector(datePickerValueChanged:)
	 forControlEvents:UIControlEventValueChanged];
}

- (void)setDateValue:(NSDate *)dateValue
{
	_dateValue = dateValue;
	if (self.pickerView && dateValue)
	{
		[self.pickerView setDate:dateValue];
	}
	if (self.topLabel)
	{
		[self updateLabel];
	}
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
	_dateValue = datePicker.date;
	[self updateLabel];
	[self.delegate entryCompleteForIdentifier:self.identifier withValue:self.dateValue];
}

- (void)updateLabel
{
	NSString *dateString = @"";
	if (self.dateValue)
	{
		dateString = [NSString stringWithFormat:@" %@",[self.dateValue stringWithFormat:@"M/d HH:mm"]];
	}
	self.topLabel.attributedText = [NSString defaultColorAndFontAttributedString:self.placeHolderValue tailString:dateString];
}



@end
