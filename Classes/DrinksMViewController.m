#import "DrinksMViewController.h"

@implementation DrinksMViewController

@synthesize DrinkMDict;
@synthesize DrinkCategoriesArray;
@synthesize DrinkMTable;
@synthesize ViewControllerIdentifier;

@synthesize drinkModel;
@synthesize selectedDrinkItem;
@synthesize lastSelectedIndexPath;

CartSingleton* Cart;
customTableCell1 *drinkTableCell;
customTableCell1 *selectedDrinksCell;


//==============================================================================
#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    
	[super viewDidLoad];
	NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Drinks"];
	CGRect frame = CGRectMake(0, 0, 100, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textColor = [UIColor whiteColor];
	label.text = headr;
	self.navigationItem.titleView = label;
	drinkModel = [DrinkModel getsharedDrinkModel];
	
	
	UIBarButtonItem *RemoveLastButton = [[UIBarButtonItem alloc]
										 initWithTitle:@"Remove Last"
										 style:UIBarButtonItemStyleDone
										 target:self
										 action:@selector(RemoveLastButtonPressed)];
	self.navigationItem.leftBarButtonItem = RemoveLastButton;
	
}
//==============================================================================
-(void)EmptyCartButtonPressed
{
	
	NSLog(@"Emptying all contents of cart");
}
//==============================================================================
-(void)RemoveLastButtonPressed
{
	
	NSLog(@"Remove Last  Item Button pressed");
	if([Cart getNumberOfDrinkItemsInCart]<1)
	   {
		UIAlertView *noItemsToDelete = [[UIAlertView alloc] initWithTitle:@"No Items To Remove!"
																message:nil
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
		[noItemsToDelete show];
		[noItemsToDelete release];
		
	   }
	else
	   {
		[Cart printCart];
		DrinkItem *tmpItem = [Cart.drinkItemsArray lastObject];
		if (tmpItem != NULL)
		   {
			NSLog(@"Removing last drink item in array: %@", tmpItem.drinkName);
			[Cart.drinkItemsArray removeLastObject];
			[Cart printCart];
		   }
	   
	NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfDrinkItemsInCart]] stringValue]]autorelease];
	if([Cart getNumberOfDrinkItemsInCart]>=1)
	   {
		NSLog(@"Changing BadgeValue....Number of items in cart after remove last item =%@", itemsInCart);
		[[[[[self tabBarController] tabBar] items] objectAtIndex:2]setBadgeValue:itemsInCart];
	   }
	else 
	   {
		[[[[[self tabBarController] tabBar] items] objectAtIndex:2]setBadgeValue:nil];
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
}
//==============================================================================


#pragma mark customCellAddButnClicked protocol methods
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	NSLog(@"Protocol method implementation..");
	NSLog(@"indexPath received byt UITableView controller from Custom cell is: %@", indexpath);
	
	
	
	selectedDrinkItem = [drinkModel getItemForIndexPath:indexpath];
	
	
	NSMutableString* drinkSelected  = [[NSMutableString alloc ] initWithString:@""];
	[drinkSelected appendString:selectedDrinkItem.drinkName];
	[drinkSelected appendString:@" "];
	[drinkSelected appendString:@"\n"];
	[drinkSelected appendString: selectedDrinkItem.drinkPrice];
	
	UIAlertView *tableRowSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Add to Cart?"
																	message:drinkSelected
																   delegate:self
														  cancelButtonTitle:@"No"
														  otherButtonTitles:@"Yes",nil ];
	
	
	[drinkSelected release];
	[tableRowSelectedAlert show];
	[tableRowSelectedAlert release];
	 self.lastSelectedIndexPath = indexpath;
	
	}

//==============================================================================
#pragma mark UIAlertViewmethods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	NSLog(@"clickedButtonAIndex says %d was pressed", buttonIndex);
	if (buttonIndex != 1) //Cancel button was pressed
	   {
		NSLog(@"ORDER NOT ADDED TO CART");
		[[self.DrinkMTable cellForRowAtIndexPath:self.lastSelectedIndexPath] setHighlighted:NO];
		
		self.lastSelectedIndexPath = nil;
		
	   }
	else //(buttonIndex == 1) Add Button was pressed
	   {
			Cart = [CartSingleton getSingleton];
		
		DrinkItem *selectedDrinkItemObj = [[DrinkItem alloc] initWithObjects:selectedDrinkItem.drinkName
																 Description:selectedDrinkItem.drinkDescription
																	Calories:selectedDrinkItem.drinkCalories
																	   Price:selectedDrinkItem.drinkPrice
																   photoPath:selectedDrinkItem.pathToPhoto
																	Category:selectedDrinkItem.drinkCategory];
		
		
		[Cart addDrinkItemToCart:selectedDrinkItemObj];
		[selectedDrinkItemObj release];
		NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfDrinkItemsInCart]] stringValue]]autorelease];
		[[[[[self tabBarController] tabBar] items] objectAtIndex:2]setBadgeValue:itemsInCart];
		
		
		float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
		NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
		
		
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
   
	NSInteger numSections = [drinkModel getnumberOfCategories];
	return numSections;
}

//==============================================================================
//method is called by the application to generate a tableView
//application goes through the section array and for each section number calls this method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
   	NSInteger numRows = [drinkModel getItemsInADrinkArrayForCategoryAtIndex:section];
	return numRows;
}

//==============================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *cellIdentifier = @"customTableCell1";
    drinkTableCell = (customTableCell1*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (drinkTableCell == nil) 
	   {
        NSLog(@"Cell created");
		
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"customTableCell1"
															owner:nil
														  options:nil];
		
		for(id currentObj in nibObjects)
		   {
			if ([currentObj isKindOfClass:[customTableCell1 class]] ) 
			   {
				drinkTableCell = (customTableCell1 *)currentObj;
			   }
		   }	
	   }
	
	DrinkItem  *currDrinkItem = [drinkModel getItemForIndexPath:indexPath];
	
	drinkTableCell.accessoryType = UITableViewCellAccessoryNone;
	
	drinkTableCell.locationLabel.hidden = TRUE;
	drinkTableCell.foodItemLabel.text = currDrinkItem.drinkName;
	drinkTableCell.thumbImage.hidden = NO;
	drinkTableCell.parentTableVC = self;
	drinkTableCell.indexPathForCell = indexPath;
	drinkTableCell.AddSidesToCartBtn.hidden = YES;
	drinkTableCell.AddSidesToCartBtn.enabled =NO;
	drinkTableCell.ItemPrice.text =  currDrinkItem.drinkPrice;
	
	drinkTableCell.ItemCategory = [drinkModel getCategoryforIndexPath:indexPath];
	drinkTableCell.ItemMisc.hidden = YES;
	drinkTableCell.CityName.hidden = TRUE;
	
	return drinkTableCell;
}
//==============================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   	
	NSString *headr = [drinkModel getHeaderForSection:section];
	return headr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}

//==============================================================================

#pragma mark -
#pragma mark Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
		
	
}

//=============================================================================
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
	
	
}
*/
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


@end

