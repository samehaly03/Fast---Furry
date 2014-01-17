//
//  MainMenu.h
//  Lights Jumper
//
//  Created by Sameh Aly on 5/1/12.
//  Copyright 2012 Extreme Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenu : CCLayer 
{
    CGSize winSize;
    
    BOOL isMusicOff;
    
    CCSprite *background1;
    CCSprite *background2;
    
    CCSprite *play;
    CCSprite *audio;
    CCSprite *gameCenter;
    
    CCSprite* _player;
    
    CCSpriteBatchNode *spriteSheet;
    CCAction *flyAction;
    NSMutableArray *flyAnimFrames;
    CCAnimation *flyAnim;
}

+(CCScene *) scene;

- (void) setupBackground;
- (void) moveBackground;
- (void) animateMouse;
- (void) setupButtons;
- (void) gotoGame;
- (void) toggleAudio;
- (void) setupAudio;

@end
