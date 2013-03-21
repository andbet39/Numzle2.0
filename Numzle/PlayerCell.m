//
//  PlayerCell.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "PlayerCell.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation PlayerCell
@synthesize nameLabel;
@synthesize avatarImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    
    }
    return self;
}
-(void)prepareForReuse{
    
    [avatarImageView removeFromSuperview];
}
-(void)initWithPlayer:(GKPlayer*)player{

    cellPlayer=player;
    
    
    avatarImageView =[[PFImageView alloc]initWithFrame:CGRectMake(7,6,40,40)];
    [self.contentView addSubview:avatarImageView];
    
    [nameLabel setText:player.displayName];
    
    [self displayPlayerAvatar:player.playerID];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)displayPlayerAvatar:(NSString*)playerID{
    
    PFQuery *PlayerQuery = [PFQuery queryWithClassName:@"PlayerAvatar"];
    [PlayerQuery whereKey:@"playerID" equalTo:playerID];
    
    PlayerQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    PlayerQuery.maxCacheAge = 60 * 60 * 24;
    [PlayerQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            [avatarImageView setImage:[UIImage imageNamed:@"standard"]];

            NSLog(@"The getFirstObject request failed.");
        } else {
            
            
            PFQuery * avatarQuery = [PFQuery queryWithClassName:@"Avatar"];
            [avatarQuery whereKey:@"objectId" equalTo:[object objectForKey:@"avatarId"]];
            avatarQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
            avatarQuery.maxCacheAge = 60 * 60 * 24;
            
            [avatarQuery getFirstObjectInBackgroundWithBlock:^(PFObject *avatar, NSError *error) {
                
                if (!object) {
                    [avatarImageView setImage:[UIImage imageNamed:@"faccina"]];
                    NSLog(@"The getFirstObject request failed.");
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
