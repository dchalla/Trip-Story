//
//  DTSTripPhotosImageCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripPhotosImageCollectionViewCell.h"

@implementation DTSTripPhotosImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
	self.imageView.image = nil;
}

@end
