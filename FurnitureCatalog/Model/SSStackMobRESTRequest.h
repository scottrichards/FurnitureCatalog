//
//  SSStackMobRESTRequest.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/30/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Furniture;

@protocol SSSTackMobRESTApiDelegate
- (void)onSuccess:(RKObjectRequestOperation *)operation result:(RKMappingResult *)mappingResult;
- (void)onFailure:(RKObjectRequestOperation *)operation error:(NSError *)error;
@end

@interface SSStackMobRESTRequest : NSObject
- (void)getFurnitureList;
- (void)addFurniture:(Furniture *)newItem;

@property (weak, nonatomic) id <SSSTackMobRESTApiDelegate>delegate;
@end
