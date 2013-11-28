//
//  SSStackMobRESTApi.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/25/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSStackMobRESTApi.h"
#import "Furniture.h"
#import "SSAppDelegate.h"

@implementation SSStackMobRESTApi

- (void)setupCoreData
{
    // Configure RestKit's Core Data stack
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"FurnitureCatalog" ofType:@"momd"]];
    
    // Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"FurnitureCatalog.sqlite"];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    
    // Create default contexts
    // For main thread and background processing
    [managedObjectStore createManagedObjectContexts];
 

    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    

    // Assign Managed object store to Object manager
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.managedObjectStore = managedObjectStore;
}

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
    
    // Reachability
    [manager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There is no network connection"
                                                            message:@"You must be connected to the internet to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            self.appIsOnline = false;
            [alert show];
            
        } else {
            self.appIsOnline = true;
        }
    }];
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
 
#ifdef USE_CORE_DATA
    // Get default managed object store
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    
    // Create mapping for entity
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"Furniture" inManagedObjectStore:managedObjectStore];
    
    // How to identify if the object we got is in database
    // Here, we identify by name.
    responseMapping.identificationAttributes = @[@"name"];
#else
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:itemClass];
#endif
    // This is where you put any fields that do not map up directly
    [responseMapping addAttributeMappingsFromArray:@[@"name",@"brand",@"category",@"price"]];
    
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
// USE CORE DATA
#if 0
    // Deleating orphaned objects
    // Define Fetch request to trigger on specific url
    [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        // Create a path matcher
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:itemsPath];
        
        // Dictionary to store request arguments
        // databaseID in our case is what we are looking for
        NSDictionary *argsDict = nil;
        
        // Match the URL with pathMatcher and retrieve arguments
        BOOL match = [pathMatcher matchesPath:[URL relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
#if 0
        // If url matched, create NSFetchRequest
        if (match) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            // Edit the entity name as appropriate.
            RKManagedObjectStore *defaultStore = [RKManagedObjectStore defaultStore];
            NSManagedObjectContext *managedObjectContext = [defaultStore persistentStoreManagedObjectContext];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Furniture" inManagedObjectContext:managedObjectContext];
            [fetchRequest setEntity:entity];
            return fetchRequest;
            
        }
#else
        if (match) {
            NSString *userFurnitureID = [argsDict objectForKey:@"userfurniture_id"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userfurniture_id = %@", userFurnitureID];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            RKManagedObjectStore *defaultStore = [RKManagedObjectStore defaultStore];
            NSManagedObjectContext *managedObjectContext = [defaultStore persistentStoreManagedObjectContext];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Furniture" inManagedObjectContext:managedObjectContext];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            return fetchRequest;
        }
#endif
        return nil;
    }];
#endif
}


- (void)addFurniture:(Furniture *)newItem
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
// Don't think I need this anymore
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/vnd.stackmob+json"];
    [manager postObject:newItem path:nil parameters:nil
                success: ^( RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"done");
                }
                failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                }];
}

- (void)getFurnitureList
{
 /*   RKObjectManager *manager = [RKObjectManager sharedManager];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/vnd.stackmob+json"];
    [manager getObjectsAtPath:@"/UserFurniture" parameters:nil
                      success: ^( RKObjectRequestOperation *operation, RKMappingResult *result) {
                          NSLog(@"done");
                      }
                      failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"error");
                      }];*/
    
    
        
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/vnd.stackmob+json"];
    [manager getObjectsAtPath:@"/UserFurniture" parameters:nil
                      success: ^( RKObjectRequestOperation *operation, RKMappingResult *result) {
                          NSLog(@"Retrieved Furniture List");
                          SSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                          [appDelegate saveContext];
                      }
                      failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"ERROR Failed to Retrieve Furniture List");
                      }];

}

@end
