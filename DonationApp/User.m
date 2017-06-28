//
//  User.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init {
    self = [super init];
    if (self) {
        self.listOfItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDictionary *)formattedUser {
    NSDictionary *returnDict =
            @{@"name":self.name,
             @"email":self.email,
             @"phoneNumber":self.phoneNumber,
             @"listofItems":[self formatArrayOfItens]
             };
    return returnDict;
}

- (NSMutableArray *)formatArrayOfItens
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.listOfItems.count; i++) {
        [returnArray addObject:[self.listOfItems[i] formattedItem]];
    }
    
    return returnArray;
}

@end
