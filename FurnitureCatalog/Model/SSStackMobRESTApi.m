//
//  SSStackMobRESTApi.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/25/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSStackMobRESTApi.h"
#import "Furniture.h"

@implementation SSStackMobRESTApi

- (void)setupObjectManager
{
    // Set the base Url. Remember not to put `/` at the end.
    // Otherwise, you'll be in a problem with response mapping.
    NSString *baseUrl = @"http://api.stackmob.com";
    
    
    NSURL *baseURL = [NSURL URLWithString:baseUrl];
    
    // Initialize our custom HTTP Client to always add _apikey to url
    //MongoHqHTTPClient *httpClient = [[MongoHqHTTPClient alloc] initWithBaseURL:baseURL];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient setDefaultHeader:@"Accept" value:@"application/vnd.stackmob+json; version=0"];
    [httpClient setDefaultHeader:@"X-StackMob-API-Key" value:@"d5e60ef8-af6e-4c52-b869-9c80c92a61b3"];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    // Init with custom HTTPClient
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/vnd.stackmob+json"];
    
    // register JSONRequestOperation to parse JSON in requests
    [manager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //   [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // Set the shared instance of the object manager
    // So we can easily re-use it later
    [RKObjectManager setSharedManager:manager];
    
    // Show activity indicator in status bar
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
}

- (void)setupMappings
{
    // Get the object manager we use
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // The class we map to
    Class itemClass = [Furniture class];
    
    // The endpoint we plan to request for getting a list of objects
    NSString *itemsPath = @"/UserFurniture";
    
    // Create the request mapping
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    
    // Following properties are a direct mapping from the StackMob Schema to our internal
    [requestMapping addAttributeMappingsFromArray:@[@"name",@"brand",@"category",@"price"]];
    
    // For any object of class MDatabase, serialize into an NSMutableDictionary using the given mapping
    // If we will provide the rootKeyPath, serialization will nest under the 'provided' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:itemClass rootKeyPath:nil method:RKRequestMethodAny];
    [manager addRequestDescriptor:requestDescriptor];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:itemClass];
    
    // This is where you put any fields that do not map up directly
//    [responseMapping addAttributeMappingsFromDictionary:@{@"userfurniture_id":@"id"}];
    
    // The root JSON key path. nil in our case states that there won't be one.
    NSString *keyPath = nil;
    
    // The mapping will be triggered if a response status code is anything in 2xx
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // Put it all together in response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:itemsPath keyPath:keyPath statusCodes:statusCodes];
    
    // Add response descriptor to our manager
    [manager addResponseDescriptor:responseDescriptor];
    
    // ROUTING
    
    // Route for list of objects
    RKRoute *itemsRoute = [RKRoute routeWithName:@"UserFurniture" pathPattern:itemsPath method:RKRequestMethodGET];
    itemsRoute.shouldEscapePath = YES;
    
    // Route for creating a new object
    RKRoute *newItemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemsPath method:RKRequestMethodPOST];
    newItemRoute.shouldEscapePath = YES;
    
    
    // Add defined routes to the Object Manager router
    [manager.router.routeSet addRoutes:@[itemsRoute, newItemRoute]];
}

- (void)simpleAddItem:(Furniture *)newItem
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/vnd.stackmob+json"];
    [manager postObject:newItem path:nil parameters:nil
                success: ^( RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"done");
                }
                failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                }];
}
@end
