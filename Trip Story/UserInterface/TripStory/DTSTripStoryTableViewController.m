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
#import "DTSEventsEntryTableViewController.h"
#import "UIView+Utilities.h"
#import "DTSTableViewCellParallaxProtocol.h"

#define kDTSTripStoryEventActivityCell @"DTSTripStoryEventActivityCell"
#define kDTSTripStoryEventGeneralCell @"DTSTripStoryEventGeneralCell"

@interface DTSTripStoryTableViewController ()

@property (nonatomic) BOOL isInEditMode;

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

- (void)refreshView
{
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.isInEditMode = YES;
    self.view.backgroundColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerClass:[DTSTripStoryEventActivityCell class] forCellReuseIdentifier:kDTSTripStoryEventActivityCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSTripStoryEventActivityCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSTripStoryEventActivityCell];
	
	[self.tableView registerClass:[DTSTripStoryEventGeneralCell class] forCellReuseIdentifier:kDTSTripStoryEventGeneralCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSTripStoryEventGeneralCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSTripStoryEventGeneralCell];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self scrollViewDidScroll:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.trip.eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTSEvent *event = self.trip.eventsList[indexPath.row];
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
	DTSEvent *event = self.trip.eventsList[indexPath.row];
	return event.tripStoryCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.isInEditMode)
	{
		[self.containerDelegate showEditEventEntryAtIndex:indexPath.row];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
	
    for (UITableViewCell *cell in visibleCells) {
		if ([cell conformsToProtocol:@protocol(DTSTableViewCellParallaxProtocol)])
		{
			[cell performSelector:@selector(didScrollOnTableView:) withObject:self.tableView];
		}
    }
}

@end
