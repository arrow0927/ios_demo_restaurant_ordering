#import "DrinkModel.h"

@implementation DrinkModel

@synthesize dictOfDicts;
@synthesize PathToFileDocs;
@synthesize PathToFileBundle;
@synthesize displayItem;
@synthesize DrinkItemCategories;

//==============================================================================
static DrinkModel *sharedDrinkModel = NULL;
+(DrinkModel*)getsharedDrinkModel
{
	if (sharedDrinkModel !=NULL)
	   {
		NSLog(@"DrinkModel has already been created.....");
		return sharedDrinkModel;
	   }
	@synchronized(self)
   {
    if (sharedDrinkModel == NULL)
	   {
		sharedDrinkModel = [[self alloc]init];
		NSLog(@"Created a new Drinkmodel");
	   }
   }
	return sharedDrinkModel;
}
//==============================================================================
+(id)alloc
{
	@synchronized([DrinkModel class])
   {
	NSLog(@"inside alloc");
	NSAssert(sharedDrinkModel == nil, @"Attempted to allocate a second instance of a singleton.");
	sharedDrinkModel = [super alloc];
	return sharedDrinkModel;
   }
	return nil;
}

//==============================================================================
-(id)init
{
	//if file exists in documents folder
	self = [super init];
	if (sharedDrinkModel != Nil) 
	   {
		NSError *error;
		NSString *errorDesc = nil;
		NSData *plistXML;
		NSPropertyListFormat format;
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"DrinkMenus.plist"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:plistDocPath]) 
		   {
			NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"DrinkMenus" ofType:@"plist"];
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
			
			DrinkItemCategories = [[NSMutableArray alloc] initWithArray:tmp];
			for(NSString *aCat in tmp)
			   {
				NSDictionary *aCatDict = [dictOfDicts objectForKey:aCat];
				int insertionIndex = [[aCatDict objectForKey:@"displayPriority"] intValue]; 
				[DrinkItemCategories replaceObjectAtIndex:insertionIndex withObject: aCat];
			   }
			
			for(NSString* aCat in DrinkItemCategories)
			   {
				NSDictionary *aCategoryDict = [dictOfDicts objectForKey:aCat];
				NSMutableArray *itemsInCategory = [[NSMutableArray alloc] initWithArray:[aCategoryDict allKeys]];
				[itemsInCategory removeObject:@"displayPriority"];
				NSMutableArray *AllDrinkItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
				
				for(NSString *aDrinkItem in itemsInCategory)
				   {
					NSDictionary *anItemDict = [aCategoryDict objectForKey:aDrinkItem]; 
					NSString * drinkName = aDrinkItem;//[aCategoryDict valueForKey:@""];
					NSString * drinkDescription = [anItemDict valueForKey:@"Description"];
					NSString * drinkCalories = [anItemDict valueForKey:@"Calories"];
					NSString * drinkPrice = [anItemDict valueForKey:@"Price"];
					NSString * pathToPhoto = [anItemDict valueForKey:@"Picture"];
					NSString * drinkCategory = aCat;
					DrinkItem *aDrinkItem = [[DrinkItem alloc]initWithObjects:drinkName 
																Description:drinkDescription
																   Calories:drinkCalories
																	  Price:drinkPrice
																  photoPath:pathToPhoto
																   Category:drinkCategory];	
					[AllDrinkItemsArray addObject:aDrinkItem];
					[aDrinkItem release];
				   }
				[itemsInCategory release];
				
				[dictOfDicts setValue:AllDrinkItemsArray forKey:aCat];
				[AllDrinkItemsArray release];
			   }
		   }
	   }
	return sharedDrinkModel;
}
//==============================================================================
-(NSInteger)getnumberOfCategories
{
	NSInteger numCat = [DrinkItemCategories count];
	return numCat;
}
//==============================================================================
-(NSInteger)getItemsInADrinkArrayForCategoryAtIndex:(NSInteger)section
{
	NSString* category = [DrinkItemCategories objectAtIndex:section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	NSInteger ct = [allItemsInCategory count];
	
	return ct;
	
}
//==============================================================================
-(DrinkItem*)getItemForIndexPath:(NSIndexPath*)indexPath
{
	NSString* category = [DrinkItemCategories objectAtIndex:indexPath.section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	DrinkItem  *itm = [allItemsInCategory objectAtIndex:indexPath.row];
	
	return itm;
}
//==============================================================================
-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath
{
	NSString* category = [DrinkItemCategories objectAtIndex:indexpath.section];
	
	return category;
	
}
//==============================================================================
-(NSString*)getHeaderForSection:(NSInteger)section
{
	NSString* category = [DrinkItemCategories objectAtIndex:section];
	return category;
}
//==============================================================================
@end
