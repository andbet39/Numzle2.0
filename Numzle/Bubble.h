//
//  Bubble.h
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 04/02/13.
//
//
#import "cocos2d.h"
#import "Box2D.h"


@interface Bubble : CCSprite
{
    b2Body *body;
    b2World *myWorld;
    
    int _value;
    int _bonus;
    CCTexture2D *spriteTexture_;
    
}
@property(readwrite)int value;
@property(readwrite)int bonus;
-(id)initWithWorld:(b2World*)world andPosition:(CGPoint)position andValue:(int)Value andBonus:(int)Bonus andtexture:(CCTexture2D*)texture;

-(void)hit;
@end
