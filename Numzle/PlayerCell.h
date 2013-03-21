//
//  PlayerCell.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"
#import <Parse/Parse.h>

@interface PlayerCell : UITableViewCell
{
    GKPlayer * cellPlayer;
    
}
@property (strong, nonatomic)PFImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundCellImage;


-(void)initWithPlayer:(GKPlayer*)player;

@end
