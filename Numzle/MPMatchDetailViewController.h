//
//  MPMatchDetailViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"
#import "MatchDataClass.h"
#import "MPGameOverViewController.h"
#import "CCViewController.h"
#import <Parse/Parse.h>
@interface MPMatchDetailViewController : UIViewController<CCViewControllerDelegate>

@property(strong,nonatomic)GKTurnBasedMatch * selectedMatch;

@property(strong,nonatomic)MatchDataClass *currentMatchData;
@property (strong, nonatomic) PFImageView * imageView1;
@property (strong, nonatomic) PFImageView * imageView2;

@property (weak, nonatomic) IBOutlet UILabel *player2Label;
@property (weak, nonatomic) IBOutlet UILabel *player1Label;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *T1P1Label;
@property (weak, nonatomic) IBOutlet UILabel *T2P1Label;
@property (weak, nonatomic) IBOutlet UILabel *T3P1Label;
@property (weak, nonatomic) IBOutlet UILabel *T1P2Label;
@property (weak, nonatomic) IBOutlet UILabel *T2P2Label;
@property (weak, nonatomic) IBOutlet UILabel *T3P2Label;
@property (weak, nonatomic) IBOutlet UILabel *winLostLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1TotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2TotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *turn1Label;
@property (weak, nonatomic) IBOutlet UILabel *turn2Label;
@property (weak, nonatomic) IBOutlet UILabel *turn3Label;
- (IBAction)playButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
- (IBAction)leaveButton:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)acceptButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
- (IBAction)declineButtonAction:(id)sender;
- (IBAction)leaveNotInTurnButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *leaveNotInTurnButton;

@end
