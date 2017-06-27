//
//  AddItemViewController.m
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "AddItemViewController.h"
#import <MapKit/MapKit.h>
#import "SelectCategoryViewController.h"

@interface AddItemViewController () <SelectCategoryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark - Navigation

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"select-category-segue"])
    {
        SelectCategoryViewController *controller = (SelectCategoryViewController *)segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - SelectCategoryViewControllerDelegate

- (void)didSelectCategory:(NSString *)categoryName
{
    self.categoryTextField.text = categoryName;
}

@end
