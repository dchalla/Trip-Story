//
//  DKCViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/2/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripDetailsViewController.h"
#import "DTSTripStoryTableViewController.h"
#import "DTSEvent.h"
#import "DTSLocation.h"
#import "NSDate+Utilities.h"

@interface DTSTripDetailsViewController ()

@property (nonatomic, strong) DTSTripStoryTableViewController *tripStoryVC;
@property (nonatomic, strong) NSMutableArray *eventsList;

@end

@implementation DTSTripDetailsViewController

- (DTSTripStoryTableViewController *)tripStoryVC
{
	if (!_tripStoryVC)
	{
		_tripStoryVC = [[DTSTripStoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	return _tripStoryVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
	self.view.backgroundColor = [UIColor colorWithRed:15/255.0 green:17/255.0 blue:22/255.0 alpha:1];
	[self.view addSubview:self.tripStoryVC.view];
	[self addChildViewController:self.tripStoryVC];
	[self createDummyEventsList];//for testing
	self.tripStoryVC.eventsList = self.eventsList;
	self.tripStoryVC.view.frame = self.view.frame;
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	self.title = @"My Trip";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.tripStoryVC.view.frame = self.view.frame;
}


- (void)createDummyEventsList
{
	self.eventsList = [NSMutableArray array];
	int j = DTSEventTypeActivity;
	for (int i=0; i <= 10; i++)
	{
		DTSEvent *event = [[DTSEvent alloc] init];
		event.eventName = [NSString stringWithFormat:@"%@%d",@"Dummy Event",i];
		event.eventDescription = @"Fun time, go Kayaking";
		event.eventID = [NSString stringWithFormat:@"%@%d",@"Dummy Event",i];
		if (i%2 == 0)
		{
			event.eventType = j++;
		}
		else
		{
			event.eventType = DTSEventTypeTravelCar;
		}
		
		event.startDateTime = [[NSDate date] dateByAddingHours:i*4];
		event.endDateTime = [event.startDateTime dateByAddingHours:[ self getRandomNumberBetween:1 maxNumber:10]];
		[self.eventsList addObject:event];
	}
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

@end
