//
//  DislayLayer.m
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 06/02/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DisplayLayer.h"

#define MAX_CIFER 3

@implementation DisplayLayer


-(id) init
{
	if( (self=[super init])) {
    
        CGSize s = [CCDirector sharedDirector].winSize;

        CCSprite *hudSprite = [CCSprite spriteWithFile:@"displayBackground.png"];
        hudSprite.position=ccp( s.width/2, (s.height-(hudSprite.contentSize.height/2))-20);
        
        [self addChild:hudSprite z:10];

        displayString = @"       ";
        score = 0;
        
        
        targetNum =[[GameManager sharedInstance].numberToHit intValue];//(arc4random()%900)+100;
        
        
        GameManager * gm  = [GameManager sharedInstance];
        
        
        bubbleOperandA = [[NSMutableArray alloc]init];
        bubbleOperandB = [[NSMutableArray alloc]init];
        operatorString=@"";
        
        CCLabelBMFont * targetLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",targetNum] fntFile:@"helveticaCondRosso20.fnt"];
     
        targetLabel.position = ccp( s.width -40 , s.height-82);
        targetLabel.scale=1.3;
        [self addChild:targetLabel z:11];
        
        
        risutato = [CCLabelBMFont labelWithString:@"0" fntFile:@"futuraBianco30.fnt"];
       // [self addChild:risutato z:11];
       // risutato.position = ccp(s.width -40 , s.height-86);
        
        displayLabel = [CCLabelBMFont labelWithString:displayString fntFile:@"helveticaCondBianco20.fnt"];
        displayLabel.anchorPoint = ccp(0.0f,0.5f);
        displayLabel.position = ccp(20, s.height-82);
        displayLabel.scale=1.3;
		[self addChild:displayLabel z:11];
        
        scoreLabel =[CCLabelBMFont labelWithString:@"Score: 0" fntFile:@"futuraBianco30.fnt" ];
        
        scoreLabel.alignment=kCCTextAlignmentLeft;
        scoreLabel.anchorPoint = ccp(0.0f,0.5f);
		scoreLabel.position = ccp( 10, s.height-45);
        
        [self addChild:scoreLabel z:11];
       
        popScoreLabel= [CCLabelBMFont labelWithString:@"0" fntFile:@"helveticaCondRosso20.fnt"];
        popScoreLabel.scale=0.8;
        popScoreLabel.position= ccp( s.width/2, s.height-78);
        popScoreLabel.visible=false;
        
        [self addChild:popScoreLabel z:12];

        
        currentCifer =0 ;
        
        
    }

    return  self;
    
}



-(int)addBubble:(Bubble*) bubble{

    
  
    if ([bubbleOperandA count]<MAX_CIFER && [operatorString length]==0) {
        
        [bubbleOperandA addObject:bubble ];
        [[SoundManager sharedInstance ]playBubblePickCoin];
        [displayLabel setString:[self calcOperationString]];
        return [bubbleOperandA indexOfObject:bubble];

    }
    if ([bubbleOperandA count]>=1 && [operatorString length]>0 && [bubbleOperandB count]<MAX_CIFER){

        [bubbleOperandB addObject:bubble];
        [[SoundManager sharedInstance ]playBubblePickCoin];
        [displayLabel setString:[self calcOperationString]];

        return [bubbleOperandB indexOfObject:bubble];

    }

    return -1;

}
-(int)addOperand:(NSString *) operatore
{
    if ([bubbleOperandA count]>0 && [operatorString isEqualToString:@""]){
        operatorString=[NSString stringWithFormat:@"%@",operatore ];
        [displayLabel setString:[self calcOperationString]];
        [[SoundManager sharedInstance ]playBubblePickCoin];

        return 1;
    }
    
    return -1;

}





-(int)addCifer:(NSString *) cifer{

    if ([cifer isEqualToString:@"="]) {
        
        if ([bubbleOperandA count]>0 && [bubbleOperandB count]>0) {
            NSLog(@"Calcolo il risultato");
            
            score +=[self calcolaPunteggio];
            [self popResult:[self calcolaPunteggio]];
            scoreLabel.string = [NSString stringWithFormat:@"Score: %d", score ];
            
            GameManager *gm =[GameManager sharedInstance];
            [gm addResult:[self calcolaPunteggio]];
            [gm addOperation:[self calcOperationString]];
            
            [bubbleOperandB removeAllObjects];
            [bubbleOperandA removeAllObjects];
            operatorString=@"";
            
            displayString = @"";

            currentCifer=0;
        }
    }
    
    
    return -1;
}

-(int)calcolaRisultato{

    int firstOperand=[self calcolaValoreForArray:bubbleOperandA];
    int secondOperand=[self calcolaValoreForArray:bubbleOperandB];
    
    
    int result =0;
    
    if ([operatorString isEqualToString:@"+"]) {
        result = firstOperand+secondOperand;
    }
    if ([operatorString isEqualToString:@"-"]) {
        result = firstOperand-secondOperand;
    }
    if ([operatorString isEqualToString:@"*"]) {
        result = firstOperand*secondOperand;
    }
    if ([operatorString isEqualToString:@"/"]) {
        result = firstOperand/secondOperand;
    }
    
    return result;
    
}

-(int)calcolaPunteggio{
    
    int result = 0;
    
    int risultato = [self calcolaRisultato];
    
    float adj_differenza  = 1;
    int bonusA=1;
    int bonusB=1;
    
    for (Bubble * b in bubbleOperandA) {
        bonusA=bonusA*(b.bonus+1);
    }

    for (Bubble * b in bubbleOperandB) {
        bonusB=bonusB*(b.bonus+1);
   }
    
    
    if (risultato<=targetNum) {
        adj_differenza=(float)risultato/(float)targetNum ;
    }else{
        adj_differenza=(float)targetNum/(float)risultato;
    }
    
    if(adj_differenza<0.8){
        adj_differenza=0;
    }
    
    if (adj_differenza>=1) {
        adj_differenza=1.5;
    }
    
    int valorePrimoOperando = [bubbleOperandA count]*5*bonusA;
    int valoreSecondoOperando = [bubbleOperandB count]*5*bonusB;
    
    int valoreOperatore = 0;
    
    if ([operatorString isEqualToString:@"*"] || [operatorString isEqualToString:@"/"]  ) {
        valoreOperatore=50;
    }
    
    if ([operatorString isEqualToString:@"+"] || [operatorString isEqualToString:@"-"]  ) {
        valoreOperatore=35;
    }
    
    result = ((float)((valorePrimoOperando+valoreSecondoOperando)*valoreOperatore)*adj_differenza);
    
    if (result<0) {
        result = 1;
    }
    return result;
}



-(int)calcolaValoreForArray:(NSMutableArray*)bubbleArray{

    NSString *resultString= @"";
    
    for (Bubble * b in bubbleArray) {
        NSString *valore = [NSString stringWithFormat:@"%d",b.value];
        resultString = [resultString stringByAppendingString:valore];
    }
    return [resultString intValue];
}


-(NSString *)calcOperationString{

    NSString * resultString = [[NSString alloc]init];

    for (Bubble * b in bubbleOperandA) {
        NSString *valore = [NSString stringWithFormat:@"%d",b.value];
        resultString = [resultString stringByAppendingString:valore];
    }
    
    resultString = [resultString stringByAppendingString:operatorString];
    
    for (Bubble * b in bubbleOperandB) {
        NSString *valore = [NSString stringWithFormat:@"%d",b.value];
        resultString = [resultString stringByAppendingString:valore];
    }
    
    return resultString;

}

-(void)popResult:(int)result
{
    [[SoundManager sharedInstance]playAddOperation1];
    popScoreLabel.string = [NSString stringWithFormat:@"+%d",result];
    
    popScoreLabel.visible=true;
    
    CCMoveBy *moveBy = [CCMoveBy actionWithDuration:0.3 position:CGPointMake(0, 40)];
    CCScaleBy * scaleBy = [CCScaleBy actionWithDuration:0.3 scale:1.5];
    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.3 opacity:0];

    id myCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(resetPopLabel)]; // to call our method
    
    [popScoreLabel runAction:
     [CCSequence actions:
    moveBy, scaleBy,fadeIn,myCallFunc,
      nil]];
    

}

-(void)resetPopLabel{
    
    CGSize s = [CCDirector sharedDirector].winSize;

    popScoreLabel.string =@"";
    popScoreLabel.opacity=255;
    
    popScoreLabel.scale=0.8;
    popScoreLabel.position= ccp( s.width/2, s.height-78);
    popScoreLabel.visible=false;

}
@end
