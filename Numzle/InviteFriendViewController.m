//
//  InviteFriendViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "GameCenterHelper.h"
#import "PlayerCell.h"
#import "Facebook.h"

#import "GAI.h"

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController

@synthesize GamecenterfriendsArray,FacebookfriendsArray,friendsTableView;
@synthesize delegate;

-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"friendsNavBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 68, 32);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    

     
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Friend Screen"];
    
    [self customizeInterface];
    
    GamecenterfriendsArray=@[];
    
    
    [[FaceBookHelper sharedInstance]setDelegate:self];

    if ([FBSession activeSession].isOpen) {
        [[FaceBookHelper sharedInstance]loadFriendListAllowFBUI:YES];
    }
    
    [[GKLocalPlayer localPlayer]loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error) {
        
       
        
        [GKPlayer loadPlayersForIdentifiers:friends withCompletionHandler:^(NSArray *players, NSError *error) {
            if (error != nil)
            {
                // Handle the error.
            }
            if (players != nil)
            {
                GamecenterfriendsArray = [[NSArray alloc]initWithArray:players];
                
                [friendsTableView reloadData];            }
        }];
     
        
    }];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return GamecenterfriendsArray.count+1;
        

    }
    if (section==1) {
        return [[FaceBookHelper sharedInstance].friends count]-1;
    }
    
    // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1 = @"playerCell";
    static NSString *CellIdentifier2 = @"facebookFriendCell";
   
    
    UITableViewCell *cell;
    
    if (indexPath.section==0) {
        PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        
        if (indexPath.row==0) {
            //La prima cella è quella dell header
            [cell.backgroundCellImage setImage:[UIImage imageNamed:@"GamecenterHeader"]];
            cell.nameLabel.text=@"";
            
            return cell;

        }else{
            
            PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
            [cell initWithPlayer:[GamecenterfriendsArray objectAtIndex:indexPath.row-1]];
        
            if ([self tableView:nil numberOfRowsInSection:indexPath.section]==indexPath.row+1) {
                
                    [cell.backgroundCellImage setImage:[UIImage imageNamed:@"backgroundCellInferiore"]];
            }else{
            
                [cell.backgroundCellImage setImage:[UIImage imageNamed:@"backgroundCellSuperiore"]];
                 
            }
            
            
        }
        return cell;


    }
    if (indexPath.section==1) {
        FacebookFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        
        [cell initWithFBGraphUser:[[FaceBookHelper sharedInstance].friends objectAtIndex:indexPath.row]];
        [cell setDelegate:self];
        if ([self tableView:nil numberOfRowsInSection:indexPath.section]==indexPath.row+1) {
                [cell.backgroundCellImage setImage:[UIImage imageNamed:@"backgroundCellInferiore"]];
        }else{
            
            if (indexPath.row==0) {
                [cell.backgroundCellImage setImage:[UIImage imageNamed:@"backgroundCellSuperiore"]];
            }else
            {
                [cell.backgroundCellImage setImage:[UIImage imageNamed:@"tableCellBackground"]];
                
            }
        }
        return cell;

    }
    
   
    
    return cell;
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
  
    
    return @"";
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MPMatchDetail
    if (indexPath.section==0 && indexPath.row!=0) {
        
    
        GKPlayer * selectedPlayer = [GamecenterfriendsArray objectAtIndex:indexPath.row-1] ;
    
    [delegate InviteFriendViewController:self didSelectPlayer:selectedPlayer];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 || section ==2) {
        return 0;
    }else{
        return 60 ;
    }
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row==0 && indexPath.section==0) {
        return 130;
    }
    return 55.0;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 39)];

    NSString *imagename =@"";
   
    if (section==1)
        imagename=@"FacebookHeader";
     
  
    
   
    UIImageView * sectionHeaderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagename]]; //initWithFrame:CGRectMake(5, 5, 300, 24)];
    
    
        [sectionHeaderImageView setFrame:CGRectMake(0, 21, 300, 39)];

    
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    sectionHeaderImageView.backgroundColor=[UIColor clearColor];
    
    [headerView addSubview:sectionHeaderImageView];
    
    if (section==1 && ![FBSession activeSession].isOpen) {
        UIButton *trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *trashBtnImg = [UIImage imageNamed:@"Fblogin"]  ;
        [trashBtn setBackgroundImage:trashBtnImg forState:UIControlStateNormal];
        [trashBtn addTarget:self action:@selector(loginFacebookButton) forControlEvents:UIControlEventTouchUpInside];
        trashBtn.frame = CGRectMake(210  , 27, 83, 26);
        [headerView addSubview:trashBtn];
    }

    return headerView;
}


#pragma mark FacebookFriendCellDelegae

-(void)FacebookFriendCell:(FacebookFriendCell *)sender didInviteFriend:(FBGraphObject<FBGraphUser> *)friend
{
   
//x    [[FaceBookHelper sharedInstance] postInviteToWall:friend];
    [[FaceBookHelper sharedInstance]  sendRequestToFBID:friend.id andMessage:@"Challenge me in Numzle. It's the new fast math game for iPhone."];

}

-(void)FacebookFriendCell:(FacebookFriendCell *)sender didPlayGCFriend:(NSString *)playerID{
   
    [GKPlayer loadPlayersForIdentifiers:@[playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil)
        {
            // Handle the error.
        }
        if (players != nil)
        {
            GKPlayer *p1 = [players objectAtIndex:0];
            
            [delegate InviteFriendViewController:self didSelectPlayer:p1];

        }
        
        
        
    }];
    


}

-(void)FacebookHelperFriendListUpdated
{
    [friendsTableView reloadData];

}

-(void)loginFacebookButton
{
    [[FaceBookHelper sharedInstance]loadFriendListAllowFBUI:YES];

}

@end
