//
//  DTSTripEventsCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 10/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Utilities.h"
#import "DTSTripEventsCollectionViewCell.h"
#import "DTSTripEventDetailsViewController.h"

@interface DTSTripEventsCollectionViewCell ()
@property (nonatomic, strong) DTSTripEventDetailsViewController *eventDetailsVC;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) DTSEvent *event;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@end

@implementation DTSTripEventsCollectionViewCell
@synthesize isExposed = _isExposed;

- (void)setIsExposed:(BOOL)isExposed
{
	_isExposed = isExposed;
	if (isExposed)
	{
		self.gestureRecognizer.enabled = YES;
	}
	else
	{
		self.gestureRecognizer.enabled = NO;
	}
}


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
	if (self) {
		self.eventDetailsVC = [[DTSTripEventDetailsViewController alloc] initWithNibName:@"DTSTripEventDetailsViewController" bundle:[NSBundle mainBundle]];
		[((UIViewController *)self.delegate) addChildViewController:self.eventDetailsVC];
		[self.eventDetailsVC didMoveToParentViewController:((UIViewController *)self.delegate)];
		self.eventDetailsVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
		self.eventDetailsVC.view.layer.cornerRadius = 10;
		[self.contentView addSubview:self.eventDetailsVC.view];
		
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(0, -2);
		self.layer.shadowOpacity = 0.5f;
		self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0].CGPath;
		
		self.clipsToBounds = NO;
		
		self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning:)];
		[self addGestureRecognizer:self.gestureRecognizer];
		self.gestureRecognizer.enabled = NO;
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.eventDetailsVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (void)updateViewWithEvent:(DTSEvent *)event
{
	self.event = event;
	[self.eventDetailsVC updateViewWithEvent:self.event];
}

- (void)panning:(UIPanGestureRecognizer *)recognizer
{
	if (self.isExposed)
	{
		CGPoint translation = [recognizer translationInView:self];
		recognizer.view.center = CGPointMake(recognizer.view.center.x,
											 recognizer.view.center.y + translation.y);
		[recognizer setTranslation:CGPointMake(0, 0) inView:self];
		
		if (recognizer.state == UIGestureRecognizerStateEnded) {
			if ([self.delegate respondsToSelector:@selector(cardCellDidPan:)]) {
				[self.delegate cardCellDidPan:self];
			}
		}
	}
}


@end
