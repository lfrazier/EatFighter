//
//  FightScene.h
//  EatFighter
//
//  Created by Lauren Frazier on 4/26/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "CCScene.h"
#import "ZJoystick.h"
#import "Restaurant.h"

@interface FightScene : CCScene <ZJoystickDelegate> {
    Restaurant *restaurant;
}

- (id)initWithRestaurant:(NSDictionary *)dict;

@end
