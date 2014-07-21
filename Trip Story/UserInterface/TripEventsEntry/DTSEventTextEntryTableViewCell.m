//
//  DTSEventTextEntryTableViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventTextEntryTableViewCell.h"

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
}

- (void)setPlaceHolderValue:(NSString *)placeHolderValue
{
	_placeHolderValue = placeHolderValue;
	if (self.textField)
	{
		self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolderValue attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
	}
}

- (void)setFieldValue:(NSString *)fieldValue
{
	_fieldValue = fieldValue;
	self.textField.text = self.fieldValue;
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
