//
//  LocationDoc.m
//  MeetBackHere
//
//  Created by Thomas Bradshaw on 7/17/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import "LocationDoc.h"
#import "LocationData.h"
#import "LocationDatabase.h"

#define kDataKey    @"Data"
#define kDataFile   @"data.plist"
#define kThumbImageFile @"thumbImage.jpg"
#define kFullImageFile @"fullImage.jpg"

@implementation LocationDoc

@synthesize fullImage = _fullImage;
@synthesize docPath = _docPath;
@synthesize data = _data;
@synthesize thumbImage = _thumbImage;

- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (id)initWithDocPath:(NSString *)docPath
{
    if (self = [super init])
    {
        _docPath = [docPath copy];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title location:(CLLocation *)location thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage
{
    if (self = [super init])
    {
        self.data = [[LocationData alloc] initWithTitle:title location:location];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
    }
    
    return self;
}

- (BOOL)createDataPath
{
    if (_docPath == nil)
    {
        self.docPath = [LocationDatabase nextLocationPath];
    }
    
    NSError *error;
    
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!success)
    {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    
    return success;
}

- (LocationData *)data
{
    if (_data != nil)
    {
        return _data;
    }
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil)
    {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];

    _data = [unarchiver decodeObjectForKey:kDataKey];

    [unarchiver finishDecoding];
    
    CLLocation *here = [[CLLocation alloc] initWithLatitude:[_data.latitude floatValue] longitude:[_data.longitude floatValue]];
    
    _data.location = here;

    return _data;
}

- (void)saveData
{
    if (_data == nil)
    {
        return;
    }
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

- (void)deleteDoc
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    
    if (!success)
    {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}

- (UIImage *)thumbImage
{
    if (_thumbImage != nil)
    {
        return _thumbImage;
    }
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    return [UIImage imageWithContentsOfFile:thumbImagePath];
}

- (UIImage *)fullImage
{
    if (_fullImage != nil)
    {
        return _fullImage;
    }
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    return [UIImage imageWithContentsOfFile:fullImagePath];
}

- (void)saveImages
{
    if (_thumbImage == nil || _fullImage == nil)
    {
        return;
    }
    
    [self createDataPath];
    
    NSString *thumbImagePath = [_docPath stringByAppendingPathComponent:kThumbImageFile];
    NSData *thumbImageData = UIImagePNGRepresentation(_thumbImage);
    [thumbImageData writeToFile:thumbImagePath atomically:YES];
    
    NSString *fullImagePath = [_docPath stringByAppendingPathComponent:kFullImageFile];
    NSData *fullImageData = UIImagePNGRepresentation(_fullImage);
    [fullImageData writeToFile:fullImagePath atomically:YES];
    
    self.thumbImage = nil;
    self.fullImage = nil;
}

- (void)dealloc
{
    _docPath = nil;
}

@end
