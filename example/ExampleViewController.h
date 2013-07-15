//
//  SLGViewController.h
//  SLGSlideShowView
//
//  Created by Steven Grace on 7/13/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLGSlideshowView;

@interface ExampleViewController : UIViewController

@property(nonatomic,readwrite)IBOutlet SLGSlideshowView *slideShowView;

@property(nonatomic,readwrite)IBOutlet UIToolbar *toolbar;
@property(nonatomic,readwrite)IBOutlet UIBarButtonItem *previousButton;
@property(nonatomic,readwrite)IBOutlet UIBarButtonItem *playButton;
@property(nonatomic,readwrite)IBOutlet UIBarButtonItem *nextButton;

-(IBAction)previousButtonAction:(id)sender;
-(IBAction)playButtonAction:(id)sender;
-(IBAction)nextButtonAction:(id)sender;



@end
