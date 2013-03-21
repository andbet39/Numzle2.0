//
//  SoundManager.h
//  Numzle
//
//  Created by Andrea Terzani on 12/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface SoundManager : NSObject

+ (SoundManager *) sharedInstance ;
-(void)playBubblePickCoin;
-(void)playAddOperation1;
-(void)playInizioGame;

-(void)playTickSound;
-(void)mute;
-(void)unmute;
@end
