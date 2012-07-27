#import <UIKit/UIKit.h>

#import "location.h"
#import "locationModel.h"

@interface AboutLocationDetailViewController : UIViewController 
{
	IBOutlet UITextView *detailtext;
	IBOutlet UIImageView *detailImage;
	IBOutlet UIButton *doneButton;

}

@property (nonatomic, retain) IBOutlet UITextView *detailtext;
@property (nonatomic, retain) IBOutlet UIImageView *detailImage;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
//==============================================================================
-(IBAction)doneButtonPressed;

@end
