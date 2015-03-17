//
//  DKCSpringboardViewController.m
//

#import "DTSSpringboardViewController.h"

#import "DTSSpringboardView.h"
#import "DTSSpringboardItemView.h"
#import "DTSSpringboardScrollView.h"
#import <libSportsData/SPPlayerStatsQuery.h>
#define CROSS_FADE_TRANSITION_MAX_SCALE 1.2f
#define CROSS_FADE_TRANSITION_MIN_SCALE 0.9f
#define CROSS_FADE_ANIMATION_DURATION 0.3f

@interface DTSSpringboardViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) SPPlayerRosterQuery *awayTeamQuery;
@property (nonatomic, strong) SPPlayerRosterQuery *homeTeamQuery;

@property (nonatomic, strong) NSArray *awayTeamPlayers;
@property (nonatomic, strong) NSArray *homeTeamPlayers;
@property (nonatomic, strong) NSArray *gamePlayers;
@property (nonatomic) BOOL didViewAppear;
@property (nonatomic, assign) BOOL presenting;

@end

@implementation DTSSpringboardViewController

#pragma mark - Privates

- (DTSSpringboardView*)customView
{
	return (DTSSpringboardView*)self.view;
}

- (DTSSpringboardScrollView*)springboard
{
	return [(DTSSpringboardView*)self.view springboard];
}

- (void)setGameDetails:(SPGameDetails *)gameDetails
{
	_gameDetails = gameDetails;
	[self startPlayerQueries];
	
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	_backgroundImage = backgroundImage;
	[self setupBackground];
}

- (void)startPlayerQueries
{
	BlockWeakSelf wSelf = self;
	self.awayTeamQuery = [SPPlayerRosterQuery queryForTeam:[SPTeam teamFromGameDetails:self.gameDetails ofSide:SPTeamSideAway] completion:^(YCSQuery *query, id data){
		BlockStrongSelf strongSelf = wSelf;
		if (strongSelf)
		{
			strongSelf.awayTeamPlayers = data;
			[strongSelf setupView];
		}
	}];
	
	self.homeTeamQuery = [SPPlayerRosterQuery queryForTeam:[SPTeam teamFromGameDetails:self.gameDetails ofSide:SPTeamSideHome] completion:^(YCSQuery *query, id data){
		BlockStrongSelf strongSelf = wSelf;
		if (strongSelf)
		{
			strongSelf.homeTeamPlayers = data;
			[strongSelf setupView];
		}
	}];
	
	[self.awayTeamQuery executeQuery];
	[self.homeTeamQuery executeQuery];
}

- (void)setupView
{
	if (self.awayTeamPlayers && self.homeTeamPlayers)
	{
		self.gamePlayers = [self.awayTeamPlayers arrayByAddingObjectsFromArray:self.homeTeamPlayers];
		self.gamePlayers = [self.gamePlayers sortedArrayUsingComparator:^NSComparisonResult(SPPlayer* p1, SPPlayer* p2){
			return [p1.firstName compare:p2.firstName];
		}];
		[(DTSSpringboardView*)self.view setupViewWithItems:self.gamePlayers];
		[self addCloseButton];
		for(DTSSpringboardItemView* item in [self springboard].itemViews)
		{
			UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DKC_iconTapped:)];
			tap.numberOfTapsRequired = 1;
			tap.delegate = self;
			[item addGestureRecognizer:tap];
		}
		
		if (self.didViewAppear)
		{
			[self doIntroAnimation];
		}
	}
}


#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if([self springboard].zoomScale < [self springboard].minimumZoomLevelToLaunchApp)
		return NO;
	return YES;
}

#pragma mark - Input

- (void)DKC_iconTapped:(UITapGestureRecognizer*)sender
{
	DTSSpringboardItemView* selectedItem = (DTSSpringboardItemView*)sender.view;
	[self.delegate itemSelected:selectedItem.player];
	int i =0;
	for(DTSSpringboardItemView* item in [self springboard].itemViews)
	{
		if (selectedItem != item)
		{
			[UIView animateWithDuration:0.2 - (rand() % [self springboard].itemViews.count)*0.005
								  delay:(rand() % [self springboard].itemViews.count)*0.005
								options:UIViewAnimationCurveEaseInOut
							 animations:^{
								 if (selectedItem.frame.origin.x < item.frame.origin.x)
								 {
									 item.frame = CGRectMake(10000, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
								 }
								 else
								 {
									 item.frame = CGRectMake(0, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
								 }
								 
							 }
							 completion:nil];
		}
		i++;
	}
	[selectedItem spui_animateSelection:@0.5 duration:0.4 completion:^{
		[self performSelector:@selector(dismissSelf) withObject:nil afterDelay:0.6];
	}];
}

- (void)dismissSelf
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController

- (id)init
{
	self = [super init];
	if (self) {
		self.transitioningDelegate = self;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self doIntroAnimation];
	self.didViewAppear = YES;
}

- (void)doIntroAnimation
{
	[[self springboard] centerOnIndex:0 zoomScale:1 animated:NO];
	[[self springboard] doIntroAnimation];
	[self springboard].alpha = 1;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.didViewAppear = NO;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view = [[DTSSpringboardView alloc] initWithFrame:self.view.frame];
	[self springboard].alpha = 0;
	[self setupBackground];
}

- (void)addCloseButton
{
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(self.view.frame.size.width - 50, 10, 40, 40);
	[closeButton setBackgroundImage:[UIImage spuiImageNamed:@"btn_close.png"] forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];
}

- (void)closeButtonTapped
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupBackground
{
	if (self.view && self.backgroundImage)
	{
		((DTSSpringboardView*)self.view).backgroundImage =self.backgroundImage;
	}
}

#pragma mark UIViewControllerAnimatedTransitioning
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	self.presenting = YES;
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.presenting = NO;
	return self;
}

#pragma mark UIViewControllerContextTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return CROSS_FADE_ANIMATION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if (self.presenting) {
		
		//View controller will be recieving events
		fromViewController.view.userInteractionEnabled = NO;
		
		[transitionContext.containerView addSubview:fromViewController.view];
		[transitionContext.containerView addSubview:toViewController.view];
		
		toViewController.view.alpha = 0.0f;
		toViewController.view.transform = CGAffineTransformMakeScale(CROSS_FADE_TRANSITION_MAX_SCALE, CROSS_FADE_TRANSITION_MAX_SCALE);
		
		[UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
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
		
		[UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
			toViewController.view.alpha = 1.0f;
			toViewController.view.transform = CGAffineTransformIdentity;
			fromViewController.view.transform = CGAffineTransformMakeScale(CROSS_FADE_TRANSITION_MAX_SCALE, CROSS_FADE_TRANSITION_MAX_SCALE);
			fromViewController.view.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:YES];
		}];
	}
}

@end
