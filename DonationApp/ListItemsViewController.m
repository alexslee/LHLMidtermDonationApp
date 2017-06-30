//
//  ListItemsViewController.m
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "ListItemsViewController.h"
#import "Item.h"
#import "ItemTableViewCell.h"
#import "AddItemViewController.h"
#import "AppDelegate.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseStorage/FirebaseStorage.h>

@interface ListItemsViewController () <UITableViewDelegate, UITableViewDataSource, AddItemViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemsList;
@property (nonatomic, strong) NSMutableArray *categoriesList;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic, strong) User *currentUser;

@end

@implementation ListItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [[User alloc] init];
    self.currentUser = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
    self.itemsList = self.currentUser.listOfItems;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.categoriesList = [[NSMutableArray alloc] init];
    for (Item *item in self.itemsList) {
        // array of subjects without duplicates
        if(![self.categoriesList containsObject:item.category])
            [self.categoriesList addObject:item.category];
        
    }
    return self.categoriesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfItems = 0;
    
    for (Item *item in self.itemsList) {
        if ([item.category isEqualToString:self.categoriesList[section]])
        {
            numberOfItems++;
        }
    }
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an array with items only from the current group/section
    NSMutableArray *filteredItemsList = [[NSMutableArray alloc] init];
    for (Item *item in self.itemsList) {
        if([self.categoriesList[indexPath.section] isEqualToString:item.category])
        {
            [filteredItemsList addObject:item];
        }
    }
    
    // Get item object from the filtered list
    Item *currentItem = filteredItemsList[indexPath.row];
    
    ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"item-cell"];
    
    if(currentItem.photos.count > 0)
    {
        cell.itemImageView.image = currentItem.photos[0];
    }
    else if (currentItem.photosURL.count >0)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        spinner.translatesAutoresizingMaskIntoConstraints = NO;
        spinner.color = [UIColor lightGrayColor];
        [spinner startAnimating];
        [cell.itemImageView addSubview:spinner];
        
        [NSLayoutConstraint constraintWithItem:spinner
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:cell.itemImageView
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0].active = YES;
        
        [NSLayoutConstraint constraintWithItem:spinner
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:cell.itemImageView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0].active = YES;
        
        
        [self downloadImage:currentItem.photosURL[0] completionHandler:^(UIImage *image) {
            cell.itemImageView.image = image;
            [spinner stopAnimating];
        }];
    }
    else
    {
        cell.itemImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    cell.titleLabel.text = currentItem.title;
    cell.descriptionTextView.text = currentItem.itemDescription;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.itemsList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.categoriesList[section];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add-new-item-segue"])
    {
        AddItemViewController *controller = (AddItemViewController *)segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - AddItemViewControllerDelegate

- (void)didSaveNewItem:(Item *)newItem
{
    self.ref = [FIRDatabase database].reference;
    
    //set item for currentuser
    FIRDatabaseReference *usersRef = [self.ref child:@"users"];
    NSLog(@"%@", usersRef.URL);
    FIRDatabaseReference *userRef = [usersRef child:self.currentUser.key];
    newItem.userEmail = self.currentUser.email;
    newItem.userName = self.currentUser.name;
    newItem.userPhoneNum = self.currentUser.phoneNumber;
    
    [self.currentUser.listOfItems addObject:newItem];
    [userRef setValue:[self.currentUser formattedUser]];
    
    //save item to firebase
    FIRDatabaseReference *itemsRef = [self.ref child:@"items"];
    FIRDatabaseReference *itemRef = [itemsRef childByAutoId];
    
    //storage images and set urls to download
    FIRStorageReference *storageRef = [[FIRStorage storage] reference];
    FIRStorageMetadata *metaData = [[FIRStorageMetadata alloc] init];
    metaData.contentType = @"image/png";
    
    for (int i = 0; i < newItem.photos.count; i++) {
        NSString *childKey = [NSString stringWithFormat:@"%@_%i", itemRef.key, i];
        FIRStorageReference *imagesRef = [storageRef child:childKey];
        NSData *photoData = UIImagePNGRepresentation([self reducePhotoSize:newItem.photos[i]]);
        [imagesRef putData:photoData
                  metadata:metaData
                completion:^(FIRStorageMetadata *metadata, NSError *error) {
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        Item *lastItem = self.currentUser.listOfItems[self.currentUser.listOfItems.count - 1];
                        [lastItem.photosURL addObject:metadata.downloadURL.absoluteString];

                        // Update data in items and user
                        [itemRef setValue:[lastItem formattedItem]];
                        [userRef setValue:[self.currentUser formattedUser]];
                    }
                }];
    }
    
    [self.tableView reloadData];
}

- (UIImage *)reducePhotoSize:(UIImage *)normalPhoto
{
    UIImage *reducedPhoto = nil;
    CGSize targetSize = CGSizeMake(normalPhoto.size.width*0.2, normalPhoto.size.height*0.2);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [normalPhoto drawInRect:thumbnailRect];
    
    reducedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reducedPhoto;
}

@end
