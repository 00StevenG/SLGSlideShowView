//
//  SLGViewController.m
//  SLGSlideShowView
//
//  Created by Steven Grace on 7/13/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "ExampleViewController.h"
#import "SLGSlideshowView.h"

@interface ExampleViewController () <SLGSlideshowViewDatasource,SLGSlideshowViewDelegate>


@end

@implementation ExampleViewController{
    
    NSArray *_slideshowData;

    NSArray *_transitionOptions;
    
}

#pragma mark View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    
     _transitionOptions= @[[NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromLeft],
                         [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromRight],
                         [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlUp],
                         [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCurlDown],
                         [NSNumber numberWithInteger:UIViewAnimationOptionTransitionCrossDissolve],
                         [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromTop],
                         [NSNumber numberWithInteger:UIViewAnimationOptionTransitionFlipFromBottom]];
    
    NSArray* section1 = @[@"flower1.jpg",@"flower2.jpg",@"flower3.jpg"];
    NSArray* section2 = @[@"flower4.jpg",@"flower5.jpg",@"flower6.jpg",@"flower7.jpg"];
    
    _slideshowData =[NSArray arrayWithObjects:section1,section2,nil];
    
    self.slideShowView.slideDuration = 4.5;
    self.slideShowView.transitionDuration= 5.5;
    self.slideShowView.transitionOption = UIViewAnimationOptionTransitionFlipFromLeft;

}
-(void)viewDidAppear:(BOOL)animated{
    
    [self.slideShowView beginSlideShow];
    
}
#pragma mark - Actions
-(IBAction)previousButtonAction:(id)sender{
    
    [self.slideShowView previousImage];
}
-(IBAction)playButtonAction:(id)sender{
    
    [self.slideShowView pauseResumeSlideShow];
}
-(IBAction)nextButtonAction:(id)sender{
    
    
    [self.slideShowView nextImage];
    
}
#pragma mark - Datasource
-(NSUInteger)numberOfSectionsInSlideshow:(SLGSlideshowView*)slideShowView{
    
    return [_slideshowData count];
    
}
-(NSInteger)numberOfItems:(SLGSlideshowView*)slideShowView inSection:(NSUInteger)section{
 
    return [[_slideshowData objectAtIndex:section]count];
}
-(UIView*)viewForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    NSString* imageName = [[_slideshowData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    UIImage* img  = [UIImage imageNamed:imageName];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

-(NSTimeInterval)slideDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    return arc4random()%4;
    
}

-(NSUInteger)transitionStyleForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    

    NSUInteger rIndex = arc4random()%[_transitionOptions count];
    return [[_transitionOptions objectAtIndex:rIndex]integerValue];
    
}

-(NSTimeInterval)transitionDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath{
    
    return (arc4random()%(4-1))+1;
    
}

#pragma mark - SlideShowDelegate
-(void)slideShowViewDidEnd:(SLGSlideshowView*)slideShowView willRepeat:(BOOL)willRepeat{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView willDisplaySlideAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"%s: %i : %i",__PRETTY_FUNCTION__,indexPath.section,indexPath.row);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView didDisplaySlideAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"%s: %i : %i",__PRETTY_FUNCTION__,indexPath.section,indexPath.row);
}
-(void)slideShowView:(SLGSlideshowView*)slideShowView willBeginSection:(NSUInteger)section{
    NSLog(@"%s:%i",__PRETTY_FUNCTION__,section);

}
-(void)slideShowView:(SLGSlideshowView*)slideShowView didBeginSection:(NSUInteger)section{
    NSLog(@"%s:%i",__PRETTY_FUNCTION__,section);
    
}
-(void)slideShowViewDidPause:(SLGSlideshowView*)slideShowView{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
-(void)slideShowViewDidResume:(SLGSlideshowView*)slideShowView{
    NSLog(@"%s",__PRETTY_FUNCTION__);    
}

@end
