//
//  UIView+Utilities.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "UIView+Utilities.h"

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

@end
