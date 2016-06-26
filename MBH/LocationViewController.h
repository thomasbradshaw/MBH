//
//  LocationViewController.h
//  MBH
//
//  Created by Thomas Bradshaw on 7/26/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *locationToFind;
}

@property (strong, nonatomic) IBOutlet UIImageView *greenArrow;

@property (strong, nonatomic) IBOutlet UILabel *latLabel;
@property (strong, nonatomic) IBOutlet UILabel *longLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *hereLatLabel;
@property (strong, nonatomic) IBOutlet UILabel *hereLongLabel;

@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *locationToFind;
@property float geoAngle;
@property (strong, nonatomic) CLLocation *currentLocation;
@property CLLocationDirection currentHeading;
 
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
