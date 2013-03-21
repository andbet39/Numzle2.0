//
//  SecondViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 23/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.Helplabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:16]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    UIImage * navigationBarImage =[UIImage imageNamed:@"tutorialNavBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];}
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
