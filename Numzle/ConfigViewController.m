//
//  ConfigViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 15/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ConfigViewController.h"
#import "GameCenterHelper.h"
#import "ParseHelper.h"
#import "InAppHelper.h"
#import "SoundManager.h"
#import "FaceBookHelper.h"
#import "GAI.h"
@interface ConfigViewController ()

@end

@implementation ConfigViewController

@synthesize facebookSwith;

-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarSettings"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 68, 32);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    

}

-(void)viewWillAppear:(BOOL)animated{

    [self customizeInterface];

    }
-(id)init{

    if(self=[super init]){
    
    
    }
    return  self;
}


-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self customizeInterface];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Config Screen"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs boolForKey:@"isSoundEnabled"] == FALSE)
    {
        
        [self.soundSwitch setOn:FALSE];
        
    }else{
        [self.soundSwitch setOn:YES];

     }
    
    
    //set the state of FB button
    if ([FBSession activeSession].isOpen && [FBSession activeSession]){
        
        
        [self.facebookSwith setOn:TRUE];
    }else
    {
        [self.facebookSwith setOn:FALSE];

    
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"selectAvatar"]) {
        SelectAvatarViewController * selAvatarVC =segue.destinationViewController;
        [selAvatarVC setCategory:self.selectedCategory];
        [selAvatarVC setDelegate:self];
    }

}
- (IBAction)selectAvatarButtonAction:(id)sender {
    
   
        
        
        if([InAppHelper sharedInstance].isPremiumVersion){
            self.selectedCategory=@"BASIC";
            
            [self performSegueWithIdentifier:@"selectAvatar" sender:self];
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Buy premium version"
                                                                message:@"You can change avatar only with the premium version."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Buy",nil];
            [alertView show];
            
        }
        
        
        
    }

- (IBAction)selectAvatarSet2:(id)sender {
    if([InAppHelper sharedInstance].isPremiumVersion){
        self.selectedCategory=@"SET2";
        
        [self performSegueWithIdentifier:@"selectAvatar" sender:self];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Buy premium version"
                                                            message:@"You can change avatar only with the premium version."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Buy",nil];
        [alertView show];
        
    }
}

- (IBAction)selectAvatarSet1:(id)sender {
    //if([InAppHelper sharedInstance].isPremiumVersion){
        self.selectedCategory=@"SET1";
        
        [self performSegueWithIdentifier:@"selectAvatar" sender:self];
    /*}else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Buy premium version"
                                                            message:@"You can change avatar only with the premium version."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Buy",nil];
        [alertView show];
        
    }*/
}

- (IBAction)restorInAppAction:(id)sender {
    
    [[InAppHelper sharedInstance]restoreInApp];
}

- (IBAction)SoundButton:(id)sender {
    
    UISwitch * sw=(UISwitch*)sender;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if (sw.isOn) {
        [[SoundManager sharedInstance]unmute];
        [prefs setBool:TRUE  forKey:@"isSoundEnabled"];
        [prefs synchronize];
    }else{
        [[SoundManager sharedInstance]mute];
        [prefs setBool:FALSE  forKey:@"isSoundEnabled"];
        [prefs synchronize];
    }
    
}

- (IBAction)facebookButton:(id)sender {
    
    UISwitch * fbswitch =(UISwitch*)sender;
    
    
    if (!fbswitch.isOn) {
        [[FaceBookHelper sharedInstance ]Logout];
    }else{
        [[FaceBookHelper sharedInstance]LoginWithAllowUI:YES];

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
    


#pragma mark selectAvatarViewController Delegate
-(void)selectAvatarViewController:(SelectAvatarViewController *)sender didSelectAvaterID:(NSString *)avatarID
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([GameCenterHelper sharedInstance].currentPlayerID !=nil) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"PlayerAvatar"];
        [query whereKey:@"playerID" equalTo:[GameCenterHelper sharedInstance].currentPlayerID];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (!error) {
                
                
               //ci sta devo fare update
                [object setObject:avatarID forKey:@"avatarId"];
                [object saveEventually];
                
            } else {
                // Log details of the failure
                [[ParseHelper sharedInstance]setAvatar:avatarID forPlayerID:[GameCenterHelper sharedInstance].currentPlayerID];
            }
        }];
    }
    
}

-(void)selectAvatarViewControllerDidCancel:(SelectAvatarViewController *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setSoundSwitch:nil];
    [self setFacebookSwith:nil];
    [self setRestoreInApp:nil];
    [super viewDidUnload];
}
- (IBAction)facebookSwitchAction:(id)sender {
}



// required by protocol
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
}

// this is to get the total number of products to restore
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    /*purchaseCount = queue.transactions.count;
    if(queue.transactions.count > 0)
        HUD.labelText = @"Restoring Purchases";*/
}

@end
