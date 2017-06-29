//
//  Item.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)init {
    self = [super init];
    if (self) {
        self.photos = [[NSMutableArray alloc] init];
        self.photosURL = [[NSMutableArray alloc] init];
        _title =  @"test title";
        _itemTitle = @"test title";
        self.itemDescription = @"test item description";
        self.category = @"testCategory";
        //self.photos = [[NSMutableArray alloc] initWithArray:@[@"iphone7plus-model-select-201703.png"]];//@[@"/private/var/mobile/Media/DCIM/iphone7plus-model-select-201703.png"]];
    }
    return self;
}

- (NSDictionary *)formattedItem {
    NSDictionary *returnDict = @{
             @"title":self.title,
             @"itemDescription":self.itemDescription,
             @"category":self.category,
             @"photos":self.photosURL,
             @"latitude":[NSNumber numberWithDouble: self.location.coordinate.latitude],
             @"longitude":[NSNumber numberWithDouble: self.location.coordinate.longitude],
             @"name":self.userName,
             @"email":self.userEmail,
             @"phone":self.userPhoneNum
             };
    return returnDict;
}

- (void)setItemTitle:(NSString *)itemTitle
{
    _title = itemTitle;
    _itemTitle = itemTitle;
}

- (void)setLocation:(CLLocation *)location
{
    _location = location;
    _coordinate = location.coordinate;
}

@end
