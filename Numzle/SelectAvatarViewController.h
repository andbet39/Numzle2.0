//
//  SelectAvatarViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 15/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectAvatarViewController;

@protocol selectAvaterViewControllerDelegate

-(void)selectAvatarViewController:(SelectAvatarViewController*)sender didSelectAvaterID:(NSString*)avatarID;
-(void)selectAvatarViewControllerDidCancel:(SelectAvatarViewController*)sender;


@end
@interface SelectAvatarViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak,nonatomic)id<selectAvaterViewControllerDelegate>delegate;
@property(strong,nonatomic)NSString * category;

@end
