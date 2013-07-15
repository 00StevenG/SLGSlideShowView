//
//  SLGImageSlideshowView.m
//
//  Created by Steven Grace on 1/11/13.
//
//

#import "SLGSlideshowView.h"

@interface SLGSlideshowView()


@property(nonatomic,readwrite,assign)NSUInteger currentSection;

@end

@implementation SLGSlideshowView{
    
    UIView* _currentView;
    NSArray* _indexPaths;
    NSUInteger _counter;
    BOOL _isPaused;
    
    
}
#pragma mark - INIT
//
//
//
-(void)_initImageSlideshowViewVars{

    _transitionDuration = 2;
    _transitionOption = UIViewAnimationOptionTransitionCrossDissolve;
    _slideDuration = 4;
    _autoRepeat = YES;
    _counter = 0;
}
//
//
//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initImageSlideshowViewVars];
    }
    return self;
}
//
//
//
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if(self){
        [self _initImageSlideshowViewVars];
    }
    return self;
}
#pragma mark - Option Validation
//
//
//
+(NSUInteger)_validTransitionOption:(NSUInteger)transitionOption{
    
    if(transitionOption != UIViewAnimationOptionTransitionNone &&
       transitionOption != UIViewAnimationOptionTransitionFlipFromLeft &&
       transitionOption != UIViewAnimationOptionTransitionFlipFromRight &&
       transitionOption != UIViewAnimationOptionTransitionCurlUp &&
       transitionOption != UIViewAnimationOptionTransitionCurlDown &&
       transitionOption != UIViewAnimationOptionTransitionCrossDissolve &&
       transitionOption != UIViewAnimationOptionTransitionFlipFromTop &&
       transitionOption != UIViewAnimationOptionTransitionFlipFromBottom){
        
        return UIViewAnimationOptionTransitionCrossDissolve;
        
    }
    return transitionOption;

}
#pragma mark - Setters
//
//
//
-(void)setTransitionOption:(NSUInteger)transitionOption{
    
    if(_transitionOption != transitionOption){
        
        _transitionOption = [[self class]_validTransitionOption:transitionOption];
        
    }

}
#pragma mark - Public
//
//
//
-(void)beginSlideShow{
    
    [self _prepareForSlideShow];
    
    [self _transitionToNextSlide];
}
//
//
//
-(void)stopSlideShow{
    
   [self _reset];
}
//
//
//
-(void)pauseResumeSlideShow{
    
    
    if(_isPaused==NO){
        _isPaused = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        if([self.delegate respondsToSelector:@selector(slideShowViewDidPause:)])
            [self.delegate slideShowViewDidPause:self];
        
    }
    else{
        _isPaused = NO;
        
        if([self.delegate respondsToSelector:@selector(slideShowViewDidResume:)])
            [self.delegate slideShowViewDidResume:self];
        
        [self _transitionToNextSlide];
    }
}
//
//
//
-(void)previousImage{
    
    if(_counter<=1)
        return;

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    _counter = _counter-2;
    
    [self _transitionToNextSlide];
    
}
//
//
//
-(void)nextImage{
    
    if(_counter==[_indexPaths count])
        return;
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _counter++;
    [self _transitionToNextSlide];
}
#pragma mark - Internal
//
//
//
-(void)_reset{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_currentView removeFromSuperview];
    _currentView = nil;
    _counter = 0;
    _isPaused = NO;
    _indexPaths = nil;
    
}
//
//
//
-(void)_prepareForSlideShow{
    
    NSAssert(_datasource!= nil,@"Attempting to being slide show with nil dasource:%s",__PRETTY_FUNCTION__);
    
    _isPaused = NO;
    _counter = 0;
    _currentSection = NSNotFound;
    NSMutableArray* mArr = [[NSMutableArray alloc]init];
    NSUInteger sections = [self.datasource numberOfSectionsInSlideshow:self];
    for(int i=0;i<sections;i++){
        NSUInteger items = [self.datasource numberOfItems:self inSection:i];
        for (int z=0;z<items;z++) {
            [mArr addObject:[NSIndexPath indexPathForRow:z inSection:i]];
        }
    }
    _indexPaths = [NSArray arrayWithArray:mArr];
    
    [self _loadFirstSlide];
    
}
//
//
//
-(void)_transitionToNextSlide{
    
    
    // check the counter if last indexPath repeat or end
    if(_counter == [_indexPaths count]){
        [self _updateAtSlideShowEnd];
        if(_autoRepeat){
            _counter = 0;
        }
        else{
            return; 
        }
    }
    
    NSIndexPath* nextIndexPath =  [_indexPaths objectAtIndex:_counter];

    UIView* nextView = [self _fetchViewFromDatasourceAtIndexPath:nextIndexPath];
    
    _counter++;
    
    
    if(_currentSection != nextIndexPath.section){
        if([self.delegate respondsToSelector:@selector(slideShowView:willBeginSection:)])
            [self.delegate slideShowView:self willBeginSection:nextIndexPath.section];
        
    }
    
    if([self.delegate respondsToSelector:@selector(slideShowView:willDisplaySlideAtIndexPath:)])
        [self.delegate slideShowView:self willDisplaySlideAtIndexPath:nextIndexPath];
    
    
    
    NSTimeInterval slideDuration = _slideDuration;
    if([self.datasource respondsToSelector:@selector(slideDurationForSlideShow:atIndexPath:)])
        slideDuration = [self.datasource slideDurationForSlideShow:self atIndexPath:nextIndexPath];
    
    
    NSUInteger transitionOption = _transitionOption;
    if([self.datasource respondsToSelector:@selector(transitionStyleForSlideShow:atIndexPath:)])
        transitionOption = [[self class]_validTransitionOption:[self.datasource transitionStyleForSlideShow:self atIndexPath:nextIndexPath]];
    
    NSUInteger transitionDuration = _transitionDuration;
    if([self.datasource respondsToSelector:@selector(transitionDurationForSlideShow:atIndexPath:)])
        transitionDuration = [self.datasource transitionDurationForSlideShow:self atIndexPath:nextIndexPath];
    
    
    if(_currentView){
        
        [UIView transitionFromView:_currentView
                            toView:nextView
                          duration:transitionDuration
                           options:transitionOption | UIViewAnimationOptionAllowUserInteraction
                        completion:^(BOOL finished) {
                            
                            _currentView = nil;
                            _currentView = nextView;
                            
                            
                            [self _updateAfterTransitionWithIndexPath:nextIndexPath];

                            
                            [self performSelector:@selector(_transitionToNextSlide)
                                       withObject:nil
                                       afterDelay:slideDuration];
                            
                        }];
        
    }
    else{
        // first view so....
        _currentView = nextView;
        
        [UIView transitionWithView:self
                          duration:transitionDuration
                           options:transitionOption|UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                            
                            [self addSubview:nextView];
                            
                            
                        } completion:^(BOOL finished) {
                            
                            [self _updateAfterTransitionWithIndexPath:nextIndexPath];
                            
                            [self performSelector:@selector(_transitionToNextSlide)
                                       withObject:nil
                                       afterDelay:slideDuration];
                            
                        }];
    }
}
//
//
//
-(void)_updateAfterTransitionWithIndexPath:(NSIndexPath*)indexPath{
    
    
    
    if(_currentSection != indexPath.section){
        
        _currentSection = indexPath.section;
        
        if([self.delegate respondsToSelector:@selector(slideShowView:didBeginSection:)])
            [self.delegate slideShowView:self didBeginSection:_currentSection];
        
    }
    
    
    if([self.delegate respondsToSelector:@selector(slideShowView:didDisplaySlideAtIndexPath:)]){
        [self.delegate slideShowView:self didDisplaySlideAtIndexPath:indexPath];
    }
    
}
//
//
//
-(UIView*)_fetchViewFromDatasourceAtIndexPath:(NSIndexPath*)indexPath{
 
    UIView* view =nil;
    view = [self.datasource viewForSlideShow:self atIndexPath:indexPath];
    
    NSAssert(view!=nil,@"%s:Failed to return view for slide show from datasource",__PRETTY_FUNCTION__);
    
    view.frame = self.bounds;
    return view;
    
}
//
//
//
-(void)_loadFirstSlide{
    
    _counter = 0;
   
    if(_currentView){
        [_currentView removeFromSuperview];
        _currentView = nil;
        
    }
    
    NSIndexPath* nextIndexPath =  [_indexPaths objectAtIndex:_counter];

    _currentView = [self _fetchViewFromDatasourceAtIndexPath:nextIndexPath];

    [self addSubview:_currentView];
    
}
//
//
//
-(void)_updateAtSlideShowEnd{
    
    
    if([self.delegate respondsToSelector:@selector(slideShowViewDidEnd:willRepeat:)])
        [self.delegate slideShowViewDidEnd:self willRepeat:_autoRepeat];
    

}
#pragma mark - UIKIT
//
//
//
-(void)layoutSubviews{
    
    [super layoutSubviews];
    _currentView.frame = self.bounds;
}
@end
