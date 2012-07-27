#import <UIKit/UIKit.h>
#import "customCellProtocol.h"//for launching modal view controller
#import "CartSingleton.h"

#import "chargesSummaryCell.h" //for food, drink and SpecialsItem
#import "FoodItem.h"
#import "DrinkItem.h"
#import "SpecialsItem.h"

#import "MyOrderFoodDetailVC.h"


#import "SidesItem.h"
#import "customerInfoViewController.h"

@interface MyOrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, customCellAddButnClicked, UIActionSheetDelegate, UIPickerViewDelegate>
{
	IBOutlet UITableView *myOrderTable;
	
	
	int itemsInCart;
	int numFoodItems;
	int numDrinkItems;
	int numSpecialItems;
	
	
	float FoodTotal;
	float DrinksTotal;
	float OtherTotal;
	float totalOfAllItems;
	chargesSummaryCell *myOrderCell;
	UIPickerView  *gratPicker;
	NSMutableArray *arrayOfGratAmounts;
	NSMutableArray *gratPercents;
	NSInteger selectedPickerIndex;
	//===============
	IBOutlet UIView *headerView;
	IBOutlet UIButton *headerButton;
	IBOutlet UILabel *headerLabel;
	
}

@property (nonatomic, retain)IBOutlet UITableView *myOrderTable;

@property (nonatomic, retain) NSMutableArray *arrayOfGratAmounts;
@property (nonatomic, retain) NSMutableArray *gratPercents;
@property (nonatomic, assign) int itemsInCart;
@property (nonatomic, assign) int numFoodItems;
@property (nonatomic, assign) int numDrinkItems;
@property (nonatomic, assign) int numSpecialItems;
@property (nonatomic, assign) UIPickerView *gratPicker;
@property (nonatomic, assign) float FoodTotal;
@property (nonatomic, assign) float DrinksTotal;
@property (nonatomic, assign) float OtherTotal;
@property (nonatomic, assign) float totalOfAllItems;
@property (nonatomic, assign) NSInteger selectedPickerIndex;
@property (nonatomic, assign) chargesSummaryCell *myOrderCell;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UIButton *headerButton;
@property (nonatomic, retain) IBOutlet UILabel *headerLabel;


-(void)populatePercentArrayForPicker:(NSMutableArray*)_percentArray andGratuityArray:(NSMutableArray*)_gratuityArray;

-(IBAction)toggleEdit:(id)sender;



@end
