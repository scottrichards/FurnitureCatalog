//
//  SSStackMobRESTApi.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/25/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Furniture;

@protocol SSSTackMobRESTApiDelegate
- (void)onSuccess:(RKObjectRequestOperation *)operation result:(RKMappingResult *)mappingResult;
- (void)onFailure:(RKObjectRequestOperation *)operation error:(NSError *)error;
@end

@interface SSStackMobRESTApi : NSObject

- (void)setupObjectManager;
- (void)setupMappings;
- (void)setupCoreData;
- (void)getFurnitureList;
- (void)addFurniture:(Furniture *)newItem;

@property (assign, nonatomic) BOOL appIsOnline;
@property (weak, nonatomic) id <SSSTackMobRESTApiDelegate>delegate;

@end
