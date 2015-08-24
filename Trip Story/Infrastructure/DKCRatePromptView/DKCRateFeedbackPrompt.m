//
//  DKCRatePromptView.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/8/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DKCRateFeedbackPrompt.h"
#import <StoreKit/StoreKit.h>

typedef enum {
	DKCRatePromptViewButtonTappedTypePositive = 1,
	DKCRatePromptViewButtonTappedTypeNegative,
}DKCRatePromptViewButtonTappedType;

#define D_DAY 86400

#define kDKCRatePromptViewNoThanks @"kDKCRatePromptViewNoThanks"
#define kDKCRatePromptViewRateApp @"kDKCRatePromptViewRateApp"
#define kDKCRatePromptViewNotNow @"kDKCRatePromptViewNotNow"
#define kDKCRatePromptViewDontLikeFeedback @"kDKCRatePromptViewDontLikeFeedback"
#define kDKCRatePromptViewDontLikeNotNow @"kDKCRatePromptViewDontLikeNotNow"
#define kDKCRatePromptViewTrackedVersion @"kDKCRatePromptViewTrackedVersion"
#define kDKCRatePromptViewDateLastTracked @"kDKCRatePromptViewDateLastTracked"
#define kDKCRatePromptViewNumberOfTimesOpenedSinceLastTracked @"kDKCRatePromptViewNumberOfTimesOpenedSinceLastTracked"

#define kDKCRatePromptViewSettingNumberOfDaysBeforePrompting @"kDKCRatePromptViewSettingNumberOfDaysBeforePrompting"
#define kDKCRatePromptViewSettingNumberOfTimesBeforePrompting @"kDKCRatePromptViewSettingNumberOfTimesBeforePrompting"
#define kDKCRatePromptViewSettingNumberOfSecondsBeforeDisappearing @"kDKCRatePromptViewSettingNumberOfSecondsBeforeDisappearing"

#define kDKCRatePromptViewSettingAppId @"kDKCRatePromptViewSettingAppId"

NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";

static DKCRateFeedbackPrompt *promptView;

@interface DKCRateFeedbackPrompt() <SKStoreProductViewControllerDelegate>

@property (nonatomic) DKCRatePromptViewButtonTappedType buttonTappedType;
@property (nonatomic, readonly) NSString *appId;
@property (nonatomic, weak) id<DKCRateFeedbackPromptProtocol> delegate;
@property (nonatomic) BOOL showFeedbackPrompt;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;

@end

@implementation DKCRateFeedbackPrompt

+ (void)load
{
	[[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:kDKCRatePromptViewSettingNumberOfDaysBeforePrompting];
	[[NSUserDefaults standardUserDefaults] setObject:@(5) forKey:kDKCRatePromptViewSettingNumberOfTimesBeforePrompting];
	[[NSUserDefaults standardUserDefaults] setObject:@(100) forKey:kDKCRatePromptViewSettingNumberOfSecondsBeforeDisappearing];
	
#ifdef DEBUG
//testing
	//[[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kDKCRatePromptViewSettingNumberOfTimesBeforePrompting];
#endif
	
	NSDate *dateLastTracked = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewDateLastTracked];
	if (!dateLastTracked) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kDKCRatePromptViewDateLastTracked];
	}
	
	NSNumber *numberOfTimesOpenedSinceLastTracked = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewNumberOfTimesOpenedSinceLastTracked];
	if (!numberOfTimesOpenedSinceLastTracked) {
		numberOfTimesOpenedSinceLastTracked = @(-1);
	}
	numberOfTimesOpenedSinceLastTracked = @(numberOfTimesOpenedSinceLastTracked.integerValue+1);
	[[NSUserDefaults standardUserDefaults] setObject:numberOfTimesOpenedSinceLastTracked forKey:kDKCRatePromptViewNumberOfTimesOpenedSinceLastTracked];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setNumberOfSecondsBeforeDisappearing:(NSInteger)numberOfSeconds {
	[[NSUserDefaults standardUserDefaults] setObject:@(numberOfSeconds) forKey:kDKCRatePromptViewSettingNumberOfSecondsBeforeDisappearing];
}

+ (void) setDaysUntilPrompt:(NSInteger)days {
	[[NSUserDefaults standardUserDefaults] setObject:@(days) forKey:kDKCRatePromptViewSettingNumberOfDaysBeforePrompting];
}

+ (void) setUsesUntilPrompt:(NSInteger)uses {
	[[NSUserDefaults standardUserDefaults] setObject:@(uses) forKey:kDKCRatePromptViewSettingNumberOfTimesBeforePrompting];
}

+ (void)showPromptWithAppId:(NSString *)appId showFeedbackPrompt:(BOOL)showFeedbackPrompt delegate:(id<DKCRateFeedbackPromptProtocol>)delegate {
	[[NSUserDefaults standardUserDefaults] setObject:appId forKey:kDKCRatePromptViewSettingAppId];
	if ([self shouldShowPrompt]) {
		UIViewController *rootVC = [self getRootViewController];
		if (rootVC.view && !promptView) {
			promptView = [DKCRateFeedbackPrompt dkc_viewFromNibWithName:@"DKCRateFeedbackPrompt" owner:nil bundle:[NSBundle mainBundle]];
			promptView.delegate = delegate;
			promptView.showFeedbackPrompt = showFeedbackPrompt;
			promptView.center = CGPointMake(rootVC.view.frame.size.width/2,124);
			promptView.userInteractionEnabled = YES;
			promptView.alpha = 0;
			[rootVC.view addSubview:promptView];
			[rootVC.view bringSubviewToFront:promptView];
			
			if (delegate && [delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didShow)]) {
				[delegate dkcRateFeedbackPrompt_didShow];
			}
			
			[UIView animateWithDuration:0.2 animations:^{
				promptView.alpha = 1;
				} completion:^(BOOL finished) {
					NSNumber *numberOfSeconds = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewSettingNumberOfSecondsBeforeDisappearing];
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(numberOfSeconds.integerValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[UIView animateWithDuration:0.2
										 animations:^{
											 promptView.alpha = 0;
										 } completion:^(BOOL finished) {
											 [promptView removeFromSuperview];
											 promptView = nil;
										 }];
					});
				}];
		}
	}
}

#pragma  mark - private methods

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.layer.cornerRadius = 4.0;
}

- (NSString *)appId
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewSettingAppId];
}

- (IBAction)positiveButtonTapped:(id)sender {
	[promptView removeFromSuperview];
	self.buttonTappedType = DKCRatePromptViewButtonTappedTypePositive;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapPositiveReview)]) {
		[self.delegate dkcRateFeedbackPrompt_didTapPositiveReview];
	}
	
	[[[UIAlertView alloc] initWithTitle:@"Great to hear!"
													message:@"Would you like to show your love in the App Store?"
												   delegate:self
										  cancelButtonTitle:@"No thanks"
										  otherButtonTitles:@"Rate app",@"Not now",
						  
	  nil] show];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didShowAppStoreReviewPrompt)]) {
		[self.delegate dkcRateFeedbackPrompt_didShowAppStoreReviewPrompt];
	}
	
}

- (IBAction)negativeButtonTapped:(id)sender {
	[promptView removeFromSuperview];
	self.buttonTappedType = DKCRatePromptViewButtonTappedTypeNegative;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapNegativeReview)]) {
		[self.delegate dkcRateFeedbackPrompt_didTapNegativeReview];
	}
	
	if (self.showFeedbackPrompt)
	{
		[[[UIAlertView alloc] initWithTitle:@"We're sorry to hear that."
									message:@"Would you like to provide feedback?"
								   delegate:self
						  cancelButtonTitle:@"Not now"
						  otherButtonTitles:@"Feedback", nil] show];
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didShowFeedbackPrompt)]) {
			[self.delegate dkcRateFeedbackPrompt_didShowFeedbackPrompt];
		}
	}
	else
	{
		[self updateUserDefaultsAfterPrompt];
	}
	
}


#pragma mark - alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (self.buttonTappedType == DKCRatePromptViewButtonTappedTypePositive) {
		switch (buttonIndex) {
			case 0:  // No thanks
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDKCRatePromptViewNoThanks];
				promptView = nil;
			
				if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapAppStoreReviewNoThanks)]) {
					[self.delegate dkcRateFeedbackPrompt_didTapAppStoreReviewNoThanks];
				}
				break;
			case 1:  // rate app
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDKCRatePromptViewRateApp];
				[self rateApp];
				if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapAppStoreReviewRateApp)]) {
					[self.delegate dkcRateFeedbackPrompt_didTapAppStoreReviewRateApp];
				}
				break;
			case 2:  // not now
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDKCRatePromptViewNotNow];
				promptView = nil;
				if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapAppStoreReviewNotNow)]) {
					[self.delegate dkcRateFeedbackPrompt_didTapAppStoreReviewNotNow];
				}
				break;
			default:
				promptView = nil;
				break;
		}
	}
	else {
		switch (buttonIndex) {
			case 1: //feedback
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDKCRatePromptViewDontLikeFeedback];
				promptView = nil;
				if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapFeedbackPromptFeedback)]) {
					[self.delegate dkcRateFeedbackPrompt_didTapFeedbackPromptFeedback];
				}
				break;
			case 0:
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDKCRatePromptViewDontLikeNotNow];
				promptView = nil;
				if (self.delegate && [self.delegate respondsToSelector:@selector(dkcRateFeedbackPrompt_didTapFeedbackPromptNotNow)]) {
					[self.delegate dkcRateFeedbackPrompt_didTapFeedbackPromptNotNow];
				}
				break;
			default:
				promptView = nil;
				break;
		}
	}
	[self updateUserDefaultsAfterPrompt];
	
}

- (void)updateUserDefaultsAfterPrompt {
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	[[NSUserDefaults standardUserDefaults] setObject:version forKey:kDKCRatePromptViewTrackedVersion];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kDKCRatePromptViewDateLastTracked];
	[[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kDKCRatePromptViewNumberOfTimesOpenedSinceLastTracked];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)rateApp {
	if (self.appId.length == 0) {
		NSLog(@"DKCRatePromptView Not set");
		return;
	}
	//Use the in-app StoreKit view if available (iOS 6) and imported. This works in the simulator. storekit doesnt allow review anymore so do no use it
	if (0) {//NSStringFromClass([SKStoreProductViewController class]) != nil) {
		
		
		dispatch_async(dispatch_get_main_queue(), ^{
			SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
			NSNumber *appId = [NSNumber numberWithInteger:self.appId.integerValue];
			[storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:nil];
			storeViewController.delegate = self;
			UIViewController *rootController = [[self class] getRootViewController];
			[rootController presentViewController:storeViewController animated:YES completion:nil];
		});
		
		
		//Use the standard openUrl method if StoreKit is unavailable.
	} else {
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
		NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", self.appId]];
		
		// iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
			reviewURL = [templateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", self.appId]];
		}
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
#endif
		
	}
	promptView = nil;
}

#pragma mark - helper methods

+ (id)getRootViewController {
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	if (window.windowLevel != UIWindowLevelNormal) {
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for(window in windows) {
			if (window.windowLevel == UIWindowLevelNormal) {
				break;
			}
		}
	}
	
	for (UIView *subView in [window subviews])
	{
		UIResponder *responder = [subView nextResponder];
		if([responder isKindOfClass:[UIViewController class]]) {
			return [self topMostViewController: (UIViewController *) responder];
		}
	}
	
	return nil;
}

+ (UIViewController *) topMostViewController: (UIViewController *) controller {
	BOOL isPresenting = NO;
	do {
		// this path is called only on iOS 6+, so -presentedViewController is fine here.
		UIViewController *presented = [controller presentedViewController];
		isPresenting = presented != nil;
		if(presented != nil) {
			controller = presented;
		}
		
	} while (isPresenting);
	UINavigationController *navController = dynamic_cast_oc(controller, UINavigationController);
	if (navController) {
		controller = [navController topViewController];
	}
	return controller;
}

+ (BOOL)shouldShowPrompt
{
	NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	NSString *trackedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewTrackedVersion];
	if (trackedVersion.length == 0) {
		trackedVersion = @"0";
	}
	
	if ([trackedVersion isEqualToString:currentVersion]) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:kDKCRatePromptViewRateApp] || [[NSUserDefaults standardUserDefaults] boolForKey:kDKCRatePromptViewNoThanks]) {
			return NO;
		}
		else if ([[NSUserDefaults standardUserDefaults] boolForKey:kDKCRatePromptViewNotNow]) {
			if ([self isNumberOfDaysBeforePromptingComplete] || [self isNumberOfTimesBeforePromptingComplete]) {
				return YES;
			}
		}
	}
	else {
		if ([self isNumberOfDaysBeforePromptingComplete] || [self isNumberOfTimesBeforePromptingComplete]) {
			return YES;
		}
	}
	return NO;
}

+ (BOOL)isNumberOfDaysBeforePromptingComplete {
	NSNumber *numberOfDaysBeforePrompting = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewSettingNumberOfDaysBeforePrompting];
	NSDate *dateLastTracked = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewDateLastTracked];
	
	NSInteger numberOfDaysSinceLastTracked = [self numberOfDaysBetweenBeforeDate:dateLastTracked futureDate:[NSDate date]];
	
	if (numberOfDaysSinceLastTracked >= numberOfDaysBeforePrompting.integerValue) {
		return YES;
	}
	return NO;
}

+ (BOOL)isNumberOfTimesBeforePromptingComplete
{
	NSNumber *numberOfTimesBeforePrompting = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewSettingNumberOfTimesBeforePrompting];
	NSNumber *numberOfTimesOpenedSinceLastTracked = [[NSUserDefaults standardUserDefaults] objectForKey:kDKCRatePromptViewNumberOfTimesOpenedSinceLastTracked];
	if (numberOfTimesOpenedSinceLastTracked.integerValue >= numberOfTimesBeforePrompting.integerValue) {
		return YES;
	}
	return NO;
}


+ (NSInteger) numberOfDaysBetweenBeforeDate:(NSDate *)beforeDate futureDate:(NSDate *)futureDate
{
	NSTimeInterval ti = [futureDate timeIntervalSinceDate:beforeDate];
	return (NSInteger) (ti / D_DAY);
}

+ (id)dkc_viewFromNibWithName:(NSString*)nibName owner:(id)owner bundle:(NSBundle*)inBundle
{
	UINib* nib = [UINib nibWithNibName:nibName bundle:inBundle];
	
	return [self dkc_viewFromNib:nib owner:owner];
}

+ (id)dkc_viewFromNib:(UINib*)nib owner:(id)owner
{
	id view = nil;
	if(nib)
	{
		NSArray* loadedObjects = [nib instantiateWithOwner:owner options:nil];
		if(loadedObjects && loadedObjects.count > 0)
		view = [loadedObjects objectAtIndex:0];
		
		NSAssert(view, @"View could not be loaded from nib");
	}
	
	return view;
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
	if (viewController){
		UIViewController *rootController = [[self class] getRootViewController];
		[rootController dismissViewControllerAnimated:YES completion:nil];
	}
}





@end
