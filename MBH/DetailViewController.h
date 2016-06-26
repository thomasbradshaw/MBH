//
//  DetailViewController.h
//  MBH
//
//  Created by Thomas Bradshaw on 7/26/13.
//  Copyright (c) 2013 Thomas Bradshaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class LocationDoc;

@interface DetailViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) LocationDoc *detailItem;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *savedLocation;

@property (strong, nonatomic) UIImagePickerController *picker;

- (IBAction)addPictureTapped:(id)sender;
- (IBAction)titleFieldTextChanged:(id)sender;
- (IBAction)btnMarkThisLocationPressed:(id)sender;
- (IBAction)btnFindThisLocationPressed:(id)sender;
@end
