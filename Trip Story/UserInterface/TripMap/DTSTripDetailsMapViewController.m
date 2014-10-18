//
//  DTSTripDetailsMapViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 10/16/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripDetailsMapViewController.h"

#define METERS_PER_MILE 1609.344
@interface DTSTripDetailsMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DTSTripDetailsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	NSArray *eventsWithLocation = self.trip.eventsWithLocationList;
	if (eventsWithLocation.count > 0)
	{
		for (DTSEvent *event in eventsWithLocation)
		{
			[self.mapView addAnnotation:event];
		}
		[self.mapView showAnnotations:self.mapView.annotations animated:YES];
	}
	else
	{
		CLLocationCoordinate2D zoomLocation ;
		zoomLocation.latitude = 39.281516;
		zoomLocation.longitude= -76.580806;
		
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
		
		[self.mapView setRegion:viewRegion animated:YES];
	}
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	DTSEvent *event = (DTSEvent *)annotation;
	MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[NSString stringWithFormat:@"EventType%d",event.eventType]];
	annotationView.enabled = YES;
	annotationView.canShowCallout = YES;
	annotationView.tintColor = event.eventTopColor;
	return annotationView;
}

@end
