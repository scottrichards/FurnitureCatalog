//
//  SSAppDelegate.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/13/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSStackMobRESTApi;

@interface SSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#if 0
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
#endif
@property (strong, nonatomic) SSStackMobRESTApi *stackMobRESTApi;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
