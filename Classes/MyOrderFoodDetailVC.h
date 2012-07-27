#import <UIKit/UIKit.h>
#import "CartSingleton.h"
#import "FoodItem.h"
#import "customTableCell2.h"
#import "SpecialsItem.h"

@interface MyOrderFoodDetailVC : UITableViewController 
{
	NSIndexPath *indxPthOfCallingCell;
	FoodItem *tmpFoodItem;
	NSArray *_sidesArr;
	NSArray *myOrderSections;
	
}

@property (nonatomic, retain)NSIndexPath *indxPthOfCallingCell;
@property (nonatomic, retain)FoodItem *tmpFoodItem;
@property (nonatomic, retain)NSArray *_sidesArr;
@property (nonatomic, retain)NSArray *myOrderSections;

@end
