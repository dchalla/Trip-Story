//
//  DTSSpringboardItemView.m
//

#import "DTSSpringboardItemView.h"

static double const kDTSSpringboardItemViewSmallThreshold = 0.75;

@interface DTSSpringboardItemView ()
{
	UIVisualEffectView *_iconBackground;
}

@end

#pragma mark -

@implementation DTSSpringboardItemView

- (void)setScale:(CGFloat)scale
{
	[self setScale:scale animated:NO];
}

- (void)setTitle:(NSString*)title
{
	_label.text = title;
	[self setNeedsLayout];
}

- (void)setModelData:(DTSSpringboardItemModel *)modelData
{
	_modelData = modelData;
	[self setTitle:modelData.title];
	[self fetchIcon];
}

- (void)fetchIcon
{
	/* TODO*/
}

- (void)setScale:(CGFloat)scale animated:(BOOL)animated
{
	if(_scale != scale)
	{
		BOOL wasSmallBefore = (_scale < kDTSSpringboardItemViewSmallThreshold);
		_scale = scale;
		[self setNeedsLayout];
		if((_scale < kDTSSpringboardItemViewSmallThreshold) != wasSmallBefore)
		{
			if(animated == YES)
			{
				
				[UIView animateWithDuration:0.3 animations:^{
					[self layoutIfNeeded];
					if(self.scale < kDTSSpringboardItemViewSmallThreshold)
						self.label.alpha = 0;
					else
						self.label.alpha = 1;
				}];
			}
			else
			{
				if(self.scale < kDTSSpringboardItemViewSmallThreshold)
					self.label.alpha = 0;
				else
					self.label.alpha = 1;
			}
		}
	}
}

#pragma mark - UIView

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize size = self.bounds.size;
	
	_iconBackground.center = CGPointMake(size.width*0.5, size.height*0.5);
	_iconBackground.layer.cornerRadius = size.width*0.5;
	_iconBackground.bounds = CGRectMake(0, 0, size.width, size.height);
	_icon.center = CGPointMake(size.width*0.5, size.height*0.5);
	_icon.bounds = CGRectMake(0, 0, size.width, size.height);
	
	[_label sizeToFit];
	_label.center = CGPointMake(size.width*0.5, size.height+4);
	
	float scale = 60/size.width;
	_iconBackground.transform = CGAffineTransformMakeScale(scale, scale);
	_icon.transform = CGAffineTransformMakeScale(scale, scale);
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		_scale = 1;
		
		_label = [[UILabel alloc] init];
		_label.opaque = NO;
		_label.backgroundColor = nil;
		_label.textColor = [UIColor whiteColor];
		_label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
		[self addSubview:_label];
		
		UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
		_iconBackground = [[UIVisualEffectView alloc] initWithEffect:effect];
		_iconBackground.clipsToBounds = YES;
		[self addSubview:_iconBackground];
		_icon = [[UIImageView alloc] init];
		[_iconBackground addSubview:_icon];
	}
	return self;
}

@end
