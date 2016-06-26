//
//  MasterViewController.m
//  MBH
//
//  Created by Thomas Bradshaw on 7/26/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "LocationDoc.h"
#import "LocationData.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize locations = _locations;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    // tb - Playing with background colors
    self.tableView.backgroundColor = [UIColor colorWithRed:(220/255.0) green:(255/255.0) blue:(217/255.0) alpha:1];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(25/255.0) green:(136/255.0) blue:(30/255.0) alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_locations)
    {
        _locations = [[NSMutableArray alloc] init];
    }
    
    // tb - Create new doc with default values
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:12.0f longitude:13.0f];
    
    LocationDoc *newDoc = [[LocationDoc alloc] initWithTitle:@"New Location" location:newLocation thumbImage:nil fullImage:nil];
    
    // tb - Add doc to our data structure
    [_locations addObject:newDoc];
    
    // tb - Gets to spot at end of list
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_locations.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    // tb - Insert new rows at end
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
    
    // tb - Pretend to touch it so we go into the new bug screen
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [self performSegueWithIdentifier:@"segueToDetail" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLocationCell" forIndexPath:indexPath];

    LocationDoc *doc = [self.locations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = doc.data.title;
    cell.imageView.image = doc.thumbImage;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // tb - Here to modify cell in some way - Delete / edit / add
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        LocationDoc *doc = [_locations objectAtIndex:indexPath.row];
        [doc deleteDoc];
        
        // remove from our data structure
        [_locations removeObjectAtIndex:indexPath.row];
        
        // delete from tableview - fade
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Do insert stuff here for editing style
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LocationDoc *doc = [self.locations objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setDetailItem:doc];
    }
}

@end
