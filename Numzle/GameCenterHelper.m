//
//  GameCenterHelper.m
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "GameCenterHelper.h"
#import "AchievementHelper.h"



@implementation GameCenterHelper


@synthesize gameCenterAvailable;
@synthesize currentPlayerID,gameCenterAuthenticationComplete;

@synthesize interfaceDelegate;

@synthesize myTurnMatchArray,OthermatchsArray,ClosedMatchArray,MatchingMatchArray;



#pragma mark Initialization

static GameCenterHelper *sharedHelper = nil;
+ (GameCenterHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GameCenterHelper alloc] init];
    }
    return sharedHelper;
}



BOOL isGameCenterAPIAvailable()
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


- (id)init {
    if ((self = [super init])) {
       
        
        myTurnMatchArray =[[NSMutableArray alloc]init];
        OthermatchsArray =[[NSMutableArray alloc]init];
        ClosedMatchArray= [[NSMutableArray alloc]init];
        MatchingMatchArray= [[NSMutableArray alloc]init];
    
    }
    return self;
    
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&
        !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated &&
               userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

#pragma mark User functions

- (void)authenticateLocalUser {
    
    if (!isGameCenterAPIAvailable()) {
        // Game Center is not available.
        self.gameCenterAuthenticationComplete = NO;
    } else {
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            // If there is an error, do not assume local player is not authenticated.
            if (localPlayer.isAuthenticated) {
                
                // Enable Game Center Functionality
                self.gameCenterAuthenticationComplete = YES;
                
                if (! self.currentPlayerID || ! [self.currentPlayerID isEqualToString:localPlayer.playerID]) {
                    
                    // Current playerID has changed. Create/Load a game state around the new user.
                    self.currentPlayerID = localPlayer.playerID;
                    
                    [[GKTurnBasedEventHandler sharedTurnBasedEventHandler]setDelegate:self];
                    
                    [[AchievementHelper sharedInstance]loadAchievements];
                    
                    
                }
            } else {
                // No user is logged into Game Center, run without Game Center support or user interface.
                self.gameCenterAuthenticationComplete = NO;
            }
        }];
    }
}



- (void)handleTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive{

    NSLog(@"(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive");
    
    
    if (didBecomeActive) {
        [self  loadMatches];
    }
    
    if ([self findMatch:match InArray:MatchingMatchArray]) {
        //QUALCUNO HA ACCETTATO LA PARTITA
        
        GKTurnBasedParticipant * p1 = [match.participants objectAtIndex:0];
        GKTurnBasedParticipant * p2 = [match.participants objectAtIndex:1];
        
  
        
        if ([p1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
            
            [GKPlayer loadPlayersForIdentifiers:@[p2.playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
                if (error != nil)
                {
                    // Handle the error.
                }
                if (players != nil)
                {
                   [interfaceDelegate GameCenterInterfaceHelperDelegateDidFoundPlayerForMatch:match andPlayers:[players objectAtIndex:0]];
                }
            }];

        }else{
        
            [GKPlayer loadPlayersForIdentifiers:@[p1.playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
                if (error != nil)
                {
                    // Handle the error.
                }
                if (players != nil)
                {
                    [interfaceDelegate GameCenterInterfaceHelperDelegateDidFoundPlayerForMatch:match andPlayers:[players objectAtIndex:0]];
                }
            }];
        
        }
        
        
    }
  
    if ([self findMatch:match InArray:OthermatchsArray] || [self findMatch:match InArray:MatchingMatchArray]) {
         GKTurnBasedParticipant * currentPartecipant = match.currentParticipant;
        
        if ([currentPartecipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
            [OthermatchsArray removeObject:match];
            [myTurnMatchArray addObject:match];
        }
    }
    
    if (match.status==GKTurnBasedMatchStatusEnded) {
        [myTurnMatchArray removeObject:match];
        [OthermatchsArray removeObject:match];
    }
    
  
    
    
    [MatchingMatchArray removeObject:match];
    [interfaceDelegate GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:match];
    
}


//Metodo peer invitare un amico
- (void)inviteMatchWithFriend:(GKPlayer*)player {
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    //request.inviteMessage = [NSString stringWithFormat:@"Want to play Numzle?"];
    
    request.playersToInvite = @[player.playerID];
    
    [GKTurnBasedMatch findMatchForRequest: request withCompletionHandler:^(GKTurnBasedMatch *match, NSError *error)
     {
         
         if (match){
             
             
            
             [self enterNewGame:match isfried:true];
             
         }
     }];
    
}




-(void)handleMatchEnded:(GKTurnBasedMatch *)match{
    NSLog(@"-(void)handleMatchEnded:(GKTurnBasedMatch *)match{");

    [myTurnMatchArray removeObject:match];
    [OthermatchsArray removeObject:match];
    [MatchingMatchArray removeObject:match];
    [ClosedMatchArray addObject:match];
    [interfaceDelegate GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:match];

    
}



-(NSArray*)getMyFriends{

   return [GKLocalPlayer localPlayer].friends;
}


- (void) loadMatches
{
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        if (matches)
        {
            [myTurnMatchArray removeAllObjects];
            [OthermatchsArray removeAllObjects];
            [ClosedMatchArray removeAllObjects];
            [MatchingMatchArray removeAllObjects];
            
            
            for (GKTurnBasedMatch * match in matches) {
                
               
                
                if (match.status==GKTurnBasedMatchStatusEnded) {
                    [ClosedMatchArray addObject:match];
                }
                if (match.status==GKTurnBasedMatchStatusMatching) {
                    [MatchingMatchArray addObject:match];
                }
                if (match.status==GKTurnBasedMatchStatusOpen && !(match.status==GKTurnBasedMatchStatusMatching) ) {
                    
                    GKTurnBasedParticipant * currentPartecipant = match.currentParticipant;
                    if ([currentPartecipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] ) {
                        [ myTurnMatchArray addObject:match];
                    }else{
                        [ OthermatchsArray addObject:match];
                    }
                }
            }
            
            [interfaceDelegate GameCenterInterfaceHelperDelegateReceivedListOfGames:matches];
        }
    }];
}



- (void)findCasualMatch {
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    [GKTurnBasedMatch findMatchForRequest: request withCompletionHandler:^(GKTurnBasedMatch *match, NSError *error)
     {
         
         if (match){
             GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
             
             if (firstParticipant.lastTurnDate) {
                 [self takeTurn:match];
             } else {
                 [self enterNewGame:match isfried:false];
             }
         }
     }];
    
}

-(void)takeTurn:(GKTurnBasedMatch*)match{
    
    NSLog(@"GamecenterHelpler TAKETURN");
       [match loadMatchDataWithCompletionHandler: ^(NSData *matchData, NSError *error) {
        if (matchData)
        {
            MatchDataClass * receivedData = (MatchDataClass*)[NSKeyedUnarchiver unarchiveObjectWithData: matchData];
            
            if ([receivedData.matchfFase isEqualToString:@"CREATED"]) {
                
                 NSLog(@"MAtchFase = CREATED ");
                    //il match già era stato creato da qualcuno. Cambio lo stato e passo il turno
                     [MatchingMatchArray removeObject:match];
                    receivedData.matchfFase=@"CANSTART";
                    receivedData.p2ID= [GKLocalPlayer localPlayer].playerID; //Mi metto come player2
                 NSLog(@"setting MAtchFase = CANSTART ");
                    //match.message = [NSString stringWithFormat:@"Gioco che aspetta il primo turno"];
                    [self sendEndTurn:receivedData forMatch:match];
                
                    //[OthermatchsArray addObject:match];
                    [interfaceDelegate GameCenterInterfaceHelperDelegateDidFindMath:match];
                 NSLog(@"fine take turn ");
            }
                    
        }
    }];
    

}




-(void)enterNewGame:(GKTurnBasedMatch*)match isfried:(bool)friend{
    NSLog(@"GamecenterHelpler ENTERNEWGAME");

    
    [match loadMatchDataWithCompletionHandler: ^(NSData *matchData, NSError *error) {
        if (matchData)
        {
            MatchDataClass * receivedData;
            
            if ([matchData length]==0) {
                receivedData =[[MatchDataClass alloc]init];
                receivedData.p1ID= [GKLocalPlayer localPlayer].playerID;
                receivedData.matchfFase=@"CREATED";
                NSLog(@"Setting match fase to CREATED");
                //se il match è con amico setto anche P2Id
                if (friend) {
                    NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
                    GKTurnBasedParticipant *nextParticipant;
                    
                    nextParticipant = [match.participants objectAtIndex:((currentIndex + 1) % [match.participants count ])];
                    receivedData.matchfFase=@"INVITED";
                    NSLog(@"Setting match fase to INVITED");
                    receivedData.p2ID=nextParticipant.playerID;
                }
                
                
            }else{
                receivedData = (MatchDataClass*)[NSKeyedUnarchiver unarchiveObjectWithData: matchData];
                NSLog(@"Qualcosa non va,EnterNewGame e matchData gia presente");
            }
           
                [self sendEndTurn:receivedData forMatch:match];
            
            
        }
        
        }];
    

}

-(GKTurnBasedMatch*)findMatch:(GKTurnBasedMatch*)match InArray:(NSArray*)array
{
    
    for (GKTurnBasedMatch * g in array){
         
        if ([match.matchID isEqualToString: g.matchID]) {
            return g;
        }
    }
    return nil;
}

-(void)sendEndTurn :(MatchDataClass*)matchData forMatch:(GKTurnBasedMatch *)match
{
    
        
    NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:matchData];
    
    
    NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    nextParticipant = [match.participants objectAtIndex:((currentIndex + 1) % [match.participants count ])];
    
    [match endTurnWithNextParticipants:@[nextParticipant] turnTimeout:(60*60*24) matchData:data completionHandler:^(NSError *error) {
        if(nextParticipant.playerID){
            [myTurnMatchArray removeObject:match];
            [OthermatchsArray addObject:match];
        }else{
            [MatchingMatchArray addObject:match];
        }
        
        NSLog(@"Send Turn to %@", nextParticipant.playerID);
        
        [interfaceDelegate GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:match];

    }];
    
    

}

-(void)sendEndGame:(MatchDataClass *)MatchData forMatch:(GKTurnBasedMatch *)match
{
        
        NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:MatchData];

        [match endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
            [[GameCenterHelper sharedInstance].myTurnMatchArray removeObject:match];
            [[GameCenterHelper sharedInstance].ClosedMatchArray addObject:match];
            [interfaceDelegate GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:match];

        }];
}


-(void)quitMatchNotInTurn:(GKTurnBasedMatch*)match andData:(MatchDataClass*)MatchData{
    
    [match participantQuitOutOfTurnWithOutcome:GKTurnBasedMatchOutcomeQuit withCompletionHandler:^(NSError *error) {
        
        [[GameCenterHelper sharedInstance].OthermatchsArray removeObject:match];
        
        [match removeWithCompletionHandler:^(NSError *error) {
            
        }];
        
        [interfaceDelegate GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:match];
    }];
    

}



-(void)removeAllClosedMatch{

    for (GKTurnBasedMatch * match in ClosedMatchArray) {
        [match removeWithCompletionHandler:^(NSError *error) {
                   }];
    }


    [ClosedMatchArray removeAllObjects];

}

-(void)leaveMatch:(GKTurnBasedMatch*)match andData:(MatchDataClass *)MatchData{

    
    GKTurnBasedParticipant *p1 =[ match.participants objectAtIndex:0];
    GKTurnBasedParticipant *p2 = [match.participants objectAtIndex:1];
    
    
      //match.message=@"ABBANDONED";
     
        if ([p1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            p2.matchOutcome=GKTurnBasedMatchOutcomeWon;
            p1.matchOutcome=GKTurnBasedMatchOutcomeLost;
        }else{
            p1.matchOutcome=GKTurnBasedMatchOutcomeWon;
            p2.matchOutcome=GKTurnBasedMatchOutcomeLost;
        }
    
    
    [[GameCenterHelper sharedInstance]sendEndGame:MatchData forMatch:match];


}

/////////////////----------------------------- LEADERBOARD SECTION -----------------------------

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        // Do something interesting here.
    }];
}




@end
