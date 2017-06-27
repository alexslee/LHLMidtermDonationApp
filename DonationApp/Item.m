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
        _title = _itemTitle =  @"test title";
        self.itemDescription = @"test item description";
        self.category = @"testCategory";
        self.photos = [[NSMutableArray alloc] initWithArray:@[@"iphone7plus-model-select-201703.png"]];//@[@"/private/var/mobile/Media/DCIM/iphone7plus-model-select-201703.png"]];
    }
    return self;
}

- (NSDictionary *)formattedItem {
    return @{
             @"title":self.title,
             @"itemDescription":self.itemDescription,
             @"category":self.category,
             @"photos":self.photos
             };
}

- (void)setItemTitle:(NSString *)itemTitle
{
    _title = _itemTitle = itemTitle;
}

@end
