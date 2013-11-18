//
//  Furniture.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/14/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Furniture : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDecimalNumber * depth;
@property (nonatomic, retain) NSDecimalNumber * height;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * private;
@property (nonatomic, retain) NSDecimalNumber * width;

@end
