//
//  Bubble.m
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 04/02/13.
//
//

#import "Bubble.h"

#define PTM_RATIO 32

@implementation Bubble

@synthesize value=_value;
@synthesize bonus=_bonus;

-(id)initWithWorld:(b2World*)world andPosition:(CGPoint)position andValue:(int)Value andBonus:(int)Bonus andtexture:(CCTexture2D*)texture
{

     if( (self= [super initWithTexture:texture rect:CGRectMake(72 * Value,0,72,72)])) {
    //if( (self=[super init])) {
	    self.position=position;
        _value=Value;
         _bonus=Bonus;
        spriteTexture_=texture;
        ;
        
         myWorld=world;
         
         
    // Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2CircleShape dynamicBubble;
	dynamicBubble.m_radius=38.0f/PTM_RATIO;
    
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBubble;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
    body->ApplyLinearImpulse(b2Vec2(0, 6), body->GetWorldCenter());
        
    //body->SetUserData();
         
         [self setUserData:body];
         
         CCSprite * bonusHint;
         
         if (_bonus>0) {
             bonusHint = [CCSprite spriteWithFile:@"bonusTip.png" rect:CGRectMake((_bonus-1)*20, 0, 20, 14)];
             bonusHint.position=ccp(61,37);
             [self addChild:bonusHint z:2];

         }
         
    }
    return  self;
}


// returns the transform matrix according the Chipmunk Body values
-(CGAffineTransform) nodeToParentTransform
{
	b2Vec2 pos  = body->GetPosition();
	
	float x = pos.x * PTM_RATIO;
	float y = pos.y * PTM_RATIO;
	
	if ( ignoreAnchorPointForPosition_ ) {
		x += anchorPointInPoints_.x;
		y += anchorPointInPoints_.y;
	}
	
	// Make matrix
	float radians = body->GetAngle();
	float c = cosf(radians);
	float s = sinf(radians);
	
	if( ! CGPointEqualToPoint(anchorPointInPoints_, CGPointZero) ){
		x += c*-anchorPointInPoints_.x + -s*-anchorPointInPoints_.y;
		y += s*-anchorPointInPoints_.x + c*-anchorPointInPoints_.y;
	}
	
	// Rot, Translate Matrix
	transform_ = CGAffineTransformMake( c,  s,
									   -s,	c,
									   x,	y );
	
	return transform_;
}

-(void)hit{

    
    
    myWorld->DestroyBody(body);
    
    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.2 opacity:0];

    
    id myCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(remove)]; // to call our method
    
    [self runAction:
     [CCSequence actions:
       fadeIn,myCallFunc,
      nil]];
    
    
    
}

-(void)remove{

    [self removeFromParentAndCleanup:YES];

}



@end
