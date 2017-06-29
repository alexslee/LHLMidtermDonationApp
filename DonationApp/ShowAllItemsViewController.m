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
@property (strong, nonatomic) NSMutableDictionary *items;
@property (strong, nonatomic) PHFetchResult *assetFetchResults;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIBarButtonItem *buttonItem;
@property (strong, nonatomic) Item *detailItemToDisplay;
//@property (strong, nonatomic) NSMutableSet *categoriesList;

@end

@implementation ShowAllItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemsToDisplay = [[NSMutableArray alloc] init];
    self.items = [[NSMutableDictionary alloc] init];
    //self.categoriesList = [[NSMutableOrderedSet alloc] init];
    FIRDatabaseReference *rootReference = [FIRDatabase database].reference;
    FIRDatabaseReference *itemsReference = [rootReference child:@"items"];
    
    [itemsReference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *itemsDictionary = snapshot.value;
        for (NSString *key in itemsDictionary.allKeys) {
            
            NSDictionary *itemDict = [itemsDictionary objectForKey:key];
            Item *item = [[Item alloc] init];
            item.itemTitle = [itemDict objectForKey:@"title"];
            item.itemDescription = [itemDict objectForKey:@"itemDescription"];
            item.category = [itemDict objectForKey:@"category"];
            NSArray *photoURLs = [itemDict objectForKey:@"photos"];
            item.photosURL = [NSMutableArray arrayWithArray:photoURLs];
            NSNumber *latitude = [itemDict objectForKey:@"latitude"];
            NSNumber *longitude = [itemDict objectForKey:@"longitude"];
            item.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
            //if ([item.photosURL count] == 0) {
                [item.photos addObject:[UIImage imageNamed:@"placeholder"]];
                item.image = item.photos[0];
            //}
            
            item.userName = [itemDict objectForKey:@"name"];
            item.userPhoneNum = [itemDict objectForKey:@"phone"];
            item.userEmail = [itemDict objectForKey:@"email"];
            
            if ([self.items objectForKey:item.category] == nil) {
                //if the item's category doesn't exist yet, create a new key-value pair in the items dictionary to display
                [self.items setObject:[[NSMutableArray alloc] init] forKey:item.category];
            }
            
            [[self.items objectForKey:item.category] addObject:item];
            
            [self.itemsToDisplay addObject:item];
            [self.collectionView reloadData];
            [self downloadItemImages];
            [self configureMapView];
        }
    }];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    
    
    
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

- (void)downloadItemImages {
    
//    for (Item* item in self.itemsToDisplay) {
//        NSArray *photoURLs = item.photosURL;
//        if ([photoURLs count] > 0) {
//            [item.photos removeObjectAtIndex:0];
//            NSString *url = photoURLs[0];
//            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
//            [item.photos addObject:[UIImage imageWithData: imageData]];
//            item.image = item.photos[0];
//            [self.collectionView reloadData];
//        }
//    }
    
    //[self.collectionView reloadData];
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
    self.mapView.delegate = self;
    self.mapView.hidden = YES;
    if ([self.itemsToDisplay count] > 0) {
        [self.mapView addAnnotations:self.itemsToDisplay];
    }
    
}

- (void)toggleMapView:(id)sender {
    self.mapView.hidden = !self.mapView.hidden;
    self.buttonItem.title = (self.mapView.isHidden) ? @"Map View" : @"List View";
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    view.canShowCallout = YES;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    //[view addSubview:imageView];
//    
//    Item *annotation = view.annotation;
//    
//    view.leftCalloutAccessoryView = imageView;
//    imageView.image = annotation.image;
//
//    CGRect frame = view.frame;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.layer.masksToBounds = YES;
//    imageView.frame = CGRectMake(-frame.size.width/2, -frame.size.height-7, frame.size.height, frame.size.height);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    Item *itemAnnotation = (Item *)annotation;
    
    UIImage *image = itemAnnotation.image;
    CGSize size = CGSizeMake(50, 50);
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    MKAnnotationView *returner = [[MKAnnotationView alloc] init];
    returner.image = resizedImage;
    
    returner.contentMode = UIViewContentModeScaleAspectFit;
    
    return returner;
}

#pragma mark - Helper

- (void)downloadImage:(NSString *)imageURL
    completionHandler:(void (^)(UIImage * image))completionHandler
{
    NSURL *url = [NSURL URLWithString:imageURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage * photoImage = [UIImage imageWithData:data];
            completionHandler(photoImage);
        }];
        
    }];
    
    [downloadTask resume];
}

#pragma mark - collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.items allKeys] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *sectionName = [[self.items allKeys] objectAtIndex:section];
    return [[self.items objectForKey:sectionName] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusable = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.sectionLabel.text = [[self.items allKeys] objectAtIndex:indexPath.section];
        reusable = header;
    }
    return reusable;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListItemsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *sections = [self.items allKeys];
    NSString *section = [sections objectAtIndex:indexPath.section];
    Item *toDisplay = [[self.items objectForKey:section] objectAtIndex:indexPath.row];
    if (toDisplay) {
        cell.titleLabel.text = toDisplay.title;
        
        if (toDisplay.photosURL.count > 0)
        {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
            spinner.translatesAutoresizingMaskIntoConstraints = NO;
            spinner.color = [UIColor lightGrayColor];
            [spinner startAnimating];
            [cell.imageView addSubview:spinner];
            
            [NSLayoutConstraint constraintWithItem:spinner
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell.imageView
                                         attribute:NSLayoutAttributeCenterX
                                        multiplier:1
                                          constant:0].active = YES;
            
            [NSLayoutConstraint constraintWithItem:spinner
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell.imageView
                                         attribute:NSLayoutAttributeCenterY
                                        multiplier:1
                                          constant:0].active = YES;
            
            [self downloadImage:toDisplay.photosURL[0] completionHandler:^(UIImage *image) {
                cell.imageView.image = image;
                [spinner stopAnimating];
            }];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionName = [[self.items allKeys] objectAtIndex:indexPath.section];
    self.detailItemToDisplay = [[self.items objectForKey:sectionName] objectAtIndex:indexPath.row];
    
    NSArray *photoURLs = self.detailItemToDisplay.photosURL;
    if ([photoURLs count] > 0 && self.detailItemToDisplay.photos.count < self.detailItemToDisplay.photosURL.count) {
        [self.detailItemToDisplay.photos removeObjectAtIndex:0];
        for (NSString *url in photoURLs) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
            [self.detailItemToDisplay.photos addObject:[UIImage imageWithData: imageData]];
        }
    }

    
    [self performSegueWithIdentifier:@"toDetailedItemSegue" sender:self];
}

@end
