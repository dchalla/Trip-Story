//
//  DTSTripEventDetailsViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 11/19/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripEventDetailsViewController.h"
#import "DTSEventDetailsInfoTableViewCell.h"

#define NumberOfTableViewRows 1
#define NumberOfTableViewSections 1
#define InfoCellRowNumber 0
#define InfoCellSectionNumber 0

#define kDTSEventDetailsInfoTableViewCellReuseIdentifier @"DTSEventDetailsInfoTableViewCell"

@interface DTSTripEventDetailsViewController ()
@property (nonatomic,strong) DTSEvent *event;
@property (nonatomic, strong) DTSEventDetailsInfoTableViewCell *prototypeInfoCell;
@end

@implementation DTSTripEventDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.clipsToBounds = YES;
	[self.tableView registerClass:[DTSEventDetailsInfoTableViewCell class] forCellReuseIdentifier:kDTSEventDetailsInfoTableViewCellReuseIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:@"DTSEventDetailsInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSEventDetailsInfoTableViewCellReuseIdentifier];
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)updateViewWithEvent:(DTSEvent *)event
{
	self.event = event;
	self.view.backgroundColor = [event eventTopColor];
	self.eventTitleLabel.text = self.event.eventName;
	self.eventTypeLabel.text =  [self.event eventTypeStringForEventType:self.event.eventType];
	[self.tableView reloadData];
}

#pragma mark - table view delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return NumberOfTableViewRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return NumberOfTableViewSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == InfoCellRowNumber && indexPath.section == InfoCellSectionNumber)
	{
		if (!self.prototypeInfoCell)
		{
			self.prototypeInfoCell = [tableView dequeueReusableCellWithIdentifier:kDTSEventDetailsInfoTableViewCellReuseIdentifier];
		}
		[self.prototypeInfoCell updateViewWithEvent:self.event];
		[self.prototypeInfoCell layoutIfNeeded];
		CGSize size = [self.prototypeInfoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
		return MAX(size.height, self.tableView.frame.size.height-30);
	}
	return 44;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == InfoCellRowNumber && indexPath.section == InfoCellSectionNumber)
	{
		DTSEventDetailsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventDetailsInfoTableViewCellReuseIdentifier];
		[cell updateViewWithEvent:self.event];
		return cell;
	}
	return nil;
}

- (IBAction)editButtonTapped:(id)sender {
	[self.delegate editButtonTapped:self.event];
}


@end
