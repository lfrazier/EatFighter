//
//  InstructionsViewController.h
//  EatFighter
//
//  Created by Lauren Frazier on 4/27/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)close:(id)sender;

@end
