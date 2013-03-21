//
//  HelloWorldLayer.h
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 04/02/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


#import "DisplayLayer.h"
#import "GameOverLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
@class HelloWorldLayer;

@protocol HelloWorldLayerDelegate <NSObject>

-(void)didEndGame:(HelloWorldLayer *)sender;

@end

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
    DisplayLayer * mainDisplay;
    
    
    NSMutableArray * bubblesArray;
    float total_time;
    
    CCLabelTTF *label;
    CCLabelBMFont *timeLabel;
    
    bool tickScheduled;
    float game_time;
    
    bool started;

    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) sceneWithDelegate:(id<HelloWorldLayerDelegate>)delegate;


@end
