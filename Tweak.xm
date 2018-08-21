@interface NFUIPlayerControlsRefreshViewController : UIViewController
-(void)forwardAction:(id)sender;
-(void)rewindAction:(id)sender;
-(void)playPauseAction:(id)sender;
-(void)didDoubleTapWithGestureRecognizer:(UIGestureRecognizer *)sender;
@end

BOOL pressing;

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
