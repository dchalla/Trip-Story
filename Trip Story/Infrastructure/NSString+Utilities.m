//
//  NSString+Utilities.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/20/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)


+ (NSAttributedString *) attributedString:(NSString *)headString tailString:(NSString *)tailString headColor:(UIColor *)headColor tailColor:(UIColor *)tailColor headFont:(UIFont *)headFont tailFont:(UIFont *)tailFont
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",headString, tailString]];
	[attributedString addAttribute:NSFontAttributeName value:headFont range:NSMakeRange(0, headString.length)];
	[attributedString addAttribute:NSFontAttributeName value:tailFont range:NSMakeRange(attributedString.length-tailString.length, tailString.length)];
	[attributedString addAttribute:NSForegroundColorAttributeName value:headColor range:NSMakeRange(0, headString.length)];
	[attributedString addAttribute:NSForegroundColorAttributeName value:tailColor range:NSMakeRange(attributedString.length-tailString.length, tailString.length)];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

+ (NSAttributedString *) defaultColorAndFontAttributedString:(NSString *)headString tailString:(NSString *)tailString
{
	return [[self class] attributedString:headString tailString:tailString headColor:[UIColor lightGrayColor] tailColor:[UIColor whiteColor] headFont:[UIFont fontWithName:@"HelveticaNeue" size:14] tailFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
}

+ (NSAttributedString *) defaultFontAttributedString:(NSString *)headString tailString:(NSString *)tailString headColor:(UIColor *)headColor tailColor:(UIColor *)tailColor
{
	return [[self class] attributedString:headString tailString:tailString headColor:headColor tailColor:tailColor headFont:[UIFont fontWithName:@"HelveticaNeue" size:14] tailFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
}


@end
