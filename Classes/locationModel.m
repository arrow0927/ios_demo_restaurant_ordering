#import "locationModel.h"

@implementation locationModel

@synthesize NamesOfCitiesDispOrder;
@synthesize dictOfDicts;
@synthesize detailDisplayLocation;
@synthesize urlString;
@synthesize mapAnnotations;
@synthesize currentElement;
@synthesize gotAllCoordinates;
@synthesize locMgr;
@synthesize userLocation;
@synthesize defaultLocationIfError;
@synthesize shortestDistance;
@synthesize longestDistance;

//@synthesize userLatitude;
//@synthesize userLongitude;

@synthesize characters;
@synthesize dataFromGoogle;
@synthesize currLAT;
@synthesize currLONG;

CLLocationCoordinate2D coord;
LocationMapAnnotation *mapAnnot;
BOOL inLocation = false;
BOOL gotBoth = false;
BOOL doneParsing = false;

//==============================================================================
static locationModel *sharedLocationModel = NULL;
+(locationModel*)getLocationModel
{
	if (sharedLocationModel !=nil)
	   {
		NSLog(@"locationModel has already been created.....");
		return sharedLocationModel;
	   }
	@synchronized(self)
   {
    if (sharedLocationModel == nil)
	   {
		sharedLocationModel = [[self alloc]init];
		NSLog(@"Created a new locationmodel");
	   }
   }
	return sharedLocationModel;
}
//==============================================================================
+(id)alloc
{
	@synchronized([locationModel class])
   {
	NSLog(@"inside alloc of location model");
	NSAssert(sharedLocationModel == nil, @"Attempted to allocate a second instance of a singleton.");
	sharedLocationModel = [super alloc];
	return sharedLocationModel;
   }
	return nil;
}

//==============================================================================
-(id)init
{
	self = [super init];
	if (sharedLocationModel != nil) 
	   {
		//================
		if(!self.locMgr)
		   {
			[self initLocationManager];
		   }
		//================
		self.gotAllCoordinates = NO;
		NSError *error;
		NSString *errorDesc = nil;
		NSPropertyListFormat format;
		NSData *plistXML;
		NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"LocationsList.plist"];
		//check the documents folder of the app for this file if file doesn't exist there
		//set the path to the application bundle and get file from there
		NSFileManager *fileManager = [NSFileManager defaultManager];
		//if file exists in documents folder
		if (![fileManager fileExistsAtPath:plistDocPath]) 
		   {
			NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"LocationsList" ofType:@"plist"];
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
			
			NSLog(@"%s %d ", __FILE__, __LINE__);
			
			dictOfDicts = [[NSMutableDictionary alloc] initWithDictionary:temp];
			NSArray *tmp = [dictOfDicts allKeys];
			
			NamesOfCitiesDispOrder = [[NSMutableArray alloc] initWithArray:tmp];
			for(NSString *cityName in tmp)
			   {
				NSDictionary *cityDict = [dictOfDicts objectForKey:cityName];
				int insertionIndex = [[cityDict objectForKey:@"displayPriority"] intValue];
				[NamesOfCitiesDispOrder replaceObjectAtIndex:insertionIndex withObject: cityName];
			   }
						
			self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:20]; 
			//NSLog(@"%s %d ", __FILE__, __LINE__);
			
			for(NSString* aCity in NamesOfCitiesDispOrder)
			   {
				NSMutableDictionary *cityDict = [dictOfDicts objectForKey:aCity];
				NSMutableArray *locationsInCity = [[NSMutableArray alloc] initWithArray:[cityDict allKeys]];
				[locationsInCity removeObject:@"displayPriority"];
				
				NSMutableArray *AllLocationObjects = [[NSMutableArray alloc]initWithCapacity:0];
				//NSLog(@"%d ",__LINE__);
				//Then create the array for the sections
				//Create an array of location objects for each section
				for(NSString *aLocation in locationsInCity)
				   {
					NSDictionary *aLocDict = [cityDict objectForKey:aLocation]; 
					NSString *Address = [aLocDict valueForKey:@"address"];
					NSString *City = [aLocDict valueForKey:@"city"];
					NSString *State = [aLocDict valueForKey:@"State/Prov"];
					NSString *Postal_Code = [aLocDict valueForKey:@"postal_code"];
					NSString *Telephone = [aLocDict valueForKey:@"telephone"];
					NSString *description = [aLocDict valueForKey:@"description"];
					NSNumber *Latitude = [aLocDict valueForKey:@"Latitude"];
					NSNumber *Longitude = [aLocDict valueForKey:@"Longitude"];
					//NSLog(@"%d ", __LINE__);
					//NSLog(@"City= %s ", aLocation);
					location *aLocationObj = [[location alloc]initWithObjects:Address
																	 cityName:City
																		State:State
																   postalCode:Postal_Code
																	telePhone:Telephone
																  Description:description];	
					aLocationObj.latitude = Latitude;
					aLocationObj.longitude = Longitude;
					//===================================
					 coord.latitude = [Latitude doubleValue];
					 coord.longitude = [Longitude doubleValue];
					mapAnnot = [[LocationMapAnnotation alloc] initWithCoordinate:coord];
					
					
					NSMutableString *title = [[NSMutableString alloc] initWithString:aLocationObj.Address];
					[title appendString:@" "];
					[title appendString:aLocationObj.CityName];
					NSString *t = [[NSString alloc] initWithString:title];
					
					
					mapAnnot.title = t;
					mapAnnot.subtitle = aLocationObj.Telephone;
					[self.mapAnnotations addObject:mapAnnot];
					
					//===========================================
					[AllLocationObjects addObject:aLocationObj];
					[aLocationObj release];
					[mapAnnot release];
					[title release];
					[t release];
				   }
				[locationsInCity release];
				
				[dictOfDicts setValue:AllLocationObjects forKey:aCity];
				[AllLocationObjects release];
			   }
				[self setDefaultLocation:self.mapAnnotations];
		   }		
	}

	return sharedLocationModel;
}
//==============================================================================
-(void)setDefaultLocation:(NSMutableArray*) mapAnnotationArray
{
	LocationMapAnnotation *tempAnnot = [mapAnnotationArray objectAtIndex:0];
	self.defaultLocationIfError = [[CLLocation alloc] initWithLatitude:tempAnnot.coordinate.latitude 
														 longitude:tempAnnot.coordinate.longitude];
}

//==============================================================================
-(void)initLocationManager
{
	NSLog(@"Loction Manager initiated");
	self.locMgr = [[CLLocationManager alloc] init];
	self.locMgr.delegate = self;
	self.locMgr.distanceFilter = kCLDistanceFilterNone;
	self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
	[self.locMgr startUpdatingLocation];
    NSLog(@"+++++++++++++++++++++++++++++++++++++");
	NSLog(@"location manager object %@", locMgr);
        NSLog(@"+++++++++++++++++++++++++++++++++++++");
}
//==============================================================================
-(void)locationManager:(CLLocationManager*)_manager 
   didUpdateToLocation:(CLLocation *)newLocation 
		  fromLocation:(CLLocation *)oldLocation
{
	self.userLocation = newLocation;
	NSLog(@"Usser location is: %@", self.userLocation);
	NSLog(@"USer location latitude = %.4f", self.userLocation.coordinate.latitude );
	NSLog(@"USer location longitude = %.4f", self.userLocation.coordinate.longitude);
	if (self.userLocation)
	   {
		[self.locMgr stopUpdatingLocation];
	   }
	[self calculateShortestDistanceBetweenUserAndBiz:self.userLocation];
	[self calculateDistanceToBeShownOnMap:self.userLocation];
	
}
//==============================================================================
-(void)locationManager:(CLLocationManager *)_manager didFailWithError:(NSError*)_error
{
	NSString* errorType = (_error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location"
													message:errorType
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
//==============================================================================
-(void)calculateShortestDistanceBetweenUserAndBiz:(CLLocation *)_userLocation
{
	NSLog(@"Entering %s", __FUNCTION__);
	
	for(LocationMapAnnotation *tempAnnot in self.mapAnnotations)
	   {
		CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:tempAnnot.coordinate.latitude
															  longitude:tempAnnot.coordinate.longitude];
		NSLog(@"tempLocation created %@ ", tempLocation);
		
		CLLocationDistance tempDistance = [_userLocation distanceFromLocation: tempLocation];
		NSLog(@"tempDistance  was calculated at %.2f", tempDistance);
		if(!self.shortestDistance) 
		   {
			self.shortestDistance = tempDistance;
			NSLog(@"Assigned value %.2f to shortestDistance", self.shortestDistance);
			continue;
		   }
		if(self.shortestDistance >= tempDistance)
		   {
			NSLog(@"Replacing shortest distance value from %.2f to %.2f", self.shortestDistance, tempDistance);
			self.shortestDistance = tempDistance;
		   }
		[tempLocation release];
	   }
	
}
//==============================================================================
-(void)calculateDistanceToBeShownOnMap:(CLLocation *)_userLocation
{
	NSLog(@"Entering %s", __FUNCTION__);
	
	for(LocationMapAnnotation *tempAnnot in self.mapAnnotations)
	   {
		CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:tempAnnot.coordinate.latitude
															  longitude:tempAnnot.coordinate.longitude];
		NSLog(@"tempLocation created %@ ", tempLocation);
		
		CLLocationDistance tempDistance = [_userLocation distanceFromLocation: tempLocation];
		NSLog(@"userlocation from this tempLocation  was calculated at %.2f meters", tempDistance);
		
		if(!self.longestDistance) 
		   {
			self.longestDistance = tempDistance;
			NSLog(@"longest distance was nil, so Assigned value %.2f meters to longestdistance", self.longestDistance);
			continue;
		   }
		if(self.longestDistance < tempDistance)
		   {
			NSLog(@"longest distance was shorter than tempLocation. Replacing longest distance value from %.2f to %.2f", self.longestDistance, tempDistance);
			self.longestDistance = tempDistance;
		   }
		[tempLocation release];
	   }
	NSLog(@"Final value of longest value was: %.2f", self.longestDistance);
}


//==============================================================================
-(NSInteger)getNumberOfCities
{
	NSInteger keys;
	keys =[NamesOfCitiesDispOrder count];
	return keys;
}
//==============================================================================
-(NSInteger)getItemsInACityArrayForCityAtIndex:(NSInteger)section
{
	NSString *key = [NamesOfCitiesDispOrder objectAtIndex:section];
	NSArray *keyArray = [dictOfDicts objectForKey:key];
	NSInteger itemsInArray = [keyArray count];
	return itemsInArray;
}
//==============================================================================
-(location*)getItemForIndexPath:(NSIndexPath *)indexPath
{
	NSString *city = [NamesOfCitiesDispOrder objectAtIndex:indexPath.section];
	NSArray *citiesArray = [dictOfDicts objectForKey:city];
	location *aLoc = [citiesArray objectAtIndex:indexPath.row];
	return aLoc;
}
//==============================================================================
-(NSString *)getHeaderForSection:(NSInteger)section
{
	NSString * headr = [NamesOfCitiesDispOrder objectAtIndex:section];
	
	NSArray *chunks = [headr componentsSeparatedByString:@","];
	NSString *city = [chunks objectAtIndex:0];
	NSString *State = [chunks objectAtIndex:1];
	NSMutableString *header = [[NSMutableString alloc] initWithString:city];
	[header appendString:@" "];
	[header appendString:State];
	NSString *h = [[[NSString alloc] initWithString:header] autorelease];
	[header release];
	return h;
	 
	
}
//==============================================================================
//this method should be run inside a new thread 
-(void)updateLocationCoordinates
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSError *error;
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSData *plistXML;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"urlString.plist"];
	//check the documents folder of the app for this file if file doesn't exist there
	//set the path to the application bundle and get file from there
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//if file exists in documents folder
	if (![fileManager fileExistsAtPath:plistDocPath]) 
	   {
		NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"urlString" ofType:@"plist"];
		[fileManager copyItemAtPath:plistBundlePath toPath:plistDocPath error:&error]; 
		if(![fileManager fileExistsAtPath:plistDocPath])
		   {
			NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
		   }
	   }
	
	plistXML = [fileManager contentsAtPath:plistDocPath];
	NSString *temp  = (NSString *)[NSPropertyListSerialization
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
	 
	 
	 int count = 0;
	 self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:20]; 
	
	NSArray *tmp = [self.dictOfDicts allKeys];
	for(NSString *cityName in tmp)
	   {
		NSArray *allLocationObjectsInACity = [self.dictOfDicts objectForKey:cityName];
		for(location *l in allLocationObjectsInACity)
		   {
			NSMutableString *urlStr = [[[NSMutableString alloc] initWithString:temp] autorelease];
			NSMutableString *address = [[NSMutableString alloc] initWithString:l.Address];
			[address appendString:@" "];
			[address appendString:l.CityName];
			[address appendString:@" "];
			[address appendString:l.State];
			[address appendString:@" "];
			[address appendString:l.PostalCode];
			NSArray *addressArray = [address componentsSeparatedByString:@" "];
			[address release];
			NSString *a = [addressArray componentsJoinedByString:@"+"];
			[urlStr appendString:a];
			[urlStr appendString:@"&sensor=false"];
			NSURL *url = [[NSURL alloc] initWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
			//---------------------------------------------
			//The following method call is a synchronous call will hold up the gui	
			NSData *data = [NSData dataWithContentsOfURL:url];
			//Here is the asynchronousversion
			
			//-------------------------------------------
			NSLog(@"urlstring = %@", url);
			printf(" \n");
			printf("Received %d bytes of data from google\n", data.length);
			printf(" \n");
			
			NSXMLParser *_parser = [[NSXMLParser alloc] initWithData:data];
			[_parser setDelegate:self];
			
			
			
			if ([_parser parse])
			   {
				NSNumber *_lat = [[NSNumber alloc]initWithFloat:[currLAT floatValue]];
				l.latitude = _lat;
				NSNumber *_long = [[NSNumber alloc]initWithFloat:[currLONG floatValue]];
				l.longitude = _long;
				coord.latitude = [_lat doubleValue];
				coord.longitude = [_long doubleValue];
				mapAnnot = [[LocationMapAnnotation alloc] initWithCoordinate:coord];
				
				
				NSMutableString *title = [[NSMutableString alloc] initWithString:l.Address];
				[title appendString:@" "];
				[title appendString:l.CityName];
				NSString *t = [[NSString alloc] initWithString:title];
				

				mapAnnot.title = t;
				mapAnnot.subtitle = l.Telephone;
				[self.mapAnnotations addObject:mapAnnot];
				
				NSLog(@"Successfully parsed Data from XML file");
				NSLog(@"Checking the contents of loc object:");				
				NSLog(@"location latitude = %@", [l.latitude stringValue]);
				NSLog(@"loccation longitude = %@", [l.longitude stringValue]);
				NSLog(@"URL String sent = %@", [url absoluteString]);
				
				[title release];
				[t release];
			   }
			NSLog (@"==========================================");
			count++;
			[url release];
			[mapAnnot release];
		   }
	   }
	 self.gotAllCoordinates = YES;
	}
	
	[pool release];
}
//===============================================================================

//NSXMLParser delegate methods=================================================
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
	currentElement = @"";
	
	if ([elementName isEqualToString:@"location"])
	   {
		inLocation = true;
		
	   }
    if ( !([elementName isEqualToString:@"lat"]||[elementName isEqualToString:@"lng"]) )
	   {
		currentElement = elementName;
		NSLog (@"Current element = %@", currentElement);
		
		return;
	   }
	
	
    if ( [elementName isEqualToString:@"lat"] && inLocation ) 
	   {
        currentElement = elementName;
		NSLog (@"Current element = %@ ", currentElement);
		
	   }
	if ([elementName isEqualToString:@"lng"] && inLocation)
	   {
        currentElement = elementName;
		NSLog (@"Current element = %@ ", currentElement);
		
	   } 
	
}
//==============================================================================
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	
	if((string !=NULL)||(string!= @"") )
	   {
		characters =  string;
		NSLog (@"Text = %@", characters);
	   }
	if (inLocation)
	   {
		if ([currentElement isEqualToString:@"lat"]) 
		   {
			currLAT = [[NSString alloc] initWithString:string];
		   }
		if ([currentElement isEqualToString:@"lng"]) 
		   {
			currLONG = [[NSString alloc] initWithString:string];
		   }
	   }
	
}

//==============================================================================

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
{
	
	currentElement = elementName;
	NSLog (@"Leaving element: %@ ", currentElement);
	if ( [elementName isEqualToString:@"location"] ) 
	   {
		currentElement = @"";
		gotBoth = true;
		inLocation = false;
		if(gotBoth && !inLocation)
		   {
			doneParsing = true;
		   }
		return;
	   }
	if ( [elementName isEqualToString:@"lat"] ) 
	   {
		currentElement = @"";
		return;
	   }
	if ([elementName isEqualToString:@"lng"])
	   {
		currentElement = @"";
		return;
	   } 
}






@end
