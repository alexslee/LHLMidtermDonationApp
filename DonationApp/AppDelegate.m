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
#import "ListItemsViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure]; //initializing connection to Firebase
    self.currentUser = [[User alloc] init];
    
    // init - check if the app has a userkey to skip tutorial and login pages
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = nil;
    UIViewController *rootController;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey = [userDefaults objectForKey:@"UserKey"];
    if(userKey != nil)
    {
        self.currentUser.key = userKey;
        FIRDatabaseReference *rootReference = [FIRDatabase database].reference;
        FIRDatabaseReference *usersReference = [rootReference child:@"users"];
        FIRDatabaseReference *userReference = [usersReference child:userKey];
        [userReference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *userInfoDictionary = snapshot.value;
            
            //for (NSString *key in userInfoDictionary) {
                //NSDictionary *user = [usersDictionary objectForKey:key];
                self.currentUser.name = [userInfoDictionary objectForKey:@"name"];
                self.currentUser.phoneNumber = [userInfoDictionary objectForKey:@"phoneNumber"];
                self.currentUser.email = [userInfoDictionary objectForKey:@"email"];
                NSArray *userItems = [userInfoDictionary objectForKey:@"listofItems"];
                NSMutableArray *itemsForUser = [[NSMutableArray alloc] init];
                for (NSDictionary *userItem in userItems) {
                    Item *item = [[Item alloc] init];
                    item.category = [userItem objectForKey:@"category"];
                    item.itemDescription = [userItem objectForKey:@"itemDescription"];
                    item.itemTitle = [userItem objectForKey:@"title"];
                    NSNumber *latitude = [userItem objectForKey:@"latitude"];
                    NSNumber *longitude = [userItem objectForKey:@"longitude"];
                    item.location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
                    item.userName = [userItem objectForKey:@"name"];
                    item.userEmail = [userItem objectForKey:@"email"];
                    item.userPhoneNum = [userItem objectForKey:@"phone"];
                    NSArray *photos = [userItem objectForKey:@"photos"];
                    item.photosURL = [NSMutableArray arrayWithArray:photos];
                    [itemsForUser addObject:item];
                }
                
                self.currentUser.listOfItems = [NSMutableArray arrayWithArray:itemsForUser];
                
            //}
            
        }];
        
        //TODO - get user from firebase
        
        mainStoryboard = [UIStoryboard storyboardWithName:@"UserItems" bundle:nil];
    }
    else
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"WelcomeScreens" bundle:nil];
    }
    
    rootController = [mainStoryboard instantiateInitialViewController];
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];

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
