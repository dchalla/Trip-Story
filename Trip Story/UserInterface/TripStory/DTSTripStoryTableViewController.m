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
#import "DTSCache.h"

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
	[self trackScreenView];
}

- (void)trackScreenView
{
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	NSString *name = NSStringFromClass([self class]);
	if ([self conformsToProtocol:@protocol(DTSAnalyticsProtocol)])
	{
		name = [self dts_analyticsScreenName];
	}
	if (name.length > 0)
	{
		[tracker set:kGAIScreenName value:name];
		[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
	}
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
	
	UIImage *tripMapImage = [self tripMapScreenshot];
	
	NSArray *objectsToShare = @[screenshotImage, tripDescription, @"http://the-TripStory.com"];
	if (tripMapImage)
	{
		objectsToShare = @[screenshotImage,tripMapImage, tripDescription, @"http://the-TripStory.com"];
	}
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




- (UIImage *)tripMapScreenshot {
	NSArray *eventsWithLocation = self.trip.eventsWithLocationList;
	if (eventsWithLocation.count > 0)
	{
		MKMapRect r = MKMapRectNull;
		for (NSUInteger i=0; i < eventsWithLocation.count; ++i) {
			MKMapPoint p = MKMapPointForCoordinate(dynamic_cast_oc(eventsWithLocation[i], DTSEvent).location.mapItem.placemark.coordinate);
			r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
		}
		MKCoordinateRegion viewRegion = MKCoordinateRegionForMapRect(r);
		viewRegion.span.latitudeDelta *=3;
		
		NSString *cacheKey = [NSString stringWithFormat:@"%f:%f:%f:%f",viewRegion.center.latitude, viewRegion.center.longitude,viewRegion.span.latitudeDelta, viewRegion.span.longitudeDelta];
		UIImage *image = [[DTSCache sharedCache] cachedImageForKey:cacheKey];
		if (image != nil)
		{
			return image;
		}
		else
		{
			MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
			
			options.region = viewRegion;
			options.size = CGSizeMake(self.view.frame.size.width, 136);
			options.scale = [[UIScreen mainScreen] scale];
			
			MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
			[snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
				if (error) {
					NSLog(@"[Error] %@", error);
					return;
				}
				
				
				MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
				UIImage *compositeImage = nil;
				UIImage *image = snapshot.image;
				UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
				{
					[image drawAtPoint:CGPointMake(0.0f, 0.0f)];
					
					CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
					for (id <MKAnnotation> annotation in eventsWithLocation) {
						CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
						if (CGRectContainsPoint(rect, point)) {
							point.x = point.x + pin.centerOffset.x -
							(pin.bounds.size.width / 2.0f);
							point.y = point.y + pin.centerOffset.y -
							(pin.bounds.size.height / 2.0f);
							[pin.image drawAtPoint:point];
						}
					}
					
					compositeImage = UIGraphicsGetImageFromCurrentImageContext();
					
				}
				UIGraphicsEndImageContext();
				[[DTSCache sharedCache] cacheImage:compositeImage forKey:cacheKey];
			}];
			
		}
		
	}

	return nil;
	
}


#pragma mark - analytics

- (NSString *)dts_analyticsScreenName
{
	return @"Trip Story View";
}

@end
