//
//  DKCFullDatePickerView.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/10/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DKCFullDatePickerView.h"

@interface DKCFullDatePickerView ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timePickerHorizontalConstraint;



@end

@implementation DKCFullDatePickerView

- (id) init {
	self = [[self class] dkc_viewFromNibWithName:@"DKCFullDatePickerView" owner:nil bundle:[NSBundle mainBundle]];
	if (self){
		
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.datePicker.transform = CGAffineTransformMakeScale(0.7, 0.7);
	self.timePicker.transform = CGAffineTransformMakeScale(0.7, 0.7);
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	self.datePickerHorizontalConstraint.constant = -(self.frame.size.width * 95)/320;
	self.timePickerHorizontalConstraint.constant = -(self.frame.size.width * 60)/320;
	
}

- (void)setDate:(NSDate *)date
{
	[self.datePicker setDate:date];
	[self.timePicker setDate:date];
}

- (IBAction)datePickerValueChanged:(id)sender {
	[self updateDateFromPickers];
}

- (IBAction)timePickerValueChanged:(id)sender {
	[self updateDateFromPickers];
}

- (void)updateDateFromPickers {
	_date = [self dateByCombiningDate:self.datePicker.date time:self.timePicker.date];
	if (self.delegate) {
		[self.delegate dkcFullDatePickerValueChanged:self.date];
	}
}

- (NSDate *)dateByCombiningDate:(NSDate *)date time:(NSDate *)time {
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *dateComps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
	NSDateComponents *dateTimeComps = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:time];
	dateTimeComps.day = dateComps.day;
	dateTimeComps.month = dateComps.month;
	dateTimeComps.year = dateComps.year;
	NSDate *dateTime = [calendar dateFromComponents:dateTimeComps];
	return dateTime;
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


@end
