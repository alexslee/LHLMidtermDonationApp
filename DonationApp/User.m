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
        self.name = @"testUser";
        self.password = @"testPass";
        self.email = @"testMail";
        self.phoneNumber = @"testNum";
        self.listOfItems = [[NSMutableArray alloc] initWithArray:@[@"testitem1",@"testitem2"]];
    }
    return self;
}

- (NSDictionary *)formattedUser {
    return @{@"name":self.name,
             @"email":self.email,
             @"password":self.password,
             @"phoneNumber":self.phoneNumber,
             @"listofItems":self.listOfItems
             };
}

@end
