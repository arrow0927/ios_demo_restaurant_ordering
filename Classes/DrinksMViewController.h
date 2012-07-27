#import <UIKit/UIKit.h>

#import "customTableCell1.h"
#import "customCellProtocol.h"
#import "CartSingleton.h"

#import "DrinkItem.h"
#import "DrinkModel.h"

@interface DrinksMViewController : UITableViewController <customCellAddButnClicked, UIAlertViewDelegate>
{
	NSDictionary *DrinkMDict;
	NSMutableArray *DrinkCategoriesArray;
	UITableView *DrinkMTable;
	NSString* ViewControllerIdentifier;
	
	
	DrinkModel *drinkModel;
	DrinkItem *selectedDrinkItem;
	UIView *headerView;
	NSIndexPath *lastSelectedIndexPath;
}

@property(nonatomic, retain) NSDictionary *DrinkMDict;
@property (nonatomic, retain)  NSMutableArray *DrinkCategoriesArray;
@property (nonatomic, retain) IBOutlet UITableView *DrinkMTable;
@property (nonatomic, retain) NSString* ViewControllerIdentifier;


@property (nonatomic, retain) DrinkModel *drinkModel;
@property (nonatomic, retain) DrinkItem *selectedDrinkItem;
@property (nonatomic, retain) NSIndexPath *lastSelectedIndexPath;

-(void)EmptyCartButtonPressed;
-(void)RemoveLastButtonPressed;

@end
