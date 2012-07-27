#import "CartSingleton.h"

@implementation CartSingleton

@synthesize selectedLocation;
@synthesize foodItemsArray;
@synthesize drinkItemsArray;
@synthesize otherItemsArray;
@synthesize locationSelected;
@synthesize customerInfoObtained;
@synthesize customerInfo;

@synthesize userLatitude;
@synthesize userLongitude;

@synthesize numFoodItems;
@synthesize myOrderSummaryRow;
@synthesize taxDict;
@synthesize taxDictKeys;
@synthesize totalTaxPercent;

@synthesize foodItemsTotalCost;
@synthesize drinkItemsTotalCost;
@synthesize otherItemTotalCost;
@synthesize totalCostOfAllItems;
@synthesize totalTaxesAmount;
@synthesize totalChargesWithTaxes;
@synthesize gratuity;
@synthesize miscCharges;


@synthesize rootSerialDict;
@synthesize foodSerialDict;
@synthesize drinkSerialDic;
@synthesize specialsSerialDic;
@synthesize customerInfoSerialDict;
@synthesize locationInfoSerialDict;
@synthesize miscItemSerialDict;
//==============================================================================
static CartSingleton *sharedSingleton = nil;
+(CartSingleton *) getSingleton
{
	if (sharedSingleton !=nil)
	   {
		NSLog(@"Cart has already been created.....");
		return sharedSingleton;
	   }
	@synchronized(self)
   {
    if (sharedSingleton == nil)
	   {
		sharedSingleton = [[self alloc]init];
		NSLog(@"Created a new Cart");
	   }
   }
	return sharedSingleton;
}
//==============================================================================
+(id)alloc
{
	@synchronized([CartSingleton class])
   {
	NSLog(@"inside alloc");
	NSAssert(sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
	sharedSingleton = [super alloc];
	return sharedSingleton;
   }
	
	return nil;
}

//==============================================================================
-(id)init
{
    self = [super init];
	if (sharedSingleton != nil ) 
	   {
		NSLog(@"inside init for Cart");
		totalItemsInCart = 0;
		self.foodItemsArray = [[NSMutableArray alloc]initWithCapacity:0]; //array contains fooditem objects
		self.drinkItemsArray = [[NSMutableArray alloc]initWithCapacity:0]; //array contains drink item objects
		self.otherItemsArray = [[NSMutableArray alloc]initWithCapacity:0]; //array contains special item objects
		selectedLocation = nil; //location object
		locationSelected = FALSE; //bool
		customerInfo = nil; //customer info model
		customerInfoObtained = FALSE; //bool
		self.numFoodItems = 0; //int
		self.gratuity = 0; //float
		self.miscCharges = 0; //float
		[self calculateTaxPercents];
		self.userLatitude = @"0";
		self.userLongitude = @"0";
	   }
	
	return sharedSingleton;
}

//==============================================================================
-(void)calculateTaxPercents
{
	
	NSError *error1;
	NSString *errorDesc1 = nil;
	NSData *plistXML1;
	NSPropertyListFormat format1;
	NSString *rootPath1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistDocPath1 = [rootPath1 stringByAppendingPathComponent:@"taxes.plist"];
	NSFileManager *fileManager1 = [NSFileManager defaultManager];
	if (![fileManager1 fileExistsAtPath:plistDocPath1]) 
	   {
		NSString *plistBundlePath1 = [[NSBundle mainBundle] pathForResource:@"taxes" ofType:@"plist"];
		[fileManager1 copyItemAtPath:plistBundlePath1 toPath:plistDocPath1 error:&error1]; 
		if(![fileManager1 fileExistsAtPath:plistDocPath1])
		   {
			NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
		   }
	   }
	plistXML1 = [fileManager1 contentsAtPath:plistDocPath1];
	NSDictionary *temp1  = (NSDictionary *)[NSPropertyListSerialization
											propertyListFromData:plistXML1
											mutabilityOption:NSPropertyListMutableContainersAndLeaves
											format:&format1
											errorDescription:&errorDesc1];
	
	if (!temp1) 
	   {
		NSLog(@"Error reading plist: %@, format: %d", errorDesc1, format1);
	   }
	else 
	   {
		self.taxDict = [[NSDictionary alloc] initWithDictionary:temp1];
		self.taxDictKeys = [[NSArray alloc] initWithArray:[self.taxDict allKeys]];
	   }
}
//==============================================================================
-(void)addLocation:(location *)loc
{
	//create a location object if it hasn't been set before
	if(self.selectedLocation==NULL)
	   {
		self.selectedLocation = [[location alloc] initWithObjects:loc.Address
														 cityName:loc.CityName
															State:loc.State
													   postalCode:loc.PostalCode
														telePhone:loc.Telephone
													  Description:loc.Description];
				
	   }
	else
	{
		[self.selectedLocation release];
		self.selectedLocation = NULL;
	 self.selectedLocation = [[location alloc] initWithObjects:loc.Address
													  cityName:loc.CityName
														 State:loc.State
													postalCode:loc.PostalCode
													 telePhone:loc.Telephone
												   Description:loc.Description];
	}
	
	self.locationSelected = TRUE;
	[self printCart];
}
//==============================================================================
-(void)removeSelectedLocation
{
	[self.selectedLocation release];
	self.selectedLocation = NULL;
	self.locationSelected = FALSE;
	NSLog(@"removed loaction");
	//[self printCart];
}

//==============================================================================
-(void)addCustomerInfo:(customerInfoModel*)_info
{
	customerInfo = _info;
	customerInfoObtained = true;
}

//==============================================================================
-(void)addFoodItemToCart:(FoodItem *)itm
{
	//create a foodItem object to be added to cart
	FoodItem *toBeAdded = [[FoodItem alloc] initWithObjects:itm.foodName
												Description:itm.foodDescription
												   Calories:itm.foodCalories
													  Price:itm.foodPrice
												  photoPath:itm.pathToPhoto
												   Category:itm.foodCategory];
	
	
	
	
	[self.foodItemsArray addObject:toBeAdded];
	
	[toBeAdded release];
	NSLog(@"Added Food item to cart");
	[self printCart];
	
}
//==============================================================================
-(void)addDrinkItemToCart:(DrinkItem *)itm
{
	[self.drinkItemsArray addObject:itm];
	
	NSLog(@"Added Drink item to cart");
	[self printCart];
}
//==============================================================================
-(void)addSpecialsItemToCart:(SpecialsItem *)itm
{
	[self.otherItemsArray addObject:itm];
	NSLog(@"Added Special item to cart");
	[self printCart];
	
}
//==============================================================================
-(int)getNumberOfItemsInCart
{
	totalItemsInCart = [foodItemsArray count] + [drinkItemsArray count] + [otherItemsArray count];
	return totalItemsInCart;
}
//==============================================================================
-(int)getNumberOfFoodItemsInCart
{
	int fditems = [foodItemsArray count];
	return fditems;
}
//==============================================================================
-(int)getNumberOfDrinkItemsInCart
{
	int drnkitems = [drinkItemsArray count];
	return drnkitems;
}

//==============================================================================
-(int)getNumberOfOtherItemsInCart
{
	int otherItems = [otherItemsArray count];
	return otherItems;
}
//==============================================================================
-(float)getTotalAmountOfAllSidesForItemAtIndex:(NSInteger)_row
{
	float total = 0; 
	FoodItem *itm = [self.foodItemsArray objectAtIndex:_row];
	if (itm == NULL )
	   {
		return 0;
	   }
	int numSides = [itm.sidesArray count];
	
	for (int i=0; i<numSides; i++)
	   {
		SidesItem *s = [itm.sidesArray objectAtIndex:i];
		total = total + [s.sidePrice floatValue];
	   }
	return total;
}
//==============================================================================
-(float)getTotalCostOfFoodItemAtIndex:(NSInteger)_row
{
	float Sidestotal = 0;
	float total = 0.00;
	if (([self.foodItemsArray count]>=1)&&( [self.foodItemsArray objectAtIndex:_row] != NULL ))
	{
	 FoodItem *itm = [self.foodItemsArray objectAtIndex:_row];
	 int numSides = [itm.sidesArray count];
	 for (int i=0; i<numSides; i++)
		{
		 SidesItem *s = [itm.sidesArray objectAtIndex:i];
		 Sidestotal = Sidestotal + [s.sidePrice floatValue];
		}
	 float foodPrice = [itm.foodPrice floatValue];
	 total = foodPrice + Sidestotal;
	}
	
	return total;
}
//==============================================================================
-(float)getTotalCostOfAllFoodItems
{
	float total = 0;
	if (self.foodItemsArray == NULL)
	{
	 return 0;
	}
	int len = [self.foodItemsArray count];
	if(len >=1)
	   {
		for (int i=0; i<len; i++)
		   {
			FoodItem *itm = [foodItemsArray objectAtIndex:i];
			total = total + [itm.foodPrice floatValue];
			float sidesTotal = 0;
			int sideslen = [itm.sidesArray count];
			if(sideslen >=1)
			   {
				for (int j=0; j<sideslen; j++)
				   {
					SidesItem *si = [itm.sidesArray objectAtIndex:j];
					sidesTotal = sidesTotal + [si.sidePrice floatValue];
				   }
			   }
			
			total = total + sidesTotal;
		   }
	   }
	self.foodItemsTotalCost = total;
	return total;
}
//==============================================================================
-(float)getTotalCostOfAllDrinkItems
{
	float total = 0;
	int len = [self.drinkItemsArray count];
	if (len >=1)
	{
	 for (int i=0; i<len; i++)
		{
		 DrinkItem *itm = [drinkItemsArray objectAtIndex:i];
		 total = total + [itm.drinkPrice floatValue];
		}
	 
	}
	self.drinkItemsTotalCost = total;
	return total;
}
//==============================================================================
-(float)getTotalCostOfAllOtherItems
{
	
	float total = 0;
	int len = [self.otherItemsArray count];
	if (len >=1)
	   {
		for (int i=0; i<len; i++)
		   {
			SpecialsItem *itm = [otherItemsArray objectAtIndex:i];
			total = total + [itm.specialsPrice floatValue];
		   }
		
	   }
	self.otherItemTotalCost = total;
	return total;
	
}
//==============================================================================
-(void)printCart
{
	NSLog(@"CartLocation:============");
	if (!self.locationSelected)
	{
	 NSLog(@"Cart.locationselected == false");
	 NSLog(@"Verifying contents of location object... should be null:");
	 NSLog(@"%@",self.selectedLocation.CityName );
	 NSLog(@"%@",self.selectedLocation.Address );
	 NSLog(@"%@",self.selectedLocation.PostalCode );
	 NSLog(@"%@",self.selectedLocation.Telephone );
	 NSLog(@"Memory Address of location = <%p>", self.selectedLocation);
	}
	else 
	{
	 NSLog(@"Cart.locationselected == true");
	 NSLog(@"Printing contents of location object:");
	 NSLog(@"%@",self.selectedLocation.CityName );
	 NSLog(@"%@",self.selectedLocation.Address );
	 NSLog(@"%@",self.selectedLocation.PostalCode );
	 NSLog(@"%@",self.selectedLocation.Telephone );
	 NSLog(@"Memory Address of item = <%p>", self.selectedLocation);
	}
	
	if ((self.foodItemsArray != nil) && ([foodItemsArray count] > 0))
	   {
		NSLog(@"FoodItems:");
		for (int i = 0; i< [foodItemsArray count]; i++)
		   {
			FoodItem *f = [foodItemsArray objectAtIndex:i];
			NSLog(@"Item[%d] = %@", i, f.foodName);
			NSLog(@"Memory Address of item = <%p>", f);
			if([f.sidesArray count]> 0)
			   {
				for (int j=0; j<[f.sidesArray count]; j++) 
				   {
					SidesItem *ss = [f.sidesArray objectAtIndex:j];
					NSLog(@"Side[%d] = %@",j , ss.sideName);
					NSLog(@"Memory Address of item = <%p>", ss);
				   }
			   }
		   }
	   }
	else 
	{
		NSLog(@"No food item selected");
	}

	if((self.drinkItemsArray != nil) && ([drinkItemsArray count]>0))
	   {
		NSLog(@"DrinkItems:");
		for (int i = 0; i<[drinkItemsArray count]; i++)
		   {
			DrinkItem *d = [drinkItemsArray objectAtIndex:i];
			NSLog(@"drink[%d] = %@", i, d.drinkName);
			NSLog(@"Memory Address of item = <%p>", d);
		   }
	   }
	else 
	   {
		NSLog(@"No Drink item selected");
	   }
	
	if((self.otherItemsArray != nil) && ([otherItemsArray count]>0))
	   {
		NSLog(@"SpecialItems:");
		for (int i = 0; i<[otherItemsArray count]; i++)
		   {
			SpecialsItem *s = [otherItemsArray objectAtIndex:i];
			NSLog(@"Specials[%d] = %@", i, s.specialsName);
			NSLog(@"Memory Address of item = <%p>", s);
		   }
	   }
	else 
	   {
		NSLog(@"No Specials item selected");
	   }
	
	NSLog(@"Cart.gratuity = %.02f", self.gratuity);
	NSLog(@"Cart.miscCharges = %.02f", self.miscCharges);
	NSLog(@"Cart food charges = %.02f", [self getTotalCostOfAllFoodItems]);
	NSLog(@"Cart Drink charges = %.02f", [self getTotalCostOfAllDrinkItems]);
	NSLog(@"Cart Specials charges = %.02f", [self getTotalCostOfAllOtherItems]);
	

	
	NSLog(@"==========Cart-End============");
}
//==============================================================================
-(float)getTotalTaxPercent
{
	NSLog(@"Cart is calculating total tax percent-----------");
	self.totalTaxPercent = 0.00;
	NSLog(@"Value before loop @%.02f", totalTaxPercent);
	for (int i = 0; i < [self.taxDictKeys count]; i++)
	{
	
	 NSLog(@"i= %d", i);
	 NSString *s =  [self.taxDictKeys objectAtIndex:i];
	 NSLog(@"Tax Type = %@",s);
	 NSString *val = [NSString stringWithFormat:@"%.02f", [[self.taxDict objectForKey:s] floatValue]];
	 float fvalue = [val floatValue];
	 NSLog(@"Value of taxType = %.02f", fvalue);
	 totalTaxPercent = totalTaxPercent + fvalue; 
	 NSLog(@"TotalTax= %.02f", totalTaxPercent);
	}
	return totalTaxPercent;
}

//==============================================================================
-(float)getTotalCostOfAllItems
{
	
	self.totalCostOfAllItems = [self getTotalCostOfAllFoodItems] + [self getTotalCostOfAllDrinkItems] + [self getTotalCostOfAllOtherItems];
	
	NSLog(@"The total cost of all items in the Cart came out to be @%.02f", self.totalCostOfAllItems);
	
	return self.totalCostOfAllItems;
}
//==============================================================================
-(float)getTotalTaxAmountForAllItems
{
	self.totalTaxesAmount = [self getTotalCostOfAllItems] * [self getTotalTaxPercent];
	return self.totalTaxesAmount;
}
//==============================================================================
-(float)getTotalChargesWithTaxes
{
	self.totalChargesWithTaxes =  [self getTotalCostOfAllItems] + self.totalTaxesAmount;
	return self.totalChargesWithTaxes;
}
//==============================================================================
-(float)getTotalOtherCharges
{
	float totalOtherCharges =  self.gratuity + self.miscCharges;
	return totalOtherCharges;
}
//==============================================================================
-(void)addGratuity:(float)_gratuity
{
	self.gratuity = _gratuity;
	NSLog(@"Added gratuity item to cart");
	[self printCart];
}
//==============================================================================
-(void)addMiscCharges:(float)_miscCharges
{
	self.miscCharges = _miscCharges;
	NSLog(@"Added misc charges to cart");
	[self printCart];
}
//==============================================================================
-(void)addCustomerLatitude:(NSString*)_lat
{
	if (_lat != nil)
	   {
		self.userLatitude = [[NSString alloc] initWithString:_lat];
		NSLog(@"Added customer latitude %@ to cart", self.userLatitude);
	   }
	
}
//==============================================================================
-(NSString*)getCustomerLatitude
{
	return self.userLatitude; 
}
//==============================================================================
-(void)addCustomerLongitude:(NSString*)_long
{
	if (_long != nil)
	{
		self.userLongitude = [[NSString alloc] initWithString:_long];
		NSLog(@"Added customer longitude %@ to cart", self.userLongitude);
	}
}
//==============================================================================
-(NSString*)getCustomerLongitude
{
	return self.userLongitude;
}
//==============================================================================
-(void)emptyCart
{
	NSLog(@"EMPTY CART IN CART SINGLETON ENTERED==============================");
	if (self.selectedLocation != nil)
	   {
		NSLog(@"Memory Address of location before setting nil= <%p>", self.selectedLocation);
		
		self.selectedLocation = nil;
		NSLog(@"Memory Address of location after setting nil= <%p>", self.selectedLocation);
		self.locationSelected = false;
	   }
	
	if (self.foodItemsArray != nil)
	   {
		NSLog(@"Memory Address of Fooditems array before setting nil= <%p>", self.foodItemsArray);
		for (int i = 0; i < [self.foodItemsArray count]; i++)
		   {
			FoodItem *temp = [self.foodItemsArray objectAtIndex:i];
			NSLog(@"Memory Address of FoodItem[%d] = <%p>",i, temp);
			if (temp.sidesArray != nil)
			   {
				NSLog(@"Memory Address of sidesarray before setting nil = <%p>", temp.sidesArray);
				
				temp.sidesArray = nil;
				NSLog(@"Memory Address of sidesarray after setting nil= <%p>", temp.sidesArray);
			   }
		   }
	
		self.foodItemsArray = nil;
		NSLog(@"Memory Address of foodarray after setting nil= <%p>", self.foodItemsArray);
	   }
		
	if (self.drinkItemsArray != nil)
	   {
		NSLog(@"Memory Address of drinkitems array before setting nil= <%p>", self.drinkItemsArray);
	
		self.drinkItemsArray = nil;
		NSLog(@"Memory Address of drinkitems array after setting nil= <%p>", self.drinkItemsArray);
	   }
	
	if (self.otherItemsArray != nil)
	   {
		NSLog(@"Memory Address of otheritems array before setting nil= <%p>", self.otherItemsArray);
	
		self.otherItemsArray = nil;
		NSLog(@"Memory Address of otheritems array after setting nil= <%p>", self.otherItemsArray);
	   }
	
	if (self.customerInfo != nil)
	   {
		NSLog(@"Memory Address of customer = <%p>", self.customerInfo);
	
		self.customerInfo = nil;
	   }
	
	self.numFoodItems = 0;
	
	
	self.foodItemsTotalCost = 0;
	self.drinkItemsTotalCost = 0;
	self.otherItemTotalCost = 0;
	self.totalCostOfAllItems = 0;
	self.totalTaxesAmount = 0;
	self.totalChargesWithTaxes = 0;
	self.gratuity = 0;
	self.miscCharges = 0;
	self.taxDict = nil;
	self.taxDictKeys = nil;
	self.userLatitude = nil;
	self.userLongitude = nil;
	NSLog(@"EMPTY CART IN CART SINGLETON EXITED==============================");
}
//==============================================================================
-(void)ResetCartToNull
{
	sharedSingleton = nil;
}
//==============================================================================
-(void)serializeCart
{
	NSString *error;
	self.rootSerialDict = [[NSMutableDictionary alloc] initWithCapacity:6];
	
	[self convertFoodArrayToDictionary];
	[self.rootSerialDict setObject:self.foodSerialDict forKey:@"Food"];
	
	[self convertDrinkArrayToDictionary];
	[self.rootSerialDict setObject:self.drinkSerialDic forKey:@"Drinks"];
	
	[self convertSpecialsArrayToDictionary];
	[self.rootSerialDict setObject:self.specialsSerialDic forKey:@"Specials"];	
	
	[self convertCustomerInfoToDictionary];
	[self.rootSerialDict setObject:self.customerInfoSerialDict forKey:@"CustomerInfo"];
	
	[self convertLocationInfoToDictionary];
	[self.rootSerialDict setObject:self.locationInfoSerialDict forKey:@"Location"];
	
	[self createDictionaryOfMiscItems];
	[self.rootSerialDict setObject:self.miscItemSerialDict forKey:@"MiscTotals"];
		
	//convert the root serial dictionary to a XML plist
	NSData* serializedCart = [NSPropertyListSerialization dataFromPropertyList:(id)self.rootSerialDict
														  format:NSPropertyListXMLFormat_v1_0 
												errorDescription:&error];
	
	//Save the serealized Cart in the documents folder
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"serializedCart.plist"];
	
	if(serializedCart) 
	   {
        [serializedCart writeToFile:plistPath atomically:YES];
	   }
    else 
	   {
        NSLog(@"%@", error);
        [error release];
	   }
	
}
//==============================================================================
-(void)convertFoodArrayToDictionary
{
	self.foodSerialDict = [NSMutableDictionary dictionaryWithCapacity: [self.foodItemsArray count]];
	NSString *foodName, *foodDesc, *foodCalories, *foodPrice;
	NSNumber *numSides;
	
	 if([self.foodItemsArray count] >= 1 )
		{
		 NSMutableDictionary *itemSerialDict;
		 for(FoodItem *i in self.foodItemsArray)
			{
			 foodName = [[NSString alloc] initWithString:i.foodName];
			 foodDesc = [[NSString alloc] initWithString:i.foodDescription];
			 foodCalories = [[NSString alloc] initWithString:i.foodCalories];
			 foodPrice = [[NSString alloc] initWithString:i.foodPrice];
			 numSides = [[NSNumber alloc ] initWithInt:[i.sidesArray count]];
			 NSMutableDictionary *sidesSerialDict;
			 if ([i.sidesArray count] > 0 ) //side exists
				{
				 sidesSerialDict = [NSMutableDictionary dictionaryWithCapacity: [i.sidesArray count]];
				 NSString *sidesName, *sidesPrice, *sidesDesc, *sidesCalories, *sidesCategory;
				 NSMutableDictionary *sideItemDict;
				 for (SidesItem *s in i.sidesArray)
					{
					 
					 sidesName = [[NSString alloc] initWithString:s.sideName];
					 sidesPrice = [[NSString alloc] initWithString:s.sidePrice];
					 sidesDesc = [[NSString alloc] initWithString:s.sideDescription];
					 sidesCalories = [[NSString alloc] initWithString:s.sideCalories];
					 sidesCategory = [[NSString alloc] initWithString:s.sideCategory];
					 
					 sideItemDict = [NSDictionary dictionaryWithObjects:
									 [NSArray arrayWithObjects:sidesName, sidesPrice, sidesDesc, sidesCalories, sidesCategory, nil]
															forKeys:
									 [NSArray arrayWithObjects:@"sidesName", @"sidesPrice", @"sidesDesc", @"sidesCalories", @"sidesCategory", nil]];
					 [sidesSerialDict setObject: sideItemDict
										 forKey:sidesName];
					 
					 [sidesName release];
					 [sidesPrice release];
					 [sidesDesc release];
					 [sidesCalories release];
					 [sidesCategory release];
					 
					}
				}
			 else  //side doesn't exist
				{
				 sidesSerialDict = [NSMutableDictionary dictionaryWithObjects:
									[NSArray arrayWithObjects: @"NoSides", nil] 
									forKeys:[NSArray arrayWithObjects: @"NoSides", nil]];
				}
			 itemSerialDict = [NSDictionary dictionaryWithObjects:
							   [NSArray arrayWithObjects: foodName, foodPrice, foodDesc, foodCalories, numSides, sidesSerialDict, nil]
														  forKeys:
							   [NSArray arrayWithObjects: @"foodName", @"foodPrice" ,@"foodDesc", @"foodCalories", @"numSides", @"sidesSerialDict", nil]];
			[self.foodSerialDict setObject:itemSerialDict
							   forKey:foodName];
			 
			 [foodName release];
			 [foodDesc release];
			 [foodPrice release];
			 [foodCalories release];
			 [numSides release];
			}
		}
	else //fooditems array count is < 1
	   {
		foodSerialDict = [NSMutableDictionary dictionaryWithObjects:
						   [NSArray arrayWithObjects:@"No items", nil] 
															 forKeys:
						   [NSArray arrayWithObjects:@"No items", nil]];
	   }

	
}
//==============================================================================
-(void)convertDrinkArrayToDictionary
{
	self.drinkSerialDic = [NSMutableDictionary dictionaryWithCapacity:[self.drinkItemsArray count]];
	NSString *drinkName, *drinkDesc, *drinkCalories, *drinkPrice, *drinkCategory;
	
	if([self.drinkItemsArray count] > 0)
	   {
		NSDictionary *drinkItemSerialDict;
		
		for (DrinkItem *d in self.drinkItemsArray)
		   {
			drinkName = [[NSString alloc] initWithString:d.drinkName];
			drinkDesc = [[NSString alloc] initWithString:d.drinkDescription];
			drinkCalories = [[NSString alloc] initWithString:d.drinkCalories];
			drinkPrice = [[NSString alloc] initWithString:d.drinkPrice];
			drinkCategory = [[NSString alloc] initWithString:d.drinkCategory];
			
			drinkItemSerialDict = [NSDictionary dictionaryWithObjects:
						 [NSArray arrayWithObjects: drinkDesc, drinkCalories, drinkPrice, drinkCategory, nil]
													forKeys:[NSArray arrayWithObjects:@"drinkDesc", @"drinkCalories", @"drinkPrice", @"drinkCategory", nil]];
			[self.drinkSerialDic setObject:drinkItemSerialDict forKey:drinkName];
			[drinkName release];
			[drinkDesc release];
			[drinkCalories release];
			[drinkPrice release];
			[drinkCategory release];
			
		   }
	   }
	else //no drink items selected
	   {
		[self.drinkSerialDic setObject:@"No Items" forKey:@"No Items"];
		NSLog(@"DrinkDictionary is empty");
	   }

}
//==============================================================================
-(void)convertSpecialsArrayToDictionary
{
	self.specialsSerialDic = [NSMutableDictionary dictionaryWithCapacity:[self.otherItemsArray count]];
	NSString *specialsName, *specialsDesc, *specialsPrice, *specialsCategory;
	
	if([self.otherItemsArray count] > 0)
	   {
		NSMutableDictionary *specialsItemSerialDict;
		
		for (SpecialsItem  *s in self.otherItemsArray)
		   {
			specialsName = [[NSString alloc] initWithString:s.specialsName];
			specialsDesc = [[NSString alloc] initWithString:s.specialsDescription];
			
			specialsPrice = [[NSString alloc] initWithString:s.specialsPrice];
			specialsCategory = [[NSString alloc] initWithString:s.specialsCategory];
			
			specialsItemSerialDict = [NSMutableDictionary dictionaryWithObjects:
								   [NSArray arrayWithObjects: specialsDesc, specialsPrice, specialsCategory, nil]
															  forKeys:[NSArray arrayWithObjects:@"specialsDesc", @"specialsPrice", @"specialsCategory", nil]];
			[self.specialsSerialDic setObject:specialsItemSerialDict forKey:specialsName];
			[specialsName release];
			[specialsDesc release];
			[specialsPrice release];
			[specialsCategory release];
		   }
	   }
	else //no specials items selected
	   {
		[self.specialsSerialDic setObject:@"No Items" forKey:@"No Items"];
		NSLog(@"SpecialsDictionary is empty");
	   }
	
	
}
//==============================================================================
-(void)convertCustomerInfoToDictionary
{
	
	NSString *customerName, *customerAptNo, *customerStreet1, *customerStreet2, *customerCity, *customerTel, *customerEmail;
	
	if(self.customerInfoObtained)
	   {
		customerName = [[NSString alloc] initWithString:self.customerInfo.Name];
		customerAptNo = [[NSString alloc] initWithString:self.customerInfo.AptNo];
		customerStreet1 = [[NSString alloc] initWithString:self.customerInfo.Street1];
		customerStreet2 = [[NSString alloc] initWithString:self.customerInfo.Street2];
		customerCity = [[NSString alloc] initWithString:self.customerInfo.City];
		customerTel = [[NSString alloc] initWithString:self.customerInfo.Tel];
		customerEmail = [[NSString alloc] initWithString:self.customerInfo.Email];
		
		self.customerInfoSerialDict = [NSDictionary dictionaryWithObjects:
								[NSArray arrayWithObjects: customerName, customerAptNo, customerStreet1, customerStreet2, customerCity, customerTel, customerEmail, nil]
								forKeys:[NSArray arrayWithObjects:@"customerName", @"customerAptNo", @"customerStreet1", @"customerStreet2", @"customerCity", @"customerTel",
										 @"customerEmail", nil]];
		[customerName release];
		[customerAptNo release];
		[customerStreet1 release];
		[customerStreet2 release];
		[customerCity release];
		[customerTel release];
		[customerEmail release];
	   }
	else //no specials items selected
	   {
		self.customerInfoSerialDict = [[NSMutableDictionary alloc] initWithCapacity:1];
		[self.customerInfoSerialDict setObject:@"No Items" forKey:@"No Items"];
		NSLog(@"No customer info obtained ");
	   }
}
//==============================================================================
-(void)convertLocationInfoToDictionary
{
	
	NSString *address, *cityName, *description, *PostalCode, *state, *telephone;
	
	if(self.locationSelected)
	   {
		address = [[NSString alloc] initWithString:self.selectedLocation.Address];
		cityName = [[NSString alloc] initWithString:self.selectedLocation.CityName];
		description = [[NSString alloc] initWithString:self.selectedLocation.Description];
		PostalCode = [[NSString alloc] initWithString:self.selectedLocation.PostalCode];
		state = [[NSString alloc] initWithString:self.selectedLocation.State];
		telephone = [[NSString alloc] initWithString:self.selectedLocation.Telephone];
			
		self.locationInfoSerialDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: address, cityName, description,PostalCode ,state, telephone, nil]
																  forKeys:[NSArray arrayWithObjects:@"address", @"cityName", @"description", @"PostalCode",
																	  @"state", @"telephone", nil]];
		[address release];
		[cityName release];
		[description release];
		
		[PostalCode release];
		[state release];
		[telephone release];
		
	   }
	else //no specials items selected
	   {
		[self.locationInfoSerialDict setObject:@"No Items" forKey:@"No Items"];
		NSLog(@"No customer info obtained ");
	   }
	
	
}
//==============================================================================
-(void)createDictionaryOfMiscItems
{
	
	NSString *_gratuity, *_CityTax, *_ProvinceTax, *_FederalTax, *_othercharges, *_totalOfFoodItems, *_totalOfDrinks, 
	*_totalOfSpecials, *_totalOfAllItems, *_custLatitude, *_custLongitude; 
	
	_gratuity = [[NSNumber numberWithFloat:self.gratuity] stringValue];
	
	_CityTax = [self.taxDict objectForKey:@"CityTax"]; 
	
	_ProvinceTax = [self.taxDict objectForKey:@"ProvinceTax"]; 
	
	_FederalTax = [self.taxDict objectForKey:@"FederalTax"]; 
	
	_othercharges = [[NSNumber numberWithFloat:self.miscCharges] stringValue]; 
	
	_totalOfFoodItems = [[NSNumber numberWithFloat:[self getTotalCostOfAllFoodItems]] stringValue];
	
	_totalOfDrinks = [[NSNumber numberWithFloat:[self getTotalCostOfAllDrinkItems]] stringValue];
	
	_totalOfSpecials = [[NSNumber numberWithFloat:[self getTotalCostOfAllOtherItems]] stringValue];
	
	_totalOfAllItems = [[NSNumber numberWithFloat:[self getTotalCostOfAllItems]] stringValue];
	
	_custLatitude = [self getCustomerLatitude];
	
	_custLongitude = [self getCustomerLongitude];
	
	self.miscItemSerialDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: _gratuity, _CityTax, _ProvinceTax, _FederalTax, _othercharges, _totalOfFoodItems,
						 _totalOfDrinks , _totalOfSpecials, _totalOfAllItems, _custLatitude, _custLongitude, nil]
						forKeys:[NSArray arrayWithObjects:@"_gratuity", @"_CityTax", @"_ProvinceTax", @"_FederalTax", @"_othercharges",
								 @"_totalOfFoodItems", @"_totalOfDrinks", @"_totalOfSpecials", @"_totalOfAllItems", @"_custLatitude", @"_custLongitude", nil]];
	
	
}

@end