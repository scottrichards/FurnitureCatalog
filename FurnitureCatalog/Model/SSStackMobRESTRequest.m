//
//  SSStackMobRESTRequest.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/30/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSStackMobRESTRequest.h"
#import "SSStackMobRESTApi.h"

@implementation SSStackMobRESTRequest

- (void)addFurniture:(Furniture *)newItem
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager postObject:newItem path:nil parameters:nil
                success: ^( RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"Add Furniture SUCCESS");
                    [self.delegate onSuccess:operation result:mappingResult];
                }
                failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"Add Furniture FAILURE");
                    [self.delegate onFailure:operation error:error];
                }];
}

- (void)getFurnitureList
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager getObjectsAtPath:@"/UserFurniture" parameters:nil
                      success: ^( RKObjectRequestOperation *operation, RKMappingResult *result) {
                          NSLog(@"Retrieved Furniture List");
                          [self.delegate onSuccess:operation result:result];
                      }
                      failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                          [self.delegate onFailure:operation error:error];
                      }];
    
}


@end
