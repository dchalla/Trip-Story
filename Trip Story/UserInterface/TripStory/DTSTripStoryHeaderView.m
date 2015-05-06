//
//  DTSTripStoryHeaderView.m
//  Trip Story
//
//  Created by Dinesh Challa on 9/1/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripStoryHeaderView.h"
#import "MagicPieLayer.h"

#define PieLayerHeight 150
#define	PierLayerWidth PieLayerHeight

@interface DTSTripStoryHeaderView()

@property (nonatomic, strong) PieLayer *pieLayer;

@end

@implementation DTSTripStoryHeaderView

- (void)setTrip:(DTSTrip *)trip
{
	_trip = trip;
	[self updateView];
}

- (void)setViewAppeared:(BOOL)viewAppeared
{
	_viewAppeared = viewAppeared;
#ifdef DEBUG
	[self performSelector:@selector(updateView) withObject:nil afterDelay:0.2];
#else
	[self updateView];
#endif
}

- (void)updateView
{
	if (self.viewAppeared && self.trip)
	{
		[self updateLabels];
		[self updatePieView];
	}
	
}

- (void)updateLabels
{
	self.tripTitle.text = self.trip.tripName.length?self.trip.tripName:@"My Trip";
	self.tripDurationLabel.text = [self.trip tripDurationString];
	self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.trip.tripDescription];
}

- (void)updatePieView
{
	if (self.pieLayer)
	{
		NSArray *eventsDuration = [self.trip eventsDurationArray];
		int i = 0;
		for (NSNumber *duration in eventsDuration)
		{
			PieElement* pieElem = self.pieLayer.values[i];
			if (pieElem.val != duration.floatValue)
			{
				[PieElement animateChanges:^{
					pieElem.val = duration.floatValue;
				}];

			}
			i++;
		}

	}
	else
	{
		self.pieLayer = [[PieLayer alloc] initWithMaxRadius:70 minRadius:50];
		self.pieLayer.frame = CGRectMake((self.pieView.frame.size.width - PierLayerWidth)/2, (self.pieView.frame.size.height - PieLayerHeight)/2, PierLayerWidth, PieLayerHeight);
		[self.pieView.layer addSublayer:self.pieLayer];
		
		NSArray *eventsDuration = [self.trip eventsDurationArray];
		NSMutableArray *pieElementsArray = [NSMutableArray array];
		int i = 0;
		for (NSNumber *duration in eventsDuration)
		{
			UIColor *eventTypeColor = [DTSEvent topColorForEventType:i];
			UIColor *eventTypeBottomColor = [DTSEvent bottomColorForEventType:i];
			PieElement *element = [PieElement pieElementWithValue:duration.floatValue color:eventTypeColor bottomColor:eventTypeBottomColor];
			[pieElementsArray addObject:element];
			i++;
		}
		
		[self.pieLayer addValues:pieElementsArray animated:YES];
	}
	
}

- (IBAction)editButtonTapped:(id)sender {
	if (self.delegate)
	{
		[self.delegate tripStoryHeaderViewEditButtonTapped];
	}
}

@end
