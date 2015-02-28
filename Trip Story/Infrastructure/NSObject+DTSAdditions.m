//
//  NSObject+DTSAdditions.m
//  Trip Story
//
//  Created by Dinesh Challa on 2/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "NSObject+DTSAdditions.h"

@implementation NSObject (DTSAdditions)

inline id __dynamic_cast_impl(id obj, Class classType)
{
	if (obj && [obj isKindOfClass:classType])
		return obj;
	return nil;
}

@end
