#import <UIKit/UIKit.h>
#import "customCellSidesButnClicked.h"

@interface customTableCell2 : UITableViewCell 
{
	IBOutlet UILabel *itemName;
	IBOutlet UILabel *itemPrice;
	IBOutlet UILabel *sides;
	IBOutlet UILabel *leftSides;
	IBOutlet UILabel *Total;
	IBOutlet UILabel *TotalEditable;
	IBOutlet UIView *ViewForBackground;
	IBOutlet UILabel *dollarTop;
	IBOutlet UILabel *dollarMid;
	IBOutlet UILabel *dollarLow;
	NSIndexPath *indexPathForCell;
}


@property (nonatomic, retain) IBOutlet UILabel *itemName;
@property (nonatomic, retain) IBOutlet UILabel *itemPrice;
@property (nonatomic, retain) IBOutlet UILabel *sides;
@property (nonatomic, retain) IBOutlet UILabel *leftSides;
@property (nonatomic, retain) IBOutlet UIView *ViewForBackground;
@property (nonatomic, retain) NSIndexPath *indexPathForCell;
@property (nonatomic, retain) IBOutlet UILabel *Total;
@property (nonatomic, retain) IBOutlet UILabel *TotalEditable;
@property (nonatomic, retain) IBOutlet UILabel *dollarTop;
@property (nonatomic, retain) IBOutlet UILabel *dollarMid;
@property (nonatomic, retain) IBOutlet UILabel *dollarLow;










@end
