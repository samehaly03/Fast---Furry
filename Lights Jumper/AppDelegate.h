//
//  AppDelegate.h
//  Lights Jumper
//
//  Created by Sameh Aly on 4/16/12.
//  Copyright Extreme Solution 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
