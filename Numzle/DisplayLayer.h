//
//  DislayLayer.h
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 06/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameManager.h"
#import "Bubble.h"

#import "SoundManager.h"
@interface DisplayLayer : CCNode {
    
    CCLabelBMFont * displayLabel;
    CCLabelBMFont * risutato ;
    int currentCifer;
    
    NSString* displayString;
    
    int score;
    int targetNum;
    
    
    CCLabelBMFont * scoreLabel;
    
    
    CCLabelBMFont * popScoreLabel;
    
    
    NSMutableArray * bubbleOperandA;
    NSMutableArray * bubbleOperandB;
    NSString * operatorString;
    
}


-(int)addCifer:(NSString *) cifer;
-(int)calcolaRisultato;
-(int)addBubble:(Bubble*) bubble;
-(int)addOperand:(NSString *) operatore;
@end
