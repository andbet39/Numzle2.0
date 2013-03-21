//
//  ViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ViewController.h"
#import "FaceBookHelper.h"
#import "GAI.h"


@interface ViewController ()

@end

@implementation ViewController

-(void)customizeInterface{
    

    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarWithTitle"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    

    
}
-(void)goConfig{
    [self performSegueWithIdentifier:@"configView" sender:self];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Home Screen"];
    
    
    
    
    [self customizeInterface];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    
    bool isSoundEnabled= [prefs boolForKey:@"isSoundEnabled"];
    if ([prefs boolForKey:@"isNotFirstTime"] == FALSE)
    {
        [prefs setBool:TRUE  forKey:@"isNotFirstTime"];
        [prefs synchronize];
        [self performSegueWithIdentifier:@"fisrtTutorial" sender:self];
        isSoundEnabled=TRUE;
        
        //[[FaceBookHelper sharedInstance]LoginWithAllowUI:YES];

        
    }
    
    
    if ( isSoundEnabled  )
    {
        [prefs setBool:TRUE  forKey:@"isSoundEnabled"];
        [[SoundManager sharedInstance]unmute];
        [prefs synchronize];

        
    }
    if (isSoundEnabled==FALSE) {
        
        [[SoundManager sharedInstance]mute];

    }
    
    
    
    
    [[FaceBookHelper sharedInstance] LoginWithAllowUI:false];
    
    //[[FacebookHelper sharedInstance] getFriendList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"startGame"]) {
        CCViewController * destination = segue.destinationViewController;
        [destination setGameOverDelegate:self];
        
    }
    
}

- (IBAction)playButton:(id)sender {
    
    
    if([InAppHelper sharedInstance].isPremiumVersion){
        [GameManager sharedInstance].numberToHit = [NSNumber numberWithInt: arc4random()%900+100];
        
        [self performSegueWithIdentifier:@"startGame" sender:self];
    }else{
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Buy premium version"
                                                            message:@"You can play solo mode only with the premium version."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Buy",nil];
        [alertView show];
    
    }
    
    
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        // È stato premuto il bottone Cancel
    } else if (buttonIndex == 1){
        //È stato premuto il bottone OK
        [[InAppHelper sharedInstance]buyProduct:@"com.atdevapps.numzle.premiumversion"];
    }
}



- (IBAction)viewLeaderboardAction:(id)sender {
        
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
            gameCenterController.leaderboardCategory = kSoloPlayerLeaderBoard;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
        
    }

- (IBAction)postFacebookwin:(id)sender {
    
    [[ParseHelper sharedInstance]TryPostWinStoryOnFBVSPlayerID:@"G:1384258620"];
    
    //[[FaceBookHelper sharedInstance]postBeatFriendStoryWithFriendId:@"1200483510"];
}

- (IBAction)goConfigAction:(id)sender {
    [self performSegueWithIdentifier:@"configView" sender:self];

}

    
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }


-(void)CCViewControllerDidEndGame:(CCViewController *)sender{
    
    [sender dismissViewControllerAnimated:FALSE completion:^{
        
    }];

}

-(void)viewDidAppear:(BOOL)animated{

    [self customizeInterface];
}
@end
