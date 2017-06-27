//
//  SelectCategoryViewController.h
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCategoryViewControllerDelegate

- (void)didSelectCategory:(NSString *)categoryName;

@end

@interface SelectCategoryViewController : UIViewController

@property (nonatomic, weak) id<SelectCategoryViewControllerDelegate> delegate;

@end
