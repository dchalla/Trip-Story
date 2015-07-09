//
//  DKCRatePromptView.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/8/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKCRateFeedbackPromptProtocol <NSObject>

@optional
- (void)dkcRateFeedbackPrompt_didShow;
- (void)dkcRateFeedbackPrompt_didTapPositiveReview;
- (void)dkcRateFeedbackPrompt_didTapNegativeReview;
- (void)dkcRateFeedbackPrompt_didShowAppStoreReviewPrompt;
- (void)dkcRateFeedbackPrompt_didTapAppStoreReviewNotNow;
- (void)dkcRateFeedbackPrompt_didTapAppStoreReviewNoThanks;
- (void)dkcRateFeedbackPrompt_didTapAppStoreReviewRateApp;
- (void)dkcRateFeedbackPrompt_didShowFeedbackPrompt;
- (void)dkcRateFeedbackPrompt_didTapFeedbackPromptNotNow;
- (void)dkcRateFeedbackPrompt_didTapFeedbackPromptFeedback;

@end

@interface DKCRateFeedbackPrompt : UIView<UIAlertViewDelegate>

+ (void)showPromptWithAppId:(NSString *)appId showFeedbackPrompt:(BOOL)showFeedbackPrompt delegate:(id<DKCRateFeedbackPromptProtocol>)delegate;

+ (void) setNumberOfSecondsBeforeDisappearing:(NSInteger)numberOfSeconds;
+ (void) setDaysUntilPrompt:(NSInteger)days;
+ (void) setUsesUntilPrompt:(NSInteger)uses;

@end
