@interface NFUIPlayerControlsRefreshViewController : UIViewController
-(void)forwardAction:(id)sender;
-(void)rewindAction:(id)sender;
-(void)didDoubleTapWithGestureRecognizer:(UIGestureRecognizer *)sender;
@end


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

%end
