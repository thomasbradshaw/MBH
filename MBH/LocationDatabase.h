//
//  ScaryBugDatabase.h
//  ScaryBugs
//
//  Created by Thomas Bradshaw on 7/21/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationDatabase : NSObject

+ (NSMutableArray *)loadLocationDocs;
+ (NSString *)nextLocationPath;

@end
