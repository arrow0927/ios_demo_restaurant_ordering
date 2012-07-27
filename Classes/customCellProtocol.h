#import <UIKit/UIKit.h>


@protocol customCellAddButnClicked <NSObject>

//For a class to implement this protocol following syntax is needed
//@interface someView : UIView <customCellAddButnClicked>
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag;


@end
