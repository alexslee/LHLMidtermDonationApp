//
//  User.h
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface User : NSObject

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *phoneNumber;

@property (strong, nonatomic) NSMutableArray<Item *> *listOfItems;

- (NSDictionary *)formattedUser;

@end
