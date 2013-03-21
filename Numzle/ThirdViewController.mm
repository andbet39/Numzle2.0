//
//  ThirdViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 23/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.helplabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:16]];


    UIImage * navigationBarImage =[UIImage imageNamed:@"tutorialNavBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"tutorialNavBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
}

-(void)viewDidAppear:(BOOL)animated{

    UIImage * navigationBarImage =[UIImage imageNamed:@"tutorialNavBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
}
- (void)viewDidUnload {
    [self setHelplabel:nil];
    [super viewDidUnload];
}
@end
