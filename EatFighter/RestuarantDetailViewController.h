//
//  RestuarantDetailViewController.h
//  EatFighter
//
//  Created by Lauren Frazier on 4/28/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestuarantDetailViewController : UIViewController <UITextFieldDelegate> {
    int restaurantID;
}

- (id)initWithRestaurantID:(int)restID;
- (IBAction)valueChanged:(UIStepper *)sender;

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIStepper *stepper;

@end
