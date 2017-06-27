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

@property (strong, nonatomic)FIRDatabaseReference *ref;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.ref = [FIRDatabase database].reference;
    User *testUser = [[User alloc] init];
    [self addUserToFirebase:testUser];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addUserToFirebase:(User *)user {
    FIRDatabaseReference *childRef = [[self.ref child:@"users"] child:user.email];
    [childRef setValue:[user formattedUser]];
}

@end
