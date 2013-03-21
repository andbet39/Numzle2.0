//
//  SelectAvatarViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 15/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "SelectAvatarViewController.h"
#import "avatarCell.h"

@interface SelectAvatarViewController ()
{

    NSArray * avatars ;
}
@end

@implementation SelectAvatarViewController

@synthesize collectionView;
@synthesize  delegate;
@synthesize category;

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
    
    
    
}

-(void)viewDidLoad{

    [super viewDidLoad];
    [self customizeInterface];
    
    [self.collectionView registerClass:[avatarCell class] forCellWithReuseIdentifier:@"avatarCell"];

    PFQuery *query = [PFQuery queryWithClassName:@"Avatar"];
    [query whereKey:@"category" equalTo:self.category];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 60 * 60 * 24;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            avatars = [[NSArray alloc]initWithArray:objects];
            [collectionView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 16;//[avatars count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    avatarCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"avatarCell" forIndexPath:indexPath];
    
    PFObject * avatarRow = [avatars objectAtIndex:indexPath.row];
    
    PFFile * avatarImageFile =[avatarRow objectForKey:@"image"];
    
    [cell initWithFile:avatarImageFile];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    PFObject *selectedAvatar =    [avatars objectAtIndex:indexPath.row];
    NSString *avatarId =selectedAvatar.objectId;
    
    
    [delegate selectAvatarViewController:self didSelectAvaterID:avatarId];

}
-(void)goback{

    [delegate selectAvatarViewControllerDidCancel:self];
}
#pragma mark – UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

@end
