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
	 UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.87];
	return [image applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (void)addTopBorderWithColor:(UIColor *)borderColor borderHeight:(CGFloat)borderHeight
{
	CALayer *topBorder = [CALayer layer];
	topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, borderHeight);
	topBorder.backgroundColor = borderColor.CGColor;
	[self.layer addSublayer:topBorder];
}

- (void)addBottomBorderWithColor:(UIColor *)borderColor borderHeight:(CGFloat)borderHeight
{
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height-borderHeight, self.frame.size.width, borderHeight);
	bottomBorder.backgroundColor = borderColor.CGColor;
	[self.layer addSublayer:bottomBorder];
}

+ (id)dts_viewFromNibWithName:(NSString*)nibName owner:(id)owner bundle:(NSBundle*)inBundle
{
	UINib* nib = [UINib nibWithNibName:nibName bundle:inBundle];
	
	return [self dts_viewFromNib:nib owner:owner];
}

+ (id)dts_viewFromNibWithName:(NSString*)nibName bundle:(NSBundle*)inBundle
{
	return [UIView dts_viewFromNibWithName:nibName owner:nil bundle:inBundle];
}

+ (id)dts_viewFromNib:(UINib*)nib owner:(id)owner
{
	id view = nil;
	if(nib)
	{
		NSArray* loadedObjects = [nib instantiateWithOwner:owner options:nil];
		if(loadedObjects && loadedObjects.count > 0)
			view = [loadedObjects objectAtIndex:0];
		
		NSAssert(view, @"View could not be loaded from nib");
	}
	
	return view;
}

+ (id)dts_viewFromNib:(UINib*)nib {
	return [UIView dts_viewFromNib:nib owner:nil];
}

@end
