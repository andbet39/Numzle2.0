//
//  GameOverLayer.m
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 06/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"


@implementation GameOverLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		
        CCSprite *backGround = [CCSprite spriteWithFile:@"background.png"];
        backGround.position=ccp( s.width/2, s.height/2);
        
        [self addChild:backGround z:0];
        
        GameManager * gm =[GameManager sharedInstance];
        
        CCLabelTTF * totalLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[gm getGrandTotal]] fontName:@"Marker Felt" fontSize:50];
		[self addChild:totalLabel z:11];
		[totalLabel setColor:ccc3(0,255,255)];
		totalLabel.position = ccp( s.width/2, s.height/2);
        
        
        CCLabelTTF * numberLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"N. oper. %d",[gm getOperationNumber]] fontName:@"Marker Felt" fontSize:50];
		[self addChild:numberLabel z:11];
		[numberLabel setColor:ccc3(0,255,255)];
		numberLabel.position = ccp( s.width/2, s.height/2+40);
        
        
        CCMenuItem *itemStart = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"uguale.png"] selectedSprite:[CCSprite spriteWithFile:@"uguale.png"] block:^(id sender) {
            
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameMenuLayer scene] withColor:ccWHITE]];
            
            
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:itemStart, nil];
        
        [menu alignItemsHorizontallyWithPadding:5];
        //[menu alignItemsVertically];
        CGSize size = [[CCDirector sharedDirector] winSize];
        [menu setPosition:ccp( size.width/2, 40)];
        [self addChild:menu z:11];
        
        
	}
	return self;
}
@end
