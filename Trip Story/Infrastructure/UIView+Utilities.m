//
//  UIView+Utilities.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "UIView+Utilities.h"
#import "UIImage+ImageEffects.h"

@implementation UIView (Utilities)

+ (CAGradientLayer *)gradientLayerWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    NSArray *gradientColors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
    NSArray *gradientLocations = @[@0.0,@1.0];
	
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
	
    return gradientLayer;
}

- (UIImage *)dts_snapshotImage
{
	UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [UIScreen mainScreen].scale);
	[self drawViewHierarchyInRect:self.frame afterScreenUpdates:YES];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage *)dts_lightBlurredSnapshotImage
{
	UIImage *image = [self dts_snapshotImage];
	return [image applyLightEffect];
}

- (UIImage *)dts_darkBlurredSnapshotImage
{
	UIImage *image = [self dts_snapshotImage];
	return [image applyDarkEffect];
}

@end
