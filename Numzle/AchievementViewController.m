//
//  AchievementViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 27/03/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "AchievementViewController.h"

@interface AchievementViewController ()

@end

@implementation AchievementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonAction:(id)sender {


    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}
@end
