//
//  DTSCreateEditTripView.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/26/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSCreateEditTripView.h"
#import "UIColor+Utilities.h"
#import "DTSWebViewController.h"

#ifdef DEBUG
#define EASY_TESTING 0
#else
#define EASY_TESTING 0
#endif

#define DescriptionPlaceholder @"Description"
#define PickerViewHeight 200

@interface DTSCreateEditTripView()

@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSString *tripDescription;
@property (nonatomic, strong) UIPickerView *privacyPickerView;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic) NSInteger pickerRow;

@end

@implementation DTSCreateEditTripView

- (UIPickerView *)privacyPickerView
{
	if (!_privacyPickerView)
	{
		_privacyPickerView = [[UIPickerView alloc] init];
		_privacyPickerView.delegate = self;
		_privacyPickerView.dataSource = self;
		_privacyPickerView.backgroundColor = [UIColor primaryColor];
		_privacyPickerView.alpha =0.95;
	}
	return _privacyPickerView;
}

- (void) setTrip:(DTSTrip *)trip
{
	_trip = trip;
	self.tripName = trip.tripName;
	self.tripDescription = trip.tripDescription;
	if (!trip.ACL || (trip.ACL && [trip.ACL getPublicReadAccess]))
	{
		self.pickerRow = 0;
	}
	else
	{
		self.pickerRow = 1;
	}
	[self updateUI];
}

- (void)awakeFromNib
{
	self.tripDescriptionTextView.text = DescriptionPlaceholder;
	self.tripDescriptionTextView.textColor = [UIColor lightGrayColor];
	self.tripNameTextField.text = @"";
	self.titleLabel.text = @"";
	self.tripCreateUpdateButton.enabled = NO;
	self.deleteButton.enabled = YES;
	self.pickerData = @[@"Public",@"Only You"];
	self.confirmDeleteLabel.hidden = YES;
	self.yesDeleteButton.hidden = YES;
	self.noDeleteButton.hidden = YES;
}


- (IBAction)privacyButtonTapped:(id)sender {
	[self.tripNameTextField resignFirstResponder];
	[self.tripDescriptionTextView resignFirstResponder];
	[self showPickerView];
}
- (IBAction)createUpdateButtonTapped:(id)sender {
	self.trip.tripName = self.tripName;
	self.trip.tripDescription = self.tripDescription;
	self.trip.user = [PFUser currentUser];
	if (self.pickerRow == 0)
	{
		PFACL *tripACL = [PFACL ACLWithUser:[PFUser currentUser]];
		[tripACL setPublicReadAccess:YES];
		self.trip.ACL = tripACL;
		self.trip.privacy = DTSPrivacyPublic;
	}
	else
	{
		PFACL *tripACL = [PFACL ACLWithUser:[PFUser currentUser]];
		[tripACL setPublicReadAccess:NO];
		self.trip.ACL = tripACL;
		self.trip.privacy = DTSPrivacyOnlyYou;
	}
	if (self.delegate)
	{
		[self.delegate updateCreateTripTappedForTrip:self.trip];
	}
	if (self.isCreateTripMode)
	{
		self.trip = [DTSTrip object];
		[self awakeFromNib];
		[self.tripNameTextField resignFirstResponder];
		[self.tripDescriptionTextView resignFirstResponder];
		[self hidePickerView];
		[self updateUI];
	}
	
}
- (IBAction)deleteButtonTapped:(id)sender {
	self.deleteButton.hidden = YES;
	self.confirmDeleteLabel.hidden = NO;
	self.yesDeleteButton.hidden = NO;
	self.noDeleteButton.hidden = NO;
	
}
- (IBAction)yesDeleteButtonTapped:(id)sender {
	[self.delegate deleteTripTapped:self.trip];
}
- (IBAction)noDeleteButtonTapped:(id)sender {
	self.deleteButton.hidden = NO;
	self.confirmDeleteLabel.hidden = YES;
	self.yesDeleteButton.hidden = YES;
	self.noDeleteButton.hidden = YES;
}

- (void)updateUI
{
	if (self.isCreateTripMode)
	{
		self.titleLabel.text = @"";
		self.deleteBackgroundView.hidden = YES;
		[self.tripCreateUpdateButton setTitle:@"Create" forState:UIControlStateNormal];
	}
	else
	{
		self.deleteBackgroundView.hidden = NO;
		self.titleLabel.text = @"";
		[self.tripCreateUpdateButton setTitle:@"Update" forState:UIControlStateNormal];
	}
	if ([self.tripNameTextField respondsToSelector:@selector(setAttributedPlaceholder:)])
	{
		self.tripNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Trip Name" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
		
	}
	self.tripNameTextField.delegate = self;
	self.tripNameTextField.keyboardAppearance = UIKeyboardAppearanceDark;
	[self.tripNameTextField addTarget:self
					   action:@selector(tripNameTextFieldDidChange:)
			 forControlEvents:UIControlEventEditingChanged];
	
	self.tripDescriptionTextView.delegate = self;
	if (self.trip && self.trip.tripName.length > 0)
	{
		self.tripNameTextField.text = self.trip.tripName;
	}
	else
	{
		if (EASY_TESTING)
		{
			NSArray *tripNamesList = @[@"My Awesome Trip To Hawaii",@"Spectacular Trip To India",@"Happy Trip To San Diego",@"Amazing Camping Trip",@"Tiring Hiking trip",@"My Sin City Trip",@"Chicago Trip"];
			NSArray *tripDescriptionList = @[@"My trip To Hawaii was simply awesome. The breath taking views, sound of waves, driving above the clouds, road to hana, snorkelling is just awesome.",
											 @"Trip To India was spectacular. Visiting Family, going to north india, delhi taj mahal and just being in India is just spectacular.",
											 @"Trip To San Diego is so happiness filled trip. Meeting two R's is just great.",
											 @"Amazing Camping Trip. Camping trip is just raw, out from the world disconnected and it felt great to be just doing nothing and camping.",
											 @"Tiring Hiking trip. It was so tiring, climbing mountains, walking for miles. But every part of the trip was worth it.",
											 @"Sin City Trip to vegas is unbelievable. Casino and party all the time.",@"Chicago Trip, one of the very good cities in the world, downtown is just great."];
			int randomNumber = arc4random_uniform(7);
			self.tripNameTextField.text = tripNamesList[randomNumber];
			self.tripDescriptionTextView.text = tripDescriptionList[randomNumber];
			self.tripName = self.tripNameTextField.text;
			self.tripDescription = self.tripDescriptionTextView.text;
		}
	}
	
	if (self.trip && self.trip.tripDescription.length > 0)
	{
		self.tripDescriptionTextView.text = self.trip.tripDescription;
		self.tripDescriptionTextView.textColor = [UIColor whiteColor];
	}
	[self updateCreateUpdateButtonVisibility];
	
	[self.tripPrivacyButton setTitle:self.pickerData[self.pickerRow] forState:UIControlStateNormal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self hidePickerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)tripNameTextFieldDidChange:(UITextField *)sender
{
	self.tripName = sender.text;
	[self updateCreateUpdateButtonVisibility];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:DescriptionPlaceholder])
	{
		textView.text = @"";
	}
	[self hidePickerView];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
	{
		textView.text = DescriptionPlaceholder;
	}
}

- (void)textViewDidChange:(UITextView *)textView
{
	self.tripDescription = textView.text;
	if ([self.tripDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 && ![[self.tripDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:DescriptionPlaceholder])
	{
		textView.textColor = [UIColor whiteColor];
	}
	else
	{
		textView.textColor = [UIColor lightGrayColor];
	}
	
	[self updateCreateUpdateButtonVisibility];
}

- (void)updateCreateUpdateButtonVisibility
{
	BOOL tripNameEmpty = YES;
	if ([self.tripName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
	{
		tripNameEmpty = NO;
	}
	
	BOOL tripDescriptionEmpty = YES;
	if ([self.tripDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0 && ![[self.tripDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:DescriptionPlaceholder])
	{
		tripDescriptionEmpty = NO;
	}
	
	
	if (!tripNameEmpty && !tripDescriptionEmpty)
	{
		self.tripCreateUpdateButton.enabled = YES;
		[self.tripCreateUpdateButton setTitleColor:[UIColor dtsGreenColor] forState:UIControlStateNormal];
	}
	else
	{
		self.tripCreateUpdateButton.enabled = NO;
		[self.tripCreateUpdateButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	}
}

#pragma mark -
#pragma mark Picker Data Source Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.pickerData count];
}

#pragma mark Picker Delegate Methods
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title = self.pickerData[row];
	NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
	return attString;
	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_pickerRow = row;
	[self updateUI];
}


- (void)showPickerView
{
	if (self.privacyPickerView.superview)
	{
		return;
	}
	self.privacyPickerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, PickerViewHeight);
	[self addSubview:self.privacyPickerView];
	[UIView animateWithDuration:0.2 animations:^{
		self.privacyPickerView.frame = CGRectMake(0, self.frame.size.height - PickerViewHeight, self.frame.size.width, PickerViewHeight);
	}];
	
}

- (void)hidePickerView
{
	[UIView animateWithDuration:0.2 animations:^{
		self.privacyPickerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, PickerViewHeight);
	} completion:^(BOOL finished){
		[self.privacyPickerView removeFromSuperview];
	}];
	
}
- (IBAction)termsOfServiceTapped:(id)sender {
	DTSWebViewController *webViewController = [[DTSWebViewController alloc] initWithNibName:@"DTSWebViewController" bundle:[NSBundle mainBundle]];
	webViewController.htmlFileName = @"theTripStoryTermsOfService";
	webViewController.didPresentViewController = YES;
	webViewController.title = @"theTripStory Terms Of Service";
	UINavigationController *navvc = [[UINavigationController alloc] initWithRootViewController:webViewController];
	[(UIViewController *)self.delegate presentViewController:navvc animated:YES completion:nil];
}

@end
