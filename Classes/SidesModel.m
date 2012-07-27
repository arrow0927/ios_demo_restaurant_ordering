#import "SidesModel.h"

@implementation SidesModel
@synthesize dictOfDicts;
@synthesize SidesItemCategories;
//==============================================================================
static SidesModel *sharedSidesModel = NULL;
+(SidesModel*)getsharedSidesModel
{
	if (sharedSidesModel !=NULL)
	   {
		NSLog(@"locationModel has already been created.....");
		return sharedSidesModel;
	   }
	@synchronized(self)
   {
    if (sharedSidesModel == NULL)
	   {
		sharedSidesModel = [[self alloc]init];
		NSLog(@"Created a new locationmodel");
	   }
   }
	return sharedSidesModel;
}


//==============================================================================
+(id)alloc
{
	@synchronized([SidesModel class])
   {
	NSLog(@"inside alloc");
	NSAssert(sharedSidesModel == nil, @"Attempted to allocate a second instance of a singleton.");
	sharedSidesModel = [super alloc];
	return sharedSidesModel;
   }
	return nil;
}

//==============================================================================
-(id)init
{
	//if file exists in documents folder
	self = [super init];
	if (sharedSidesModel != Nil) 
	   {
		NSError *error;
		NSString *errorDesc = nil;
		NSData *plistXML;
		NSPropertyListFormat format;
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"FoodSides.plist"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:plistDocPath]) 
		   {
			NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"FoodSides" ofType:@"plist"];
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
			SidesItemCategories = [[NSMutableArray alloc] initWithArray:tmp];
			//this part rearranges the keys in the key array according to their display priority
			for(NSString *aCat in tmp)
			   {
				NSDictionary *aCatDict = [dictOfDicts objectForKey:aCat];
				int insertionIndex = [[aCatDict objectForKey:@"displayPriority"] intValue]; 
				[SidesItemCategories replaceObjectAtIndex:insertionIndex withObject: aCat];
			   }
			
			for(NSString* aCat in SidesItemCategories)
			   {
				NSDictionary *aCategoryDict = [dictOfDicts objectForKey:aCat];
				
				NSMutableArray *itemsInCategory = [[NSMutableArray alloc] initWithArray:[aCategoryDict allKeys]];
				[itemsInCategory removeObject:@"displayPriority"];
				NSMutableArray *AllSideItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
				
				for(NSString *_sidesItem in itemsInCategory)
				   {
					NSString *price = [aCategoryDict valueForKey:_sidesItem];				
					SidesItem *aSideItem = [[SidesItem alloc]initWithObjects:_sidesItem 
																Description:@""
																   Calories:@""
																	  Price:price
																  photoPath:@""
																   Category:aCat];	
					[AllSideItemsArray addObject:aSideItem];
					[aSideItem release];
				   }
				[itemsInCategory release];
				
				[dictOfDicts setValue:AllSideItemsArray forKey:aCat];
				[AllSideItemsArray release];
			   }
		   }
	   }
	return sharedSidesModel;
}
//==============================================================================
-(NSInteger)getnumberOfCategories
{
	NSInteger numCat = [SidesItemCategories count];
	return numCat;
}
//==============================================================================
-(NSInteger)getItemsInAFoodArrayForCategoryAtIndex:(NSInteger)section
{
	NSString* category = [SidesItemCategories objectAtIndex:section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	NSInteger ct = [allItemsInCategory count];
	
	return ct;
	
}
//==============================================================================
-(SidesItem*)getItemForIndexPath:(NSIndexPath*)indexPath
{
	NSString* category = [SidesItemCategories objectAtIndex:indexPath.section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	SidesItem  *itm = [allItemsInCategory objectAtIndex:indexPath.row];
	
	return itm;
}

//==============================================================================
-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath
{
	NSString* category = [SidesItemCategories objectAtIndex:indexpath.section];
	
	return category;
	
}

//==============================================================================
-(NSString*)getHeaderForSection:(NSInteger)section
{
	NSString* category = [SidesItemCategories objectAtIndex:section];
	return category;
}


@end
