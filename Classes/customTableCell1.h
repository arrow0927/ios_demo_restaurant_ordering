#import <UIKit/UIKit.h>


#import "customCellProtocol.h"

#define addCartButtonTag 311820

@interface customTableCell1 : UITableViewCell <UIAlertViewDelegate>
{
	IBOutlet UILabel *locationLabel;
	IBOutlet UILabel *dollar;
	IBOutlet UILabel *ItemPrice;
	IBOutlet UIButton *AddToCartBtn;
	IBOutlet UIButton *AddSidesToCartBtn;
	IBOutlet UILabel *CityName;
	IBOutlet UIImageView *thumbImage;
	IBOutlet UILabel *foodItemLabel;
	id <customCellAddButnClicked> parentTableVC;
	NSIndexPath* indexPathForCell;
	NSString *ItemCategory;
	NSString *ItemDescription;
	IBOutlet UILabel *ItemMisc;
	IBOutlet UIButton *sidesButton;
	BOOL isSelected;
	
}

@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *ItemPrice;
@property (nonatomic, retain) IBOutlet UILabel *CityName;
@property (nonatomic, retain) IBOutlet UIButton *AddToCartBtn;
@property (nonatomic, retain) IBOutlet UIButton *AddSidesToCartBtn;
@property(nonatomic, assign) id<customCellAddButnClicked> parentTableVC;
@property (nonatomic, retain) NSIndexPath* indexPathForCell;
@property (nonatomic, retain) NSString *ItemCategory;
@property (nonatomic, retain) NSString *ItemDescription;
@property (nonatomic, retain) IBOutlet UILabel *ItemMisc;
@property (nonatomic, retain) IBOutlet UIButton *sidesButton;
@property(nonatomic, assign) BOOL isSelected;
@property (nonatomic, retain) IBOutlet UIImageView *thumbImage;
@property (nonatomic, retain) IBOutlet UILabel *foodItemLabel;
@property (nonatomic, retain) IBOutlet UILabel *dollar;

-(IBAction) addCartButtonClicked: (UIButton*)addBtn;



@end
