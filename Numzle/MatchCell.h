//
//  MatchCell.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"

#import <Parse/Parse.h>

@interface MatchCell : UITableViewCell
{
    

}
@property(strong,nonatomic)GKTurnBasedMatch * cellMatch;


@property (weak, nonatomic) IBOutlet UILabel *player1Label;
@property (weak, nonatomic) IBOutlet UILabel *player2Label;
@property (weak, nonatomic) IBOutlet UILabel *matchMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchingIndicator;
@property (strong, nonatomic)PFImageView *avatarImageView;

-(void)initWithMatch:(GKTurnBasedMatch *) match;
@end
