//
//  SSAppDelegate.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/13/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class SMClient;
//@class SMCoreDataStore;

@interface SSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (strong, nonatomic) SMClient * client;
//@property (strong, nonatomic) SMCoreDataStore *coreDataStore;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
