//
//  DTSAddEventDelegate.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/26/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSEvent.h"
@protocol DTSAddEventDelegate <NSObject>
- (void)didAddEvent:(DTSEvent *)event isNew:(BOOL)isNew;

@end
