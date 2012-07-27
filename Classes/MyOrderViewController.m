#import "MyOrderViewController.h"

@implementation MyOrderViewController 
@synthesize myOrderTable;

@synthesize itemsInCart;
@synthesize numFoodItems;
@synthesize numDrinkItems;
@synthesize numSpecialItems;
@synthesize gratPicker;
@synthesize arrayOfGratAmounts;
@synthesize FoodTotal;
@synthesize DrinksTotal;
@synthesize OtherTotal;
@synthesize totalOfAllItems;
@synthesize myOrderCell;
@synthesize gratPercents;
@synthesize selectedPickerIndex;


@synthesize headerView;
@synthesize headerButton;
@synthesize headerLabel;

CartSingleton* Cart;

FoodItem *tmpFoodItem;
DrinkItem *tmpDrinkItem;
SpecialsItem *tmpSpecialsItem;


//==============================================================================
-(void)viewWillAppear:(BOOL)animated
{
	
	[self.myOrderTable reloadData];
	
}
//==============================================================================
-(IBAction)toggleEdit:(id)sender
{
	[self.myOrderTable setEditing:!self.myOrderTable.editing animated:YES];
	
	if(self.myOrderTable.editing)
	   {	
		   [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	   }
	else 
	{
	 if (Cart.myOrderSummaryRow == 0) 
	{
		 [self.navigationItem.rightBarButtonItem setTitle:@"Delete Sides"];
	 }
	 else 
	{
		 [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
	 }
	}

}

//==============================================================================
-(void)foodDeleteButtonPressed:(id)sender
{
 	NSInteger index = [sender tag];
	NSLog(@"Delete button pressed for section: %d", index);
	FoodItem *tmpItem = [Cart.foodItemsArray objectAtIndex:index];
	int ct = [tmpItem.sidesArray count];
	
	if(ct > 0)
	   {
		NSLog(@"About to delete %d sides", ct);
		[tmpItem.sidesArray removeAllObjects];
	   }
	else 
	   {
		NSLog(@"The fooditem to be deleted has no side items");
	   }
	
	NSLog(@"About to remove object from ffod items array");
	[Cart.foodItemsArray removeObjectAtIndex:index];
	[self.myOrderTable deleteSections:[NSIndexSet indexSetWithIndex:index]
					 withRowAnimation: UITableViewRowAnimationFade];

	
	[self.myOrderTable reloadData];
	//adjust the badge values
	//foodbadge
	NSString* foodBadgeCount = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfFoodItemsInCart]] stringValue]]autorelease];
	
	if ([foodBadgeCount isEqualToString:@"0"]) 
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:nil];
	   }
	else
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:foodBadgeCount];
	   }
	//totals badge
	float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
	NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
	if ([totalDollarsinCart isEqualToString:@"$0.00"]) 
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:nil];
	   }
	else
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
	   }

	//adjust the total for the headerview
	NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Total: $ "];
	float tot = [Cart getTotalCostOfAllFoodItems];
	[headr appendString:[NSString stringWithFormat:@"%.2f",tot]];
	CGRect frame = CGRectMake(0, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:15.0];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textColor = [UIColor whiteColor];
	label.text = headr;
	self.navigationItem.titleView = label;
	
}
//==============================================================================

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forSectionAtIndexPath:(NSIndexPath*)indexPath
{
	
	//remove object from datasource

	[tableView deleteSections:[NSArray arrayWithObject:indexPath]
			 withRowAnimation: UITableViewRowAnimationFade];
	
	//update the badges
}

//==============================================================================
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	//remove object from the data source
	if(Cart.myOrderSummaryRow == 0)
	   {
		//delete the 
		FoodItem *tmpFood = [Cart.foodItemsArray objectAtIndex:section];
		[tmpFood.sidesArray removeObjectAtIndex:row];
		//update the badge
		NSString* badgeCount = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfFoodItemsInCart]] stringValue]]autorelease];
		if ([badgeCount isEqualToString:@"0"]) 
		   {
			[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:nil];
		   }
		else
		   {
			[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:badgeCount];
		   }
		
	   }
	
	
	if(Cart.myOrderSummaryRow == 1)
	   {
		//remove the corresponding item from the drinks array
		NSLog(@"User wants to delete item at row: %d", row);
		DrinkItem *temp = [Cart.drinkItemsArray objectAtIndex:row];
		NSLog(@"That item is= %@", temp.drinkName );
		[Cart.drinkItemsArray removeObjectAtIndex:row];
		//update the header
		//then update the badges
		NSString* badgeCount = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfDrinkItemsInCart]] stringValue]]autorelease];
		if ([badgeCount isEqualToString:@"0"]) 
		{
			[[[[[self tabBarController] tabBar] items] objectAtIndex:2]setBadgeValue:nil];
		}
		else
		{
			[[[[[self tabBarController] tabBar] items] objectAtIndex:2]setBadgeValue:badgeCount];
		}
		
		//set the header title
		NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Drink Charges: $ "];
		float tot = [Cart getTotalCostOfAllDrinkItems];
		[headr appendString:[NSString stringWithFormat:@"%.2f",tot]];
		CGRect frame = CGRectMake(0, 0, 300, 44);
		UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont boldSystemFontOfSize:15.0];
		label.textAlignment = UITextAlignmentCenter;
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textColor = [UIColor whiteColor];
		label.text = headr;
		self.navigationItem.titleView = label;
		
		
	   }
	if (Cart.myOrderSummaryRow == 2)
	   {	
		   //remove the corresponding item from the speials array
		    
		NSLog(@"User wants to delete item at row: %d", row);
		SpecialsItem *temp = [Cart.otherItemsArray objectAtIndex:row];
		NSLog(@"That item is= %@", temp.specialsName );
		[Cart.otherItemsArray removeObjectAtIndex:row];
		  
		   //then update the badges
		   NSString* badgeCount = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfOtherItemsInCart]] stringValue]]autorelease];
		   if ([badgeCount isEqualToString:@"0"]) 
			  {
			   [[[[[self tabBarController] tabBar] items] objectAtIndex:3]setBadgeValue:nil];
			  }
		   else
			  {
			   [[[[[self tabBarController] tabBar] items] objectAtIndex:3]setBadgeValue:badgeCount];
			  }
		   //set the header title
		   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Specials Charges: $ "];
		   float tot = [Cart getTotalCostOfAllOtherItems];
		   [headr appendString:[NSString stringWithFormat:@"%.2f",tot]];
		   CGRect frame = CGRectMake(0, 0, 300, 44);
		   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
		   label.backgroundColor = [UIColor clearColor];
		   label.font = [UIFont boldSystemFontOfSize:15.0];
		   label.textAlignment = UITextAlignmentCenter;
		   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		   label.textColor = [UIColor whiteColor];
		   label.text = headr;
		   self.navigationItem.titleView = label;
		   
		   
	   }
	
	float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
	NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
	NSLog(@"totalDollarsinCart = %@", totalDollarsinCart);
	if ([totalDollarsinCart isEqualToString:@"$0.00"])
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:nil];
	   }
	else
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
	   }
	
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
					 withRowAnimation:UITableViewRowAnimationFade];
	
	
}
//==============================================================================
-(void)RefreshButtonPressed
{
	[self.myOrderTable reloadData];
}
//==============================================================================
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	
	Cart = [CartSingleton getSingleton];
	gratPercents = [[NSMutableArray alloc] initWithCapacity:0];
	arrayOfGratAmounts = [[NSMutableArray alloc] initWithCapacity:0];
	[self populatePercentArrayForPicker:self.gratPercents andGratuityArray:self.arrayOfGratAmounts];
	self.selectedPickerIndex = [self.arrayOfGratAmounts count] -1;
	NSLog(@"Setting selectedPickerINdex to the last index of the arrayofGratamounts = %d", self.selectedPickerIndex);
	NSLog(@"The value at the last index of arrayofGratamounts = %@", [self.arrayOfGratAmounts objectAtIndex:self.selectedPickerIndex]);
	if (Cart.gratuity <= 0)
	{
		[Cart addGratuity:[[self.arrayOfGratAmounts objectAtIndex:self.selectedPickerIndex] floatValue]];
	}
	
	
	self.itemsInCart = [Cart getNumberOfItemsInCart];
	self.numFoodItems = [Cart getNumberOfFoodItemsInCart];
	self.numDrinkItems = [Cart getNumberOfDrinkItemsInCart];
	self.numSpecialItems = [Cart getNumberOfOtherItemsInCart];
	self.FoodTotal = 0;
	self.DrinksTotal = 0;
	self.OtherTotal = 0;
	self.totalOfAllItems = 0;
	
	if ((Cart.myOrderSummaryRow == 7) &&(Cart.locationSelected))
	{
	 UIBarButtonItem *ChangeButton = [[UIBarButtonItem alloc]
										 initWithTitle:@"Remove"
										 style:UIBarButtonItemStyleDone
										 target:self
										 action:@selector(deleteLocationButnPressed)];
	 self.navigationItem.rightBarButtonItem = ChangeButton;
	}
	
	
	switch (Cart.myOrderSummaryRow)
   {
	   case 0:
	  {
	  
	   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Total: $ "];
	   float tot = [Cart getTotalCostOfAllFoodItems];
	   [headr appendString:[NSString stringWithFormat:@"%.2f",tot]];
	   CGRect frame = CGRectMake(0, 0, 200, 44);
	   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	   label.backgroundColor = [UIColor clearColor];
	   label.font = [UIFont boldSystemFontOfSize:15.0];
	   label.textAlignment = UITextAlignmentCenter;
	   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	   label.textColor = [UIColor whiteColor];
	   label.text = headr;
	   self.navigationItem.titleView = label;
	   //Add an edit button
	   UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete Sides"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(toggleEdit:)];
	   self.navigationItem.rightBarButtonItem = editButton;
	   [editButton release];
	   
	   break;
	  }
	   case 1:
	  {
	   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Drink Charges: $ "];
	   float tot = [Cart getTotalCostOfAllDrinkItems];
	   [headr appendString:[NSString stringWithFormat:@"%.2f",tot]];
	   CGRect frame = CGRectMake(0, 0, 300, 44);
	   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	   label.backgroundColor = [UIColor clearColor];
	   label.font = [UIFont boldSystemFontOfSize:15.0];
	   label.textAlignment = UITextAlignmentCenter;
	   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	   label.textColor = [UIColor whiteColor];
	   label.text = headr;
	   self.navigationItem.titleView = label;
	   //Add an edit button
	   UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(toggleEdit:)];
	   self.navigationItem.rightBarButtonItem = editButton;
	   [editButton release];
	   
	   break;
	  }
	   case 2:
	  {
	   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Specials Charges: $ "];
	   float tot = [Cart getTotalCostOfAllOtherItems];
	   [headr appendString:[NSString stringWithFormat:@"%.2f",tot]];
	   CGRect frame = CGRectMake(0, 0, 300, 44);
	   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	   label.backgroundColor = [UIColor clearColor];
	   label.font = [UIFont boldSystemFontOfSize:15.0];
	   label.textAlignment = UITextAlignmentCenter;
	   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	   label.textColor = [UIColor whiteColor];
	   label.text = headr;
	   self.navigationItem.titleView = label;
	   //Add an edit button
	   UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(toggleEdit:)];
	   self.navigationItem.rightBarButtonItem = editButton;
	   [editButton release];
	   
	   break;
	  }
	   case 4:
	  {
	   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Total Taxes ["];
	   float totaltaxPercent = [Cart totalTaxPercent] * 100;
	   NSString *totalTaxPercent = [NSString stringWithFormat:@"%.2f",totaltaxPercent];
	  
	   [headr appendString:totalTaxPercent];
	   [headr appendString:@"%] = $"];
	   float totalCharges = [Cart totalTaxesAmount];
	   [headr appendString:[NSString stringWithFormat:@"%.2f",totalCharges]]; 
	   CGRect frame = CGRectMake(0, 0, 300, 44);
	   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	   label.backgroundColor = [UIColor clearColor];
	   label.font = [UIFont boldSystemFontOfSize:15.0];
	   label.textAlignment = UITextAlignmentCenter;
	   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	   label.textColor = [UIColor whiteColor];
	   label.text = headr;
	   self.navigationItem.titleView = label;
	   break;
	  }
	   case 5:
	{
	 NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Gratuity & Other Charges: $"];
	 
	 [headr appendString:[NSString stringWithFormat:@"%.2f",Cart.gratuity]];
	 CGRect frame = CGRectMake(0, 0, 300, 44);
	 UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	 label.backgroundColor = [UIColor clearColor];
	 label.font = [UIFont boldSystemFontOfSize:15.0];
	 label.textAlignment = UITextAlignmentCenter;
	 label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	 label.textColor = [UIColor whiteColor];
	 label.text = headr;
	 self.navigationItem.titleView = label;
		break;
	}
	   case 7:
	  {
	   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Order Location"];
	   CGRect frame = CGRectMake(0, 0, 300, 44);
	   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	   label.backgroundColor = [UIColor clearColor];
	   label.font = [UIFont boldSystemFontOfSize:15.0];
	   label.textAlignment = UITextAlignmentCenter;
	   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	   label.textColor = [UIColor whiteColor];
	   label.text = headr;
	   self.navigationItem.titleView = label;
	   break;
	  }
	   case 8:
	  {
	   UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
									  initWithTitle:@"Edit"
									  style:UIBarButtonItemStyleDone
									  target:self
									  action:@selector(custInfoEditButnClicked)];
	   self.navigationItem.rightBarButtonItem = editButton;   
	   
	   
	   NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Customer Info"];
		   CGRect frame = CGRectMake(0, 0, 400, 44);
		   UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
		   label.backgroundColor = [UIColor clearColor];
		   label.font = [UIFont boldSystemFontOfSize:15.0];
		   label.textAlignment = UITextAlignmentCenter;
		   label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		   label.textColor = [UIColor whiteColor];
		   label.text = headr;
		   self.navigationItem.titleView = label;
		   break;
   }
   }
}
//==============================================================================
-(void)deleteLocationButnPressed
{
	//CHANGES LOCATION IF ORESSED BY BRINGING USER TO ABOUT LOCATION SCREEN
	NSLog(@"TO BE IMPLEMENTED");
	
}

//==============================================================================
-(void)custInfoEditButnClicked
{
	customerInfoViewController *custInfoVC = [[[customerInfoViewController alloc]
											  initWithNibName:@"customerInfoViewController" 
											  bundle:nil] 
											  autorelease];
	[self.navigationController presentModalViewController:custInfoVC animated:YES];
	
}
//==============================================================================
-(void)populatePercentArrayForPicker:(NSMutableArray*)_percentArray andGratuityArray:(NSMutableArray*)_gratuityArray
{
	for(int i = 30; i >= 0; i--)
	   {
		int percent = i;
		NSString *percentStr = [NSString stringWithFormat:@"%d", percent];
		[_percentArray addObject:percentStr];
		float _percent = (float)percent;
		float gratAmount = (_percent/100) * [Cart getTotalCostOfAllItems];
		NSString *gratAmt = [NSString stringWithFormat:@"%.2f", gratAmount];
		[_gratuityArray addObject:gratAmt];
		
	   }
}
//==============================================================================
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	int selectedRow = Cart.myOrderSummaryRow;
	NSLog(@"Customer cell at %@ says show its sides", indexpath);
	NSLog(@"MyOrderSummaryRow that was clicked was %d", selectedRow);
	
	NSMutableString *theTitle = [[NSMutableString alloc]initWithString:@"Select a Gratuity amount \non total Charges: $ "];
	
	[theTitle appendString:[NSString stringWithFormat:@"%.2f",[Cart getTotalChargesWithTaxes]]];
	
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:theTitle
													  delegate:self
											 cancelButtonTitle:@"Select"
										destructiveButtonTitle:@"Cancel"
											 otherButtonTitles:nil];
	
	[theTitle release];
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,185,0,0)];
	self.gratPicker = pickerView;
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;    // note this is default to NO
	
	[menu addSubview:pickerView];
	
	[menu showInView:self.parentViewController.tabBarController.view];
	[menu setBounds:CGRectMake(0,0,320, 700)];
	[pickerView release];
	[menu release];
	

}


	
//==============================================================================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"Actionsheet button that was clicked has an index of: %d", buttonIndex);
	if(buttonIndex == 0) //Cancel was clicked
	   {
		NSLog(@"Actionsheet Cancel button was pressed no selection ,made for gratuity");
	   }
	else 
	{
	[self pickerView:self.gratPicker didSelectRow:[self.gratPicker selectedRowInComponent:0] inComponent:0];
	 [Cart addGratuity:[[self.arrayOfGratAmounts objectAtIndex:self.selectedPickerIndex] floatValue]];
	 NSLog(@"Gratuity in cart = %.2f", Cart.gratuity);
	 //update tableview
	 [self.myOrderTable reloadData];
	 float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
	 NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
	 [[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];

	 NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Gratuity & Other Charges: $"];
	 //update header
	 [headr appendString:[NSString stringWithFormat:@"%.2f",Cart.gratuity]];
	 CGRect frame = CGRectMake(0, 0, 300, 44);
	 UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	 label.backgroundColor = [UIColor clearColor];
	 label.font = [UIFont boldSystemFontOfSize:15.0];
	 label.textAlignment = UITextAlignmentCenter;
	 label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	 label.textColor = [UIColor whiteColor];
	 label.text = headr;
	 self.navigationItem.titleView = label;
	 
	}
}

//==============================================================================
#pragma mark UIPickerViewMethods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSMutableString* str = [[[NSMutableString alloc] initWithString:@"  "] autorelease];
	[str appendString:[self.gratPercents objectAtIndex:row]];
	[str appendString:@" %         = $ "];
	[str appendString:[arrayOfGratAmounts objectAtIndex:row]];
	
	return str;
}
//==============================================================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
//==============================================================================
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [arrayOfGratAmounts count];
}

//==============================================================================
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.selectedPickerIndex = row;
	NSLog(@"The selected index in pickerView was %d", self.selectedPickerIndex);
}
//============================================================================


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44;
}
//==============================================================================
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* customView;
	if (Cart.myOrderSummaryRow == 0)
	   {
		// create the parent view that will hold header Label
		customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.00)] autorelease];
		customView.backgroundColor = [UIColor grayColor];
		
		//food item label
		UILabel * _headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_headerLabel.backgroundColor = [UIColor clearColor];
		_headerLabel.opaque = YES;
		_headerLabel.textColor = [UIColor blackColor];
		
		_headerLabel.font = [UIFont boldSystemFontOfSize:14];
		_headerLabel.frame = CGRectMake(40.0, 0.0, 300.0, 44.0);
		
		NSMutableString *header = [[[NSMutableString alloc] initWithCapacity:20] autorelease];
		FoodItem *tmpFoodItem = [Cart.foodItemsArray objectAtIndex:section];
		[header appendString:tmpFoodItem.foodName];
		_headerLabel.text = header;
		 [customView addSubview:_headerLabel];
		[_headerLabel release];
		//price label
		UILabel * _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_priceLabel.backgroundColor = [UIColor clearColor];
		_priceLabel.opaque = YES;
		_priceLabel.textColor = [UIColor blackColor];
		
		_priceLabel.font = [UIFont boldSystemFontOfSize:14];
		_priceLabel.frame = CGRectMake(200.0, 0.0, 300.0, 44.0);
		
		NSMutableString *price = [[[NSMutableString alloc] initWithCapacity:20] autorelease];
		[price appendString:@"$"];
		[price appendString:tmpFoodItem.foodPrice];
		_priceLabel.text = price;
		[customView addSubview:_priceLabel];
		[_priceLabel release];
		
		//delete button
		UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];    
		deleteButton.frame = CGRectMake(260.0, 10, 40.0, 20.0); // x,y,width,height
		[deleteButton setTitle:@"-" forState:UIControlStateNormal];
		[deleteButton addTarget:self 
						 action:@selector(foodDeleteButtonPressed:)
			   forControlEvents:UIControlEventTouchDown];        
		
		deleteButton.tag = section;
		NSLog(@"The Button's tag = %d", deleteButton.tag);
		[customView addSubview:deleteButton];
		
	   }
	else 
	   {
		customView = nil;
	}

		
	return customView;
	
	
}


//==============================================================================
#pragma mark tableview_methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	int numsections = 0;
	switch (Cart.myOrderSummaryRow)
   {
	   case 0: //foodsection
		if ([Cart getNumberOfFoodItemsInCart] >= 0)
		   {
			numsections = [Cart getNumberOfFoodItemsInCart];
		   }
		break;
	   case 1: //drinksection
		if (numDrinkItems >= 1)
		   {
			numsections = 1;
		   }
		break;
	   case 2: //specialssection
		if (numSpecialItems >= 1)
		   {
			numsections = 1;
		   }
		break;
	   case 4: //taxes = HST + PST
		
		numsections = 1;
		
		break;
	   case 5: //other charges = gratuity
		numsections = 1;
		break;
	   case 7:
		numsections = 1;
		break;
	   case 8:
		numsections = 1;
		break;
	   default:
		numsections = 1;
		break;
   }
	
	return numsections;
}
//==============================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	
	self.itemsInCart = [Cart getNumberOfItemsInCart];
	self.numFoodItems = [Cart getNumberOfFoodItemsInCart];
	self.numDrinkItems = [Cart getNumberOfDrinkItemsInCart];
	self.numSpecialItems = [Cart getNumberOfOtherItemsInCart];
	if(self.numFoodItems >=1)
	   {
		tmpFoodItem = [Cart.foodItemsArray objectAtIndex:section];
	   }
	
	int numrows = 0;
	switch (Cart.myOrderSummaryRow)
   {
	   case 0: //foodsection
		if ([tmpFoodItem.sidesArray count] >= 1)
		   {
			numrows = [tmpFoodItem.sidesArray count];
		   }
		break;
	   case 1: //drinksection
		if (numDrinkItems >= 1)
		   {
			numrows = numDrinkItems;
		   }
		break;
	   case 2: //specialssection
		if (numSpecialItems >= 1)
		   {
			numrows = numSpecialItems;
		   }
		break;
	   case 4: //taxes = HST + PST
		numrows = [Cart.taxDictKeys count];
		break;
	   case 5: //other charges = gratuity
		numrows = 2;
		
		break;
	   case 7:
		numrows = 4;
		break;
	   case 8:
		numrows = 6;
		break;
	   default:
		numrows = 1;
		break;
   }
	
	return numrows;
	
}
//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	self.itemsInCart = [Cart getNumberOfItemsInCart];
	self.numFoodItems = [Cart getNumberOfFoodItemsInCart];
	self.numDrinkItems = [Cart getNumberOfDrinkItemsInCart];
	self.numSpecialItems = [Cart getNumberOfOtherItemsInCart];
	
	static NSString *CellIdentifier = @"chargesSummaryCell";
	myOrderCell = (chargesSummaryCell*)[self.myOrderTable dequeueReusableCellWithIdentifier:CellIdentifier];
	if (myOrderCell == nil) 
	   {
		NSLog(@"Cell created");
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"chargesSummaryCell"
															owner:nil
														  options:nil];
		for(id currentObj in nibObjects)
		   {
			if ([currentObj isKindOfClass:[chargesSummaryCell class]] ) 
			   {
				myOrderCell = (chargesSummaryCell *)currentObj;
			   }
		   }	
	   }
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	if (self.numFoodItems >= 1)
	{
		tmpFoodItem = [Cart.foodItemsArray objectAtIndex:section];
	}
	
	NSLog(@"Section = %d", section);
	NSLog(@"Row = %d", row);
	NSLog(@"numFoodItems = %d", numFoodItems);
	NSLog(@"numDrinkItems = %d", numDrinkItems);
	NSLog(@"numSpecialItems = %d", numSpecialItems);
	NSLog(@"numTotalItems = %d", itemsInCart);
	//======================================================	
	if (itemsInCart >= 1)
	   {
		switch (Cart.myOrderSummaryRow)
		  {
			  case 0: //food was tapped, show cell for cart.foodarray[row]
			 {
			  if ([tmpFoodItem.sidesArray count] >=1) //With Sides
				 {
				  SidesItem *side = [tmpFoodItem.sidesArray objectAtIndex:row];
				  myOrderCell.leftLabel.text = side.sideName;
				  myOrderCell.rightLabel.text = side.sidePrice;
				  myOrderCell.addButton.hidden = YES;
				 }
			  else //no sides
				 {
				  myOrderCell.leftLabel.text = @"No Sides";
				  myOrderCell.dollarSign.hidden = YES;
				  myOrderCell.rightLabel.hidden = YES;
				  myOrderCell.addButton.hidden = YES;
				 }
			  break;	 
			 } //Case 0
			  case 1: 
			 {
			  if(numDrinkItems >= 1)
				 {
				  DrinkItem *tmpDrinkItem = [Cart.drinkItemsArray objectAtIndex:row];
				  myOrderCell.leftLabel.text = tmpDrinkItem.drinkName;
				  myOrderCell.rightLabel.text = tmpDrinkItem.drinkPrice;
				 }
			  break;
			 } //case 1
			  case 2: //other was tapped, show cell for cart.otherarray[row]
			 {
			  if(numSpecialItems >=1)
				 {
				   SpecialsItem *tmpSpecialsItem = [Cart.otherItemsArray objectAtIndex:row];
				   myOrderCell.leftLabel.text = tmpSpecialsItem.specialsName;
				  myOrderCell.rightLabel.text = tmpSpecialsItem.specialsPrice;
				  // myOrderCell.accessoryType = UITableViewCellAccessoryNone;
				 }
			  break;
			 }
			  case 4: //was tapped show 2 rows 0 = HST & 1 = PST
			 {
			  
			  NSMutableString *typeTax = [[NSMutableString alloc] initWithString:[Cart.taxDictKeys objectAtIndex:row]];
	
			  float taxRate = [[Cart.taxDict objectForKey:typeTax]floatValue];
			  float taxPercent = taxRate *100;
			  [typeTax appendString:[NSString stringWithFormat:@" : %.2f %%", taxPercent]];
			  myOrderCell.leftLabel.text = typeTax; 
			  float taxAmt = [Cart getTotalCostOfAllItems] * taxRate;
			  myOrderCell.rightLabel.text = [NSString stringWithFormat:@"%.02f", taxAmt];
			  myOrderCell.rightLabel.textAlignment = UITextAlignmentLeft;
			  break;
			   
			 }
			  case 5: //other charges = gratuity
			 {
			  if (row == 0)
				 {
				  myOrderCell.leftLabel.text = @"Gratuity";
				  myOrderCell.rightLabel.text = [NSString stringWithFormat:@"%.02f", Cart.gratuity];
				  NSLog(@"Gratuity in cart = %.2f", Cart.gratuity);
				  myOrderCell.indexPathForCell = indexPath;
				  [myOrderCell.addButton setHidden: FALSE];
				  [myOrderCell.addButton setEnabled: TRUE];
				  myOrderCell.parentTableVC = self;
				 }
			  else 
				 {
				  myOrderCell.leftLabel.text = @"Other Charge";
				  myOrderCell.rightLabel.text = [NSString stringWithFormat:@"%.02f", Cart.miscCharges];
				  myOrderCell.indexPathForCell = indexPath;
				  [myOrderCell.addButton setHidden: TRUE];
				  [myOrderCell.addButton setEnabled: FALSE];
				  myOrderCell.parentTableVC = self;				 
				 }
				break; 
			}
			  case 7: //location
			 {
			  myOrderCell.LocationLabel.hidden = NO;
			  myOrderCell.LocationLabel.enabled = TRUE;
			  myOrderCell.leftLabel.hidden = TRUE;
			  myOrderCell.rightLabel.hidden = TRUE;
			  myOrderCell.dollarSign.hidden = TRUE;
			  myOrderCell.leftLabel.enabled = FALSE;
			  myOrderCell.rightLabel.enabled = FALSE;
			  myOrderCell.dollarSign.enabled = FALSE;
			  switch (row)
				{
				case 0: 
				 {
				  myOrderCell.LocationLabel.text = Cart.selectedLocation.CityName;
				  myOrderCell.LocationLabel.font = [UIFont boldSystemFontOfSize: 16];
					 break;
				 }
				case 1:
				 {
				  myOrderCell.LocationLabel.text = Cart.selectedLocation.Address;
					 break;
				 }
				case 2:
				 {	 
					 myOrderCell.LocationLabel.text = Cart.selectedLocation.PostalCode;
					break; 
				 }
				case 3:
				 {	 
					 myOrderCell.LocationLabel.text = Cart.selectedLocation.Telephone;
					 myOrderCell.LocationLabel.font = [UIFont boldSystemFontOfSize: 16];
					break; 
				 }
				}
			  myOrderCell.rightLabel.enabled = NO;
			  myOrderCell.rightLabel.hidden = YES;
			  break;
			 }
			  case 8: //Customer Info
			 {
			  if (!Cart.customerInfoObtained)
				{
				 
				 switch (row)
				   {
					   case 0: 
					  {
					   myOrderCell.leftLabel.text = @"Name:";
					   myOrderCell.rightLabel.text =@"No Info";
					   break;
					  }
					   case 1:
					{	 
						myOrderCell.leftLabel.text = @"Apt";
						myOrderCell.rightLabel.text =@"No Info";
						break;
					}
					   case 2:
					{	 
						myOrderCell.leftLabel.text = @"Street";
						myOrderCell.rightLabel.text =@"No Info";
						break; 
					}
					   case 3:
					{	 
						myOrderCell.leftLabel.text = @"Street";
						myOrderCell.rightLabel.text =@"No Info";
						break; 
					}
					   case 4:
					{	 
						myOrderCell.leftLabel.text = @"City";
						myOrderCell.rightLabel.text =@"No Info";
						break; 
					}
					   case 5:
					{	 
						myOrderCell.leftLabel.text = @"Telephone";
						myOrderCell.rightLabel.text =@"No Info";
						break; 
					}
					   case 6:
					{	 
						myOrderCell.leftLabel.text = @"email";
						myOrderCell.rightLabel.text =@"No Info";
						break; 
					} 
				   }
				} //if
			  else //Cart.customerinfoObtined == TRUE
				 {
				  myOrderCell.leftLabel.hidden = YES;
				  myOrderCell.leftLabel.enabled = NO;
				  myOrderCell.rightLabel.hidden = YES;
				  myOrderCell.rightLabel.enabled = NO;
				  myOrderCell.LocationLabel.enabled = YES;
				  myOrderCell.LocationLabel.hidden = NO;
				  switch (row)
					{
						case 0: 
					   {
						myOrderCell.LocationLabel.text = Cart.customerInfo.Name;
						break;
					   }
						case 1:
					 {	 
						myOrderCell.LocationLabel.text = Cart.customerInfo.AptNo;
						break;
					 }
						case 2:
					 {	 
						myOrderCell.LocationLabel.text = Cart.customerInfo.Street1;
						break; 
					 }
						case 3:
					 {	 
						myOrderCell.LocationLabel.text = Cart.customerInfo.Street2;
						 break; 
					 }
						case 4:
					 {	 
						myOrderCell.LocationLabel.text = Cart.customerInfo.City; 
						 break; 
					 }
						case 5:
					 {	 
						myOrderCell.LocationLabel.text = Cart.customerInfo.Tel;  
						 break; 
					 }
						case 6:
					 {	 
						myOrderCell.LocationLabel.text = Cart.customerInfo.Email;   
						 break; 
					 } 
					}
			  
			  break;
			 }
			  default:
			   break;
		  } //switch
	   }
	   }
	else //itemsincart ==0
	   {
		
		if (Cart.myOrderSummaryRow == 8)
		{
		 myOrderCell.leftLabel.text = @"Select Items First";
		 myOrderCell.rightLabel.text = @"";
		} 
		else 
		   {
			 myOrderCell.leftLabel.text = @"No Item Selected";
			myOrderCell.rightLabel.text = @"0.00";
		   }

				
		[myOrderCell.addButton setHidden: TRUE];
		[myOrderCell.addButton setEnabled: FALSE];

	   }

	myOrderCell.accessoryType = UITableViewCellAccessoryNone;
	
	if (Cart.myOrderSummaryRow != 5)
	   {
		[myOrderCell.addButton setHidden: TRUE];
		[myOrderCell.addButton setEnabled: FALSE];
	   }
	if (Cart.myOrderSummaryRow == 7 ||Cart.myOrderSummaryRow == 8) 
	{
	 
	 myOrderCell.dollarSign.hidden = YES;
	 myOrderCell.dollarSign.enabled = NO;
	}
	
	myOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
	myOrderCell.leftLabel.textColor = [UIColor blackColor];
	myOrderCell.leftLabel.font = [UIFont boldSystemFontOfSize:14];
	
	return myOrderCell;
}
//====================================================================================================

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:(BOOL)animated];
	//[self.navigationController popViewControllerAnimated:NO ];
}


//=============================================================================
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{	
	MyOrderFoodDetailVC *FoodDetailVC = [[MyOrderFoodDetailVC alloc]
										 initWithNibName:@"MyOrderFoodDetailVC" 
										 bundle:nil];
	FoodDetailVC.indxPthOfCallingCell = indexPath;
	[self.navigationController pushViewController: FoodDetailVC animated: YES];
	[FoodDetailVC release];		
}
//==============================================================================
- (void)didReceiveMemoryWarning 
{
	/*
	 // Releases the view if it doesn't have a superview.
	 [super didReceiveMemoryWarning];
	 
	 // Release any cached data, images, etc. that aren't in use.
	 */
}
//==============================================================================
- (void)viewDidUnload 
{
	/*
	 [super viewDidUnload];
	 // Release any retained subviews of the main view.
	 // e.g. self.myOutlet = nil;
	 */
}
//==============================================================================
- (void)dealloc 
{
	
	[myOrderTable release];
	[arrayOfGratAmounts release];
	[gratPercents release];
	
	    [super dealloc];
}
//==============================================================================

@end
