#import <Foundation/Foundation.h>
#import "DrinkItem.h"

@interface DrinkModel : NSObject 
{
	NSMutableDictionary *dictOfDicts;
	NSString *PathToFileDocs;
	NSString *PathToFileBundle;
	DrinkItem *displayItem;
	NSMutableArray *DrinkItemCategories;
}

@property (nonatomic, retain) NSMutableDictionary *dictOfDicts;
@property (nonatomic, retain) NSString *PathToFileDocs;
@property (nonatomic, retain) NSString *PathToFileBundle;
@property (nonatomic, retain) DrinkItem *displayItem;
@property (nonatomic, retain) NSMutableArray *DrinkItemCategories;


+(DrinkModel*)getsharedDrinkModel;

-(NSInteger)getnumberOfCategories;

-(NSInteger)getItemsInADrinkArrayForCategoryAtIndex:(NSInteger)section;

-(DrinkItem*)getItemForIndexPath:(NSIndexPath*)indexPath;

-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath;

-(NSString*)getHeaderForSection:(NSInteger)section;



@end
