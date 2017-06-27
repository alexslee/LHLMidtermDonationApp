//
//  SelectCategoryViewController.m
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "SelectCategoryViewController.h"

@interface SelectCategoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categoriesList;

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.categoriesList = [[NSArray alloc] init];
    self.categoriesList = @[@"Clothing", @"Electronic", @"Food", @"Furniture", @"Money", @"Pet", @"Other..."];
}

#pragma mark - TableView datasource/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoriesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category-cell"];
    cell.textLabel.text = self.categoriesList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectCategory:self.categoriesList[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
