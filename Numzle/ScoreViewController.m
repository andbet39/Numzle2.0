//
//  ScoreViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 10/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ScoreViewController.h"



@interface ScoreViewController ()


@property(nonatomic,strong) MatchDataClass * testData ;

@end

@implementation ScoreViewController

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

    self.testData = [[MatchDataClass alloc]init];
    
    self.testData.p1ID=[GKLocalPlayer localPlayer].playerID;
    self.testData.p2ID=@"g:000000000";
    
    
    [self.testData.p1Results addObjectsFromArray :@[@"1000",@"1000",@"10000"] ];
    [self.testData.p2Results addObjectsFromArray: @[@"2000",@"2000",@"3000"]];
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)JobsAchievementAction:(id)sender {
    
    [[AchievementHelper sharedInstance] checkForJobsAchievementInMatch:self.testData andPresenterViewController:self];
    
 
}

- (IBAction)resetAction:(id)sender {
    
    [[AchievementHelper sharedInstance]resetAchievements];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
