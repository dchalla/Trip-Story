//
//  NSString+Utilities.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/20/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

+ (NSAttributedString *) attributedString:(NSString *)headString tailString:(NSString *)tailString headColor:(UIColor *)headColor tailColor:(UIColor *)tailColor headFont:(UIFont *)headFont tailFont:(UIFont *)tailFont;
+ (NSAttributedString *) defaultColorAndFontAttributedString:(NSString *)headString tailString:(NSString *)tailString;
+ (NSAttributedString *) defaultFontAttributedString:(NSString *)headString tailString:(NSString *)tailString headColor:(UIColor *)headColor tailColor:(UIColor *)tailColor;

@end
