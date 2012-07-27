#import <UIKit/UIKit.h>


@interface incorrectTextViewController : UIViewController 
{
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *aptLabel;
	IBOutlet UILabel *streetLabel1;
	IBOutlet UILabel *streetLabel2;
	IBOutlet UILabel *cityLabel;
	IBOutlet UILabel *telephoneLabel;
	IBOutlet UILabel *emailLabel;
	
	IBOutlet UILabel *nameTopRight;
	IBOutlet UILabel *nameBottomRight;
	IBOutlet UILabel *aptTopRight;
	IBOutlet UILabel *aptBottomRight;
	IBOutlet UILabel *street1TopRight;
	IBOutlet UILabel *street1BottomRight;
	IBOutlet UILabel *street2TopRight;
	IBOutlet UILabel *street2BottomRight;
	IBOutlet UILabel *cityTopRight;
	IBOutlet UILabel *cityBottomRight;
	IBOutlet UILabel *telTopRight;
	IBOutlet UILabel *telBottomRight;
	IBOutlet UILabel *emailTopRight;
	IBOutlet UILabel *emailBottomRight;
	IBOutlet UIButton *doneButton;

}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *aptLabel;
@property (nonatomic, retain) IBOutlet UILabel *streetLabel1;
@property (nonatomic, retain) IBOutlet UILabel *streetLabel2;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *telephoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;

@property (nonatomic, retain) IBOutlet UILabel *nameTopRight;
@property (nonatomic, retain) IBOutlet UILabel *nameBottomRight;
@property (nonatomic, retain) IBOutlet UILabel *aptTopRight;
@property (nonatomic, retain) IBOutlet UILabel *aptBottomRight;
@property (nonatomic, retain) IBOutlet UILabel *street1TopRight;
@property (nonatomic, retain) IBOutlet UILabel *street1BottomRight;
@property (nonatomic, retain) IBOutlet UILabel *street2TopRight;
@property (nonatomic, retain) IBOutlet UILabel *street2BottomRight;
@property (nonatomic, retain) IBOutlet UILabel *cityTopRight;
@property (nonatomic, retain) IBOutlet UILabel *cityBottomRight;
@property (nonatomic, retain) IBOutlet UILabel *telTopRight;
@property (nonatomic, retain) IBOutlet UILabel *telBottomRight;
@property (nonatomic, retain) IBOutlet UILabel *emailTopRight;
@property (nonatomic, retain) IBOutlet UILabel *emailBottomRight;

@property (nonatomic, retain) IBOutlet UIButton *doneButton;

-(void)processtextFieldStatusArray:(NSMutableArray*)UITextFieldInValidity;
-(void)doneButtonPressed;

@end
