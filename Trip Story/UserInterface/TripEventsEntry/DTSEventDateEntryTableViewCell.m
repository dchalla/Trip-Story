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

@interface DTSEventDateEntryTableViewCell()<DKCFullDatePickerViewProtocol>
@property (nonatomic, strong) DKCFullDatePickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackgroundView;

@end

@implementation DTSEventDateEntryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.pickerView = [[DKCFullDatePickerView alloc] init];
	self.pickerView.frame = self.bottomBackgroundView.bounds;
	[self.bottomBackgroundView addSubview:self.pickerView];
	
	if (self.dateValue)
	{
		[self.pickerView setDate:self.dateValue];
		[self updateLabel];
	}
	self.pickerView.delegate = self;
}

- (void)setDateValue:(NSDate *)dateValue
{
	_dateValue = dateValue;
	if (self.pickerView && dateValue)
	{
		//[self.pickerView setDate:dateValue];
	}
	if (self.topLabel)
	{
		[self updateLabel];
	}
}

- (void)dkcFullDatePickerValueChanged:(NSDate *)date
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
