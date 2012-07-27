#import "myOrderSummary.h"

@implementation myOrderSummary
@synthesize tableView;
@synthesize myOrderRows;
@synthesize proceedToOrderDetails;
@synthesize selectedCellIndex;
@synthesize shouldBeEmpty;
@synthesize federalTax;
@synthesize cityTax;
@synthesize provinceTax;
@synthesize sendOrderVC;

CartSingleton *Cart;
chargesSummaryCell *SummaryCell;
float otherCharges;
//==============================================================================
-(void)viewWillAppear:(BOOL)animated
{
	
	[self.tableView reloadData];
	float totCostAllItemsInCart = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
	
	if(!totCostAllItemsInCart <= 0)
	{
	 NSString* totalDollarsinCart = [NSString stringWithFormat:@"$%.2f", totCostAllItemsInCart];
	 [[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:totalDollarsinCart];
	}
	otherCharges = [Cart getTotalOtherCharges];
	
}
//==============================================================================
- (void) customCellAddButnClicked:(NSIndexPath*)indexpath withTag:(NSInteger)tag
{
	NSLog(@"Inside CustomCellButnClicked in myOrderSummary");
	NSLog(@"indexPath received byt UITableView controller from Custom cell is: %@", indexpath);
	self.selectedCellIndex = indexpath;
	
}

//==============================================================================
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad 
{
    [super viewDidLoad];
	Cart = [CartSingleton getSingleton];
	NSError *error = nil;
	NSString *errorDesc = nil;
	NSData *plistXML;
	NSPropertyListFormat format;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"myOrderSummary.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:plistDocPath]) 
	   {
		NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"myOrderSummary" ofType:@"plist"];
		[fileManager copyItemAtPath:plistBundlePath toPath:plistDocPath error:&error]; 
		if(![fileManager fileExistsAtPath:plistDocPath])
		   {
			NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
		   }
	   }
	plistXML = [fileManager contentsAtPath:plistDocPath];
	NSArray *temp = (NSArray*) [NSPropertyListSerialization
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
		myOrderRows = [[NSMutableArray alloc]initWithArray:temp];
	   }
	self.navigationItem.title = @"Checkout";
	
	UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Bill"
								   style:UIBarButtonItemStyleBordered
								   target:nil
								   action:nil];
	self.navigationItem.backBarButtonItem = backbutton;
	
	UIBarButtonItem *EmptyCartButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Empty Cart"
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(EmptyCartButtonPressed)];
	self.navigationItem.leftBarButtonItem = EmptyCartButton;
	
	UIBarButtonItem *SendOrderButton = [[UIBarButtonItem alloc]
										initWithTitle:@"Send Order"
										style:UIBarButtonItemStyleDone
										target:self
										action:@selector(SendOrderButtonPressed)];
	self.navigationItem.rightBarButtonItem = SendOrderButton;
	
	//register for notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(recevedCartSentNotification:)
												 name:@"CartSent"
											   object:nil];
	
	
	
	
}
//==============================================================================
-(void)recevedCartSentNotification:(NSNotification*)notification
{
	if([[notification name] isEqualToString:@"CartSent"])
	   {
		NSLog(@"Received notification that cart was sent successfully..... Now clear badges");
		[self EmptyCartButtonPressed];
	   }
}



//==============================================================================
-(void)EmptyCartButtonPressed
{
	
	NSLog(@"Emptying all contents of cart");
	[Cart emptyCart];	
	[[[[[self tabBarController] tabBar] items] objectAtIndex:0]setBadgeValue:nil];
	[[[[[self tabBarController] tabBar] items] objectAtIndex:1]setBadgeValue:nil];
	[[[[[self tabBarController] tabBar] items] objectAtIndex:2]setBadgeValue:nil];
	[[[[[self tabBarController] tabBar] items] objectAtIndex:3]setBadgeValue:nil];
	[[[[[self tabBarController] tabBar] items] objectAtIndex:4]setBadgeValue:nil];
	//[Cart printCart];
	
	self.shouldBeEmpty = TRUE;
	[Cart ResetCartToNull];
	[self.tableView reloadData];
	self.shouldBeEmpty = FALSE;
	//Cart is nil now, need to initialize an empty cart because many other objects depend on the default values in the cart
	//not initializing cart results in crash
	Cart = [CartSingleton getSingleton];
}
//==============================================================================
-(void)SendOrderButtonPressed
{
	
	NSLog(@"Send order button pressed");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Have you Verified you selections?"
															 delegate:self
													cancelButtonTitle:@"Wait. Don't send Order"
											   destructiveButtonTitle:@"Yes. Send Order"
													otherButtonTitles:nil];
	
	[actionSheet showInView:self.parentViewController.tabBarController.view];
	
	
	
	[actionSheet release];
	
}
//==============================================================================
-(void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [actionSheet cancelButtonIndex])
	{
	 NSLog(@"Cancelled sending order");
	}
	else 
	{
	 	
	 NSLog(@"Serialize Cart and send order");
	 //Launch a new view controller
	 self.sendOrderVC = [[SendOrderViewController alloc] 
						 initWithNibName:@"SendOrderViewController"
						 bundle:nil];
	 
	 [sendOrderVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	 [self presentModalViewController:sendOrderVC 
							 animated: YES ];	 
	
	}

}
//==============================================================================
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{	
	
	return 1;
}

//=============================================================================
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger numRows = [myOrderRows count];
	return numRows;
}
//=============================================================================
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"chargesSummaryCell";
	
	SummaryCell = (chargesSummaryCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (SummaryCell == nil) 
	   {
		NSLog(@"Cell created");
		
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"chargesSummaryCell"
															owner:nil
														  options:nil];
		
		for(id currentObj in nibObjects)
		   {
			if ([currentObj isKindOfClass:[chargesSummaryCell class]] ) 
			   {
				SummaryCell = (chargesSummaryCell *)currentObj;
				/*
				if ((indexPath.row % 2)== 0) {
					[SummaryCell.contentView setBackgroundColor:[UIColor whiteColor]];
					
				}else{
					[SummaryCell.contentView setBackgroundColor:[UIColor lightGrayColor]];
					
				}
				*/
			   }
		   }	
		
	   }
	
	if(self.shouldBeEmpty)
	   {
		SummaryCell.leftLabel.text = @"";
		SummaryCell.rightLabel.text = @"";
		SummaryCell.dollarSign.text = @"";
		SummaryCell.LocationLabel.hidden = TRUE;
		SummaryCell.LocationLabel.enabled = FALSE;
		SummaryCell.indexPathForCell = indexPath;
		return SummaryCell;
	   }
	
	
	SummaryCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	SummaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
	SummaryCell.leftLabel.textColor = [UIColor blackColor];
	[SummaryCell.leftLabel setFont:[UIFont boldSystemFontOfSize:14]];
	SummaryCell.rightLabel.textColor = [UIColor darkGrayColor];
	[SummaryCell.rightLabel setFont:[UIFont fontWithName:@"Arial" size: 16]];
	
	SummaryCell.LocationLabel.hidden = TRUE;
	SummaryCell.LocationLabel.enabled = FALSE;

	SummaryCell.leftLabel.text = [myOrderRows objectAtIndex:indexPath.row];
	SummaryCell.rightLabel.textAlignment = UITextAlignmentRight;
	SummaryCell.parentTableVC = self;
	SummaryCell.indexPathForCell = indexPath;
	NSMutableString *costString = [[NSMutableString alloc] initWithString:@""];
	
	float tot = [Cart getTotalCostOfAllItems];
	NSLog(@"Cost os all items is @%.02f", tot);
	switch (indexPath.row)
   {
	   case 0: //food
		[costString appendString:[NSString stringWithFormat:@"%.02f", [Cart getTotalCostOfAllFoodItems]]];
		SummaryCell.rightLabel.text  = costString;
		if ([Cart getNumberOfFoodItemsInCart] < 1) 
		   {
			SummaryCell.accessoryType = UITableViewCellAccessoryNone;
		   }
		SummaryCell.addButton.hidden = YES;
		
		break;
	   case 1: //drink
		[costString appendString:[NSString stringWithFormat:@"%.02f", [Cart getTotalCostOfAllDrinkItems]]];
		SummaryCell.rightLabel.text  = costString;
		if ([Cart getNumberOfDrinkItemsInCart] < 1) 
		   {
			SummaryCell.accessoryType = UITableViewCellAccessoryNone;
		   }
		SummaryCell.addButton.hidden = YES;
		break;
	   case 2: //other
		[costString appendString:[NSString stringWithFormat:@"%.02f", [Cart getTotalCostOfAllOtherItems]]];
		SummaryCell.rightLabel.text  = costString;
		if ([Cart getNumberOfOtherItemsInCart] < 1) 
		   {
			SummaryCell.accessoryType = UITableViewCellAccessoryNone;
		   }
		SummaryCell.addButton.hidden = YES;
		break;
	   case 3: //subtotal
		[costString appendString:[NSString stringWithFormat:@"%.02f", tot]];
		SummaryCell.rightLabel.text  = costString;
		SummaryCell.accessoryType = UITableViewCellAccessoryNone; 
		SummaryCell.addButton.hidden = YES;
		break;
	   case 4: //Taxes
	  {
	   
	   float totalAfterTax = [Cart getTotalTaxAmountForAllItems];
	   [costString appendString:[NSString stringWithFormat:@"%.02f", totalAfterTax]];
	   SummaryCell.rightLabel.text  = costString;
	   if (tot <= 0) 
		  {
		   SummaryCell.accessoryType = UITableViewCellAccessoryNone;
		  }
	   SummaryCell.addButton.hidden = YES;
	   break;	   
	  }
		
	   case 5: //Other Charges
	{	
		if(otherCharges <= 0)
		   {
			[costString appendString:[NSString stringWithFormat:@"0.00"]];
		   }
		else 
		{
			[costString appendString:[NSString stringWithFormat:@"%.02f",[Cart getTotalOtherCharges]]];
		}
		
		SummaryCell.rightLabel.text  = costString;
		SummaryCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		SummaryCell.addButton.hidden = TRUE;
		SummaryCell.addButton.enabled = FALSE;
	}
		break;
	   case 6: //Total
	  {
	   float tot = [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems] + Cart.gratuity;
	   [costString appendString:[NSString stringWithFormat:@"%.02f", tot]];
	   SummaryCell.rightLabel.text  = costString;
	   SummaryCell.accessoryType = UITableViewCellAccessoryNone; 
	   SummaryCell.addButton.hidden = YES;
	   
	   
	   SummaryCell.dollarSign.textColor = [UIColor redColor];
	   
	   SummaryCell.dollarSign.font = [UIFont boldSystemFontOfSize:16];
	   SummaryCell.rightLabel.font = [UIFont boldSystemFontOfSize:16];
	   SummaryCell.rightLabel.textColor = [UIColor redColor];
	   break;
	  }
		case 7:
	  {
	   SummaryCell.rightLabel.hidden = TRUE;
	   SummaryCell.rightLabel.enabled = FALSE;
	   SummaryCell.dollarSign.enabled = FALSE;
	   SummaryCell.dollarSign.hidden = TRUE;
	   SummaryCell.addButton.enabled = FALSE;
	   SummaryCell.addButton.hidden = TRUE;
	   break;	   
	  }
		case 8:
	  {
	   SummaryCell.rightLabel.hidden = TRUE;
	   SummaryCell.rightLabel.enabled = FALSE;
	   SummaryCell.dollarSign.enabled = FALSE;
	   SummaryCell.dollarSign.hidden = TRUE;
	   SummaryCell.addButton.enabled = FALSE;
	   SummaryCell.addButton.hidden = TRUE;
	   break;	   
	  }
		default:
		[costString appendString:[NSString stringWithFormat:@"%.02f", [Cart getTotalCostOfAllItems] + [Cart getTotalTaxAmountForAllItems]]];
		SummaryCell.rightLabel.text  = costString;
		SummaryCell.addButton.hidden = YES;
		break;
   }
	[costString release];
		return SummaryCell;
}
//==============================================================================
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
	if (Cart == nil)
	   {
		UIAlertView *emptyCartView = [[UIAlertView alloc] initWithTitle:@"Alert!"
												   message:@"Cart is empty"
												  delegate:self
										 cancelButtonTitle:@"OK"
										 otherButtonTitles:nil];
		[emptyCartView show];
		[emptyCartView release];
		return;
	}
	else 
	{
	 //The cart keeps a pointer to which reow was pressed
	 if (indexPath.row!= 7)
		{
		 Cart.myOrderSummaryRow = indexPath.row;
		 
		 MyOrderViewController *myOrderVC = [[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
		 [self.navigationController pushViewController: myOrderVC animated: YES];
		 [myOrderVC release];
		}
	 else 
		{
		 AboutLocationViewController *LocViewController = [[AboutLocationViewController alloc] 
														   initWithNibName:@"AboutLocationViewController" 
														   bundle:nil];
		 [self.navigationController pushViewController:LocViewController
											  animated:YES];
		 [LocViewController release];	
		 
		}
	 
	}

	
	
	
}

//==============================================================================
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//==============================================================================
- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//==============================================================================

- (void)dealloc 
{
    //release from notification
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[myOrderRows release];
	
	
	[super dealloc];
}


@end