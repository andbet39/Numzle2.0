//
//  MatchCell.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "MatchCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MatchCell
@synthesize player1Label,player2Label,matchMessageLabel;
@synthesize cellMatch;
@synthesize searchingIndicator;
@synthesize avatarImageView;


-(id)init{
    if (self=[super init]) {
        
        
        //avatarImageView.image=nil;
        
         

        
    }
    
    
    return self;


}
-(void)prepareForReuse{

    [avatarImageView removeFromSuperview];
}
-(void)initWithMatch:(GKTurnBasedMatch *) match{
    
    avatarImageView =[[PFImageView alloc]initWithFrame:CGRectMake(6,6,37,37)];
            [self.contentView addSubview:avatarImageView];
    /*
    avatarImageView.layer.cornerRadius=15;
    avatarImageView.layer.masksToBounds=YES;
    avatarImageView.layer.borderWidth=2;
    avatarImageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    */

    [matchMessageLabel setFont:[UIFont fontWithName:@"Segoe Condensed" size:13]];

    
    cellMatch = match;
    
    
    GKTurnBasedParticipant * player1 = [match.participants objectAtIndex:0];
    GKTurnBasedParticipant * player2 = [match.participants objectAtIndex:1];
    
    NSString * toLoad=@"";
    NSString * cellText=@"";
    int meindex=-1;
    
    
    //I MATCH CHIUSI
    if (match.status==GKTurnBasedMatchStatusEnded){
        [self setForClosedMatch:cellMatch];
    }else{
    
    if (match.status!=GKTurnBasedMatchStatusMatching && match.status!=GKTurnBasedMatchStatusEnded) {
        //NSLog(match.matchID);
        [searchingIndicator stopAnimating];
        avatarImageView.hidden=false;
        searchingIndicator.hidden=true;

        
        if ([player1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            toLoad=player2.playerID;
            meindex=0;
            
        }else
        {
            toLoad=player1.playerID;
            meindex=1;

        }
        
        NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
        GKTurnBasedParticipant *nextParticipant;
        
        nextParticipant = [match.participants objectAtIndex:((currentIndex + 1) % [match.participants count ])];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm dd/MM/yyyy"];
        
        
        NSString *stringFromDate = [formatter stringFromDate:nextParticipant.lastTurnDate];
        
        [matchMessageLabel setText:[NSString stringWithFormat:@"Last turn %@",stringFromDate]];
        
        
        if (toLoad){
            
            [self displayPlayerAvatar:toLoad];

        [GKPlayer loadPlayersForIdentifiers:@[toLoad] withCompletionHandler:^(NSArray *players, NSError *error) {
            if (error != nil)
            {
                // Handle the error.
            }
            if (players != nil)
            {
               GKPlayer *p1 = [players objectAtIndex:0];
                    NSString * cellText =[NSString stringWithFormat:@"Playing with %@",p1.displayName];
                   // [player1Label setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
                    player1Label.text=cellText;
                
                //Se è un invito cambia il testo
                GKTurnBasedParticipant *me = [match.participants objectAtIndex:meindex];
               GKTurnBasedParticipant *other = [match.participants objectAtIndex:(meindex+1)%[match.participants count]];

                if (me.status == GKTurnBasedParticipantStatusInvited) {
                    NSString * cellText =[NSString stringWithFormat:@"Invited by %@",p1.displayName];
                    player1Label.text=cellText;
                }
               if (other!=nil) {
                
                    if (other.status == GKTurnBasedParticipantStatusInvited) {
                        NSString * cellText =[NSString stringWithFormat:@"Waiting %@ to accept",p1.displayName];
                        player1Label.text=cellText;
                    }
                }
               
            }
           
                
            
        }];
        }
        
    }else{
        avatarImageView.hidden=true;
        searchingIndicator.hidden=false;
        
        [searchingIndicator startAnimating];
        cellText=@"Waiting a player";
            
           // [player1Label setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
            player1Label.text=cellText;
            [matchMessageLabel setText:@"Waiting for opponent"];
        
    }
    }
    
    
}

   


-(void)setForClosedMatch:(GKTurnBasedMatch*)match{

   
    [searchingIndicator stopAnimating];
    avatarImageView.hidden=false;
    searchingIndicator.hidden=true;
    
    GKTurnBasedParticipant * player1 = [match.participants objectAtIndex:0];
    GKTurnBasedParticipant * player2 = [match.participants objectAtIndex:1];
    
    NSString * toLoad=@"";
    NSString * cellText=@"";
    int meindex=-1;
    
    
        if ([player1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            toLoad=player2.playerID;
            meindex=0;
            
        }else
        {
            toLoad=player1.playerID;
            meindex=1;
            
        }
    
        
        
        if (toLoad){
            
            [self displayPlayerAvatar:toLoad];
            [GKPlayer loadPlayersForIdentifiers:@[toLoad] withCompletionHandler:^(NSArray *players, NSError *error) {
                if (error != nil)
                {
                    // Handle the error.
                }
                if (players != nil)
                {
                    GKPlayer *p1 = [players objectAtIndex:0];
                    NSString * cellText =[NSString stringWithFormat:@"Game with %@",p1.displayName];
                  //  [player1Label setFont:[UIFont fontWithName:@"Segoe Condensed" size:18]];
                    player1Label.text=cellText;
                    
                    
                
            [match loadMatchDataWithCompletionHandler: ^(NSData *matchData, NSError *error) {
                if (matchData)
                {
                    NSString * cellText;
                    
                    MatchDataClass * receivedData = (MatchDataClass*)[NSKeyedUnarchiver unarchiveObjectWithData: matchData];
                    
                    GKTurnBasedParticipant *me = [match.participants objectAtIndex:meindex];
                    GKTurnBasedParticipant *other = [match.participants objectAtIndex:(meindex+1)%2];
                    
                    int punteggio1=0;
                    int punteggio2=0;
                    
                    
                    //Calcola punteggio player1
                    for (NSString * point in receivedData.p1Results) {
                        punteggio1+=[point intValue];
                    }
                    //Calcola punteggio player2
                    for (NSString * point in receivedData.p2Results) {
                        punteggio2+=[point intValue];
                    }
                    
                    if (me.matchOutcome==GKTurnBasedMatchOutcomeWon) {
                        cellText=[NSString stringWithFormat:@"You won this match %d-%d",punteggio1,punteggio2];
                    }else{
                        cellText=[NSString stringWithFormat:@"You lose this match %d-%d",punteggio1,punteggio2];
                    }
                    
                    if (me.status==GKTurnBasedParticipantStatusDeclined) {
                        cellText=@"You declined this match";
                    }
                    if (other.status==GKTurnBasedParticipantStatusDeclined) {
                        cellText=@"Match invitation declined";
                    }
                    
                    [matchMessageLabel setText:cellText];
                    
                    
                }
            }];
            
            
                }}];
        }
}




-(void)displayPlayerAvatar:(NSString*)playerID{

        
 
    PFQuery *PlayerQuery = [PFQuery queryWithClassName:@"PlayerAvatar"];
    [PlayerQuery whereKey:@"playerID" equalTo:playerID];
    
    PlayerQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    PlayerQuery.maxCacheAge = 60 * 60 * 24;
    [PlayerQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            [avatarImageView setImage:[UIImage imageNamed:@"standard"]];
        } else {
            
            
            PFQuery * avatarQuery = [PFQuery queryWithClassName:@"Avatar"];
            [avatarQuery whereKey:@"objectId" equalTo:[object objectForKey:@"avatarId"]]; 
            avatarQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
            avatarQuery.maxCacheAge = 60 * 60 * 24;
            
            [avatarQuery getFirstObjectInBackgroundWithBlock:^(PFObject *avatar, NSError *error) {
                
                if (!object) {
                    

                    NSLog(@"PORCO getFirstObject request failed.");
                } else {
                
                    PFFile * avatarImage = [avatar  objectForKey:@"image"];
                    
                    [avatarImageView setFile:avatarImage];
                    [avatarImageView loadInBackground];
               
            
                }
            }
    ];
    
    
}
    }];
           
    
     }

@end
