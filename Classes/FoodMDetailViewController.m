#import "FoodMDetailViewController.h"
#import "customTableCell1.h"

@implementation FoodMDetailViewController


@synthesize itemImage;
@synthesize itemDescription;
@synthesize tableView;
@synthesize FoodSidesDict;
@synthesize FoodSidesSectionArray;

@synthesize _sideModel;
@synthesize _sidesItem;

CartSingleton* Cart;
customTableCell1* selectedFoodCell;

//==============================================================================
- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Add Ons"];
	CGRect frame = CGRectMake(0, 0, 100, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textColor = [UIColor whiteColor];
	label.text = headr;
	self.navigationItem.titleView = label;
	
	Cart = [CartSingleton getSingleton];
	_sideModel = [SidesModel getsharedSidesModel];
	//Done button
	UIBarButtonItem *donebutton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Back"
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(doneButtonPressed)];
	
	self.navigationItem.rightBarButtonItem = donebutton;
	self.navigationItem.hidesBackButton = YES;
	
	UIBarButtonItem *RemoveLastButton = [[UIBarButtonItem alloc]
										 initWithTitle:@"Remove Last"
										 style:UIBarButtonItemStyleDone
										 target:self
										 action:@selector(RemoveLastButtonPressed)];
	self.navigationItem.leftBarButtonItem = RemoveLastButton;
	
}


//==============================================================================
-(void)doneButtonPressed
{
	[self.navigationController popViewControllerAnimated:YES];
	
}
//==============================================================================
-(void)RemoveLastButtonPressed
{
	
	NSLog(@"Removing Last side");
	FoodItem *tmp = [Cart.foodItemsArray lastObject];

	if(tmp == NULL || ([tmp.sidesArray count] < 1))
	   {
		UIAlertView *noItemsToDelete = [[UIAlertView alloc] initWithTitle:@"No Side Items To Remove!"
																  message:nil
																 delegate:self
														cancelButtonTitle:@"OK"
														otherButtonTitles:nil];
		[noItemsToDelete show];
		[noItemsToDelete release];
	   }
		else// ([tmp.sidesArray count]>=1) //side item exists
	   {
		NSLog(@"Removing last side item %@ for FoodItem: %@", [tmp.sidesArray lastObject], tmp.foodName );
		[tmp.sidesArray removeLastObject];
		[Cart printCart];
		}
	
	float totCostAllItemsInCart = [Cart getTotalCostOfAllFoodItems] + [Cart getTotalCostOfAllDrinkItems] + [Cart getTotalCostOfAllOtherItems];
	NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
	if (totCostAllItemsInCart > 0)
	   {
		NSLog(@"Changing BadgeValue....dollars in cart after remove last item :%@", totalDollarsinCart);
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
	   }
	else 
	   {
		NSLog(@"Changing BadgeValue....dollars in cart should be 0 after remove last item Check:%@", totalDollarsinCart);
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:nil];
	   }
}
//==============================================================================
#pragma mark customCellAddButnClicked
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	NSLog(@"Inside CustomCellButnClicked in FoodMViewControler");
	NSLog(@"indexPath received byt UITableView controller from Custom cell is: %@", indexpath);
		
	_sidesItem = [_sideModel getItemForIndexPath:indexpath];
	
	NSMutableString* sidesItemSelected  = [[NSMutableString alloc ] initWithString:@""];
	[sidesItemSelected appendString:@"\n"];
	[sidesItemSelected appendString:_sidesItem.sideName];
	[sidesItemSelected appendString:@" "];
	[sidesItemSelected appendString:@"\n"];
	[sidesItemSelected appendString: _sidesItem.sidePrice];
	UIAlertView *tableRowSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Add"
																	message:sidesItemSelected
																   delegate:self
														  cancelButtonTitle:@"Cancel"
														  otherButtonTitles:@"Add", nil];
	[tableRowSelectedAlert show];
	[tableRowSelectedAlert release];
	[sidesItemSelected release];	
	
		
}
//==============================================================================
#pragma mark UIAlertViewevets
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"clickedButtonAIndex says %d was pressed", buttonIndex);
	if (buttonIndex != 1) //Cancel button was pressed
	   {
		NSLog(@"ORDER NOT ADDED TO CART");
		Cart = [CartSingleton getSingleton];
		[Cart printCart];
	   }
	else //(buttonIndex == 1) Add Button was pressed
	   {
		[Cart printCart];		
		//Add an object not a reference to cart
		SidesItem *_sidesItemObj = [[SidesItem alloc] initWithObjects:_sidesItem.sideName
														  Description:_sidesItem.sideDescription
															 Calories:_sidesItem.sideCalories
																Price:_sidesItem.sidePrice
															photoPath:_sidesItem.pathToPhoto
															 Category:_sidesItem.sideCategory];
		
		FoodItem *fm = [Cart.foodItemsArray lastObject];
		[fm.sidesArray addObject:_sidesItemObj];		
		[_sidesItemObj release];
		SidesItem *sideAdded = [fm.sidesArray lastObject];
		 
		
		float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
		NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
		NSLog(@"Added side %@ item to %@", sideAdded.sideName, fm.foodName);
		[Cart printCart];
	   }
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

#pragma mark tableview_methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    NSInteger numSections = [_sideModel getnumberOfCategories];
	return numSections;
}
//==============================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	
	NSInteger numRows = [_sideModel getItemsInAFoodArrayForCategoryAtIndex:section];
	return numRows;
}
//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *CellIdentifier = @"Cell";
    customTableCell1 *cell = (customTableCell1*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
	 NSLog(@"Cell created");
	 
	 NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"customTableCell1"
														 owner:nil
													   options:nil];
	 
	 for(id currentObj in nibObjects)
		{
		 if ([currentObj isKindOfClass:[customTableCell1 class]] ) 
			{
			 cell = (customTableCell1 *)currentObj;
			}
		}	
	 
	}
	
	SidesItem *currSidesItem = [_sideModel getItemForIndexPath:indexPath];
	
	cell.locationLabel.hidden = TRUE;
	cell.foodItemLabel.text = currSidesItem.sideName;
	cell.thumbImage.hidden = NO;
	cell.ItemPrice.text = currSidesItem.sidePrice;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.parentTableVC = self;
	cell.indexPathForCell = indexPath;
	cell.ItemMisc.hidden = YES;
	cell.AddSidesToCartBtn.enabled = NO;
	cell.AddSidesToCartBtn.hidden = YES;
	
	cell.CityName.hidden = YES;
	
	return cell;
}
//====================================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
	NSString *headr = [_sideModel getHeaderForSection:section];
	return headr;
}
//====================================================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}
//====================================================================================================

-(void)viewDidDisappear:(BOOL)Animated
{
	[super viewDidDisappear:Animated];
	[self.navigationController popViewControllerAnimated:TRUE];
}

//====================================================================================================
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//====================================================================================================
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//====================================================================================================

- (void)dealloc {
    [super dealloc];
}


@end
