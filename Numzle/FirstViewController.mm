//
//  FirstViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 23/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
@end
