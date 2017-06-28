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
    }
    return self;
}

- (NSDictionary *)formattedItem {
    NSDictionary *returnDict = @{
             @"title":self.title,
             @"itemDescription":self.itemDescription,
             @"category":self.category,
             @"photos":self.photosURL
             };
    return returnDict;
}

- (void)setItemTitle:(NSString *)itemTitle
{
    _title = _itemTitle = itemTitle;
}

@end
