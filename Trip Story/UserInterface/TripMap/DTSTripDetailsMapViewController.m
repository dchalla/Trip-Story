//
//  DTSTripDetailsMapViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 10/16/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTripDetailsMapViewController.h"
#import "DTSMKPolyLine.h"
#import "UIColor+Utilities.h"

#define METERS_PER_MILE 1609.344
@interface DTSTripDetailsMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DTSTripDetailsMapViewController

@synthesize topLayoutGuideLength;
@synthesize bottomLayoutGuideLength;
@synthesize trip = _trip;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[self removeAnnotations];
	[self removeOverlayViews];
	
	NSArray *eventsWithLocation = self.trip.eventsWithLocationList;
	if (eventsWithLocation.count > 0)
	{
		for (DTSEvent *event in eventsWithLocation)
		{
			[self.mapView addAnnotation:event];
		}
		[self.mapView showAnnotations:self.mapView.annotations animated:YES];
		[self drawDirectionsBetweenTravelEvents];
	}
	else
	{
		CLLocationCoordinate2D zoomLocation ;
		zoomLocation.latitude = 37.81683941;
		zoomLocation.longitude= -122.47793890;
		
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
		
		[self.mapView setRegion:viewRegion animated:YES];
	}
}

- (void)removeAnnotations
{
	for (id<MKAnnotation> annotation in self.mapView.annotations) {
		[_mapView removeAnnotation:annotation];
	}
}

- (void)removeOverlayViews
{
	for (id<MKOverlay>overlay in self.mapView.overlays) {
		[self.mapView removeOverlay:overlay];
	}
}


- (void)drawDirectionsBetweenTravelEvents
{
	NSArray *startAndEndTravelEventsArray = [self.trip startAndEndTravelEventsArray];
	for (NSArray *eventSet in startAndEndTravelEventsArray)
	{
		[self drawDirectionsBetweenEvent:eventSet.firstObject endEvent:eventSet.lastObject];
	}
}

- (void)drawDirectionsBetweenEvent:(DTSEvent *)startEvent endEvent:(DTSEvent *)endEvent
{
	if (startEvent.location.mapItem && endEvent.location.mapItem)
	{
		if (endEvent.isTravelEvent)
		{
			MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
			[request setSource:startEvent.location.mapItem];
			[request setDestination:endEvent.location.mapItem];
			if (endEvent.eventType == DTSEventTypeTravelByRoad)
			{
				[request setTransportType:MKDirectionsTransportTypeAutomobile];
			}
			else if (endEvent.eventType == DTSEventTypeTravelByAir || endEvent.eventType == DTSEventTypeTravelByWater)
			{
				CLLocationCoordinate2D coordinates[2];
				coordinates[0] = startEvent.location.mapItem.placemark.coordinate;
				coordinates[1] = endEvent.location.mapItem.placemark.coordinate;
				DTSMKPolyLine *airLine = [DTSMKPolyLine polylineWithCoordinates:coordinates count:2];
				airLine.eventType = endEvent.eventType;
				[self.mapView addOverlay:airLine];
				return;
			}
			else
			{
				[request setTransportType:MKDirectionsTransportTypeAny];
			}
			
			MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
			
			[direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
				if (error || response == nil)
				{
					NSLog(@"Map Data Error");
				}
				else
				{
					NSArray *arrRoutes = [response routes];
					MKRoute *rout = arrRoutes.firstObject;
					MKPolyline *line = [rout polyline];
					if (rout && line)
					{
						[self.mapView addOverlay:line];
						NSLog(@"Rout Name : %@",rout.name);
						NSLog(@"Total Distance (in Meters) :%f",rout.distance);
						
						NSArray *steps = [rout steps];
						
						NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
						
						[steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
							NSLog(@"Rout Instruction : %@",[obj instructions]);
							NSLog(@"Rout Distance : %f",[obj distance]);
						}];
					}
					
				}
				
			}];

		}
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
	annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	return annotationView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
	if ([overlay isKindOfClass:[MKPolyline class]])
	{
		MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
		aView.strokeColor = [UIColor colorWithRed:57/255.0 green:149/255.0 blue:253/255.0 alpha:0.8];
		if ([overlay isKindOfClass:[DTSMKPolyLine class]])
		{
			DTSMKPolyLine *polyLine = (DTSMKPolyLine *)overlay;
			if (polyLine.eventType == DTSEventTypeTravelByWater)
			{
				aView.strokeColor = [UIColor blackColor];
			}
			else if (polyLine.eventType == DTSEventTypeTravelByAir)
			{
				aView.strokeColor = [UIColor redColor];
			}
		}
		aView.lineWidth = 10;
		return aView;
	}
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	DTSEvent *event = (DTSEvent*)view.annotation;
 
	NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
	[event.location.mapItem openInMapsWithLaunchOptions:launchOptions];
}

@end
