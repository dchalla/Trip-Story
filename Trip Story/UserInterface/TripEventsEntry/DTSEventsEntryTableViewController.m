//
//  DTSEventsEntryTableViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventsEntryTableViewController.h"
#import "UIViewController+Utilities.h"
#import "DTSEventTextEntryTableViewCell.h"
#import "DTSEventDateEntryTableViewCell.h"
#import "DTSEventPickerEntryTableViewCell.h"
#import "DTSEventLocationEntryTableViewCell.h"
#import "DTSLocationEntryViewController.h"
#import "UIView+Utilities.h"
#import "UIView+Utilities.h"

#define kDTSEventTextEntryTableViewCell @"DTSEventTextEntryTableViewCell"
#define kDTSEventDateEntryTableViewCell @"DTSEventDateEntryTableViewCell"
#define kDTSEventPickerEntryTableViewCell @"DTSEventPickerEntryTableViewCell"
#define kDTSEventLocationEntryTableViewCell @"DTSEventLocationEntryTableViewCell"
#define kFieldValue @"fieldValue"
#define kPlaceHolderValue @"placeHolderValue"
#define kIdentifier @"identifier"

#define DefaultRowHeight 50
#define ExpandedRowHeight 184

typedef enum {
	DTSEventEntryFieldTypeName  = 0,
	DTSEventEntryFieldTypeStartDate,
	DTSEventEntryFieldTypeEndDate,
	DTSEventEntryFieldTypePlace,
	DTSEventEntryFieldTypeEventType,
	DTSEventEntryFieldTypeDescription,
}DTSEventEntryFieldType;


@interface DTSEventsEntryTableViewController ()

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) DTSEvent *originalEvent;
@property (nonatomic) BOOL isValueChanged;

@end

@implementation DTSEventsEntryTableViewController

- (NSMutableArray *)tableData
{
	if (!_tableData)
	{
		_tableData = [NSMutableArray array];
	}
	return _tableData;
}

- (void)setIsValueChanged:(BOOL)isValueChanged
{
	_isValueChanged = isValueChanged;
	[self updateRightBarButton];
}

- (void)setBlurredBackgroundImage:(UIImage *)blurredBackgroundImage
{
	_blurredBackgroundImage = blurredBackgroundImage;
	[self updateBackgroundImage];
}

- (void)setEvent:(DTSEvent *)event{
	_event = event;
	self.originalEvent = [DTSEvent eventFromEvent:event];
}

- (void)updateBackgroundImage
{
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:self.blurredBackgroundImage];
	backgroundImageView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
	[self.tableView setBackgroundView:backgroundImageView];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

	if (self.isNewEvent)
	{
		self.title = @"Add Event";
	}
	else
	{
		self.title = @"Edit Event";
	}
	
	UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonTapped)];
	[self.navigationItem setRightBarButtonItem:doneBarButton];
	
	UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
	[self.navigationItem setLeftBarButtonItem:cancelBarButton];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.tableView registerClass:[DTSEventTextEntryTableViewCell class] forCellReuseIdentifier:kDTSEventTextEntryTableViewCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSEventTextEntryTableViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSEventTextEntryTableViewCell];
	
	[self.tableView registerClass:[DTSEventDateEntryTableViewCell class] forCellReuseIdentifier:kDTSEventDateEntryTableViewCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSEventDateEntryTableViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSEventDateEntryTableViewCell];
	
	[self.tableView registerClass:[DTSEventPickerEntryTableViewCell class] forCellReuseIdentifier:kDTSEventPickerEntryTableViewCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSEventPickerEntryTableViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSEventPickerEntryTableViewCell];
	
	[self.tableView registerClass:[DTSEventLocationEntryTableViewCell class] forCellReuseIdentifier:kDTSEventLocationEntryTableViewCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSEventLocationEntryTableViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSEventLocationEntryTableViewCell];
	
	[self createTableData];
	self.isValueChanged = NO;
}

- (void)createTableData
{
	NSMutableArray *tempTableData = [NSMutableArray array];
	for (int i = 0; i < 6; i++)
	{
		switch (i)
		{
			case DTSEventEntryFieldTypeName:
			{
				NSDictionary *dict = @{kIdentifier: @(i),kPlaceHolderValue:@"Event Name"};
				[tempTableData addObject:dict];
			}
				break;
			case DTSEventEntryFieldTypeDescription:
			{
				NSDictionary *dict = @{kIdentifier: @(i),kPlaceHolderValue:@"Event Description"};
				[tempTableData addObject:dict];
			}
				break;
			case DTSEventEntryFieldTypeStartDate:
			{
				NSDictionary *dict = @{kIdentifier: @(i),kPlaceHolderValue:@"Start"};
				[tempTableData addObject:dict];
			}
				break;
			case DTSEventEntryFieldTypeEndDate:
			{
				NSDictionary *dict = @{kIdentifier: @(i),kPlaceHolderValue:@"End"};
				[tempTableData addObject:dict];
			}
				break;
			case DTSEventEntryFieldTypePlace:
			{
				NSDictionary *dict = @{kIdentifier: @(i),kPlaceHolderValue:@"Place"};
				[tempTableData addObject:dict];
			}
				break;
			case DTSEventEntryFieldTypeEventType:
			{
				NSDictionary *dict = @{kIdentifier: @(i),kPlaceHolderValue:@"Event Type"};
				[tempTableData addObject:dict];
			}
				break;
				
			default:
				break;
		}
	}
	self.tableData = tempTableData;
	
}

- (void)doneButtonTapped
{
	self.event.isPlaceHolderEvent = NO;
	[self.addEventDelegate didAddEvent:self.event isNew:self.isNewEvent];
	[self.dismissDelegate dismissViewController];
}

- (void)cancelButtonTapped
{
	[self.event copyFromEvent:self.originalEvent];
	[self.dismissDelegate dismissViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateBackgroundImage];
	if (!self.isNewEvent) {
		DTSEventsEntryDeleteView *footerView = [DTSEventsEntryDeleteView dts_viewFromNibWithName:@"DTSEventsEntryDeleteView" bundle:[NSBundle mainBundle]];
		footerView.delegate = self;
		self.tableView.tableFooterView = footerView;
	}
}

- (void)eventDeleteButtonTapped {
	[self.delegate eventDeleteButtonTapped:self.event];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tableData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedIndexPath = indexPath;
	
	switch (indexPath.row)
	{
		case DTSEventEntryFieldTypeName:
		{
			
			
		}
			break;
		case DTSEventEntryFieldTypeDescription:
		{
			
		}
			break;
		case DTSEventEntryFieldTypeStartDate:
		{
			[self.view endEditing:YES];
		}
			break;
		case DTSEventEntryFieldTypeEndDate:
		{
			[self.view endEditing:YES];
		}
			break;
		case DTSEventEntryFieldTypePlace:
		{
			[self presentLocationSearchController];
		}
			break;
		case DTSEventEntryFieldTypeEventType:
		{
			[self.view endEditing:YES];
		}
			break;
			
		default:
			
			break;
	}

	
	[tableView beginUpdates];
	[tableView endUpdates];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case DTSEventEntryFieldTypeName:
		{
			return [self eventNameTableViewCellForTableView:tableView atIndexPath:indexPath];
		}
			break;
		case DTSEventEntryFieldTypeDescription:
		{
			return [self eventDescriptionTableViewCellForTableView:tableView atIndexPath:indexPath];
		}
			break;
		case DTSEventEntryFieldTypeStartDate:
		{
			return [self eventStartDateTableViewCellForTableView:tableView atIndexPath:indexPath];
		}
			break;
		case DTSEventEntryFieldTypeEndDate:
		{
			return [self eventEndDateTableViewCellForTableView:tableView atIndexPath:indexPath];
		}
			break;
		case DTSEventEntryFieldTypePlace:
		{
			return [self eventLocationTableViewCellForTableView:tableView atIndexPath:indexPath];
		}
			break;
		case DTSEventEntryFieldTypeEventType:
		{
			return [self eventTypeTableViewCellForTableView:tableView atIndexPath:indexPath];
		}
			break;
			
		default:
			return nil;
			break;
	}

}

- (UITableViewCell *)eventNameTableViewCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	DTSEventTextEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventTextEntryTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
	NSDictionary *dict = self.tableData[indexPath.row];
    cell.identifier = dict[kIdentifier];
	cell.placeHolderValue = dict[kPlaceHolderValue];
	cell.fieldValue = self.event.eventName;
	
    return cell;
}

- (UITableViewCell *)eventDescriptionTableViewCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	DTSEventTextEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventTextEntryTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
	NSDictionary *dict = self.tableData[indexPath.row];
    cell.identifier = dict[kIdentifier];
	cell.placeHolderValue = dict[kPlaceHolderValue];
	cell.fieldValue = self.event.eventDescription;
	
    return cell;
}

- (UITableViewCell *)eventStartDateTableViewCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	DTSEventDateEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventDateEntryTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
	NSDictionary *dict = self.tableData[indexPath.row];
    cell.identifier = dict[kIdentifier];
	cell.placeHolderValue = dict[kPlaceHolderValue];
	cell.dateValue = self.event.startDateTime;
	
    return cell;
}

- (UITableViewCell *)eventEndDateTableViewCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	DTSEventDateEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventDateEntryTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
	NSDictionary *dict = self.tableData[indexPath.row];
    cell.identifier = dict[kIdentifier];
	cell.placeHolderValue = dict[kPlaceHolderValue];
	cell.dateValue = self.event.endDateTime;
	
    return cell;
}

- (UITableViewCell *)eventTypeTableViewCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	DTSEventPickerEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventPickerEntryTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
	NSDictionary *dict = self.tableData[indexPath.row];
    cell.identifier = dict[kIdentifier];
	cell.placeHolderValue = dict[kPlaceHolderValue];
	cell.pickerValue = @(self.event.eventType);
	cell.pickerData = [self.event eventTypeStringsArray];
	
    return cell;
}

- (UITableViewCell *)eventLocationTableViewCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
	DTSEventLocationEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventLocationEntryTableViewCell forIndexPath:indexPath];
	NSDictionary *dict = self.tableData[indexPath.row];
    cell.identifier = dict[kIdentifier];
	cell.placeHolderValue = dict[kPlaceHolderValue];
	cell.fieldValue = self.event.location;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case DTSEventEntryFieldTypeName:
		{
			return DefaultRowHeight;
			
		}
			break;
		case DTSEventEntryFieldTypeDescription:
		{
			return DefaultRowHeight;
		}
			break;
		case DTSEventEntryFieldTypeStartDate:
		{
			if (self.selectedIndexPath.row == indexPath.row && self.selectedIndexPath.section == indexPath.section)
			{
				return ExpandedRowHeight;
			}
			else
			{
				return DefaultRowHeight;
			}
		}
			break;
		case DTSEventEntryFieldTypeEndDate:
		{
			if (self.selectedIndexPath.row == indexPath.row && self.selectedIndexPath.section == indexPath.section)
			{
				return ExpandedRowHeight;
			}
			else
			{
				return DefaultRowHeight;
			}
		}
			break;
		case DTSEventEntryFieldTypePlace:
		{
			return DefaultRowHeight;
		}
			break;
		case DTSEventEntryFieldTypeEventType:
		{
			if (self.selectedIndexPath.row == indexPath.row && self.selectedIndexPath.section == indexPath.section)
			{
				return ExpandedRowHeight;
			}
			else
			{
				return DefaultRowHeight;
			}
		}
			break;
			
		default:
			return DefaultRowHeight;
			break;
	}

}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return DefaultRowHeight;
}



#pragma mark UIViewControllerAnimatedTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	self.presenting = YES;
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.presenting = NO;
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return [self dts_transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	[self dts_animateTransition:transitionContext presenting:self.presenting];
}

#pragma mark EntryCellDelegate

- (void)placeEntryCompletedWithValue:(DTSLocation *)location
{
	self.isValueChanged = YES;
	self.event.location = location;
	[self.tableView reloadData];
}

- (void)entryCompleteForIdentifier:(id)identifier withValue:(id)value
{
	self.isValueChanged = YES;
	switch (((NSNumber *)identifier).integerValue)
	{
		case DTSEventEntryFieldTypeName:
		{
			if ([value isKindOfClass:[NSString class]])
			{
				self.event.eventName = value;
			}
			
		}
			break;
		case DTSEventEntryFieldTypeDescription:
		{
			if ([value isKindOfClass:[NSString class]])
			{
				self.event.eventDescription = value;
			}
		}
			break;
		case DTSEventEntryFieldTypeStartDate:
		{
			if ([value isKindOfClass:[NSDate class]])
			{
				self.event.startDateTime = value;
				[self.tableView reloadData];
			}
		}
			break;
		case DTSEventEntryFieldTypeEndDate:
		{
			if ([value isKindOfClass:[NSDate class]])
			{
				self.event.endDateTime = value;
				[self.tableView reloadData];
			}
		}
			break;
		case DTSEventEntryFieldTypePlace:
		{
			
		}
			break;
		case DTSEventEntryFieldTypeEventType:
		{
			if ([value isKindOfClass:[NSNumber class]])
			{
				self.event.eventType = (DTSEventType)((NSNumber *)value).integerValue;
				[self.tableView reloadData];
			}
		}
			break;
			
		default:
			
			break;
	}
}

- (void)didSelectCellForIdentifier:(id)identifier
{
	NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:((NSNumber *)identifier).integerValue inSection:0];
	[self tableView:self.tableView didSelectRowAtIndexPath:tempIndexPath];
}


- (void)presentLocationSearchController
{
	DTSLocationEntryViewController *locationSearchVC = [[DTSLocationEntryViewController alloc] initWithNibName:@"DTSLocationEntryViewController" bundle:[NSBundle mainBundle]];
	locationSearchVC.dismissDelegate = self;
	locationSearchVC.blurredBackgroundImage = [self.view dts_darkBlurredSnapshotImage];
	locationSearchVC.entryDelegate = self;
	locationSearchVC.trip = self.trip;
	[self presentViewController:locationSearchVC animated:YES completion:^{}];
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)updateRightBarButton
{
	if (self.isValueChanged || (self.isNewEvent))
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}


@end
