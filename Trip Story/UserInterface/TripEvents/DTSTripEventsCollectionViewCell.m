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

@interface DTSTripEventsCollectionViewCell ()
@property (nonatomic, strong) UIView *cardView;
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

- (CAGradientLayer *)gradientLayer
{
	if (!_gradientLayer)
	{
		_gradientLayer = [UIView gradientLayerWithTopColor:self.event.eventTopColor bottomColor:self.event.eventBottomColor];
		_gradientLayer.masksToBounds = YES;
		_gradientLayer.cornerRadius = 10;
	}
	return _gradientLayer;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
	if (self) {
		self.cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
		
		self.cardView.layer.cornerRadius = 10;
		self.cardView.clipsToBounds = YES;
		[self.contentView addSubview:self.cardView];
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(0, -2);
		self.layer.shadowOpacity = 0.5f;
		self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10].CGPath;
		
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
	[self updateGradientLayerFrame];
}

- (void)updateViewWithEvent:(DTSEvent *)event
{
	self.event = event;
	[self.layer insertSublayer:self.gradientLayer atIndex:0];
	[self updateGradientLayerFrame];
}

- (void)updateGradientLayerFrame
{
	CGRect frame = self.bounds;
	frame.origin.x = 0;
	frame.origin.y = 0;
	self.gradientLayer.frame = frame;
}

- (void)prepareForReuse
{
	if (_gradientLayer)
	{
		[self.gradientLayer removeFromSuperlayer];
		_gradientLayer = nil;
	}
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
