//
//  RestaurantViewController.h
//  EatFighter
//
//  Created by Lauren Frazier on 4/27/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RestaurantViewController : UITableViewController <UIAlertViewDelegate> {
    NSIndexPath *indexPathToDelete; // For the tableView
    int indexToDelete; // For the array
}

@property (nonatomic, retain) NSIndexPath *indexPathToDelete;

@end
