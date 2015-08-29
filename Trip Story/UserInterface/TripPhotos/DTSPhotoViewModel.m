//
//  DTSPhotoViewModel.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/28/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSPhotoViewModel.h"

@implementation DTSPhotoViewModel
@synthesize image = _image;
@synthesize placeholderImage = _placeholderImage;
@synthesize attributedCaptionCredit = _attributedCaptionCredit;
@synthesize attributedCaptionSummary = _attributedCaptionSummary;
@synthesize attributedCaptionTitle = _attributedCaptionTitle;

- (id)initWithTripPhoto:(DTSTripPhoto *)tripPhoto andImage:(UIImage *)image
{
	self = [super init];
	if (self) {
		self.tripPhoto = tripPhoto;
		_image = image;
	}
	return self;
}

- (void)setTripPhoto:(DTSTripPhoto *)tripPhoto {
	_tripPhoto = tripPhoto;
	
}



@end
