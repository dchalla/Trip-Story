//
//  DTSTripStoryTableViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/2/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripStoryTableViewController.h"
#import "DTSEvent.h"
#import "DTSLocation.h"
#import "DTSTripStoryEventActivityCell.h"
#import "DTSTripStoryEventGeneralCell.h"

#define kDTSTripStoryEventActivityCell @"DTSTripStoryEventActivityCell"
#define kDTSTripStoryEventGeneralCell @"DTSTripStoryEventGeneralCell"

@interface DTSTripStoryTableViewController ()

@end

@implementation DTSTripStoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerClass:[DTSTripStoryEventActivityCell class] forCellReuseIdentifier:kDTSTripStoryEventActivityCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSTripStoryEventActivityCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSTripStoryEventActivityCell];
	
	[self.tableView registerClass:[DTSTripStoryEventGeneralCell class] forCellReuseIdentifier:kDTSTripStoryEventGeneralCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSTripStoryEventGeneralCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSTripStoryEventGeneralCell];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTSEvent *event = self.eventsList[indexPath.row];
	if (event.eventKind == DTSEventKindActivity)
	{
		DTSTripStoryEventActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSTripStoryEventActivityCell forIndexPath:indexPath];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		// Configure the cell...
		[cell updateWithEvent:event];
		return cell;
	}
	else
	{
		DTSTripStoryEventGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSTripStoryEventGeneralCell forIndexPath:indexPath];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		// Configure the cell...
		[cell updateWithEvent:event];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTSEvent *event = self.eventsList[indexPath.row];
	return event.tripStoryCellHeight;
}

@end
