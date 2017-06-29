//
//  ListItemDetailedViewController.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-27.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "ListItemDetailedViewController.h"

@interface ListItemDetailedViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;

@property (strong, nonatomic) NSArray *images;

@property (nonatomic) CGFloat imageOriginX;

@end

@implementation ListItemDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc] initWithTitle:@"Contact" style:UIBarButtonItemStylePlain target:self action:@selector(contactPressed:)];
    contactButton.tintColor = [UIColor greenColor];
    self.navigationItem.rightBarButtonItem = contactButton;
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    self.imageOriginX = self.imagesScrollView.bounds.origin.x;
    self.images = [NSArray arrayWithArray:self.item.photos];
    for (UIImage *image in self.images) {
        CGRect frame = CGRectMake(self.imageOriginX, 0, CGRectGetWidth(self.imagesScrollView.bounds), CGRectGetHeight(self.imagesScrollView.bounds));
        
        UIImageView *view = [[UIImageView alloc]initWithImage:image];
        view.frame = frame;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        view.userInteractionEnabled = NO;
        
        //lastly, add the image to the UIScrollView, and increment the x position for use in placing the next image
        [self.imagesScrollView addSubview:view];
        self.imageOriginX += CGRectGetWidth(self.imagesScrollView.bounds);
    }
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.contentSize = CGSizeMake([self.images count] * CGRectGetWidth(self.imagesScrollView.bounds), CGRectGetHeight(self.imagesScrollView.bounds));
    
    self.imagesScrollView.delegate = self;
    
    self.categoryLabel.text = self.item.category;
    self.itemTitleLabel.text = self.item.title;
    self.itemDescriptionLabel.text = self.item.itemDescription;
}

- (IBAction)contactPressed:(UIButton *)sender {
    NSString *userInfoString = [NSString stringWithFormat:@"Here's the owner's contact info:\nName: %@\nPhone Number: %@\nEmail: %@",self.item.userName,self.item.userPhoneNum,self.item.userEmail];
    UIAlertController *contactInfo = [UIAlertController alertControllerWithTitle:@"Contact the owner" message:userInfoString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
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
