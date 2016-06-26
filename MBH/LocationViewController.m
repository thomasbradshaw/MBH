//
//  LocationViewController.m
//  MBH
//
//  Created by Thomas Bradshaw on 7/26/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import "LocationViewController.h"

#define RadiansToDegrees(radians)(radians * 180.0 / M_PI)
#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize greenArrow = _greenArrow;
@synthesize locationManager = _locationManager;
@synthesize locationToFind = _locationToFind;
@synthesize geoAngle = _geoAngle;
@synthesize currentLocation = _currentLocation;
@synthesize currentHeading = _currentHeading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Other set up here
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.headingFilter = kCLDistanceFilterNone; // report all angles
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
 
    // This needed for iOS8 Core Location startup
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    
    _latLabel.text = [NSString stringWithFormat:@"%f", _locationToFind.coordinate.latitude];
    _longLabel.text = [NSString stringWithFormat:@"%f",_locationToFind.coordinate.longitude];
    
    // Set arrow back to north
    [self rotateArrow:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rotateArrow:(CGFloat)angleInRadians
{
    _greenArrow.transform = CGAffineTransformMakeRotation(angleInRadians);
}

- (void)updateScreenData //:(CLLocation *)currentLocation
{
    _hereLatLabel.text = [NSString stringWithFormat:@"%f", _currentLocation.coordinate.latitude];
    _hereLongLabel.text = [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude];
    
    CLLocationDistance meters = [_locationToFind distanceFromLocation:_currentLocation];
    _distanceLabel.text = [NSString stringWithFormat:@"%12.2f meters", meters];
    
    // Get true-north angle regardless of direction you're facing
    float absoluteAngleFromCurrentLocation = [self setLatLonForDistanceAndAngle:_currentLocation];
    NSLog(@"absoluteAngle=%f", absoluteAngleFromCurrentLocation); // 0=North 1=NE 2=SE 3=AlmostS 4=SW = 5=NW 6=AlmostN radians

    // Get true-north angle of direction you're facing
    float absoluteAngleOfCurrentHeading = DegreesToRadians(_currentHeading);
    NSLog(@"absoluteBearing=%f", absoluteAngleOfCurrentHeading); // 0=North 1=NE 2=SE 3=AlmostS 4=SW = 5=NW 6=AlmostN radians
    
    // This is relative angle -- go this direction
    _geoAngle = absoluteAngleFromCurrentLocation - absoluteAngleOfCurrentHeading;
    
    // rotate screen arrow
    [self rotateArrow:_geoAngle];
}

#pragma mark CLLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [locations lastObject];
    [self updateScreenData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // if accuracy is valid, process event
    if (newHeading.headingAccuracy > 0)
    {
        _currentHeading = newHeading.magneticHeading;
        [self updateScreenData];
    }
}

- (float)setLatLonForDistanceAndAngle:(CLLocation *)userLocation
{
    float lat1 = DegreesToRadians(userLocation.coordinate.latitude);
    float lon1 = DegreesToRadians(userLocation.coordinate.longitude);
    
    float lat2 = DegreesToRadians(_locationToFind.coordinate.latitude);
    float lon2 = DegreesToRadians(_locationToFind.coordinate.longitude);
    
    float dLon = lon2 - lon1;
    
    float y = sin(dLon) * cos(lat2);
    float x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    
    // Magic happens here - get the angle between two points
    float radiansBearing = atan2(y,x);
    
    if (radiansBearing < 0.0)
    {
        radiansBearing += 2 * M_PI;
    }
    
    return radiansBearing;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
}

@end
