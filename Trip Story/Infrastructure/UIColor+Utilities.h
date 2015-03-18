//
//  UIColor+Utilities.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (NSString *)hexValuesFromUIColor:(UIColor *)color;
+ (UIColor *)selectionColor;
+ (UIColor *)primaryColor;
+ (UIColor *)secondaryColor;
+ (UIColor *)dtsBlueColor;


@end
