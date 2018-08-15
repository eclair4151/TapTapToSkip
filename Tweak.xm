@interface NFUIPlayerControlsRefreshViewController : UIViewController
-(void)forwardAction:(id)sender;
-(void)rewindAction:(id)sender;
-(void)didDoubleTapWithGestureRecognizer:(UIGestureRecognizer *)sender;
@end


%hook NFUIPlayerControlsRefreshViewController

    -(void)didDoubleTapWithGestureRecognizer:(UIGestureRecognizer *)sender {

    	CGPoint touchPoint = [sender locationInView: self.view];
    	if (touchPoint.x < [[self view] bounds].size.width/2.0) {
    		[self rewindAction:sender];
    	} else {
    		[self forwardAction:sender];
    	}
      
	    return %orig;
	}



%end