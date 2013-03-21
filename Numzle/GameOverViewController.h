//
//  GameOverViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameManager.h"
#import "OperationCell.h"

@class GameOverViewController;

@protocol GameOverViewControllerDelegate
- (void) GameOverViewControllerDidEndGame:(GameOverViewController*)sender;
@end

@interface GameOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *operationCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *punteggioLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberToHitLabel;
@property(strong,nonatomic)id<GameOverViewControllerDelegate>delegate;
- (IBAction)menuButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *totalPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
