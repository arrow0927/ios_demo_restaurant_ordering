
#import "FoodModel.h"


@implementation FoodModel


@synthesize dictOfDicts;
@synthesize PathToFileDocs;
@synthesize PathToFileBundle;
@synthesize detailDisplayFoodItem;
@synthesize FoodItemCategories;

//==============================================================================
static FoodModel *sharedFoodModel = NULL;
+(FoodModel*)getsharedFoodModel
{
	if (sharedFoodModel !=NULL)
	   {
		NSLog(@"FoodModelModel has already been created.....");
		return sharedFoodModel;
	   }
	@synchronized(self)
   {
    if (sharedFoodModel == NULL)
	   {
		sharedFoodModel = [[self alloc]init];
		NSLog(@"Created a new locationmodel");
	   }
   }
	return sharedFoodModel;
}
//==============================================================================
+(id)alloc
{
	@synchronized([FoodModel class])
   {
	NSLog(@"inside alloc");
	NSAssert(sharedFoodModel == nil, @"Attempted to allocate a second instance of a singleton.");
	sharedFoodModel = [super alloc];
	return sharedFoodModel;
   }
	return nil;
}

//==============================================================================
-(id)init
{
	//if file exists in documents folder
	self = [super init];
	if (sharedFoodModel != Nil) 
	   {
		NSError *error;
		NSString *errorDesc = nil;
		NSData *plistXML;
		NSPropertyListFormat format;
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"FoodMenus.plist"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:plistDocPath]) 
		   {
			NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"FoodMenus" ofType:@"plist"];
			[fileManager copyItemAtPath:plistBundlePath toPath:plistDocPath error:&error]; 
			if(![fileManager fileExistsAtPath:plistDocPath])
			   {
				NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
			   }
		   }
		plistXML = [fileManager contentsAtPath:plistDocPath];
		NSDictionary *temp  = (NSDictionary *)[NSPropertyListSerialization
											   propertyListFromData:plistXML
											   mutabilityOption:NSPropertyListMutableContainersAndLeaves
											   format:&format
											   errorDescription:&errorDesc];
		
		if (!temp) 
		   {
			NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
		   }
		else 
		   {
			
			dictOfDicts = [[NSMutableDictionary alloc] initWithDictionary:temp];
			NSArray *tmp = [dictOfDicts allKeys];
			
			FoodItemCategories = [[NSMutableArray alloc] initWithArray:tmp];
			for(NSString *aCat in tmp)
			{
				NSDictionary *aCatDict = [dictOfDicts objectForKey:aCat];
				int insertionIndex = [[aCatDict objectForKey:@"displayPriority"] intValue]; 
				[FoodItemCategories replaceObjectAtIndex:insertionIndex withObject: aCat];
			}
			
			for(NSString* aCat in FoodItemCategories)
			   {
				NSDictionary *aCategoryDict = [dictOfDicts objectForKey:aCat];
				
				NSMutableArray *itemsInCategory = [[NSMutableArray alloc] initWithArray:[aCategoryDict allKeys]];
				[itemsInCategory removeObject:@"displayPriority"];
				NSMutableArray *AllFoodItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
				
				for(NSString *aFoodItem in itemsInCategory)
				   {
					NSDictionary *anItemDict = [aCategoryDict objectForKey:aFoodItem]; 
					NSString * foodName = aFoodItem;
					NSString * foodDescription = [anItemDict valueForKey:@"Description"];
					NSString * foodCalories = [anItemDict valueForKey:@"Calories"];
					NSString * foodPrice = [anItemDict valueForKey:@"Price"];
					NSString * pathToPhoto = [anItemDict valueForKey:@"Picture"];
					NSString * foodCategory = aCat;
					FoodItem  *aFoodItem = [[FoodItem alloc]initWithObjects:foodName 
																Description:foodDescription
																   Calories:foodCalories
																	  Price:foodPrice
																  photoPath:pathToPhoto
																   Category:foodCategory];	
					[AllFoodItemsArray addObject:aFoodItem];
					[aFoodItem release];
				   }
				[itemsInCategory release];
				
				[dictOfDicts setValue:AllFoodItemsArray forKey:aCat];
				[AllFoodItemsArray release];
			   }
		   }
	   }
	return sharedFoodModel;
}
//==============================================================================
-(NSInteger)getnumberOfCategories
{
	NSInteger numCat = [FoodItemCategories count];
	return numCat;
}
//==============================================================================
-(NSInteger)getItemsInAFoodArrayForCategoryAtIndex:(NSInteger)section
{
	NSString* category = [FoodItemCategories objectAtIndex:section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	NSInteger ct = [allItemsInCategory count];
	
	return ct;
	
}
//==============================================================================
-(FoodItem*)getItemForIndexPath:(NSIndexPath*)indexPath
{
	NSString* category = [FoodItemCategories objectAtIndex:indexPath.section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	FoodItem *itm = [allItemsInCategory objectAtIndex:indexPath.row];
	
	return itm;
}
//==============================================================================
-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath
{
	NSString* category = [FoodItemCategories objectAtIndex:indexpath.section];
	
	return category;
	
}
//==============================================================================
-(NSString*)getHeaderForSection:(NSInteger)section
{
	NSString* category = [FoodItemCategories objectAtIndex:section];
	return category;
}
//==============================================================================
@end
