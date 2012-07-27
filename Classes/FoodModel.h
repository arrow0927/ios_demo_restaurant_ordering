#import <Foundation/Foundation.h>
#import "FoodItem.h"

@interface FoodModel : NSObject 
{
	
	NSMutableDictionary *dictOfDicts;
	
	NSString *PathToFileDocs;
	NSString *PathToFileBundle;
	FoodItem *detailDisplayFoodItem;
	NSMutableArray *FoodItemCategories;

}


@property (nonatomic, retain) NSMutableDictionary *dictOfDicts;
@property (nonatomic, retain) NSString *PathToFileDocs;
@property (nonatomic, retain) NSString *PathToFileBundle;
@property (nonatomic, retain) FoodItem *detailDisplayFoodItem;
@property (nonatomic, retain) NSMutableArray *FoodItemCategories;
//=============================================================================
+(FoodModel*)getsharedFoodModel;

-(NSInteger)getnumberOfCategories;

-(NSInteger)getItemsInAFoodArrayForCategoryAtIndex:(NSInteger)section;

-(FoodItem*)getItemForIndexPath:(NSIndexPath*)indexPath;

-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath;

-(NSString*)getHeaderForSection:(NSInteger)section;

@end
