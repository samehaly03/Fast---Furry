//
//  SplashScreenScene.m
//  ScenesAndLayers
//

#import "SplashScreenScene.h"
#import "GameScene.h"
#import "MainMenu.h"


@implementation SplashScreenScene
//++++++++++++++++++++++++++++++++++++
+(id) scene
{
	//CCLOG(@"===========================================");
	//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	CCScene* scene = [CCScene node];
	SplashScreenScene* layer = [SplashScreenScene node];
	[scene addChild:layer];
	return scene;
}
//++++++++++++++++++++++++++++++++++++
-(id) init
{
	if ((self = [super init]))
	{
		//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
		
        [self setupBackground];
        
        [self setupLogo];
        
        //[self setupLogoAnimation:@"splash" withFrameCount:2 withDelay:0.3];
        
        [self setupTimer:2.0];

		//self.isTouchEnabled = YES;
	}
	return self;
}
//++++++++++++++++++++++++++++++++++++
-(void) dealloc
{
	//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[logo_CCSprite stopAllActions];
    
    
    [self removeAllChildrenWithCleanup:YES];
    [self unscheduleAllSelectors];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures]; // since v0.8
    [self removeFromParentAndCleanup:YES];
	// don't forget to call "super dealloc"
	[super dealloc];
}
//++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++
-(void)setupLogo
{
    logo_CCSprite =[CCSprite spriteWithFile:@"Logo.png"];  
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    logo_CCSprite.position =ccp(screenSize.width/2, screenSize.height/2);
    
    [self addChild:logo_CCSprite];
}
//++++++++++++++++++++++++++++++++++++
-(void)setupTimer:(int)delay
{
       
    [self performSelector:@selector(showGame) withObject:nil afterDelay:delay];
}
//++++++++++++++++++++++++++++++++++++
-(void)showGame
{
    CCScene * mainmenu = [MainMenu scene];
    CCTransitionFade * fadeTransitions = [CCTransitionFade transitionWithDuration:1 scene:mainmenu withColor:ccBLACK];
    
	[[CCDirector sharedDirector] replaceScene:fadeTransitions];
    
   // CCTransitionFade
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-(void)setupLogoAnimation :(NSString*)spriteFileName withFrameCount:(int)frameCount withDelay:(float)delay
{
    
    CCAnimation * animation = [CCAnimation animation]; 
    
    [animation addFrameWithFilename:[NSString stringWithFormat:@"%@0.png",spriteFileName]];
    [animation addFrameWithFilename:[NSString stringWithFormat:@"%@1.png",spriteFileName]];
    [animation addFrameWithFilename:[NSString stringWithFormat:@"%@0.png",spriteFileName]];
    
    [animation setDelay:delay];
      
    logo_CCAction = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES];
    
    
    [logo_CCSprite runAction:logo_CCAction];
    
}
//+++++++++++++++++++++++++++++++++++++++++++++++++
-(void)setupBackground
{
    CCLayerColor * layer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
    
    [self addChild:layer];
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
@end
