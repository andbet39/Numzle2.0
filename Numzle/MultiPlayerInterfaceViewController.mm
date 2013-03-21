//
//  MultiPlayerInterfaceViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "MultiPlayerInterfaceViewController.h"
#import "MatchCell.h"
#import "MPMatchDetailViewController.h"
#import "InAppHelper.h"
#import "FaceBookHelper.h"
#import "GAI.h"

@interface MultiPlayerInterfaceViewController ()
{
    
    
    GKTurnBasedMatch * selectedMatch;
}

@end

@implementation MultiPlayerInterfaceViewController

@synthesize matchTableView;
@synthesize layoutBannerToTableview;
@synthesize bannerIsVisible;
@synthesize bannerView;

-(void)customizeInterface{

    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarWithTitle"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     UIImage *backBtnImage = [UIImage imageNamed:@"backButton"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 68, 32);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *reloadBtnImage = [UIImage imageNamed:@"reloadButton"]  ;
    [reloadBtn setBackgroundImage:reloadBtnImage forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(reloadDataButton:) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.frame = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithCustomView:reloadBtn] ;
    self.navigationItem.rightBarButtonItem = reloadButton;
    //NAsconde il bannerview
    
   

}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutBanners];

    [bannerView setDelegate:self];
    [self customizeInterface];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Multyplayer Screen"];
    

    [[FaceBookHelper sharedInstance]LoginWithAllowUI:NO];

    [[GameCenterHelper sharedInstance]setInterfaceDelegate:self];
    
    [[GameCenterHelper sharedInstance]loadMatches];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"My Turn";
    if(section == 1)return @"Other Turn";
    
    if(section == 2)return @"Matching";

        if(section == 3)return @"Closed";

    return @"";
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) return [[GameCenterHelper sharedInstance].myTurnMatchArray count]+1+[[GameCenterHelper sharedInstance].MatchingMatchArray count];
    if (section==1)  return [[GameCenterHelper sharedInstance].OthermatchsArray count];
    if (section==2)  return 0;//[[GameCenterHelper sharedInstance].MatchingMatchArray count];
    if (section==3)  return [[GameCenterHelper sharedInstance].ClosedMatchArray count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MatchCell";
    static NSString *Cell2Identifier = @"buttonCell";

    if (indexPath.row==0 && indexPath.section==0) {//è la prima cella, quella con  i bottoni
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:Cell2Identifier forIndexPath:indexPath];
        [cell setDelegate:self];
        return cell;
    }else{

        MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        
        
        //Nella prima sezione fa vedere ancehe i match in matching
        if (indexPath.section==0){
            if (indexPath.row>[[GameCenterHelper sharedInstance].myTurnMatchArray count]) {
                [cell initWithMatch:[[GameCenterHelper sharedInstance].MatchingMatchArray objectAtIndex:(indexPath.row-1-[[GameCenterHelper sharedInstance].myTurnMatchArray count])]];
            }else{
                [cell initWithMatch:[[GameCenterHelper sharedInstance].myTurnMatchArray objectAtIndex:indexPath.row-1]];
            }
        }
        
        
        
        if (indexPath.section==1)
            [cell initWithMatch:[[GameCenterHelper sharedInstance].OthermatchsArray objectAtIndex:indexPath.row]];
        //if (indexPath.section==2)
          //  [cell initWithMatch:[[GameCenterHelper sharedInstance].MatchingMatchArray objectAtIndex:indexPath.row]];
        if (indexPath.section==3)
            [cell initWithMatch:[[GameCenterHelper sharedInstance].ClosedMatchArray objectAtIndex:indexPath.row]];
       
        
        //Aggiusta l immagine di sfondo della cella a seconda se è la prima o l ultima
        
        if ([self tableView:nil numberOfRowsInSection:indexPath.section]==indexPath.row+1) {
            [cell.backImage setImage:[UIImage imageNamed:@"backgroundCellInferiore"]];
        }else{
    
            if (indexPath.row==0) {
                [cell.backImage setImage:[UIImage imageNamed:@"backgroundCellSuperiore"]];
            }else
            {
                [cell.backImage setImage:[UIImage imageNamed:@"tableCellBackground"]];
 
            }
        }
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 || section ==2) {
        return 0;
    }else{
        return 55.0;
    }
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 && indexPath.row==0) {
        return 140.0;
    }else{
        return 55.0;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    
    NSString *imagename =@"";
    if (section==1) {
        imagename=@"WaitingMatchHeaderBack";
    }
     
    
    if (section==3) {
        
        imagename=@"closedMatchHeader";
    }
   
    
    UIImageView * sectionHeaderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagename]];
    [sectionHeaderImageView setFrame:CGRectMake(0, 15, 300, 40)];
    
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    sectionHeaderImageView.backgroundColor=[UIColor clearColor];

    [headerView addSubview:sectionHeaderImageView];
    if (section==3) {
        UIButton *trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *trashBtnImg = [UIImage imageNamed:@"clearButton"]  ;
        [trashBtn setBackgroundImage:trashBtnImg forState:UIControlStateNormal];
        [trashBtn addTarget:self action:@selector(removeActionButton:) forControlEvents:UIControlEventTouchUpInside];
        trashBtn.frame = CGRectMake(220  , 22, 68, 27);
        [headerView addSubview:trashBtn];
     }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MPMatchDetail
    if (indexPath.row==0 && indexPath.section==0) {
        
    }else{
    if (indexPath.section==0) 
        //selectedMatch = [[GameCenterHelper sharedInstance].myTurnMatchArray objectAtIndex:indexPath.row-1];
        if (indexPath.section==0){
            if (indexPath.row>[[GameCenterHelper sharedInstance].myTurnMatchArray count]) {
               selectedMatch =[[GameCenterHelper sharedInstance].MatchingMatchArray objectAtIndex:(indexPath.row-1-[[GameCenterHelper sharedInstance].myTurnMatchArray count])];
            }else{
                selectedMatch =[[GameCenterHelper sharedInstance].myTurnMatchArray objectAtIndex:indexPath.row-1];
            }
        }
        
    if (indexPath.section==1)
        selectedMatch = [[GameCenterHelper sharedInstance].OthermatchsArray objectAtIndex:indexPath.row];
    if (indexPath.section==2)
        selectedMatch = [[GameCenterHelper sharedInstance].MatchingMatchArray objectAtIndex:indexPath.row];
    if (indexPath.section==3)
        selectedMatch = [[GameCenterHelper sharedInstance].ClosedMatchArray objectAtIndex:indexPath.row];
    
    
    
    [self performSegueWithIdentifier:@"MPMatchDetail" sender:self];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    if ([segue.identifier isEqualToString:@"MPMatchDetail"]) {
        
        MPMatchDetailViewController  * matchDetailController = segue.destinationViewController;
        [matchDetailController setSelectedMatch:selectedMatch];
            
    }
    if ([segue.identifier isEqualToString:@"inviteFriend"]) {
        
        InviteFriendViewController  * inviteController = segue.destinationViewController;
        [inviteController setDelegate:self];
        
    }
}

-(void)InviteFriendViewController:(InviteFriendViewController *)sender didSelectPlayer:(GKPlayer *)player
{

    [self.navigationController popViewControllerAnimated:YES];    
    [[GameCenterHelper sharedInstance]inviteMatchWithFriend:player];

}




- (IBAction)endAllMatch:(id)sender {
    
    for (GKTurnBasedMatch * match in [GameCenterHelper sharedInstance].myTurnMatchArray) {
        for(GKTurnBasedParticipant * part in match.participants){
        
            if ([part.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                [part setMatchOutcome:GKTurnBasedMatchOutcomeLost];
            }else{
                [part setMatchOutcome:GKTurnBasedMatchOutcomeWon];
                }
        
        }
   
        MatchDataClass * currentMatchData =[[MatchDataClass alloc]init];
        
        NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:currentMatchData];
        
       
        
        [match endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
            
        }];
    }
    
}

- (IBAction)findMatch:(id)sender {
  
    if([[GameCenterHelper sharedInstance].MatchingMatchArray count]<3){
        [[GameCenterHelper sharedInstance]findCasualMatch];
    }else{
    
        
        UIAlertView *allerView = [[UIAlertView alloc] initWithTitle:@"Allert"
                                                            message:@"You cannot queue for more then 3 match."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
        [allerView show];
    }
    
}



- (IBAction)inviteFriendButton:(id)sender {

    [self performSegueWithIdentifier:@"inviteFriend" sender:self];
}

- (IBAction)removeActionButton:(id)sender {
    
    [[GameCenterHelper sharedInstance]removeAllClosedMatch];
    [matchTableView reloadData];
}

- (IBAction)reloadDataButton:(id)sender {
    [[GameCenterHelper sharedInstance]loadMatches];
    [matchTableView reloadData];


}



#pragma mark ButtonCellDelegate


-(void)ButtonsCelldidPressFriendsButton:(ButtonsCell*)sender{
    [self inviteFriendButton:self];
    
}
-(void)ButtonsCelldidPressRandomButton:(ButtonsCell*)sender{
    
    [self findMatch:self];
    
}


#pragma mark GameCenterInterfaceHelperDelegate

-(void)GameCenterInterfaceHelperDelegateReceivedListOfGames:(NSArray *)matchs
{
     [matchTableView reloadData];
    
}


-(void)GameCenterInterfaceHelperDelegateDidFindMath:(GKTurnBasedMatch *)match
{
    //[matchTableView reloadData];
    selectedMatch=match;
    [self performSegueWithIdentifier:@"MPMatchDetail" sender:self];
}

-(void)GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:(GKTurnBasedMatch *)match{

    [matchTableView reloadData];
}

-(void)GameCenterInterfaceHelperDelegateDidFoundPlayerForMatch:(GKTurnBasedMatch *)match andPlayers:(GKPlayer*)player
{
    
    NSString *message = [NSString stringWithFormat:@"%@ accepted match",player.displayName ];
    
    UIAlertView *allerView = [[UIAlertView alloc] initWithTitle:@"Hurra!"
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [allerView show];


}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Banner view did load add");

    if (self.bannerIsVisible && ![InAppHelper sharedInstance].isPremiumVersion)
    {
        self.bannerIsVisible = NO;
       /* [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, +banner.frame.size.height);
        [UIView commitAnimations];*/
        
        [self layoutBanners];

    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Banner view did load add");

    if (!self.bannerIsVisible && ![InAppHelper sharedInstance].isPremiumVersion)
    {
        /*[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];;*/
        
        [self layoutBanners];
        self.bannerIsVisible = YES;
    }
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction =YES;
    
    if (!willLeave && shouldExecuteAction)
    {
        if ([InAppHelper sharedInstance].isPremiumVersion) {
            shouldExecuteAction=NO;
            
        }
    }
    return shouldExecuteAction;
}

-(void)layoutBanners{
    NSLog(@"LayoutBanner : Is banner loaded :%d",self.bannerView.isBannerLoaded);
    if (self.bannerView.bannerLoaded && ![[InAppHelper sharedInstance]isPremiumVersion]) {
        [self shouldShowBanner:nil];
        [self shouldShowBanner:nil];
    }else{
        [self shouldHideBanner:nil];
        [self shouldHideBanner:nil];
    }
}

- (void)shouldShowBanner:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [_bannerVerticalSpace setConstant:0];
        [self.view layoutSubviews];
    }];
}

- (void)shouldHideBanner:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [_bannerVerticalSpace setConstant:-50];
        [self.view layoutSubviews];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self customizeInterface];
}
@end
