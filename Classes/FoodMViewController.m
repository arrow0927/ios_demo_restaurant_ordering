#import "FoodMViewController.h"

@implementation FoodMViewController
@synthesize FoodMDict;
@synthesize FoodCategoriesArray;
@synthesize FoodMTable;

@synthesize foodModel;
@synthesize selectedFoodItem;

CartSingleton* Cart;
customTableCell1 *selectedFoodCell;
customTableCell1 *foodtableCell;


//==============================================================================
#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
		
	NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Food"];
	CGRect frame = CGRectMake(0, 0, 50, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textColor = [UIColor whiteColor];
	label.text = headr;
	self.navigationItem.titleView = label;
	
	
	UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Food"
								   style:UIBarButtonItemStyleBordered
								   target:nil
								   action:nil];
	
		UIBarButtonItem *RemoveLastButton = [[UIBarButtonItem alloc]
										initWithTitle:@"Remove Last"
										style:UIBarButtonItemStyleDone
										target:self
										action:@selector(RemoveLastButtonPressed)];
	self.navigationItem.leftBarButtonItem = RemoveLastButton;
	
	[self.navigationItem.backBarButtonItem setEnabled:NO];
	
	self.navigationItem.backBarButtonItem = backbutton;	
	foodModel = [FoodModel getsharedFoodModel];
	//=============================================
	[headr release];
	
	[backbutton release];
	[RemoveLastButton release];
	
}
//==============================================================================
-(void)sidesButtonPressed
{
	
}
//==============================================================================
#pragma mark customCellAddButnClicked protocol
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	selectedFoodItem = nil; 
	NSLog(@"Inside CustomCellButnClicked in FoodMViewControler");
	NSLog(@"indexPath received byt UITableView controller from Custom cell is: %@", indexpath);
	selectedFoodItem = [foodModel getItemForIndexPath:indexpath];

	NSMutableString* foodItemSelected  = [[NSMutableString alloc ] initWithString:@""];
	[foodItemSelected appendString:selectedFoodItem.foodName];
	[foodItemSelected appendString:@" "];
	[foodItemSelected appendString:@"\n"];
	[foodItemSelected appendString: selectedFoodItem.foodPrice];
	
	UIAlertView *addItemsAlert;
	UIAlertView *addSidesAlert;
	if (tag == 0)
	   {
		addItemsAlert = [[UIAlertView alloc] initWithTitle:@"Add Item without any Sides"
														   message:foodItemSelected
														  delegate:self
												 cancelButtonTitle:@"Cancel"
												 otherButtonTitles:@"Yes", nil];
		[addItemsAlert show];
		[addItemsAlert release];
	   }
	if (tag == 1)
	{
	 addSidesAlert = [[UIAlertView alloc] initWithTitle:@"Add Item and Choose Sides"
														message:foodItemSelected
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Yes", nil];
	 
	 [addSidesAlert show];
	 [addSidesAlert release];
	} 

		
	
	
	
	[foodItemSelected release];	
	 
}
//==============================================================================
-(void)addFoodItemToCart:(FoodItem*)fItem
{
	
}
//==============================================================================
-(void)addFoodItemandSidesToCart:(FoodItem*)fItem
{
	
}

//==============================================================================
#pragma mark UIAlertViewEvents
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	   
	if([alertView.title isEqualToString:@"Add Item without any Sides"])
	   {
		if (buttonIndex == 0)
		{
			//cancel
		}
		else 
		{
			//add
		 Cart = [CartSingleton getSingleton];
		 NSLog(@"Cart before insert:");
		 [Cart printCart];
		 [Cart addFoodItemToCart:selectedFoodItem];
		 
		 NSLog(@"Cart after insert:");
		 [Cart printCart]; 
		 NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfFoodItemsInCart]] stringValue]]autorelease];
		 [[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:itemsInCart];
		 
		 float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
		 NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
		 [[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
		}
	   }
	else 
	   {
		if (buttonIndex == 0)
		   {
			//cancel
		   }
		else 
		   {
			//add
			Cart = [CartSingleton getSingleton];
			NSLog(@"Cart before insert:");
			[Cart printCart];
			[Cart addFoodItemToCart:selectedFoodItem];
			
			NSLog(@"Cart after insert:");
			[Cart printCart]; 
			
			NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfFoodItemsInCart]] stringValue]]autorelease];
			[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:itemsInCart];
			float totCostAllItemsInCart = [Cart getTotalCostOfAllFoodItems] + [Cart getTotalCostOfAllDrinkItems] + [Cart getTotalCostOfAllOtherItems];
			NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
			[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
			FoodMDetailViewController *FoodDetailVC = [[FoodMDetailViewController alloc]
													   initWithNibName:@"FoodMDetailViewController" 
													   bundle:nil];
			[self.navigationController pushViewController: FoodDetailVC animated: YES];
			[FoodDetailVC release];	
			
		   }
	   }
	
}
//==============================================================================
-(void)RemoveLastButtonPressed
{
	
	NSLog(@"Remove Last Food Item Button pressed");
	if([Cart getNumberOfFoodItemsInCart]<1)
	   {
		UIAlertView *noItemsToDelete = [[UIAlertView alloc] initWithTitle:@"No Items To Remove!"
																  message:nil
																 delegate:self
														cancelButtonTitle:@"OK"
														otherButtonTitles:nil];
		[noItemsToDelete show];
		[noItemsToDelete release];
	   }
	else //([Cart getNumberOfFoodItemsInCart]>=1)
	   {
		[Cart printCart];
		FoodItem *tmpItem = [Cart.foodItemsArray lastObject];
		if (tmpItem != NULL)
		   {
			if ([tmpItem.sidesArray count]>=1)
			   {
				[tmpItem.sidesArray release];
			   }
			NSLog(@"Removing last food item in array: %@", tmpItem.foodName);
			[Cart.foodItemsArray removeLastObject];
			[Cart printCart];
		   }
	   }
	
	NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfFoodItemsInCart]] stringValue]]autorelease];
	if([Cart getNumberOfFoodItemsInCart]>=1)
	   {
		NSLog(@"Changing BadgeValue....Number of items in cart after remove last item =%@", itemsInCart);
		[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:itemsInCart];
	   }
	else 
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:nil];
		NSLog(@"Changing BadgeValue....Number of items in cart should be 0, after remove last item Check:%@", itemsInCart);
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
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	NSInteger numSections = [foodModel getnumberOfCategories];
	return numSections;
}
//==============================================================================
//method is called by the application to generate a tableView
//application goes through the section array and for each section number calls this method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger numRows = [foodModel getItemsInAFoodArrayForCategoryAtIndex:section];
	return numRows;
	
	
}
//==============================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *cellIdentifier = @"customTableCell1";    
    foodtableCell = (customTableCell1*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 	
	if (foodtableCell == nil) 
	   {
        NSLog(@"Cell created");
		
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"customTableCell1"
															owner:nil
														  options:nil];
		
		for(id currentObj in nibObjects)
		{
			if ([currentObj isKindOfClass:[customTableCell1 class]] ) 
			{
			 foodtableCell = (customTableCell1 *)currentObj;
			}
		 }	
	   }
	
	FoodItem *currFoodItem = [foodModel getItemForIndexPath:indexPath];
	
	foodtableCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	
	foodtableCell.locationLabel.hidden = TRUE;
	foodtableCell.thumbImage.hidden = TRUE;
	foodtableCell.dollar.hidden = NO;
	foodtableCell.dollar.enabled = YES;
	foodtableCell.dollar.text = @"$";
	foodtableCell.foodItemLabel.text = currFoodItem.foodName;
	foodtableCell.parentTableVC = self;
	foodtableCell.indexPathForCell = indexPath;
	
	foodtableCell.ItemPrice.text =  currFoodItem.foodPrice;
	foodtableCell.CityName.hidden = TRUE;
	foodtableCell.ItemCategory = [foodModel getCategoryforIndexPath:indexPath];
	foodtableCell.ItemMisc.hidden = YES;
	
	if(indexPath.section == 4)
	   {
		foodtableCell.AddSidesToCartBtn.hidden = YES;
		foodtableCell.AddSidesToCartBtn.enabled = NO;
	   }
	else 
	   {
		foodtableCell.AddSidesToCartBtn.hidden = NO;
		foodtableCell.AddSidesToCartBtn.enabled = YES;
	   }

	return foodtableCell;
}

//=============================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *headr = [foodModel getHeaderForSection:section];
	return headr;
}
//=============================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}
//=============================================================================


#pragma mark -
#pragma mark Table view delegate
//=============================================================================
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
		AboutLocationDetailViewController *locDetailVC = [[AboutLocationDetailViewController alloc]
													  initWithNibName:@"AboutLocationDetailViewController" 
													  bundle:nil];
	[self.navigationController pushViewController: locDetailVC animated: YES];
	[locDetailVC release];
	
}


//==============================================================================

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}
//==============================================================================
- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
//==============================================================================

- (void)dealloc 
{
		
	
    [super dealloc];
}

//==============================================================================
@end