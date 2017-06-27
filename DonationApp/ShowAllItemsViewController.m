//
//  ListItemsViewController.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "ShowAllItemsViewController.h"
@import Photos;
@interface ShowAllItemsViewController () <UICollectionViewDelegate,UICollectionViewDataSource, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *itemsToDisplay;
@property (strong, nonatomic) PHFetchResult *assetFetchResults;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIBarButtonItem *buttonItem;
@property (strong, nonatomic) Item *detailItemToDisplay;

@end

@implementation ShowAllItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Item *itemOne = [[Item alloc] init];
    Item *itemTwo = [[Item alloc] init];

    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    FIRDatabaseReference *itemsRef = [ref child:@"items"];
    [[itemsRef child:@"itemOne"] setValue:[itemOne formattedItem]];
    [[itemsRef child:@"itemTwo"] setValue:[itemTwo formattedItem]];
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.assetFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    itemOne.coordinate = CLLocationCoordinate2DMake(49.2820, -123.1171);
    itemTwo.coordinate = CLLocationCoordinate2DMake(49.520, -123.1171);
    //itemOne.image = [self.assetFetchResults lastObject];
    //itemTwo.image = [self.assetFetchResults lastObject];
    
    self.itemsToDisplay = [[NSMutableArray alloc] initWithObjects:itemOne, itemTwo, nil];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    
    [self configureMapView];
    
    self.buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map View" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMapView:)];
    self.navigationItem.rightBarButtonItem = self.buttonItem;
    //self.navigationController.navigationItem.rightBarButtonItem = buttonItem;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toDetailedItemSegue"]) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        ListItemDetailedViewController *controller = (ListItemDetailedViewController *)[segue destinationViewController];
        [controller setItem:self.detailItemToDisplay];
    }
}


#pragma mark - map view methods

- (void)configureMapView {
    
    //add to view but have it hidden first
    [self.view addSubview:self.mapView];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    //define constraints
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.mapView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.collectionView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.mapView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.collectionView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.mapView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.collectionView
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0
                                                                 constant:0.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.mapView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.collectionView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0.0];
    leading.active = YES;
    top.active = YES;
    width.active = YES;
    height.active = YES;
    [self.mapView addAnnotations:self.itemsToDisplay];
    self.mapView.delegate = self;
    self.mapView.hidden = YES;
    
}

- (void)toggleMapView:(id)sender {
    self.mapView.hidden = !self.mapView.hidden;
    self.buttonItem.title = (self.mapView.isHidden) ? @"Map View" : @"List View";
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    view.canShowCallout = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //[view addSubview:imageView];
    Item *annotation = (Item *)view;
    view.leftCalloutAccessoryView = imageView;
    imageView.image = annotation.image;
    
    CGRect frame = view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.frame = CGRectMake(-frame.size.width/2, -frame.size.height-7, frame.size.height, frame.size.height);
}

#pragma mark - collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Item *toDisplay = [self.itemsToDisplay objectAtIndex:indexPath.row];
    if (toDisplay) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus) {
            if (authorizationStatus == PHAuthorizationStatusAuthorized) {
                Item* item = [self.itemsToDisplay objectAtIndex:indexPath.row];
                cell.imageView.image = item.image;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                NSString *filePath = [documentsPath stringByAppendingPathComponent:toDisplay.photos[0]]; //Add the file name
                NSData *pngData = [NSData dataWithContentsOfFile:filePath];
                UIImage *image = [UIImage imageWithData:pngData];
                cell.imageView.image = image;//[UIImage imageWithContentsOfFile:toDisplay.photos[0]];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageView.layer.masksToBounds = YES;
                //
                PHAsset *asset = [self.assetFetchResults lastObject];
                //cell.backgroundColor = [UIColor clearColor];
                
                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                options.version = PHImageRequestOptionsVersionCurrent;
                options.synchronous = NO;
                
                CGFloat scale = MIN(2.0, [[UIScreen mainScreen] scale]);
                CGSize requestImageSize = CGSizeMake(CGRectGetWidth(cell.bounds) * scale, CGRectGetHeight(cell.bounds) * scale);
                [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                                  targetSize:requestImageSize
                                                                 contentMode:PHImageContentModeAspectFit
                                                                     options:options
                                                               resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                   item.image = result;
                                                                   cell.imageView.image = result;
                                                               }];
            }
        }];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.detailItemToDisplay = [self.itemsToDisplay objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toDetailedItemSegue" sender:self];
}

@end
