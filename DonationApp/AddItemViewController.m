//
//  AddItemViewController.m
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "AddItemViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SelectCategoryViewController.h"

@interface AddItemViewController () <SelectCategoryViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIView *photoMenuView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) int imageCounter;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup textfields/textview
    self.descriptionTextView.layer.borderWidth = 1;
    self.descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.descriptionTextView.layer.cornerRadius = 5.0f;

    // setup image picker
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    
    // setup photo menu
    self.photoMenuView.layer.cornerRadius = 10.0f;
    self.photoMenuView.alpha = 0.9;
    
    // setup location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
//    self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestLocation];

}

#pragma mark - Navigation

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)addPhotoButtonPressed:(UIButton *)sender {
    self.photoMenuView.hidden = NO;
}

- (IBAction)photoMenuButtonPressed:(UIButton *)sender {
    
    if([sender.currentTitle isEqual:@"Camera"])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else if([sender.currentTitle isEqual:@"Photo Librar"])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }

    self.photoMenuView.hidden = YES;
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"select-category-segue"])
    {
        SelectCategoryViewController *controller = (SelectCategoryViewController *)segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - Location

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (!self.currentLocation) {
        self.currentLocation = locations[0];
        
        NSLog(@"location: %@", locations[0]);
        
        int regionRadius = 1000;
        CLLocationCoordinate2D startLocationCoordinate = self.currentLocation.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(startLocationCoordinate, regionRadius*2, regionRadius*2);
        [self.mapView setRegion:region];

    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting the location updates: %@", error.localizedDescription);
}

#pragma mark - ImagePicker delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    switch (self.imageCounter) {
        case 0:
            self.image1.image = selectedImage;
            self.imageCounter++;
            break;
        case 1:
            self.image2.image = selectedImage;
            self.imageCounter++;
        default:
            self.image3.image = selectedImage;
            break;
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - SelectCategoryViewControllerDelegate

- (void)didSelectCategory:(NSString *)categoryName
{
    self.categoryTextField.text = categoryName;
}

@end
