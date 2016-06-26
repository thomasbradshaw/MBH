//
//  ScaryBugDoc.h
//  ScaryBugs
//
//  Created by Thomas Bradshaw on 7/17/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// tb - Forward reference
@class LocationData;

NSString *_docPath;

@interface LocationDoc : NSObject

@property (strong, nonatomic) LocationData *data;
@property (strong, nonatomic) UIImage *thumbImage;
@property (strong, nonatomic) UIImage *fullImage;

@property (copy) NSString *docPath;

- (id)initWithTitle:(NSString *)title location:(CLLocation *)location thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)saveData;
- (void)deleteDoc;
- (void)saveImages;

@end
