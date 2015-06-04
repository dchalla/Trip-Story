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

#define extraPaddingBottom 20

@interface DTSTripStoryTableViewController ()

@property (nonatomic) BOOL isInEditMode;
@property (nonatomic, strong) DTSTripStoryHeaderView *headerView;
@property (nonatomic, strong) DTSTripStoryFooterView *footerView;

@end

@implementation DTSTripStoryTableViewController

@synthesize topLayoutGuideLength = _topLayoutGuideLength;
@synthesize bottomLayoutGuideLength = _bottomLayoutGuideLength;
@synthesize trip = _trip;


- (BOOL)isInEditMode
{
	if ([self.trip.user.username isEqualToString:[PFUser currentUser].username])
	{
		return YES;
	}
	return NO;
}

- (void)setTopLayoutGuideLength:(CGFloat)topLayoutGuideLength
{
	_topLayoutGuideLength = topLayoutGuideLength;
	[self setupTableViewInsets];
}

- (void)setBottomLayoutGuideLength:(CGFloat)bottomLayoutGuideLength
{
	_bottomLayoutGuideLength = bottomLayoutGuideLength;
	[self setupTableViewInsets];
}

- (void)setupTableViewInsets
{
	self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength+extraPaddingBottom, 0);
}

- (void)setTrip:(DTSTrip *)trip
{
	_trip = trip;
	[self refreshView];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (DTSTripStoryHeaderView *)headerView
{
	if (!_headerView)
	{
		_headerView = [[[NSBundle mainBundle] loadNibNamed:@"DTSTripStoryHeaderView" owner:self options:nil] objectAtIndex:0];
		_headerView.delegate = self;
	}
	return _headerView;
}

- (DTSTripStoryFooterView *)footerView
{
	if (!_footerView) {
		_footerView = [DTSTripStoryFooterView dts_viewFromNibWithName:@"DTSTripStoryFooterView" bundle:[NSBundle mainBundle]];
		_footerView.delegate = self;
	}
	return _footerView;
}

- (void)refreshView
{
	[self.tableView reloadData];
	[self updateHeaderView];
	[self updateFooterView];
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
	[self updateHeaderView];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self scrollViewDidScroll:self.tableView];
	[self setupTableViewInsets];
	[self refreshView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.headerView.viewAppeared = YES;
}

- (void)updateHeaderView
{
	if (self.tableView)
	{
		self.headerView.trip = self.trip;
		self.tableView.tableHeaderView = self.headerView;
		
	}
}

- (void)updateFooterView
{
	if (self.tableView)
	{
		self.footerView.trip = self.trip;
		self.tableView.tableFooterView = self.footerView;
		[self.footerView updateView];
	}
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
		[cell updateWithEvent:event isFirstCell:indexPath.row == 0?YES:NO];
		return cell;
	}
	else
	{
		DTSTripStoryEventGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSTripStoryEventGeneralCell forIndexPath:indexPath];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		// Configure the cell...
		[cell updateWithEvent:event isFirstCell:indexPath.row == 0?YES:NO];
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
	DTSEvent *event = self.trip.eventsList[indexPath.row];
	if (event.isPlaceHolderEvent)
	{
		if (self.isInEditMode)
		{
			[self.containerDelegate showEditEventEntry:event];
		}
	}
	else
	{
		[self.containerDelegate openEventDetails:event];
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

#pragma mark - Header/Footer View delegate
- (void)tripStoryHeaderViewEditButtonTapped
{
	if (self.containerDelegate)
	{
		[self.containerDelegate showEditTripView];
	}
}

- (void)tripStoryFooterViewAddEventTapped
{
	if (self.containerDelegate)
	{
		[self.containerDelegate showNewEventEntry];
	}
}

#pragma mark - sharing
- (void)shareButtonTapped
{
	UIImage *screenshotImage = [self screenshotImageForSharing];
	NSString *tripDescription = self.trip.tripDescription;
	if (tripDescription.length == 0) {
		tripDescription = @"";
	}
	NSArray *objectsToShare = @[screenshotImage, tripDescription, @"http://www.facebook.com/TripStory"];
	UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
	[controller setValue:self.trip.tripName forKey:@"subject"];
	[self presentViewController:controller animated:YES completion:nil];
}

-(UIImage *)screenshotImageForSharing
{
	
	int height = self.tableView.contentSize.height + 100;
	CGRect headerViewFrame = self.headerView.frame;
	CGRect tableViewFrame = self.tableView.frame;
	CGRect newTableViewFrame = tableViewFrame;
	newTableViewFrame.size.height = height;
	self.tableView.frame = newTableViewFrame;
	[self.tableView reloadData];
	self.headerView.frame = headerViewFrame;
	self.footerView.isSharing = YES;
	[self.footerView updateView];
	
	UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, YES, 3);
	[self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.tableView.frame = tableViewFrame;
	self.headerView.frame = headerViewFrame;
	self.footerView.isSharing = NO;
	[self.footerView updateView];
	
	return img;
}

@end
