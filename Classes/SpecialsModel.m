#import "SpecialsModel.h"


@implementation SpecialsModel
@synthesize dictOfDicts;
@synthesize PathToFileDocs;
@synthesize PathToFileBundle;

@synthesize SpecialsItemCategories;


//==============================================================================
static SpecialsModel *sharedSpecialsModel = NULL;
+(SpecialsModel*)getsharedSpecialsModel
{
	if (sharedSpecialsModel !=NULL)
	   {
		NSLog(@"SpecialsModel has already been created.....");
		return sharedSpecialsModel;
	   }
	@synchronized(self)
   {
    if (sharedSpecialsModel == NULL)
	   {
		sharedSpecialsModel = [[self alloc]init];
		NSLog(@"Created a new locationmodel");
	   }
   }
	return sharedSpecialsModel;
}

//==============================================================================
+(id)alloc
{
	@synchronized([SpecialsModel class])
   {
	NSLog(@"inside alloc");
	NSAssert(sharedSpecialsModel == nil, @"Attempted to allocate a second instance of a singleton.");
	sharedSpecialsModel = [super alloc];
	return sharedSpecialsModel;
   }
	return nil;
}

//==============================================================================
-(id)init
{
	//if file exists in documents folder
	self = [super init];
	if (sharedSpecialsModel != Nil) 
	   {
		NSError *error;
		NSString *errorDesc = nil;
		NSData *plistXML;
		NSPropertyListFormat format;
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"SpecialMenus.plist"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:plistDocPath]) 
		   {
			NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"SpecialMenus" ofType:@"plist"];
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
			
			SpecialsItemCategories = [[NSMutableArray alloc] initWithArray:tmp];
			for(NSString *aCat in tmp)
			   {
				NSDictionary *aCatDict = [dictOfDicts objectForKey:aCat];
				int insertionIndex = [[aCatDict objectForKey:@"displayPriority"] intValue]; 
				[SpecialsItemCategories replaceObjectAtIndex:insertionIndex withObject: aCat];
			   }
			
			for(NSString* aCat in SpecialsItemCategories)
			   {
				NSDictionary *aCategoryDict = [dictOfDicts objectForKey:aCat];
				
				NSMutableArray *itemsInCategory = [[NSMutableArray alloc] initWithArray:[aCategoryDict allKeys]];
				[itemsInCategory removeObject:@"displayPriority"];
				NSMutableArray *AllSpecialsItemsArray = [[NSMutableArray alloc]initWithCapacity:0];
				
				for(NSString *aSpecialsItem in itemsInCategory)
				   {
					NSDictionary *anItemDict = [aCategoryDict objectForKey:aSpecialsItem]; 
					NSString * specialsName = aSpecialsItem;
					NSString * specialsDescription = [anItemDict valueForKey:@"Description"];
					
					NSString * specialsPrice = [anItemDict valueForKey:@"Price"];
					NSString * pathToPhoto = [anItemDict valueForKey:@"Picture"];
					NSString * specialsCategory = aCat;
					SpecialsItem *aSpecialsItem = [[SpecialsItem alloc]initWithObjects:specialsName 
																Description:specialsDescription
																   
																	  Price:specialsPrice
																  photoPath:pathToPhoto
																   Category:specialsCategory];	
					[AllSpecialsItemsArray addObject:aSpecialsItem];
					[aSpecialsItem release];
				   }
				[itemsInCategory release];
				
				[dictOfDicts setValue:AllSpecialsItemsArray forKey:aCat];
				[AllSpecialsItemsArray release];
			   }
		   }
	   }
	return sharedSpecialsModel;
}

//==============================================================================
-(NSInteger)getnumberOfCategories
{
	NSInteger numCat = [SpecialsItemCategories count];
	return numCat;
	
}

//==============================================================================
-(NSInteger)getItemsInASpecialsArrayForCategoryAtIndex:(NSInteger)section
{
	
	NSString* category = [SpecialsItemCategories objectAtIndex:section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	NSInteger ct = [allItemsInCategory count];
	
	return ct;
	
}

//==============================================================================
-(SpecialsItem*)getItemForIndexPath:(NSIndexPath*)indexPath
{
	NSString* category = [SpecialsItemCategories objectAtIndex:indexPath.section];
	NSArray *allItemsInCategory =  [dictOfDicts objectForKey:category];
	SpecialsItem  *itm = [allItemsInCategory objectAtIndex:indexPath.row];
	
	return itm;
	
}

//==============================================================================
-(NSString*)getCategoryforIndexPath:(NSIndexPath*)indexpath
{
	NSString* category = [SpecialsItemCategories objectAtIndex:indexpath.section];
	
	return category;
}

//==============================================================================
-(NSString*)getHeaderForSection:(NSInteger)section
{
	
	NSString* category = [SpecialsItemCategories objectAtIndex:section];
	return category;
}

//==============================================================================
@end
