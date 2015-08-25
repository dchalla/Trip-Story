//
//  DTSEventTextEntryTableViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventTextEntryTableViewCell.h"
#import "UIColor+Utilities.h"

@implementation DTSEventTextEntryTableViewCell

- (void)awakeFromNib
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
	if ([self.textField respondsToSelector:@selector(setAttributedPlaceholder:)])
	{
		if (self.placeHolderValue)
		{
			self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolderValue attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
		}
		
	}
	self.textField.delegate = self;
	self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
	[self.textField addTarget:self
				  action:@selector(textFieldDidChange:)
		forControlEvents:UIControlEventEditingChanged];
	self.suggestionMarkerView.backgroundColor = [UIColor dtsRedColor];

	self.backgroundColor = [UIColor clearColor];
	self.backgroundView.backgroundColor = [UIColor clearColor];
}

- (void)setPlaceHolderValue:(NSString *)placeHolderValue
{
	_placeHolderValue = placeHolderValue;
	if (self.textField)
	{
		self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolderValue attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
	}
	if ([placeHolderValue.lowercaseString isEqualToString:@"event description"]) {
		self.suggestionMarkerView.backgroundColor = [UIColor dtsYellowColor];
	}
}

- (void)setFieldValue:(NSString *)fieldValue
{
	_fieldValue = fieldValue;
	self.textField.text = self.fieldValue;
	if (self.fieldValue.length == 0) {
		self.suggestionMarkerView.hidden = NO;
	}
	else
	{
		self.suggestionMarkerView.hidden = YES;
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

- (void)textFieldDidChange:(UITextField *)sender
{
	_fieldValue = sender.text;
	if (self.delegate)
	{
		[self.delegate entryCompleteForIdentifier:self.identifier withValue:self.fieldValue];
	}
	if (self.fieldValue.length == 0) {
		self.suggestionMarkerView.hidden = NO;
	}
	else
	{
		self.suggestionMarkerView.hidden = YES;
	}

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self.delegate didSelectCellForIdentifier:self.identifier];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	self.identifier = nil;
	self.textField.text = @"";
	_fieldValue = nil;
}



@end
