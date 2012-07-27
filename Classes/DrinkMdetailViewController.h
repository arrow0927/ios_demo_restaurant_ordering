

#import <UIKit/UIKit.h>


@interface DrinkMdetailViewController : UIViewController 
{
	IBOutlet UIImageView *backgroundImage;
	IBOutlet UIImageView *SelectionImage;
	IBOutlet UITextView *SelectionDescription;
}

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *SelectionImage;
@property (nonatomic, retain) IBOutlet UITextView *SelectionDescription;

@end
