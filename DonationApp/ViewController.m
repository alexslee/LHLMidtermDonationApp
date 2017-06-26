//
//  ViewController.m
//  DonationApp
//
//  Created by Alex Lee on 2017-06-26.
//  Copyright © 2017 Alex Lee. All rights reserved.
//
#import "User.h"
#import "ViewController.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FIRDatabaseReference *ref = [FIRDatabase database].reference;
    User *testUser = [[User alloc] init];
    [[ref child:@"users"] setValue:[testUser formattedUser]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
