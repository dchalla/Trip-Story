//
//  DTSCreateEditTripView.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/26/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"

@protocol DTSCreateEditTripViewProtocol <NSObject>

- (void)updateCreateTripTappedForTrip:(DTSTrip *)trip;
- (void)dismissCreateTripView;

@end

@interface DTSCreateEditTripView : UIView<UITextFieldDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tripNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *tripDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *tripPrivacyButton;
@property (weak, nonatomic) IBOutlet UIButton *tripCreateUpdateButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic) BOOL isCreateTripMode;
@property (nonatomic, strong) DTSTrip *trip;

@property (nonatomic, weak) id<DTSCreateEditTripViewProtocol> delegate;

- (void)updateUI;

@end
