#import <UIKit/UIKit.h>
#import "FoodMDetailViewController.h"
#import "customTableCell1.h"
#import "customCellProtocol.h"
#import "CartSingleton.h"
#import "FoodModel.h"
#import "FoodItem.h"
#import "AboutLocationDetailViewController.h"


@interface FoodMViewController : UITableViewController <customCellAddButnClicked, UIAlertViewDelegate>
{
	NSDictionary *FoodMDict;
	NSMutableArray *FoodCategoriesArray;
	UITableView *FoodMTable;
	
	FoodModel *foodModel;
	FoodItem *selectedFoodItem;
	UIView *headerView;
}


@property(nonatomic, retain) NSDictionary *FoodMDict;
@property (nonatomic, retain) NSMutableArray *FoodCategoriesArray;
@property (nonatomic, retain) IBOutlet UITableView *FoodMTable;

@property (nonatomic, retain) FoodModel *foodModel;
@property (nonatomic, retain) FoodItem *selectedFoodItem;
-(void)sidesButtonPressed;
-(void)RemoveLastButtonPressed;
-(void)addFoodItemToCart:(FoodItem*)fItem;
-(void)addFoodItemandSidesToCart:(FoodItem*)fItem;

@end

