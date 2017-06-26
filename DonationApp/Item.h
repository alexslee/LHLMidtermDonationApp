//
//  Item.h
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"

@interface Item : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *itemDescription;

@property (strong, nonatomic) NSString *category;

@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) User *user;

- (NSDictionary *)formattedItem;

@end
