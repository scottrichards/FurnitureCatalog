//
//  SSMainViewController.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/13/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSMainViewController.h"
#import "SSFurnitureDetailController.h"

@interface SSMainViewController ()

@end

@implementation SSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addFurniture)];
        [[self navigationItem] setRightBarButtonItem:addItem];
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}

- (void)addFurniture
{
    SSFurnitureDetailController *detailViewController = [[SSFurnitureDetailController alloc] init];
    detailViewController.delegate = self;
    detailViewController.newItem = YES;
    [detailViewController setDismissBlock:^{
        NSLog(@"Cancel Add");
    }];
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
