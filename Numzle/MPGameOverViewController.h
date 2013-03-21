//
//  MPGameOverViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

//#import "ViewController.h"
#import "GameManager.h"

@class MPGameOverViewController;

@protocol MPGameOverViewControllerDelegate

-(void)MPGameOverViewControllerDidEndGame:(MPGameOverViewController*)sender;

@end


@interface MPGameOverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *operationCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *punteggioLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberToHitLabel;
@property (readwrite)int playerNum;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *totalPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property(strong,nonatomic)id<MPGameOverViewControllerDelegate>delegate;

- (IBAction)endTurn:(id)sender;
@end
