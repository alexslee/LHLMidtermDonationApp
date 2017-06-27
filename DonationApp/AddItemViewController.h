//
//  AddItemViewController.h
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol AddItemViewControllerDelegate

- (void)didSaveNewItem:(Item *)newItem;

@end

@interface AddItemViewController : UIViewController

@property (nonatomic, strong) id<AddItemViewControllerDelegate> delegate;

@end
