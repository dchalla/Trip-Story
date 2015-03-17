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

+ (NSString *)durationStringForHours:(NSNumber *)totalhours
{
	NSInteger days = totalhours.floatValue/24;
	NSInteger hours = totalhours.integerValue%24;
	NSString *durationString = @"";
	if ([NSDateComponentsFormatter class])
	{
		NSDateComponentsFormatter *dateComponentsFromatter = [[NSDateComponentsFormatter alloc] init];
		dateComponentsFromatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
		
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		dateComponents.day = days;
		dateComponents.hour = hours;
		
		durationString = [dateComponentsFromatter stringFromDateComponents:dateComponents];
		durationString = [durationString stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
	}
	else
	{
		NSString *daysString = @"";
		NSString *hoursString = @"";
		if (days > 1)
		{
			daysString = [NSString stringWithFormat:@"%ld days",days];
		}
		else if(days > 0)
		{
			daysString = [NSString stringWithFormat:@"%ld day",days];
		}
		
		if (hours > 1)
		{
			hoursString = [NSString stringWithFormat:@"%ld hours",hours];
		}
		else if(hours > 0)
		{
			hoursString = [NSString stringWithFormat:@"%ld hour",hours];
		}
		if (daysString.length > 0)
		{
			if (hoursString.length > 0)
			{
				durationString = [NSString stringWithFormat:@"%@\n%@",daysString,hoursString];
			}
			else
			{
				durationString = daysString;
			}
		}
		else if(hoursString.length > 0)
		{
			durationString = hoursString;
		}
	}
	
	return durationString;
	
}


@end
