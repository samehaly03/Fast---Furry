//
//  HelloWorldLayer.h
//  Lights Jumper
//
//  Created by Sameh Aly on 4/16/12.
//  Copyright Extreme Solution 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "HUDLayer.h"
#import "iAd/ADBannerView.h"

// HelloWorldLayer
@interface GameScene : CCLayer <ADBannerViewDelegate>
{
    
    BOOL isMusicOff;
    
    float xForce;
    float yForce;
    
	GLESDebugDraw *m_debugDraw;
    HUDLayer *_hud;
    
    CCLabelTTF *label;
    
    CGRect spriteRect;
    CGRect playerRect;
    
    CGSize winSize;
    
    int score;
    int cheeseScore;
    int timeScore;
    
    b2World *_world;
    b2Body *_body;
    b2BodyDef ballBodyDef;
    
    b2Body *groundBody;
    
    int boxWidth ;
    int boxHeight;
    
    BOOL isPaused;
    BOOL isTouched;
    
    CCSprite* _player;
    
    
    BOOL isWalking;
    BOOL isFlying;
    BOOL isDying;
    
    CCAction *walkAction;
    CCSpriteBatchNode *spriteSheet;
    NSMutableArray *walkAnimFrames;
    CCAnimation *walkAnim;
    
    CCAction *flyAction;
    NSMutableArray *flyAnimFrames;
    CCAnimation *flyAnim;
    
    CCAction *dieAction;
    NSMutableArray *dieAnimFrames;
    CCAnimation *dieAnim;
}

@property (retain) HUDLayer *_hud;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (id)initWithHUD:(HUDLayer *)hud;
- (void) setupWorld;
- (void) destroyPlayerBody;
- (void) resetPlayerBody;
- (void) addTarget;
- (void) gameLogic:(ccTime)dt;
- (void) spriteMoveFinished:(id)sender;
- (void) scale:(CGFloat) newScale scaleCenter:(CGPoint) scaleCenter;
- (void) startGame;
- (void) stopGame;
- (void) checkForCollision;
- (void) setupBackground;
- (void) addCoin;
- (void) setLabels;

@end
