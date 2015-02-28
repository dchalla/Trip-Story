//
//  NSObject+DTSAdditions.h
//  Trip Story
//
//  Created by Dinesh Challa on 2/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DTSAdditions)

#ifndef dynamic_cast_oc
extern id __dynamic_cast_impl(id obj, Class classType);
#define dynamic_cast_oc(OBJ,CLASS) ((CLASS *) __dynamic_cast_impl(OBJ, [CLASS class]))
#endif

@end
