//
//  SSStackMobRESTApi.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/25/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Furniture;

@interface SSStackMobRESTApi : NSObject

- (void)setupObjectManager;
- (void)setupMappings;
- (void)setupCoreData;

@property (assign, nonatomic) BOOL appIsOnline;

@end
