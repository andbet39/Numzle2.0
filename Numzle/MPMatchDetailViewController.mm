//
//  MPMatchDetailViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "MPMatchDetailViewController.h"
#import "GameManager.h"
#import "CCViewController.h"
#import "GAI.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface MPMatchDetailViewController ()
{
    
}
@end

@implementation MPMatchDetailViewController

@synthesize selectedMatch;
@synthesize player1Label,player2Label;
@synthesize playButton,leaveButton,leaveNotInTurnButton;
@synthesize T1P1Label,T2P1Label,T3P1Label;
@synthesize T1P2Label,T2P2Label,T3P2Label;
@synthesize turn1Label,turn2Label,turn3Label;
@synthesize currentMatchData;
@synthesize winLostLabel;
@synthesize acceptButton;
@synthesize declineButton;
@synthesize backButton;
@synthesize imageView1,imageView2;
@synthesize p1TotalLabel,p2TotalLabel;

-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarWithTitle"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 68, 32);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
   
    
      imageView1= [[PFImageView alloc]initWithFrame:CGRectMake(35, 110, 50, 50)];
    [self.view addSubview:imageView1];
    
     imageView2= [[PFImageView alloc]initWithFrame:CGRectMake(230,110, 50, 50)];

    [self.view addSubview:imageView2];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"MatchDetail Screen"];
    
    [self customizeInterface];
    
    playButton.enabled=false;
    leaveNotInTurnButton.enabled=false;
    leaveButton.enabled=false;
    
    [self initWithSelectedMach];
    [self loadAndDisplayMatchData];
    
    

}



-(void)initWithSelectedMach{

    [[GameManager sharedInstance]setCurrentMatch:selectedMatch];


    GKTurnBasedParticipant * player1 = [selectedMatch.participants objectAtIndex:0];
    GKTurnBasedParticipant * player2 = [selectedMatch.participants objectAtIndex:1];
    NSArray *identifiers;
    
    if (player1.matchOutcome==GKTurnBasedMatchOutcomeWon && [player1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
        
        [winLostLabel setText:@"YOU WIN!"];
        //[winLostLabel setTextColor:RGB(78, 195, 95)];
        
    }
    if (player2.matchOutcome==GKTurnBasedMatchOutcomeWon && [player2.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
        
        [winLostLabel setText:@"YOU WIN!"];
      //  [winLostLabel setTextColor:RGB(78, 195, 95)];

    }
    
    if (player2.matchOutcome==GKTurnBasedMatchOutcomeLost && [player2.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
        
        [winLostLabel setText:@"YOU LOSE!"];
        //[winLostLabel setTextColor:RGB(254, 142, 92)];
    }
    
    if (player1.matchOutcome==GKTurnBasedMatchOutcomeLost && [player1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
        
        [winLostLabel setText:@"YOU LOSE!"];
     //   [winLostLabel setTextColor:RGB(254, 142, 92)];

        
    }
    

    
   if ([selectedMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
       
       leaveButton.hidden=false;
       acceptButton.hidden=true;
       declineButton.hidden=true;
       backButton.hidden=true;
       leaveNotInTurnButton.hidden=true;
       
       
       [playButton setImage:[UIImage imageNamed:@"matchplayButton"] forState:UIControlStateNormal];
       [leaveButton setImage:[UIImage imageNamed:@"leaveButton"] forState:UIControlStateNormal];
       
   }else{
       acceptButton.hidden=true;
       declineButton.hidden=true;

       [playButton setImage:[UIImage imageNamed:@"waitButton"] forState:UIControlStateNormal];
       [playButton setEnabled:FALSE];
       leaveButton.hidden=true;
       
       leaveNotInTurnButton.hidden=false;
       [leaveButton setEnabled:FALSE];
       backButton.hidden=true;

   }
    
    
    if (selectedMatch.currentParticipant.status==GKTurnBasedParticipantStatusInvited &&[selectedMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        
        leaveButton.hidden=true;
        playButton.hidden=true;
        declineButton.hidden=false;
        acceptButton.hidden=false;
        
        backButton.hidden=true;
        leaveNotInTurnButton.hidden=true;

    }
    
    if (selectedMatch.status==GKTurnBasedMatchStatusEnded) {
        leaveButton.hidden=true;
        playButton.hidden=true;
        declineButton.hidden=true;
        acceptButton.hidden=true;
        backButton.hidden=false;
        leaveNotInTurnButton.hidden=true;
    }
    
    if (player2.playerID && player1.playerID) {
        identifiers = @[player1.playerID,player2.playerID];
        
    }else{
        
        if (player1.playerID==NULL) {
            identifiers = @[player2.playerID];
            
        }else
        {
            identifiers = @[player1.playerID];
            
        }
    }
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        if (players != nil && [players count]>0)
        {
            if ([players count]==2) {
                GKPlayer *p1 = [players objectAtIndex:0];
                GKPlayer *p2 = [players objectAtIndex:1];
                
                player1Label.text =p1.displayName;
                player2Label.text =p2.displayName;
            }else
            {
                
                GKPlayer *p1 = [players objectAtIndex:0];
                
                
                player1Label.text =p1.displayName;
                
            }
            
        }
    }];
    player1Label.text =player1.playerID;
    player2Label.text =player2.playerID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadAndDisplayMatchData
{
    
        [selectedMatch loadMatchDataWithCompletionHandler: ^(NSData *matchData, NSError *error) {
            if (matchData)
            {
                
                
               MatchDataClass * receivedData = (MatchDataClass*)[NSKeyedUnarchiver unarchiveObjectWithData: matchData];
                
                currentMatchData =receivedData;
                
                if ([currentMatchData.p1Results count]>0) {
                    T1P1Label.text = [currentMatchData.p1Results objectAtIndex:0];
                }
                if ([currentMatchData.p1Results count]>1) {
                    T2P1Label.text = [currentMatchData.p1Results objectAtIndex:1];
                }
                if ([currentMatchData.p1Results count]>2) {
                    T3P1Label.text = [currentMatchData.p1Results objectAtIndex:2];
                }
                
                if ([currentMatchData.p2Results count]>0) {
                    T1P2Label.text = [currentMatchData.p2Results objectAtIndex:0];
                }
                if ([currentMatchData.p2Results count]>1) {
                    T2P2Label.text = [currentMatchData.p2Results objectAtIndex:1];
                }
                if ([currentMatchData.p2Results count]>2) {
                    T3P2Label.text = [currentMatchData.p2Results objectAtIndex:2];
                }
                
                
                int punteggio1=0;
                int punteggio2=0;
                //Calcola punteggio player1
                for (NSString * point in currentMatchData.p1Results) {
                    punteggio1+=[point intValue];
                }
                //Calcola punteggio player2
                for (NSString * point in currentMatchData.p2Results) {
                    punteggio2+=[point intValue];
                }
                
                [p1TotalLabel setText:[NSString stringWithFormat:@"%d",punteggio1]];
                [p2TotalLabel setText:[NSString stringWithFormat:@"%d",punteggio2]];
                
                if([selectedMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID])
                    playButton.enabled=true;
                
                
                leaveNotInTurnButton.enabled=true;
                leaveButton.enabled=true;
                
                //Risolve un crash
                if (currentMatchData.p1ID) {

                    if (![currentMatchData.p1ID isEqualToString:@""]) {
                        [self displayPlayerAvatar:currentMatchData.p1ID onPFImage:imageView1];
                    }
                }
                if (currentMatchData.p2ID) {

                if (![currentMatchData.p2ID isEqualToString:@""]) {
                    [self displayPlayerAvatar:currentMatchData.p2ID onPFImage:imageView2];
                    

                }
                }
                
            }
        }];
    
    
  
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"startGame"]) {
        CCViewController * destination = segue.destinationViewController;
        [destination setGameOverDelegate:self];
        
    }
    
}

- (IBAction)playButton:(id)sender {
    
    int turnNumber = -1;
    
    [[GameManager sharedInstance] setCurrentMathData:currentMatchData];
    [[GameManager sharedInstance] setCurrentMatch:selectedMatch];
	
    
    
    if([selectedMatch.currentParticipant.playerID isEqualToString:currentMatchData.p1ID]){
    
        turnNumber=[currentMatchData.p1Results count]+1;
    }
    if([selectedMatch.currentParticipant.playerID isEqualToString:currentMatchData.p2ID]){
        
        turnNumber=[currentMatchData.p2Results count]+1;
    }

    
    [GameManager sharedInstance].numberToHit =  [currentMatchData.numbersToHit objectAtIndex:turnNumber];
    
    [self performSegueWithIdentifier:@"startGame" sender:self];

}



-(void)CCViewControllerDidEndGame:(CCViewController *)sender{
    
    
    [sender dismissViewControllerAnimated:FALSE completion:^{
        
     
    }];
    
    [self initWithSelectedMach];
    [self loadAndDisplayMatchData];
    
    
}

     
-(void)displayPlayerAvatar:(NSString*)playerID onPFImage:(PFImageView*)imageView{
         
         PFQuery *PlayerQuery = [PFQuery queryWithClassName:@"PlayerAvatar"];
         [PlayerQuery whereKey:@"playerID" equalTo:playerID];
    
    if ([playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        PlayerQuery.cachePolicy = kPFCachePolicyNetworkElseCache;

    }else{
         PlayerQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    }
         PlayerQuery.maxCacheAge = 60 * 60 * 24;
         [PlayerQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
             
             if (!object) {
                 [imageView setImage:[UIImage imageNamed:@"standard"]];

                 NSLog(@"The getFirstObject request failed.");
             } else {
                 
                 
                 PFQuery * avatarQuery = [PFQuery queryWithClassName:@"Avatar"];
                 [avatarQuery whereKey:@"objectId" equalTo:[object objectForKey:@"avatarId"]];
                 avatarQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
                 avatarQuery.maxCacheAge = 60 * 60 * 24;
                 
                 [avatarQuery getFirstObjectInBackgroundWithBlock:^(PFObject *avatar, NSError *error) {
                     
                     if (!object) {
                         NSLog(@"The getFirstObject request failed.");
                     } else {
                         
                         PFFile * avatarImage = [avatar  objectForKey:@"image"];
                         
                         [imageView setFile:avatarImage];
                         [imageView loadInBackground];
                         
                         
                     }
                 }
                  ];
                 
                 
             }
         }];
     }


//Abbandona il giogo... perde automaticamente
- (IBAction)leaveButton:(id)sender {
    
    
    [[GameCenterHelper sharedInstance]leaveMatch:selectedMatch andData:currentMatchData];
    [self.navigationController popViewControllerAnimated:YES];
    

}
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptButtonAction:(id)sender {
    
    
    
    int turnNumber = [currentMatchData.turnNumber intValue]+1;
    
    
    if([selectedMatch.currentParticipant.playerID isEqualToString:currentMatchData.p1ID]){
        
        turnNumber=[currentMatchData.p1Results count]+1;
    }
    if([selectedMatch.currentParticipant.playerID isEqualToString:currentMatchData.p2ID]){
        
        turnNumber=[currentMatchData.p2Results count]+1;
    }
    
    //Aggiusta i data per adattare ad invito
    currentMatchData.turnNumber=[NSNumber numberWithInt:turnNumber];
    
    //questo vale solo per i match con invito
    if ([currentMatchData.p2ID isEqualToString:@""]) {
        currentMatchData.p2ID=[GKLocalPlayer localPlayer].playerID;
    }
    currentMatchData.matchfFase=@"CANSTART";

    [[GameManager sharedInstance] setCurrentMathData:currentMatchData];
    [[GameManager sharedInstance] setCurrentMatch:selectedMatch];
	
    
    
    [GameManager sharedInstance].numberToHit =  [currentMatchData.numbersToHit objectAtIndex:turnNumber];
    
    [self performSegueWithIdentifier:@"startGame" sender:self];
    
    
}
- (IBAction)declineButtonAction:(id)sender {
    
    
    if ([currentMatchData.p2ID isEqualToString:@""]) {
        currentMatchData.p2ID=[GKLocalPlayer localPlayer].playerID;
    }
    
    [selectedMatch declineInviteWithCompletionHandler:^(NSError *error) {
        
    }];
    
    
    
    
    
}

- (IBAction)leaveNotInTurnButtonAction:(id)sender {
    
    [[GameCenterHelper sharedInstance]quitMatchNotInTurn:selectedMatch andData:currentMatchData];
     
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setLeaveNotInTurnButton:nil];
    [super viewDidUnload];
}
@end
