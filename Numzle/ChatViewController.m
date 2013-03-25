//
//  ChatViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 23/03/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import <GameKit/GameKit.h>
#import "InAppHelper.h"
#import "GAI.h"



#define TABBAR_HEIGHT 0
#define TEXTFIELD_HEIGHT 70.0f

#define CLASSNAME @"ChatMessage"
#define MAX_ENTRIES_LOADED 10



@interface ChatViewController ()
{

    
    BOOL _reloading;
    NSString * className;
    NSString * userID;
    
    

}

@property(nonatomic,strong)NSString * chatIdentifier;
@property(nonatomic,strong)NSDictionary * playersName;
@property(readwrite)bool bannerIsVisible;



@end

@implementation ChatViewController
@synthesize chatTable;


@synthesize tfEntry;
-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"navigationBarWithTitle"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 68, 32);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    
 
    
    
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initWithChatIdentifier:(NSString*)identifier andPlayerName:(NSDictionary*)players
{



    self.chatIdentifier=identifier;
    self.playersName =players;
    
    //self.title = identifier;
    
    [self customizeInterface];

}

-(void)viewWillAppear:(BOOL)animated{

    chatData  = [[NSMutableArray alloc] init];
    userID = [GKLocalPlayer localPlayer].playerID;
    className = @"ChatMessage";
    [self loadLocalChat];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerIsVisible =false;
    [self.bannerView setDelegate:self];
    [self layoutBanners];

    tfEntry.delegate = self;
    tfEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerForKeyboardNotifications];
    
    if (_refreshHeaderView == nil) {
        
        PF_EGORefreshTableHeaderView *view = [[PF_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - chatTable.bounds.size.height, chatTable.bounds.size.width, chatTable.bounds.size.height)];
        view.delegate = self;
        view.lastUpdatedLabel.textColor=[UIColor whiteColor];
        view.statusLabel.textColor=[UIColor whiteColor]
        ;
        
        [chatTable addSubview:view];
        _refreshHeaderView = view;
    }
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Chat Screen"];
    //[self logFont];
    
}


-(void)logFont{


    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Parse

- (void)loadLocalChat
{
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    [query whereKey:@"ChatRoom" equalTo:self.chatIdentifier];
    
    
    [query orderByAscending:@"createdAt"];
 
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        [chatData removeAllObjects];

                        NSLog(@"Successfully retrieved %d chats.", objects.count);
                        
                        [chatData addObjectsFromArray:objects];
                     
                        
                        
                        [chatTable reloadData];
                        
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
    
       
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"the text content%@",tfEntry.text);
    [textField resignFirstResponder];
    
    if (tfEntry.text.length>0) {
        
        
        // updating the table immediately
        NSArray *keys = [NSArray arrayWithObjects:@"text", @"ChatRoom",@"UserID", @"date", nil];
        NSArray *objects = [NSArray arrayWithObjects:tfEntry.text, self.chatIdentifier,userID, [NSDate date], nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [chatData addObject:dictionary];
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [chatTable beginUpdates];
        [chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [chatTable endUpdates];
        [chatTable reloadData];
        
        // going for the parsing
        PFObject *newMessage = [PFObject objectWithClassName:CLASSNAME];
        [newMessage setObject:tfEntry.text forKey:@"text"];
        [newMessage setObject:self.chatIdentifier forKey:@"ChatRoom"];
        [newMessage setObject:userID forKey:@"UserID"];
        [newMessage setObject:[NSDate date] forKey:@"date"];
        [newMessage saveInBackground];
        tfEntry.text = @"";
    }
    
    // reload the data
    //[self loadLocalChat];
    return NO;
}


#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = (ChatCell *)[tableView dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];
    NSUInteger row = [chatData count]-[indexPath row]-1;
    
    
    NSString *chatText = [[chatData objectAtIndex:row] objectForKey:@"text"];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    
        
        cell.textString.text = chatText;
        [cell.textString sizeToFit];
    
    NSString * name = [self.playersName objectForKey:[chatData[row] objectForKey:@"UserID"]];
    NSDate *theDate = [[chatData objectAtIndex:row] objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a"];
    NSString *timeString = [formatter stringFromDate:theDate];
    
    
    cell.userLabel.text = [NSString stringWithFormat:@"%@ at %@",name,timeString];
    
    
    if ([self tableView:nil numberOfRowsInSection:indexPath.section]==indexPath.row+1) {
        [cell.imageBackGround setImage:[UIImage imageNamed:@"backgroundCellInferiore"]];
    }else{
        
        if (indexPath.row==0) {
            [cell.imageBackGround setImage:[UIImage imageNamed:@"backgroundCellSuperiore"]];
        }else
        {
            [cell.imageBackGround setImage:[UIImage imageNamed:@"tableCellBackground"]];
            
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [[chatData objectAtIndex:chatData.count-indexPath.row-1] objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
    CGSize constraintSize = CGSizeMake(225.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"TableCellSize = %f",labelSize.height);
    
    return labelSize.height + 30;
}

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    [self loadLocalChat];
    [chatTable reloadData];
}
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:chatTable];
    
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



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(PF_EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PF_EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(PF_EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark - Chat textfield

-(IBAction) textFieldDoneEditing : (id) sender
{
    NSLog(@"the text content%@",tfEntry.text);
    [sender resignFirstResponder];
    [tfEntry resignFirstResponder];
}

-(IBAction) backgroundTap:(id) sender
{
    [self.tfEntry resignFirstResponder];
}



-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardWillShow:(NSNotification*)aNotification
{
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height+TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height-TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}


- (void)viewDidUnload {
    [self setTfEntry:nil];
    [self setChatTable:nil];
    [self setChatTable:nil];
 
    [self setBannerVerticalSpace:nil];
    [self setBannerView:nil];
    [super viewDidUnload];
}
@end
