#import <AudioToolbox/AudioServices.h>

@interface NFUIPlayerControlsRefreshViewController : UIViewController
-(void)forwardAction:(id)sender;
-(void)rewindAction:(id)sender;
-(void)playPauseAction:(id)sender;
-(void)didDoubleTapWithGestureRecognizer:(UIGestureRecognizer *)sender;
@end

@interface AIVPlayerControlsView: UIView
-(void)skipForwards;
-(void)skipBackwards;
-(void)togglePlayPause;
-(void)doubleTapGestureRecognized:(UIGestureRecognizer *)sender;
@end

@interface HadronVideoViewBase: UIView
//-(BOOL)gestureSet;
//-(void)setGestureSet:(BOOL)value;
// -(UIView *)forwardsButton;
// -(void)setForwardsButton:(UIView *)value;
// -(UIView *)backwardsButton;
// -(void)setBackwardsButton:(UIView *)value;
// -(void)skipForward:(id)sender;
// -(void)skipBackward:(id)sender;
-(void)togglePlayPause;
//-(void)doubleTapGestureRecognized:(UIGestureRecognizer *)sender;
//-(UIView *)findViewWithAccessibilityLabel:(NSString *)accessibilityLabel withView:(UIView *)parentView;
@end

@interface CRVideoPlayerView: UIView
-(void)doubleTapGestureRecognized:(UIGestureRecognizer *)sender;
-(UIButton *)fastForwardButton;
-(UIButton *)rewindButton;
-(UIButton *)playButton;
-(UIButton *)pauseButton;
@end

@interface YTContentVideoPlayerOverlayViewController: UIViewController
-(void)didTogglePlayPause;
@end

//HBLogDebug(@"Debug hblog");

BOOL pressing;
long long lastMillis;


//---------------NETFLIX---------------------------
%hook NFUIPlayerControlsRefreshViewController
    -(void)didDoubleTapWithGestureRecognizer:(UIGestureRecognizer *)sender {

    	CGPoint touchPoint = [sender locationInView: self.view];
    	if (touchPoint.x < [[self view] bounds].size.width/5.0 * 2) {
    		[self rewindAction:sender];
    	} else if (touchPoint.x > [[self view] bounds].size.width/5.0 * 3) {
    		[self forwardAction:sender];
    	} else {
    		%orig;
    	}
	}

    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
    }

   - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
    }

    -(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

        if (!pressing) {
            for (UITouch *touch in touches) {
                CGFloat force = touch.force;
                CGFloat percentage = force/touch.maximumPossibleForce;
                if (percentage > 0.8) {
                    pressing = YES;
                    [self playPauseAction:event];
                    return;
                }
            }
        }
    }

%end
//---------------------------------------------------





//---------------PRIME-VIDEO---------------------------

%hook AIVPlayerControlsView

    -(void)doubleTapGestureRecognized:(UIGestureRecognizer *)sender {
        CGPoint touchPoint = [sender locationInView: self];
        if (touchPoint.x < [self bounds].size.width/5.0 * 2) {
            [self skipBackwards];
        } else if (touchPoint.x > [self bounds].size.width/5.0 * 3) {
            [self skipForwards];
        } else {
            %orig;
        }
    }

     - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
    }

   - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
    }

    -(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
         HBLogDebug(@"HODOR: touch moved");

        if (!pressing) {
            for (UITouch *touch in touches) {
                CGFloat force = touch.force;
                CGFloat percentage = force/touch.maximumPossibleForce;
                if (percentage > 0.8) {
                    AudioServicesPlaySystemSound(1519);
                    pressing = YES;
                    [self togglePlayPause];
                    return;
                }
            }
        }
    }

%end
//---------------------------------------------------






//---------------HBO-GO---------------------------
%hook HadronVideoViewBase
    //%property (nonatomic, retain) BOOL gestureSet;
    
    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
        %orig;
    }

   - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
        %orig;
    }

    -(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if (!pressing) {
            for (UITouch *touch in touches) {
                CGFloat force = touch.force;
                CGFloat percentage = force/touch.maximumPossibleForce;
                if (percentage > 0.8) {
                    AudioServicesPlaySystemSound(1519);
                    pressing = YES;
                    [self togglePlayPause];
                    return;
                }
            }
        }
        %orig;
    }


    // %new
    // -(UIView *)findViewWithAccessibilityLabel:(NSString *)accessibilityLabel withView:(UIView *)parentView {
    //     if([parentView.accessibilityLabel isEqualToString:accessibilityLabel]) {          
    //             return parentView;
    //     }

    //     for (UIView *subview in parentView.subviews)
    //     {
    //         UIView *newButton = [((HadronVideoViewBase *)self) findViewWithAccessibilityLabel:accessibilityLabel withView:subview];
    //         if(newButton != nil) {
    //             return newButton;
    //         }
    //     }

    //     return nil;
    // }


    // - (void)willMoveToSuperview:(UIView *)superView {
    //     if (!((HadronVideoViewBase *)self).gestureSet) {
    //         UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
    //         tapGesture.numberOfTapsRequired = 2;
    //         [self addGestureRecognizer:tapGesture];
    //         ((HadronVideoViewBase *)self).gestureSet = YES;     
    //     }
    // }
%end

%ctor {
    %init(HadronVideoViewBase=objc_getClass("GO.HadronVideoViewBase"));
}
//--------------------------------------------------



//---------------CRUNCHY-ROLL---------------------------
%hook CRVideoPlayerView

    -(void)awakeFromNib 
    {
        %orig;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognized:)];
        tapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGesture];
     // Initialization code
    }

    %new
    -(void)doubleTapGestureRecognized:(UIGestureRecognizer *)sender {
        CGPoint touchPoint = [sender locationInView: self];
        if (touchPoint.x < [self  bounds].size.width/5.0 * 2) {
            [[self rewindButton] sendActionsForControlEvents:UIControlEventTouchUpInside];
        } else if (touchPoint.x > [self bounds].size.width/5.0 * 3) {
            [[self fastForwardButton] sendActionsForControlEvents:UIControlEventTouchUpInside];
        } 
    }

     - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
        %orig;
    }

   - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
        pressing = NO;
        %orig;
    }

    -(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if (!pressing) {
            for (UITouch *touch in touches) {
                CGFloat force = touch.force;
                CGFloat percentage = force/touch.maximumPossibleForce;
                if (percentage > 0.8) {
                    AudioServicesPlaySystemSound(1519);
                    pressing = YES;
                    if([self playButton].hidden) {
                        [[self pauseButton] sendActionsForControlEvents:UIControlEventTouchUpInside];
                    } else {
                         [[self playButton] sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                    return;
                }
            }
        }
        %orig;
    }
%end
//------------------------------------------------



//---------------YOUTUBE---------------------------
%hook YTContentVideoPlayerOverlayViewController
    -(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if (!pressing) {
            for (UITouch *touch in touches) {
                CGFloat force = touch.force;
                CGFloat percentage = force/touch.maximumPossibleForce;
                if (percentage > 0.8) {
                   long long curMillis = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
                    if(curMillis > lastMillis + 500) {
                        lastMillis = curMillis;
                        AudioServicesPlaySystemSound(1519);
                        [self didTogglePlayPause];
                        return;

                    }  
                }
            }
        }
        %orig;
    }
%end
//-------------------------------------------------
