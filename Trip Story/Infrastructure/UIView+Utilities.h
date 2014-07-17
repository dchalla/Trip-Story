//
//  UIView+Utilities.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

+ (CAGradientLayer *)gradientLayerWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
- (UIImage *)dts_snapshotImage;
- (UIImage *)dts_lightBlurredSnapshotImage;
- (UIImage *)dts_darkBlurredSnapshotImage;

@end
