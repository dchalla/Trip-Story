//
//  UIViewController+Utilities.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "UIViewController+Utilities.h"
#define CROSS_FADE_TRANSITION_MAX_SCALE 1.2f
#define CROSS_FADE_TRANSITION_MIN_SCALE 0.9f
#define CROSS_FADE_ANIMATION_DURATION 0.3f

@implementation UIViewController (Utilities)


- (void)dts_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext presenting:(BOOL)presenting
{
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if (presenting) {
		
		//View controller will be recieving events
		fromViewController.view.userInteractionEnabled = NO;
		
		[transitionContext.containerView addSubview:fromViewController.view];
		[transitionContext.containerView addSubview:toViewController.view];
		
		toViewController.view.alpha = 0.0f;
		toViewController.view.transform = CGAffineTransformMakeScale(CROSS_FADE_TRANSITION_MAX_SCALE, CROSS_FADE_TRANSITION_MAX_SCALE);
		
		[UIView animateWithDuration:[self dts_transitionDuration:transitionContext] animations:^{
			fromViewController.view.transform = CGAffineTransformMakeScale(CROSS_FADE_TRANSITION_MIN_SCALE, CROSS_FADE_TRANSITION_MIN_SCALE);
			toViewController.view.transform = CGAffineTransformIdentity;
			toViewController.view.alpha = 1.0f;
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
		}];
	}
	else {
		toViewController.view.userInteractionEnabled = YES;
		
		[transitionContext.containerView addSubview:toViewController.view];
		[transitionContext.containerView addSubview:fromViewController.view];
		
		toViewController.view.transform = CGAffineTransformMakeScale(CROSS_FADE_TRANSITION_MIN_SCALE, CROSS_FADE_TRANSITION_MIN_SCALE);
		
		[UIView animateWithDuration:[self dts_transitionDuration:transitionContext] animations:^{
			toViewController.view.alpha = 1.0f;
			toViewController.view.transform = CGAffineTransformIdentity;
			fromViewController.view.transform = CGAffineTransformMakeScale(CROSS_FADE_TRANSITION_MAX_SCALE, CROSS_FADE_TRANSITION_MAX_SCALE);
			fromViewController.view.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
		}];
	}
}

- (NSTimeInterval)dts_transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return CROSS_FADE_ANIMATION_DURATION;
}


@end
