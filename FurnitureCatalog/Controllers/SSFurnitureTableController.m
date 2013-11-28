//
//  SSFurnitureTableController.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/14/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSFurnitureTableController.h"
#import "SSAppDelegate.h"
#import "SSFurnitureDetailController.h"
#import "SSFurnitureTableViewCell.h"
#import "Furniture.h"
#import "SSStackMobRESTApi.h"

@interface SSFurnitureTableController ()

@end

@implementation SSFurnitureTableController

@synthesize furnitureArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadTableData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"SSFurnitureTableViewCell" bundle:nil];
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"SSFurnitureTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [furnitureArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SSFurnitureTableViewCell";
    SSFurnitureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SSFurnitureTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"SSFurnitureTableViewCell"];
    }
    
    // Grab the artist
    Furniture *furniture = [self.furnitureArray objectAtIndex:indexPath.row];
    cell.name.text = furniture.name;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create and push Task Detail view controller.
    SSFurnitureDetailController *detailViewController = [[SSFurnitureDetailController alloc] init];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    [detailViewController setDelegate:self];
    Furniture *selectedItem = [self.furnitureArray objectAtIndex:[indexPath row]];
    
    // Give detail view controller a pointer to the item object in row
    [detailViewController setItem:selectedItem];
    
    // Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];
}


- (void) loadTableData {
    SSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.stackMobRESTApi.appIsOnline) {
        RKObjectManager *manager = [RKObjectManager sharedManager];
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/vnd.stackmob+json"];
        [manager getObjectsAtPath:@"/UserFurniture" parameters:nil
                          success: ^( RKObjectRequestOperation *operation, RKMappingResult *result) {
                              NSLog(@"done");
                              self.furnitureArray = [result array];
                              [self.tableView reloadData];
                              SSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                              [appDelegate saveContext];
                          }
                          failure: ^( RKObjectRequestOperation *operation, NSError *error) {
                              NSLog(@"error");
                          }];
        
    } else {
        RKManagedObjectStore *defaultStore = [RKManagedObjectStore defaultStore];
        NSManagedObjectContext *context = [defaultStore persistentStoreManagedObjectContext];
        
        // Construct a fetch request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Furniture"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        // Add an NSSortDescriptor to sort the labels alphabetically
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                       ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSError *error = nil;
        self.furnitureArray = [context executeFetchRequest:fetchRequest error:&error];
        [self.tableView reloadData];
    }
}





@end
