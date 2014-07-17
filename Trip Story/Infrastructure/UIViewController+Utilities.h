//
//  UIViewController+Utilities.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utilities)

- (void)dts_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)presenting;
- (NSTimeInterval)dts_transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
