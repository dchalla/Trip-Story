//
//  DTSViewControllerView.m
//

#import "DTSSpringboardView.h"

#import "DTSSpringboardItemView.h"
#import "DTSSpringboardScrollView.h"

#import "DTSSpringboardItemModel.h"

@interface DTSSpringboardView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation DTSSpringboardView


#pragma mark - UIView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
		[self addSubview:self.backgroundImageView];
	}
	return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	_backgroundImage = backgroundImage;
	self.backgroundImageView.image = backgroundImage;
}

- (void)setupViewWithItems:(NSArray *)items
{
	self.items = items;
	CGRect fullFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	UIViewAutoresizing mask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.backgroundColor = [UIColor clearColor];
	_springboard = [[DTSSpringboardScrollView alloc] initWithFrame:fullFrame];
	_springboard.autoresizingMask = mask;
	
	NSMutableArray* itemViews = [NSMutableArray array];
	
	// build out item set
	for(DTSSpringboardItemModel* item in self.items)
	{
		DTSSpringboardItemView* itemView = [[DTSSpringboardItemView alloc] init];
		itemView.modelData = item;
		[itemViews addObject:itemView];
	}
	_springboard.itemViews = itemViews;
	
	[self addSubview:_springboard];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if(self.window != nil)
	{
		CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
		statusFrame = [self.window convertRect:statusFrame toView:self];
		
		UIEdgeInsets insets = _springboard.contentInset;
		insets.top = statusFrame.size.height;
		_springboard.contentInset = insets;
	}
	
	
	
}

@end
