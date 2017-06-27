//
//  Item.h
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"

@interface Item : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, copy) NSString *itemTitle;

@property (strong, nonatomic) UIImage *image;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) NSString *itemDescription;

@property (strong, nonatomic) NSString *category;

@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) User *user;

- (NSDictionary *)formattedItem;

@end
