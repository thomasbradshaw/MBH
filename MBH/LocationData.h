//
//  LocationData.h
//  MeetBackHere
//
//  Created by Thomas Bradshaw on 7/17/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationData : NSObject <NSCoding>

@property (strong) NSString *title;
@property (assign) CLLocation *location;
@property (strong) NSString *latitude;
@property (strong) NSString *longitude;

- (id)initWithTitle:(NSString *)title location:(CLLocation *)location;

@end
