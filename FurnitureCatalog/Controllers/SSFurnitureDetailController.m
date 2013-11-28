//
//  SSFurnitureDetailController.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/13/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSFurnitureDetailController.h"
#import "Furniture.h"
#import "SSAppDelegate.h"
#import "SSStackMobRESTApi.h"

@interface SSFurnitureDetailController () <UITextFieldDelegate>


@end

@implementation SSFurnitureDetailController

@synthesize dismissBlock;
@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific

        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                     target:self
                                     action:@selector(create:)];
        [[self navigationItem] setLeftBarButtonItem:saveItem];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                    target:self
                                       action:@selector(cancelAdd:)];
        [[self navigationItem] setRightBarButtonItem:cancelItem];
    }
    return self;
}

- (void)cancelAdd:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.name setText:[item name]];
    [self.category setText:[item category]];
    [self.brand setText:[item brand]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *priceStr = [formatter stringFromNumber:[item price]];
    [self.price setText:priceStr];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.name.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
    self.name.returnKeyType = UIReturnKeyDone;
    
    self.name.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    self.name.placeholder = @"<Product Name>";
    self.name.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) create:(id)sender
{
    RKManagedObjectStore *defaultStore = [RKManagedObjectStore defaultStore];
    NSManagedObjectContext *context = [defaultStore persistentStoreManagedObjectContext];
    Furniture *furniture;
    // Grab the Label entity
    if (self.newItem)
        furniture = [NSEntityDescription insertNewObjectForEntityForName:@"Furniture" inManagedObjectContext:context];
    else
        furniture = item;
    
    // Set label name
    [furniture setName:[[self name] text]];
    [furniture setCategory:[[self category] text]];
    [furniture setBrand:[[self brand] text]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * price = [formatter numberFromString:[[self price] text]];
    NSDecimalNumber* decimalPrice = [NSDecimalNumber decimalNumberWithDecimal:[price decimalValue]];
    [furniture setPrice:decimalPrice];
    
    SSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.stackMobRESTApi.appIsOnline) {
        [appDelegate.stackMobRESTApi addFurniture:furniture];
    }
    
    // Save everything
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"The save wasn't successful: %@", [error userInfo]);
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)backgroundTapped:(id)sender {
     [[self view] endEditing:YES];
}
@end
