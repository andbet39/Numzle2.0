//
//  SoundManager.m
//  Numzle
//
//  Created by Andrea Terzani on 12/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "SoundManager.h"
#import "SimpleAudioEngine.h"   //ADDED
#import "CocosDenshion.h"        //ADDED
#import "CDAudioManager.h"     //ADDED

#define BubblePickUP @"numberpick.wav"
#define AdddOperation1 @"addedOperation.wav"
#define InizioGame @"inizioGame.wav"
#define tickSound @"histicks.wav"


@implementation SoundManager



static SoundManager *sharedManager = nil;
+ (SoundManager *) sharedInstance {
    if (!sharedManager) {
        sharedManager = [[SoundManager alloc] init];
        
        
    }
    return sharedManager;
}


-(id)init{

    if (self=[super init]) {
        
        SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
        [engine preloadEffect:BubblePickUP];
        [engine preloadEffect:AdddOperation1];
        [engine preloadEffect:InizioGame];
        [engine preloadEffect:tickSound];
    }
    
    return self;

}

-(void)mute{

    [SimpleAudioEngine sharedEngine].mute=TRUE;
}
-(void)unmute{
    
    [SimpleAudioEngine sharedEngine].mute=FALSE;
}

-(void)playBubblePickCoin
{
    
    [[SimpleAudioEngine sharedEngine]playEffect:BubblePickUP];
    
}

-(void)playAddOperation1
{
    
    [[SimpleAudioEngine sharedEngine]playEffect:AdddOperation1];
    
}

-(void)playInizioGame{
    
    [[SimpleAudioEngine sharedEngine]playEffect:InizioGame];
    
}

-(void)playTickSound{
    
    [[SimpleAudioEngine sharedEngine]playEffect:tickSound];
    
}
@end
