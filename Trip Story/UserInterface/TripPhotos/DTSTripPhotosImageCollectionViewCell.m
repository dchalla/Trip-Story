//
//  DTSTripPhotosImageCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripPhotosImageCollectionViewCell.h"
#import "MPSkewedCollectionViewLayoutAttributes.h"
#import <Shimmer/FBShimmeringView.h>

@interface DTSTripPhotosImageCollectionViewCell()

@property (nonatomic, assign) CGFloat parallaxValue;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;

@end

@implementation DTSTripPhotosImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
	_imageView.frame = CGRectInset(self.bounds, 0, -CGRectGetHeight(self.frame) / 8);
	_imageView.backgroundColor = [UIColor clearColor];
	_imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	_imageView.clipsToBounds = YES;
	
	UIImageView *shimmerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Imageplaceholder"]];
	self.shimmeringView.contentView = shimmerImage;
	self.shimmeringView.shimmering = YES;
	self.shimmeringView.shimmeringOpacity = 0.1;
	self.shimmeringView.shimmeringAnimationOpacity = 0.5;
	
}

- (void)prepareForReuse {
	self.imageView.image = nil;
}

- (void)applyLayoutAttributes:(MPSkewedCollectionViewLayoutAttributes *)layoutAttributes {
	[super applyLayoutAttributes:layoutAttributes];
	self.parallaxValue = layoutAttributes.parallaxValue;
}


- (void)setParallaxValue:(CGFloat)parallaxValue {
	_parallaxValue = parallaxValue;
	CGFloat height = CGRectGetHeight(self.bounds);
	CGFloat maxOffset = -height / 8 - height / 8;
	
	CGRect frame = self.imageView.frame;
	frame.origin.y = maxOffset * parallaxValue;
	self.imageView.frame = frame;
	
}

@end
