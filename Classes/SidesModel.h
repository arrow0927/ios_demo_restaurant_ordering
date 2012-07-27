#import <Foundation/Foundation.h>
#import "SidesItem.h"

@interface SidesModel : NSObject 
{
	NSMutableDictionary *dictOfDicts;
	NSMutableArray *SidesItemCategories;
}

@property (nonatomic, retain) NSMutableDictionary *dictOfDicts;
@property (nonatomic, retain) NSMutableArray *SidesItemCategories;

+(SidesModel*)getsharedSidesModel;

-(NSInteger)getnumberOfCategories;
-(NSInteger)getItemsInAFoodArrayForCategoryAtIndex:(NSInteger)section;
-(SidesItem*)getItemForIndexPath:(NSIndexPath*)indexPath;
-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath;
-(NSString*)getHeaderForSection:(NSInteger)section;

@end
