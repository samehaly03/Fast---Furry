//
//  Monster.m
//  Ninjas
//
//  Created by Sameh Aly on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Light.h"


@implementation Light

@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;

@end


@implementation Coin

+ (id) light
{    
    Coin *light = nil;

    if ((light = [[[super alloc] initWithFile:@"coin.png"] autorelease])) 
    {
        light.minMoveDuration = 15;
        light.maxMoveDuration = 20;
    }
	
	return light;
    
}

@end

@implementation Laser

+ (id) light
{    
    Laser *light = nil;
    
    if ((light = [[[super alloc] initWithFile:@"laser.png"] autorelease])) 
    {
        light.minMoveDuration = 15;
        light.maxMoveDuration = 20;
    }

	
	return light;
    
}

@end

@implementation Cat

+ (id) light
{    
    Cat *light = nil;
    
    if ((light = [[[super alloc] initWithFile:@"object_sleepingcat.png"] autorelease]))
    {
        light.minMoveDuration = 20;
        light.maxMoveDuration = 30;
    }
    
	
	return light;
    
}

@end

@implementation Dog

+ (id) light
{    
    Dog *light = nil;
    
    if ((light = [[[super alloc] initWithFile:@"object_sleepingdog.png"] autorelease]))
    {
        light.minMoveDuration = 20;
        light.maxMoveDuration = 30;
    }
    
	
	return light;
    
}

@end

@implementation Cheese

+ (id) light
{    
    Cheese *light = nil;
    
    if ((light = [[[super alloc] initWithFile:@"cheese.png"] autorelease]))
    {
        light.minMoveDuration = 20;
        light.maxMoveDuration = 30;
    }

	
	return light;
    
}

@end

