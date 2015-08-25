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
#import "DKCFullDatePickerView.h"
#import "PMEDatePicker.h"

@interface DTSEventDateEntryTableViewCell()<PMEDatePickerDelegate,UIPickerViewDelegate>
@property (nonatomic, strong) PMEDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackgroundView;

@end

@implementation DTSEventDateEntryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.pickerView = [[PMEDatePicker alloc] init];
	self.pickerView.frame = self.bottomBackgroundView.bounds;
	[self.bottomBackgroundView addSubview:self.pickerView];
	
	if (self.dateValue)
	{
		[self.pickerView setDate:self.dateValue];
		[self updateLabel];
	}
	self.pickerView.dateDelegate = self;
	self.pickerView.dateFormatTemplate = @"yyyy MMM d h mm a";
	
	self.backgroundColor = [UIColor clearColor];
	self.backgroundView.backgroundColor = [UIColor clearColor];
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

- (void)datePicker:(PMEDatePicker *)datePicker didSelectDate:(NSDate *)date
{
	_dateValue = date;
	[self updateLabel];
	[self.delegate entryCompleteForIdentifier:self.identifier withValue:self.dateValue];
}



- (void)updateLabel
{
	NSString *dateString = @"";
	if (self.dateValue)
	{
		dateString = [NSString stringWithFormat:@" %@",[self.dateValue stringWithFormat:@"d MMM YYYY, h:mm a"]];
	}
	self.topLabel.attributedText = [NSString defaultColorAndFontAttributedString:self.placeHolderValue tailString:dateString];
}



@end
