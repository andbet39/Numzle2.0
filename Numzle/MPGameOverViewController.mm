//
//  MPGameOverViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "MPGameOverViewController.h"
#import "OperationCell.h"
#import "GameCenterHelper.h"
#import "ParseHelper.h"

@interface MPGameOverViewController ()
{
    GameManager * gm;
}
@end

@implementation MPGameOverViewController
@synthesize operationCountLabel,punteggioLabel,numberToHitLabel;
@synthesize delegate,playerNum;
@synthesize navigationBar;
@synthesize numberLabel,totalPointLabel;

-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarWithTitle"];
    [navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
   // [numberLabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
    //[totalPointLabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
    //[punteggioLabel setFont:[UIFont fontWithName:@"Segoe Semibold" size:20]];
    //[operationCountLabel setFont:[UIFont fontWithName:@"Segoe Semibold" size:20]];

    
    
    //NAsconde il bannerview
    //bannerView.frame = CGRectOffset(bannerView.frame, 0, -bannerView.frame.size.height);
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeInterface];
    gm = [GameManager sharedInstance];
    
    [punteggioLabel setText:[NSString stringWithFormat:@"%d",[gm getGrandTotal]]];
    
    
  
    
    
    [operationCountLabel setText:[NSString stringWithFormat:@"%d",[gm getOperationNumber]]];
    
    [numberToHitLabel setText:[gm.numberToHit stringValue]];
    
    MatchDataClass * currentMatchData = [GameManager sharedInstance].currentMathData ;
    
    int turnNumber = [currentMatchData.turnNumber intValue];

    if ([[GKLocalPlayer localPlayer].playerID isEqualToString: currentMatchData.p1ID]) {
        [currentMatchData.p1Results addObject:[NSString stringWithFormat:@"%d",[gm getGrandTotal]]];
        //[GameCenterHelper sharedInstance].currentMatch.message=[NSString stringWithFormat:@"Player 1 ha fatto : %d punti",[gm getGrandTotal]];
        
    }
    
    if ([[GKLocalPlayer localPlayer].playerID isEqualToString: currentMatchData.p2ID]) {
        [currentMatchData.p2Results addObject:[NSString stringWithFormat:@"%d",[gm getGrandTotal]]];
       // [GameCenterHelper sharedInstance].currentMatch.message=[NSString stringWithFormat:@"Player 2 ha fatto : %d punti",[gm getGrandTotal]];
        
    }
    
     turnNumber++;
    currentMatchData.turnNumber = [NSNumber numberWithInt:turnNumber];
        
 

    [[GameCenterHelper sharedInstance]reportScore:[gm getGrandTotal] forLeaderboardID:kMultiplayerLeaderBoard];
        
    
    
    
    if ([currentMatchData.p2Results count]>=NUMBER_OF_TURN && [currentMatchData.p1Results count]>=NUMBER_OF_TURN){
    
        [self endCurrentGame:currentMatchData];
        
    
    }else{
        
       
        for (GKTurnBasedParticipant *participant in [GameManager sharedInstance].currentMatch.participants)
            
            if (participant.matchOutcome==GKTurnBasedMatchOutcomeQuit) {
                NSLog(@"The other player quitted the match");
                if (participant.playerID == currentMatchData.p1ID) {
                    [currentMatchData.p1Results removeAllObjects];
                }
                if (participant.playerID == currentMatchData.p2ID) {
                    [currentMatchData.p2Results removeAllObjects];
                }
                [self endCurrentGame:currentMatchData];
                
            
            }
        
        }
    
        [self sendNextTurn:currentMatchData];
    }
    


-(void)endCurrentGame:(MatchDataClass*)data{

    int punteggio1=0;
    int punteggio2=0;
    
    
    //Calcola punteggio player1
    for (NSString * point in data.p1Results) {
        punteggio1+=[point intValue];
    }
    //Calcola punteggio player2
    for (NSString * point in data.p2Results) {
        punteggio2+=[point intValue];
    }
    
    //Calcola il player che ha vinto
    int playerWinner=0;
    if (punteggio1>punteggio2) {
        playerWinner=1;
    }
    if (punteggio1<punteggio2) {
        playerWinner=2;
    }
    
    if (playerWinner==0) {//Pareggio
        playerWinner=1;//na porcata
        
    }
    
    
    
    if (playerWinner==1) {//Ha vinto il player 1
        
        for (GKTurnBasedParticipant * player in [GameManager sharedInstance].currentMatch.participants) {
            if ([player.playerID isEqualToString:data.p1ID]) {
                player.matchOutcome=GKTurnBasedMatchOutcomeWon;
                
                
                
            }else{
                player.matchOutcome=GKTurnBasedMatchOutcomeLost;
                [[ParseHelper sharedInstance]TryPostWinStoryOnFBVSPlayerID:player.playerID];
                
            }
        }
        
    }
    
    if (playerWinner==2) {//Ha vinto il player 1
        
        for (GKTurnBasedParticipant * player in [GameManager sharedInstance].currentMatch.participants) {
            if ([player.playerID isEqualToString:data.p2ID]) {
                player.matchOutcome=GKTurnBasedMatchOutcomeWon;
            }else{
                player.matchOutcome=GKTurnBasedMatchOutcomeLost;
                [[ParseHelper sharedInstance]TryPostWinStoryOnFBVSPlayerID:player.playerID];

            }
        }
        
    }
    
    /*//Se sono il player 1 invia il punteggio1
    if ([[GKLocalPlayer localPlayer].playerID isEqualToString:data.p1ID]) {
        [[GameCenterHelper sharedInstance]reportScore:punteggio1 forLeaderboardID:kMultiplayerLeaderBoard];

    }
    //Se sono il player 2 invia il punteggio2

    if ([[GKLocalPlayer localPlayer].playerID isEqualToString:data.p2ID]) {
        [[GameCenterHelper sharedInstance]reportScore:punteggio2 forLeaderboardID:kMultiplayerLeaderBoard];
        
    }*/
    
    

    [[GameCenterHelper sharedInstance]sendEndGame:data forMatch:gm.currentMatch];
    
    

}



-(void)sendNextTurn:(MatchDataClass*)data{

    
    [[GameCenterHelper sharedInstance]sendEndTurn:data forMatch:gm.currentMatch];
    

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
    
    [cell initStyle];
    
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




- (IBAction)endTurn:(id)sender {
    
    
    [delegate MPGameOverViewControllerDidEndGame:self];
   
    
}
@end
