//
//  SSFurnitureTableController.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/14/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SSStackMobRESTApi.h"
#import "SSStackMobRESTRequest.h"

@interface SSFurnitureTableController : UITableViewController <SSSTackMobRESTApiDelegate,NSFetchedResultsControllerDelegate>
- (void)onSuccess:(RKObjectRequestOperation *)operation result:(RKMappingResult *)mappingResult;
- (void)onFailure:(RKObjectRequestOperation *)operation error:(NSError *)error;
// An array to house all of our fetched Artist objects
//@property (strong, nonatomic) NSArray *furnitureArray;


@end
