#import "SpecialsMViewController.h"
@implementation SpecialsMViewController

@synthesize SpecialsDict;
@synthesize SpecialsCategoryArray;
@synthesize Specialstable;
@synthesize ViewControllerIdentifier;

@synthesize specialsModel;
@synthesize selectedSpecialsItem;

CartSingleton* Cart;
customTableCell1* specialsCell;
//==============================================================================
#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSMutableString *headr  = [[NSMutableString alloc] initWithString:@"Specials"];
	CGRect frame = CGRectMake(0, 0, 100, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:16.0];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textColor = [UIColor whiteColor];
	label.text = headr;
	self.navigationItem.titleView = label;
	
	UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Specials"
								   style:UIBarButtonItemStyleBordered
								   target:nil
								   action:nil];
	self.navigationItem.backBarButtonItem = backbutton;
	specialsModel = [SpecialsModel getsharedSpecialsModel];
	
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
	if([Cart getNumberOfOtherItemsInCart]<1)
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
		SpecialsItem *tmpItem = [Cart.otherItemsArray lastObject];
		if (tmpItem != NULL)
		   {
			NSLog(@"Removing last specials item in array: %@", tmpItem.specialsName);
			[Cart.otherItemsArray removeLastObject];
			[Cart printCart];
		   }
		
		NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfOtherItemsInCart]] stringValue]]autorelease];
		if([Cart getNumberOfOtherItemsInCart]>=1)
		   {
			NSLog(@"Changing BadgeValue....Number of items in cart after remove last item =%@", itemsInCart);
			[[[[[self tabBarController] tabBar] items] objectAtIndex:3]setBadgeValue:itemsInCart];
		   }
		else 
		   {
			[[[[[self tabBarController] tabBar] items] objectAtIndex:3]setBadgeValue:nil];
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
#pragma mark protocolMethod
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	NSLog(@"Protocol method implementation..");
	NSLog(@"indexPath received byt UITableView controller from Custom cell is: %@", indexpath);
	
	
	selectedSpecialsItem = [specialsModel getItemForIndexPath:indexpath];
	
	NSMutableString* specialItemSelected  = [[NSMutableString alloc ] initWithString:@""];
	
	[specialItemSelected appendString:selectedSpecialsItem.specialsName];
	[specialItemSelected appendString:@"\n"];
	[specialItemSelected appendString:selectedSpecialsItem.specialsPrice];
	
	UIAlertView *tableRowSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Add to Cart:"
																	message:specialItemSelected
																   delegate:self
														  cancelButtonTitle:@"Cancel"
														  otherButtonTitles:@"Add",nil ];
	
		[specialItemSelected release];
	[tableRowSelectedAlert show];
	[tableRowSelectedAlert release];
	
}
//==============================================================================
#pragma mark UIAlertViewEvents
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	NSLog(@"clickedButtonAIndex says %d was pressed", buttonIndex);
	if (buttonIndex != 1) //Cancel button was pressed
	   {
		NSLog(@"ORDER NOT ADDED TO CART");
	   }
	else //(buttonIndex == 1) Add Button was pressed
	   {
		//Create a Item Object
		Cart = [CartSingleton getSingleton];
		
		SpecialsItem *selectedSpecialsItemObj = [[SpecialsItem alloc] initWithObjects:selectedSpecialsItem.specialsName
																		  Description:selectedSpecialsItem.specialsDescription
																				Price:selectedSpecialsItem.specialsPrice
																			photoPath:selectedSpecialsItem.pathToPhoto
																			 Category:selectedSpecialsItem.specialsCategory];
		
		[Cart addSpecialsItemToCart:selectedSpecialsItemObj];
		[selectedSpecialsItemObj release];
		
		NSString* itemsInCart = [[[NSString alloc]initWithString:[[NSNumber numberWithInt:[Cart getNumberOfOtherItemsInCart]] stringValue]]autorelease];
		[[[[[self tabBarController] tabBar] items] objectAtIndex:3]setBadgeValue:itemsInCart];
		
		
		float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
		NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
		[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
		
		
		
	   }
	
	
}
//==============================================================================

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    NSInteger numSections = [specialsModel getnumberOfCategories];
	return numSections;
}

//==============================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numRows = [specialsModel getItemsInASpecialsArrayForCategoryAtIndex:section];
	return numRows;
 
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






// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *SpecialsCellIdentifier = @"customTableCell1";
    
    customTableCell1 *specialsCell = (customTableCell1*)[tableView dequeueReusableCellWithIdentifier:SpecialsCellIdentifier];
    if (specialsCell == nil) 
	   {
        NSLog(@"Cell created");
        
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"customTableCell1"
															owner:nil
														  options:nil];
		for(id currentObj in nibObjects)
		   {
			if ([currentObj isKindOfClass:[customTableCell1 class]] ) 
			   {
				specialsCell = (customTableCell1 *)currentObj;
			   }
		   }			
	   }	
	
	SpecialsItem *currSpecialsItem = [specialsModel getItemForIndexPath:indexPath];
	
	
	specialsCell.locationLabel.hidden = TRUE;
	specialsCell.foodItemLabel.text = currSpecialsItem.specialsName;
	specialsCell.thumbImage.hidden = FALSE;
	
	specialsCell.ItemPrice.text = currSpecialsItem.specialsPrice;
	specialsCell.parentTableVC = self;
	specialsCell.indexPathForCell = indexPath;
	specialsCell.ItemMisc.hidden = YES;
	specialsCell.CityName.hidden = true;
	specialsCell.AddSidesToCartBtn.hidden = YES;
	specialsCell.AddSidesToCartBtn.enabled = NO;
	
	specialsCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	return specialsCell;
	
}

//==============================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *headr = [specialsModel getHeaderForSection:section];
	return headr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}




//=============================================================================
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
	SpecialsDetailViewController *SpecialsDetailVC = [[SpecialsDetailViewController alloc]
													  initWithNibName:@"SpecialsDetailViewController" 
													  bundle:nil];
	[self.navigationController pushViewController: SpecialsDetailVC animated: YES];
	[SpecialsDetailVC release];
	
	}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

