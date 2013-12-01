//
//  SSFurnitureDetailController.h
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/13/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSStackMobRESTrequest.h"

@class SSMainViewController;
@class Furniture;

@interface SSFurnitureDetailController : UIViewController <SSSTackMobRESTApiDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (weak, nonatomic) IBOutlet UITextField *brand;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) BOOL newItem;

@property (strong, nonatomic) Furniture *item;
@property (weak, nonatomic) UIViewController* delegate;
@property (nonatomic, copy) void (^dismissBlock)(void);
- (IBAction)backgroundTapped:(id)sender;
@end
