//
//  ListItemDetailedViewController.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-27.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "ListItemDetailedViewController.h"

@interface ListItemDetailedViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation ListItemDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    self.imageView.image = self.item.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    
    self.categoryLabel.text = self.item.category;
    self.itemTitleLabel.text = self.item.title;
    self.itemDescriptionLabel.text = self.item.itemDescription;
}

- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contactPressed:(UIButton *)sender {
    NSString *userInfoString = [NSString stringWithFormat:@"Here's the owner's contact info:\nName: %@\nPhone Number: %@\nEmail: %@",self.item.userName,self.item.userPhoneNum,self.item.userEmail];
    UIAlertController *contactInfo = [UIAlertController alertControllerWithTitle:@"Contact the owner" message:userInfoString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [contactInfo addAction:okAction];
    [self presentViewController:contactInfo animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
