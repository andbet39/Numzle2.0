//
//  FacebookFriendCell.m
//  Numzle
//
//  Created by Andrea Terzani on 18/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "FacebookFriendCell.h"
//#import "Facebook.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>


@implementation FacebookFriendCell
@synthesize picture;
@synthesize nameLabel,backgroundCellImage,GameCenterID;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

-(void)prepareForReuse{

    [picture removeFromSuperview];
    picture=nil;

}
-(void)initWithFBGraphUser:(FBGraphObject<FBGraphUser>*)inviteFriend{
    
    
    if (picture==nil) {
        picture =[[FBProfilePictureView alloc]initWithFrame:CGRectMake(7,4,40,40)];
        [self.contentView addSubview:picture];

    }
    
    
    picture.profileID=inviteFriend.id;
 
    
    cellFriend=inviteFriend;
    
    [self loadOnParse];
    
    [nameLabel setText:inviteFriend.name];
    
       picture.layer.cornerRadius = 5;
    picture.layer.masksToBounds = YES;
    picture.layer.borderWidth=2;
    picture.layer.borderColor=[UIColor lightGrayColor].CGColor;
    

    
}

-(void)loadOnParse{
   
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerFacebookID"];
    [query whereKey:@"facebookID" equalTo:cellFriend.id];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
  //  query.cachePolicy=kPFCachePolicyNetworkOnly;
    query.maxCacheAge = 15 * 60 ;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved Avatar file");
            
            if ([objects count]==0) {
                
               self.GameCenterID=@"";
                [self.inviteButton setImage:[UIImage imageNamed:@"inviteButton"] forState:UIControlStateNormal];

                
            }else{
                
                PFObject *player =  [objects objectAtIndex:0];
                
                self.GameCenterID = [player objectForKey:@"gameCenterID"];
               
                [self.inviteButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

    
}

- (IBAction)inviteButton:(id)sender {
    
    if (![self.GameCenterID isEqualToString:@""]) {
        [self.delegate FacebookFriendCell:self didPlayGCFriend:self.GameCenterID];
    }else{
        
        [self.delegate FacebookFriendCell:self didInviteFriend:cellFriend];
    }

}
@end
