//
//  LocationData.m
//  MeetBackHere
//
//  Created by Thomas Bradshaw on 7/17/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import "LocationData.h"

@implementation LocationData

@synthesize title = _title;
@synthesize location = _location;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)initWithTitle:(NSString *)title location:(CLLocation *)location
{
    if (self = [super init])
    {
        self.title = title;
        self.location = location;
        self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    }
    
    return self;
}

#pragma mark NSCoding

#define kTitleKey   @"Title"
#define kLocationKey  @"Location"
#define kLatitude @"Latitude"
#define kLongtitude @"Longitude"

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_title forKey:kTitleKey];
    // [encoder encodeObject:_location forKey:kLocationKey];
    [encoder encodeObject:_latitude forKey:kLatitude];
    [encoder encodeObject:_longitude forKey:kLongtitude];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    // CLLocation *location = [decoder decodeObjectForKey:kLocationKey];
    
    NSString *latitudeAsString = [decoder decodeObjectForKey:kLatitude];
    NSString *longitudeAsString = [decoder decodeObjectForKey:kLongtitude];
                                   
    float la = [latitudeAsString floatValue];
    float lo = [longitudeAsString floatValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:la longitude:lo];
    
    return [self initWithTitle:title location:location];
}

@end
