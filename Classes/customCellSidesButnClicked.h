#import <UIKit/UIKit.h>


@protocol customCellSidesButnClicked

//For a class to implement this protocol following syntax is needed
//@interface someView : UIView <customCellSidesButnClicked>
- (void) customCellSidesButnClicked:(NSIndexPath*)indexpath;



@end
