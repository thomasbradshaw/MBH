//
//  ScaryBugDatabase.m
//  ScaryBugs
//
//  Created by Thomas Bradshaw on 7/21/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import "LocationDatabase.h"
#import "LocationDoc.h"

@implementation LocationDatabase

+ (NSString *)getPrivateDocsDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}

+ (NSMutableArray *)loadLocationDocs
{
    // Get private docs dir
    NSString *documentsDirectory = [LocationDatabase getPrivateDocsDir];
    NSLog(@"Loading data from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (files == nil)
    {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    }
    
    // Create Location doc for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    
    for (NSString *file in files)
    {
        if ([file.pathExtension compare:@"location" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            LocationDoc *doc = [[LocationDoc alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }
    
    return retval;
}

+ (NSString *)nextLocationPath
{
    // Get private docs dir
    NSString *documentsDirectory = [LocationDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (files == nil)
    {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files)
    {
        if([file.pathExtension compare:@"location" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get Available name
    NSString *availableName = [NSString stringWithFormat:@"%d.location", maxNumber+1];
    
    return [documentsDirectory stringByAppendingPathComponent:availableName];
}

@end
