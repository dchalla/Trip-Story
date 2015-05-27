//
//  DTSRequiresLoginView.m
//  Trip Story
//
//  Created by Dinesh Challa on 5/22/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSRequiresLoginView.h"
#import "DTSUserAuthHelper.h"
#import "UIColor+Utilities.h"
#import "DTSConstants.h"

@implementation DTSRequiresLoginView

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.backgroundColor = [UIColor clearColor];
	self.layer.cornerRadius = 8.0;
}

- (IBAction)loginButtonTapped:(id)sender {
	[[DTSUserAuthHelper sharedManager] presentLoginModalIfNotLoggedIn];
	
}

@end
