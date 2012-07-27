#import "AboutLocationViewController.h"

@implementation AboutLocationViewController
@synthesize locTable;
@synthesize mapView;
@synthesize ViewControllerIdentifier;
@synthesize locModel;
@synthesize selectedCellIndex;
@synthesize AboutLocSeg;
@synthesize mapAnnotations;
@synthesize locationManager;
@synthesize selectedMapLocation;

customTableCell1 *locationCell;
CartSingleton* Cart;
customTableCell1* selectedLocationCell;
location *selectedLocation;
UIAlertView *mapSelectedAlertView;
UIAlertView *locationSelectedAlert;
UIAlertView *locationAlertNoneInCart;
UIAlertView *locationAlertClearLoc;
//==============================================================================
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	Cart = [CartSingleton getSingleton];
	//self.AboutLocSeg.selectedSegmentIndex == 0;
	
}

//==============================================================================
-(IBAction) AboutLocSegPressed: (id) sender
{
	if([sender selectedSegmentIndex] == 0)
	   {
		//Make Table View visible, hide other views
		self.locTable.hidden = TRUE;
		self.mapView.hidden = FALSE;
		
		}
	else //([sender selectedSegmentIndex] == 1)
	   {
		//Make Table View visible, hide other views
		self.locTable.hidden = FALSE;
		self.mapView.hidden = TRUE;
		
	   }
}
//==============================================================================
-(void)ClearLocationButtonPressed:(id)sender
{
	NSLog(@"Clear all locations set in cart");
	
	if (!Cart.locationSelected) 
	   {
		NSLog(@"Tried to lear location but value of location in cart is:%@", Cart.selectedLocation);
		locationAlertNoneInCart =  [[UIAlertView alloc] initWithTitle:@"Location not selected!"
													message:@"There is noting to clear!"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	   }
	else //Cart.locationSelected
	   {
		NSMutableString * locAddress = [[NSMutableString alloc] 
										initWithString:Cart.selectedLocation.Address];
		[locAddress appendString:@" , "];
		[locAddress appendString:Cart.selectedLocation.CityName];
		NSString *locInCart = [[NSString alloc] initWithString:locAddress];
		[locAddress release];
		
		locationAlertClearLoc = [[UIAlertView alloc] initWithTitle:@"Clear Selected Location:"
														   message:locInCart
														  delegate:self
												 cancelButtonTitle:@"No"
												 otherButtonTitles:@"Clear", nil];
		[locInCart release];
	   }

	
	[locationAlertNoneInCart show];
	[locationAlertNoneInCart release];
	[locationAlertClearLoc show];
	[locationAlertClearLoc release];
	
	
}
//==============================================================================
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	Cart = [CartSingleton getSingleton];
	
	UIBarButtonItem *ClearButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Clear"
								   style:UIBarButtonItemStyleBordered
								   target:self
									action:@selector(ClearLocationButtonPressed:)];
	self.navigationItem.rightBarButtonItem = ClearButton;
	
	[ClearButton release];
	
	AboutLocSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Map",@"List", nil]];
	AboutLocSeg.segmentedControlStyle = UISegmentedControlStyleBar;
	AboutLocSeg.selectedSegmentIndex = 0;
	[AboutLocSeg addTarget:self action:@selector(AboutLocSegPressed:) forControlEvents: UIControlEventValueChanged];
	[AboutLocSeg setWidth:75.0 forSegmentAtIndex:0];	
	[AboutLocSeg setWidth:75.0 forSegmentAtIndex:1];
	self.navigationItem.titleView = AboutLocSeg;
	[AboutLocSeg release];
	self.locModel = [locationModel getLocationModel];
	//Set up the mapview
	[self.mapView setMapType:MKMapTypeStandard];
	[self.mapView setZoomEnabled:YES];
	[self.mapView setScrollEnabled:YES];
	//get cvustomer's coordinates
	CLLocationCoordinate2D centerCoord;
	centerCoord.latitude = self.locModel.userLocation.coordinate.latitude ;
	centerCoord.longitude = self.locModel.userLocation.coordinate.longitude; 
	//save the cvustomer coordinates 
	NSString *tmpLat = [[NSString alloc] initWithFormat:@"%g", centerCoord.latitude];
	NSString *tmpLong = [[NSString alloc] initWithFormat:@"%g", centerCoord.longitude];
	//add cvustomer coordinates to cart
	[Cart addCustomerLatitude:tmpLat];
	[Cart addCustomerLongitude:tmpLong];	

	[tmpLat release];
	[tmpLong release];
	
	NSLog(@"*******User's latitude is: %@", [Cart getCustomerLatitude]);
	NSLog(@"*******User's longitude is: %@", [Cart getCustomerLongitude]);
	
	if ((!centerCoord.latitude) || (centerCoord.latitude == 0) || (!centerCoord.longitude)  || (centerCoord.longitude == 0))
	{
	 centerCoord = self.locModel.defaultLocationIfError.coordinate;
	}
	
	NSLog(@"The map center latitude were: %.2f", centerCoord.latitude);
	NSLog(@"The map center longitude were: %.2f", centerCoord.longitude);

	//this function call will show the area covered by all locations with the user location as center
	MKCoordinateRegion preRegion = MKCoordinateRegionMakeWithDistance(centerCoord, self.locModel.longestDistance + 50000, self.locModel.longestDistance + 50000 ); 
	
	//this function call will show the area covered by closest location with the user location as center
	//MKCoordinateRegion preRegion = MKCoordinateRegionMakeWithDistance(centerCoord, self.locModel.shortestDistance + 1000, self.locModel.shortestDistance + 1000); 
	MKCoordinateRegion region = [mapView regionThatFits:preRegion];
	[self.mapView setRegion:region animated:YES]; 
	[self.mapView setDelegate:self];
	
		//self.navigationItem.title = @"Select a Location";
	UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Locations"
								   style:UIBarButtonItemStyleBordered
								   target:nil
								   action:nil];
	self.navigationItem.backBarButtonItem = backbutton;
	
	[backbutton release];
	self.selectedCellIndex = NULL;
	self.locModel = [locationModel getLocationModel];
	[self displayCoordinates];
	
	
	for (LocationMapAnnotation *annot in self.locModel.mapAnnotations)
	   {
		[self.mapView addAnnotation:annot];
	   }
}
//==============================================================================
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([annotation isMemberOfClass:[MKUserLocation class]]) 
		return nil;
	
	MKPinAnnotationView *annView=[[[MKPinAnnotationView alloc] 
								  initWithAnnotation:annotation 
								  reuseIdentifier:@"currentloc"] 
								  autorelease];
    
	
	 UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	 myDetailButton.frame = CGRectMake(0, 0, 23, 23);
	 myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	 myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	 
	[myDetailButton addTarget:self 
						action:nil
			  forControlEvents:UIControlEventTouchUpInside];
	
    annView.rightCalloutAccessoryView = myDetailButton;
	
    annView.animatesDrop=NO;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}
//==============================================================================
-(void)displayCoordinates 
{
	NSArray *cityKeys = [self.locModel.dictOfDicts allKeys];
	for (NSString *city in cityKeys)
	   {
		NSLog(@"City = %@", city);
		NSArray *locationsinCity = [self.locModel.dictOfDicts objectForKey:city];
		for(location *loc in locationsinCity)
		   {
			NSLog(@"Location = %@", loc.Address);
			NSLog(@"City = %@", loc.CityName);
			NSLog(@"Latitude = %@", loc.latitude);
			NSLog(@"Longitude = %@", loc.longitude);
		   }
		
	   }
	
}
//==============================================================================
//method will be called when the accessory view button of the annotation is clicked
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	LocationMapAnnotation *tempAnnotation = view.annotation;
	NSLog(@"accessory  tapped annotation was %@", tempAnnotation.title);
	//now using this information add the apropriate location to Cart
	NSArray *keys = [self.locModel.dictOfDicts allKeys];
	
	for (NSString * aCity in keys)
	   {
		NSArray *locationsInCaity = [self.locModel.dictOfDicts valueForKey:aCity];
		for (location *l in locationsInCaity)
		{
		 NSMutableString *tmp = [[NSMutableString alloc] initWithString:l.Address];
		 [tmp appendString:@" "];
		 [tmp appendString:l.CityName];
			if ([tmp isEqualToString:tempAnnotation.title])
				self.selectedMapLocation = l;
		 NSLog(@"Selectedmaplocation is: %@", self.selectedMapLocation);
		 [tmp release];
		}
	   }
	NSMutableString *displayText = [[NSMutableString alloc] initWithCapacity:10];
	[displayText appendString:self.selectedMapLocation.Address];
	[displayText appendString:@" , "];
	[displayText appendString:self.selectedMapLocation.CityName];
	NSString *alertViewText = [[NSString alloc] initWithString:displayText];
	[displayText release];
	
	
	if(!Cart.locationSelected)
	   {
		mapSelectedAlertView = [[UIAlertView alloc] initWithTitle:@"Selected Location:"
														   message:alertViewText
														  delegate:self
												 cancelButtonTitle:@"Cancel"
												 otherButtonTitles:@"Add ", nil];
	   }
	else //prior location has been slelected - change that
	   {
		mapSelectedAlertView = [[UIAlertView alloc] initWithTitle:@"Switch Selected Location to:"
														   message:alertViewText
														  delegate:self
												 cancelButtonTitle:@"No"
												 otherButtonTitles:@"Yes", nil];
	   }
	
	[alertViewText release];
	[mapSelectedAlertView show];
	[mapSelectedAlertView release];
}
//==============================================================================
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	LocationMapAnnotation *tempAnnotation = view.annotation;
	NSLog(@"The tapped annotation was %@", tempAnnotation.title);
}
//==============================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}
//==============================================================================
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
		return nil;
}

//==============================================================================
#pragma mark protocolMethod
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	NSLog(@"Inside CustomCellButnClicked in AboutViewLocControler");
	NSLog(@"indexPath received byt UITableView controller from Custom cell is: %@", indexpath);
	//locationSelectedAlert
	selectedLocation = [locModel getItemForIndexPath:indexpath];
	NSMutableString* locationSelected  = [[NSMutableString alloc ] initWithString:@""];
	[locationSelected appendString:selectedLocation.Address];
	[locationSelected appendString:@" "];
	[locationSelected appendString:@"\n"];
	[locationSelected appendString:selectedLocation.CityName];
	
	if(!Cart.locationSelected)
	   {
		locationSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Selected Location:"
																	message:locationSelected
																   delegate:self
														  cancelButtonTitle:@"Cancel"
														  otherButtonTitles:@"Add ", nil];
		}
	else //prior location has been slelected - change that
	{
	 locationSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Switch Selected Location to:"
														message:locationSelected
													   delegate:self
											  cancelButtonTitle:@"No"
											  otherButtonTitles:@"Yes", nil];
	}

	[locationSelected release];
	[locationSelectedAlert show];
	[locationSelectedAlert release];
		
}
//==============================================================================
#pragma mark UIAlertViewEvents
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"Alertview = %@",alertView);
	if ([alertView isEqual:mapSelectedAlertView])
	{
	 NSLog(@"MapAlertview works");
	 if (buttonIndex == 0) //Cancel button was pressed
		{
		 NSLog(@"Cancel button pressed. No location added");
		 
		 self.selectedMapLocation = nil;
		 
		 
		}
	 else //if(buttonIndex == 1)//Add Button was pressed
		{
		 if (Cart.selectedLocation != nil)
			{
			 [Cart.selectedLocation release];
			 Cart.selectedLocation = nil;
			}
		 
		 [Cart addLocation:self.selectedMapLocation];
		 Cart.locationSelected = true;
		 
		 //Add vibrate and audio here 
		 
		 
		 
		 NSString* badgeValue = Cart.selectedLocation.CityName;
		 [[[[[self tabBarController] tabBar] items] objectAtIndex:0]setBadgeValue:badgeValue];
		 
		}
	}
	else if([alertView isEqual:locationSelectedAlert]) //the alertview is not map alertview but a table alertview
	   {
		if (buttonIndex == 0) //Cancel button was pressed
		   {
			NSLog(@"Cancel button pressed. No location added");
			
		   }
		else //if(buttonIndex == 1)//Add Button was pressed
		   {
			if (Cart.selectedLocation != nil)
			   {
				[Cart.selectedLocation release];
				Cart.selectedLocation = nil;
			   }
			
			[Cart addLocation:selectedLocation];
			Cart.locationSelected = true;
			
			//Add vibrate and audio here
			
			NSString* badgeValue = Cart.selectedLocation.CityName;
			[[[[[self tabBarController] tabBar] items] objectAtIndex:0]setBadgeValue:badgeValue];
			
			
		   }
	   }
	else if([alertView isEqual:locationAlertClearLoc])
	   {
		//Location has been selected in cart, clear it
		if(buttonIndex == 0) //Cancel
		   {
			NSLog(@"Pressed location clear button, cart's location value needs to be cleared, but then cancel was pressed: %@", Cart.selectedLocation );
			NSLog(@"Button pressed was %d", buttonIndex);
		   }
		else //Clear
		   {
			
			NSLog(@"Button pressed was %d", buttonIndex);
			[Cart.selectedLocation release];
			Cart.selectedLocation = nil;
			Cart.locationSelected = NO;
			self.selectedMapLocation = nil;
			NSLog(@"Pressed location clear button, cart's location value after clearing is: %@", Cart.selectedLocation );
			NSLog(@"Cart.locationselected values is: %d", Cart.locationSelected );
			//NSLog(@"self.selectedmapLocation value is: %d", self.selectedMapLocation );
			[[[[[self tabBarController] tabBar] items] objectAtIndex:0]setBadgeValue:nil];
			//Add vibrate and audio here
			
			
			
		   }
	   }
	else //locationalertNoneIncart
	   {
		//No location was selected so nothing needs to be done
		NSLog(@"Pressed location clear button, but there is no location selected, here is the cart's location value: %@", Cart.selectedLocation);
	}

}
//==============================================================================
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
	
	locModel.detailDisplayLocation = [locModel getItemForIndexPath:indexPath];
	AboutLocationDetailViewController *locDetailVC = [[AboutLocationDetailViewController alloc]
													  initWithNibName:@"AboutLocationDetailViewController" 
													  bundle:nil];
	
	[self.navigationController pushViewController: locDetailVC animated: YES];
	[locDetailVC release];
	
}


//==============================================================================

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{	
	
	NSInteger numSects = [locModel getNumberOfCities];
	return numSects;
}

//=============================================================================
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger numRows = [locModel getItemsInACityArrayForCityAtIndex:section];
	return numRows;
	
}
//=============================================================================
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *LocationCellIdentifier = @"customTableCell1";
    locationCell = (customTableCell1*)[tableView dequeueReusableCellWithIdentifier:LocationCellIdentifier];
    
	if (locationCell == nil) 
	   {
		
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"customTableCell1"
															owner:nil
														  options:nil];
		for(id currentObj in nibObjects)
		   {
			if ([currentObj isKindOfClass:[customTableCell1 class]] ) 
			   {
				locationCell = (customTableCell1 *)currentObj;
			   }
		   }			
	   }
	
	location *currLocation = [locModel getItemForIndexPath:indexPath];
	
	locationCell.thumbImage.hidden = YES;
	[locationCell.AddToCartBtn setTitle:@"Select" 
							   forState:UIControlStateNormal];
	locationCell.dollar.hidden = YES;
	[locationCell.dollar setEnabled:NO ];
	locationCell.foodItemLabel.text = currLocation.Address;
	locationCell.ItemPrice.text = currLocation.PostalCode;
	locationCell.ItemMisc.text = currLocation.Telephone;
	locationCell.indexPathForCell = indexPath;
	locationCell.parentTableVC = self;
	locationCell.ItemMisc.hidden = NO; 
	locationCell.sidesButton.hidden = true;
	locationCell.CityName.hidden = true;
	locationCell.AddSidesToCartBtn.hidden = YES;
	locationCell.AddSidesToCartBtn.enabled = NO;
	[locationCell setAccessoryType:UITableViewCellAccessoryNone];
	return locationCell;
}
//==============================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
	NSString *headr = [locModel getHeaderForSection:section];
	return headr;
}
//=============================================================================

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}
//=============================================================================

//==============================================================================
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//==============================================================================
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//==============================================================================
- (void)viewDidDisappear:(BOOL)animated 
{
	
}



- (void)dealloc 
{
	
    [super dealloc];
	
}
//==============================================================================
@end