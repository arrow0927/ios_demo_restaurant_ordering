#import <Foundation/Foundation.h>
#import "SpecialsItem.h"

@interface SpecialsModel : NSObject 
{
	NSMutableDictionary *dictOfDicts;
	
	NSString *PathToFileDocs;
	NSString *PathToFileBundle;
	
	NSMutableArray *SpecialsItemCategories;

}

@property (nonatomic, retain) NSMutableDictionary *dictOfDicts;
@property (nonatomic, retain) NSString *PathToFileDocs;
@property (nonatomic, retain) NSString *PathToFileBundle;

@property (nonatomic, retain) NSMutableArray *SpecialsItemCategories;

//=============================================================================
+(SpecialsModel*)getsharedSpecialsModel;

-(NSInteger)getnumberOfCategories;

-(NSInteger)getItemsInASpecialsArrayForCategoryAtIndex:(NSInteger)section;

-(SpecialsItem*)getItemForIndexPath:(NSIndexPath*)indexPath;

-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath;

-(NSString*)getHeaderForSection:(NSInteger)section;





@end
