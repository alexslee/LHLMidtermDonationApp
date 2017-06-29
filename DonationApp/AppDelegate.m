//
//  AppDelegate.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "AppDelegate.h"
@import Firebase;
#import <FirebaseDatabase/FirebaseDatabase.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure]; //initializing connection to Firebase
    
    // should get that from firebase after login. harcoded for now
    self.currentUser = [[User alloc] init];
    self.currentUser.key = @"-KngmyMc4ElruRjBqyRk";
    self.currentUser.name = @"John Doe";
    self.currentUser.email = @"johndoe@lighthouselabs.ca";
    self.currentUser.phoneNumber = @"604-100-1234";
    
//    Item *item1 = [[Item alloc] init];
//    item1.itemTitle = @"Dinner table with 3 chairs";
//    item1.itemDescription = @"In pretty good conditions, by i missed a chair";
//    item1.category = @"Furniture";
//    
//    Item *item2 = [[Item alloc] init];
//    item2.itemTitle = @"iPhone 4s";
//    item2.itemDescription = @"Broken screen, no battery, no cables, button not working";
//    item2.category = @"Electronic";
//    
//    Item *item3 = [[Item alloc] init];
//    item3.itemTitle = @"A lot of baby girl clothes";
//    item3.itemDescription = @"My kid grew up and they don't fit him anymore";
//    item3.category = @"Clothing";
//    
//    Item *item4 = [[Item alloc] init];
//    item4.itemTitle = @"Old television";
//    item4.itemDescription = @"My grand-grandfather black and white tv can be useful for you";
//    item4.category = @"Electronic";
//    
//    Item *item5 = [[Item alloc] init];
//    item5.itemTitle = @"King bed with dirty mattress";
//    item5.itemDescription = @"I am moving next week and need to get rid of it";
//    item5.category = @"Furniture";
//    
//    Item *item6 = [[Item alloc] init];
//    item6.itemTitle = @"Playstation 1";
//    item6.itemDescription = @"Only works upside down";
//    item6.category = @"Electronic";
    
//    self.currentUser.listOfItems = [[NSMutableArray alloc] init];
//    self.currentUser.listOfItems = [NSMutableArray arrayWithArray:@[item1, item2, item3, item4, item5, item6]];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


@end
