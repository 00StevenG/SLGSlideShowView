//
//  SLGImageSlideshowView.h
//
//  Created by Steven Grace on 1/11/13.
//
//

#import <UIKit/UIKit.h>

@protocol SLGSlideshowViewDatasource;
@protocol SLGSlideshowViewDelegate;


@interface SLGSlideshowView : UIView



// duration of the transition between slides
@property(nonatomic,readwrite)NSTimeInterval transitionDuration;
// duration to present each item
@property(nonatomic,readwrite)NSTimeInterval slideDuration;

// repeat slideshow
@property(nonatomic,readwrite)BOOL autoRepeat;

// UIViewAnimationOptionTransition
//(defaults to UIViewAnimationOptionTransitionCrossDissolve if passed invalid option)
@property(nonatomic,readwrite)NSUInteger transitionOption;

@property(nonatomic,readwrite,weak)IBOutlet id<SLGSlideshowViewDatasource>datasource;
@property(nonatomic,readwrite,weak)IBOutlet id<SLGSlideshowViewDelegate>delegate;

@property(nonatomic,readonly)NSUInteger currentSection;


/** PRESENTATION **/
-(void)beginSlideShow;
-(void)stopSlideShow;
-(void)pauseResumeSlideShow;
-(void)previousImage; 
-(void)nextImage;



@end


@protocol SLGSlideshowViewDatasource <NSObject>

-(NSUInteger)numberOfSectionsInSlideshow:(SLGSlideshowView*)slideShowView;
-(NSInteger)numberOfItems:(SLGSlideshowView*)slideShowView inSection:(NSUInteger)section;
-(UIView*)viewForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath;


@optional
-(NSTimeInterval)slideDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath;
-(NSTimeInterval)transitionDurationForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath;


-(NSUInteger)transitionStyleForSlideShow:(SLGSlideshowView*)slideShowView atIndexPath:(NSIndexPath*)indexPath;

@end


@protocol SLGSlideshowViewDelegate <NSObject>

@optional
-(void)slideShowViewDidEnd:(SLGSlideshowView*)slideShowView willRepeat:(BOOL)willRepeat;



-(void)slideShowView:(SLGSlideshowView*)slideShowView willDisplaySlideAtIndexPath:(NSIndexPath*)indexPath;
-(void)slideShowView:(SLGSlideshowView*)slideShowView didDisplaySlideAtIndexPath:(NSIndexPath*)indexPath;

-(void)slideShowView:(SLGSlideshowView*)slideShowView willBeginSection:(NSUInteger)section;
-(void)slideShowView:(SLGSlideshowView*)slideShowView didBeginSection:(NSUInteger)section;


-(void)slideShowViewDidPause:(SLGSlideshowView*)slideShowView;
-(void)slideShowViewDidResume:(SLGSlideshowView*)slideShowView;


@end


