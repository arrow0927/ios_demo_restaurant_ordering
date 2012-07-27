#import <UIKit/UIKit.h>
#import "CartSingleton.h"


@interface SendOrderViewController : UIViewController 
{
	IBOutlet UIImageView *sendOrderBackGroundImg;
	IBOutlet UIImageView *sendOrderTopImage;
	IBOutlet UIImageView *sendOrderBottomImage;
	IBOutlet UILabel *leftLabel;
	IBOutlet UILabel *rightLabel;
	IBOutlet UIButton *doneButton;
	NSMutableData *receivedData;
}

@property (nonatomic, retain) IBOutlet UIImageView *sendOrderBackGroundImg;
@property (nonatomic, retain) IBOutlet UIImageView *sendOrderTopImage;
@property (nonatomic, retain) IBOutlet UIImageView *sendOrderBottomImage;
@property (nonatomic, retain) IBOutlet UILabel *leftLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightLabel;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) NSMutableData *receivedData;

-(IBAction)DoneButtonpressed;


@end
