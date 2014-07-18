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
    // Initialization code
	if ([self.textField respondsToSelector:@selector(setAttributedPlaceholder:)])
	{
		self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Event Name" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
