//
//  AppDelegate.h
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Item.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) User *currentUser;

@end

