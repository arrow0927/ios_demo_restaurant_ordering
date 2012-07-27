#import <UIKit/UIKit.h>
#import "customCellProtocol.h"

@interface chargesSummaryCell : UITableViewCell 
{
	IBOutlet UIView *view;
	IBOutlet UILabel *leftLabel;
	IBOutlet UILabel *rightLabel;
	IBOutlet UILabel *LocationLabel;
	IBOutlet UIButton *addButton;
	id <customCellAddButnClicked> parentTableVC;
	NSIndexPath* indexPathForCell;
	IBOutlet UILabel *dollarSign;
}

@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, retain) IBOutlet UILabel *leftLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightLabel;
@property (nonatomic, retain) IBOutlet UILabel *LocationLabel;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property(nonatomic, assign) id<customCellAddButnClicked> parentTableVC;
@property (nonatomic, retain) NSIndexPath* indexPathForCell;
@property (nonatomic, retain) IBOutlet UILabel *dollarSign;


-(IBAction) addCartButtonClicked: (UIButton*)addBtn;

@end
