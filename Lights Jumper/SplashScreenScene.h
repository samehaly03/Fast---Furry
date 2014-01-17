//
//  FirstScene.h
//  ScenesAndLayers
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SplashScreenScene : CCLayer 
{
	CCSprite * logo_CCSprite;
    CCAction * logo_CCAction;
}

+(id) scene;

-(void)setupLogo;
-(void)setupTimer:(int)delay;
-(void)showGame;



-(void)setupBackground;

@end
