//
//  DetailViewController.m
//  MBH
//
//  Created by Thomas Bradshaw on 7/26/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import "DetailViewController.h"
#import "LocationViewController.h"
#import "LocationDoc.h"
#import "LocationData.h"
#import "UIImageExtras.h"
#import "SVProgressHUD.h"


@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize picker = _picker;
@synthesize detailItem = _detailItem;
@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize savedLocation = _savedLocation;

#pragma mark - Managing detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        // Update view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        self.titleField.text = self.detailItem.data.title;
        self.savedLocation = [[CLLocation alloc] initWithLatitude:[self.detailItem.data.latitude floatValue] longitude:[self.detailItem.data.latitude floatValue]];
        self.imageView.image = self.detailItem.fullImage;
    }
    
    // tb - Playing with background colors - kind of greenish
    self.view.backgroundColor = [UIColor colorWithRed:(220/255.0) green:(255/255.0) blue:(217/255.0) alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init current location
    _currentLocation = [[CLLocation alloc] init];

    // Init location manager    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=kCLDistanceFilterNone;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnMarkThisLocationPressed:(id)sender
{
    // Save current location here
    CLLocation *here = [[CLLocation alloc] initWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    self.detailItem.data.location = here;
    _detailItem.data.latitude = [NSString stringWithFormat:@"%f", here.coordinate.latitude];
    _detailItem.data.longitude = [NSString stringWithFormat:@"%f", here.coordinate.longitude];
    
    [_detailItem saveData];
}

- (IBAction)btnFindThisLocationPressed:(id)sender
{
    // Really, nothing to do here since segue takes care of it
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Retrieve our saved coordinates
    float la = [_detailItem.data.latitude floatValue];
    float lo = [_detailItem.data.longitude floatValue];
    
    // Create a new location to pass on
    _savedLocation = [[CLLocation alloc] initWithLatitude:la longitude:lo];
    
    // temp stub in destination
    // _savedLocation = [[CLLocation alloc] initWithLatitude:37.617495 longitude:-97.180595];
    
    if([[segue identifier] isEqualToString:@"segueToLocation"])
    {
        LocationViewController *locationViewController = [segue destinationViewController];
        locationViewController.locationToFind = _savedLocation;
    }
}

- (IBAction)addPictureTapped:(id)sender
{
    if (self.picker == nil)
    {
        // tb - Show Status lightbox
        [SVProgressHUD showWithStatus:@"Loading Picker..."];
        
        // tb - Get a concurrent queue from the system
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // tb - Load picker in background
        dispatch_async(concurrentQueue, ^{
            
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.allowsEditing = NO;
            
            // tb - Present picker in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController presentViewController:_picker animated:YES completion:nil];
                [SVProgressHUD dismiss];
            });
        });
    }
    else
    {
        [self.navigationController presentViewController:_picker animated:YES completion:nil];
    }
}

#pragma mark UITextField delegate

- (IBAction)titleFieldTextChanged:(id)sender
{
    self.detailItem.data.title = self.titleField.text;
    [_detailItem saveData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // This makes keyboard disappear when return is pressed
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[self dismissModalViewControllerAnimated:TRUE];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    UIImage *fullImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    // tb - Show Status
    [SVProgressHUD showWithStatus:@"Resizing image..."];
    
    // tb - Get concurrent queue from the system
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    // tb - Resize image in background
    dispatch_async(concurrentQueue, ^{
        UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        
        // tb - Present image in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.detailItem.fullImage = fullImage;
            self.detailItem.thumbImage = thumbImage;
            self.imageView.image = fullImage;
            [_detailItem saveImages];
            
            [SVProgressHUD dismiss];
        });
    });
}

#pragma mark - Location Manager delegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"There was an error retrieving your location"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    
    NSLog(@"Error: %@",error.description);
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Save off our current location
    _currentLocation = [locations lastObject];
}

@end
