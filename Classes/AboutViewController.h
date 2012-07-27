#import <UIKit/UIKit.h>
#import "AboutLocationViewController.h"


@interface AboutViewController : UIViewController 
{
	IBOutlet UIImageView *promoBanner;
	IBOutlet UITextView* textView;
	IBOutlet UIImageView *backgroundImage;
	IBOutlet UIImageView *bizLogo;
	UISegmentedControl *AboutSeg;
}


@property (nonatomic, retain) IBOutlet UIImageView *promoBanner;
@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) UISegmentedControl *AboutSeg;
@property (nonatomic, retain) IBOutlet UIImageView *bizLogo;


-(IBAction)promoBannerClicked;


@end
