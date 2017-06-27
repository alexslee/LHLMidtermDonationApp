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

@interface ListItemsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemsList;
@property (nonatomic, strong) NSMutableArray *categoriesList;

@end

@implementation ListItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self generateDataSource];
}

- (void)generateDataSource
{
    Item *item1 = [[Item alloc] init];
    item1.title = @"Dinner table with 3 chairs";
    item1.itemDescription = @"In pretty good conditions, by i missed a chair";
    item1.category = @"Furniture";
    
    Item *item2 = [[Item alloc] init];
    item2.title = @"iPhone 4s";
    item2.itemDescription = @"Broken screen, no battery, no cables, button not working";
    item2.category = @"Electronic";
    
    Item *item3 = [[Item alloc] init];
    item3.title = @"A lot of baby girl clothes";
    item3.itemDescription = @"My kid grew up and they don't fit him anymore";
    item3.category = @"Clothing";
    
    Item *item4 = [[Item alloc] init];
    item4.title = @"Old television";
    item4.itemDescription = @"My grand-grandfather black and white tv can be useful for you";
    item4.category = @"Electronic";
    
    Item *item5 = [[Item alloc] init];
    item5.title = @"King bed with dirty mattress";
    item5.itemDescription = @"I am moving next week and need to get rid of it";
    item5.category = @"Furniture";
    
    Item *item6 = [[Item alloc] init];
    item6.title = @"Playstation 1";
    item6.itemDescription = @"Only works upside down";
    item6.category = @"Electronic";

    
    self.itemsList = [[NSMutableArray alloc] init];
    self.itemsList = [NSMutableArray arrayWithArray:@[item1, item2, item3, item4, item5, item6]];
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
        if(self.categoriesList[indexPath.section] == item.category)
        {
            [filteredItemsList addObject:item];
        }
    }
    
    // Get item object from the filtered list
    Item *currentItem = filteredItemsList[indexPath.row];
    
    ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"item-cell"];
    cell.itemImageView.image = [UIImage imageNamed:@"placeholder"];
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

@end
