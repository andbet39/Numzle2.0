//
//  GameOverViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "GameOverViewController.h"
#import "GameCenterHelper.h"

@interface GameOverViewController ()
{

    GameManager * gm;

}

@end

@implementation GameOverViewController

@synthesize operationCountLabel,punteggioLabel,numberToHitLabel;
@synthesize delegate;
@synthesize navigationBar;
@synthesize numberLabel,totalPointLabel;


-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarWithTitle"];
    [navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    //[numberLabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
    
    
    //[totalPointLabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
    //[punteggioLabel setFont:[UIFont fontWithName:@"Segoe Semibold" size:20]];
    //[operationCountLabel setFont:[UIFont fontWithName:@"Segoe Semibold" size:20]];
    
    //NAsconde il bannerview
    //bannerView.frame = CGRectOffset(bannerView.frame, 0, -bannerView.frame.size.height);
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    gm = [GameManager sharedInstance];
    
    [self customizeInterface];
    [punteggioLabel setText:[NSString stringWithFormat:@"%d",[gm getGrandTotal]]];
    
    [operationCountLabel setText:[NSString stringWithFormat:@"%d",[gm getOperationNumber]]];

    [numberToHitLabel setText:[gm.numberToHit stringValue]];
    
    
    [[GameCenterHelper sharedInstance]reportScore:[gm getGrandTotal] forLeaderboardID:kSoloPlayerLeaderBoard];


}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [gm getOperationNumber];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OperationCell";
    
    OperationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSNumber * result = [gm.results objectAtIndex:indexPath.row];
    [cell.punteggioLabel setText:[result stringValue]];
    [cell.operationLabel setText:[gm.operations objectAtIndex:indexPath.row]];
    
    
    if ([self tableView:nil numberOfRowsInSection:indexPath.section]==indexPath.row+1) {
        [cell.imageBackground setImage:[UIImage imageNamed:@"backgroundCellInferiore"]];
    }else{
        
        if (indexPath.row==0) {
            [cell.imageBackground setImage:[UIImage imageNamed:@"backgroundCellSuperiore"]];
        }else
        {
            [cell.imageBackground setImage:[UIImage imageNamed:@"tableCellBackground"]];
            
        }
    }

    
    return cell;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButton:(id)sender {
    [delegate GameOverViewControllerDidEndGame:self];

}
- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setTotalPointLabel:nil];
    [self setNumberLabel:nil];
    [super viewDidUnload];
}
@end
