//
//  MainMenuScene.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/26/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "MainMenuScene.h"
#import "FightScene.h"
#import "AppDelegate.h"
#import "InstructionsViewController.h"
#import "RestaurantViewController.h"

@implementation MainMenuScene

- (id)init {
    self = [super init];
    if (self) {
        [CCMenuItemFont setFontName:@"Aldo the Apache"];
        [CCMenuItemFont setFontSize:50];
        CCMenuItemFont *startNew = [CCMenuItemFont itemWithString:@"New Game" target:self selector: @selector(newGame)];
        CCMenuItemFont *leaveReview = [CCMenuItemFont itemWithString:@"Write a Review" target:self selector: @selector(writeReview)];
        CCMenuItemFont *instructions = [CCMenuItemFont itemWithString:@"Instructions" target:self selector: @selector(showInstructions)];
        CCMenu *menu = [CCMenu menuWithItems:startNew, leaveReview, instructions, nil];
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu];
    }
    return self;
}

- (void)newGame {
    ((AppController *)[UIApplication sharedApplication].delegate).currentRestaurantIndex = 0;
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"stars" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants sortUsingDescriptors:sortDescriptors];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"restaurants.txt"];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants writeToFile:fileName atomically:YES];

    NSDictionary *dict = [((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:0];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionProgressRadialCW transitionWithDuration:0.5 scene:[[FightScene alloc] initWithRestaurant:dict]]];
}

- (void)writeReview {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[RestaurantViewController alloc] init]];
    [((AppController *)[UIApplication sharedApplication].delegate).navController presentViewController:navController animated:YES completion:nil];
}

- (void)showInstructions {
    InstructionsViewController *instructions = [[InstructionsViewController alloc] init];
    [((AppController *)[UIApplication sharedApplication].delegate).navController presentViewController:instructions animated:YES completion:nil];
}

@end
