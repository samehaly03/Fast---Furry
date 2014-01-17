//
//  Monster.h
//  Ninjas
//
//  Created by Sameh Aly on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface Light : CCSprite 
{
	
	int _minMoveDuration;
	int _maxMoveDuration;

}

@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

@end

@interface Coin : Light
{
			
}
	
+ (id) light;

@end

@interface Laser : Light
{
	
}

+ (id) light;

@end

@interface Cat : Light
{
	
}

+ (id) light;

@end

@interface Dog : Light
{
	
}

+ (id) light;

@end

@interface Cheese : Light
{
	
}

+ (id) light;


@end


