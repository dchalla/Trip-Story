//
//  DTSEventPickerEntryTableViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/19/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventPickerEntryTableViewCell.h"
#import "NSString+Utilities.h"
#import "UIColor+Utilities.h"

@implementation DTSEventPickerEntryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	if (self.pickerValue)
	{
		[self.pickerView selectRow:self.pickerValue.integerValue inComponent:0 animated:YES];
	}
	else
	{
		[self.pickerView selectRow:0 inComponent:0 animated:YES];
	}
	[self updateLabel];
    [self.pickerView reloadAllComponents];
	self.suggestionMarkerView.backgroundColor = [UIColor dtsYellowColor];
	self.suggestionMarkerView.hidden = NO;
	
	self.backgroundColor = [UIColor clearColor];
	self.backgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setPickerValue:(NSNumber *)pickerValue
{
	_pickerValue = pickerValue;
	if (self.pickerView && pickerValue)
	{
		[self.pickerView selectRow:self.pickerValue.integerValue inComponent:0 animated:YES];
	}
	if (self.topLabel)
	{
		[self updateLabel];
	}
}

- (void)setPickerData:(NSArray *)pickerData
{
	_pickerData = pickerData;
	[self updateLabel];
}

- (void)updateLabel
{
	NSString *valueString = @"";
	self.suggestionMarkerView.hidden = NO;
	if (self.pickerValue && self.pickerData)
	{
		if ([self.pickerValue integerValue] >= self.pickerData.count)
		{
			_pickerValue = @(0);
		}
		valueString = [NSString stringWithFormat:@" %@",self.pickerData[self.pickerValue.integerValue]];
		if (valueString.length <= 0)
		{
			valueString = @"";
		}
		if (_pickerValue.integerValue != 0 && valueString.length > 0) {
			self.suggestionMarkerView.hidden = YES;
		}
	}
	self.topLabel.attributedText = [NSString defaultColorAndFontAttributedString:self.placeHolderValue tailString:valueString];
}


#pragma mark -
#pragma mark Picker Data Source Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}

#pragma mark Picker Delegate Methods
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerValue = @(row);
	[self updateLabel];
	[self.delegate entryCompleteForIdentifier:self.identifier withValue:self.pickerValue];
}


@end
