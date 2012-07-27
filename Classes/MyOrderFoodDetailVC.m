#import "MyOrderFoodDetailVC.h"


@implementation MyOrderFoodDetailVC
@synthesize indxPthOfCallingCell;
@synthesize tmpFoodItem;
@synthesize _sidesArr;
@synthesize myOrderSections;

CartSingleton *Cart;
customTableCell2 *myOrderCell;
#pragma mark -
#pragma mark View lifecycle
//==============================================================================
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.tableView reloadData];
	Cart = [CartSingleton getSingleton];
	tmpFoodItem = [Cart.foodItemsArray objectAtIndex:indxPthOfCallingCell.row];
	_sidesArr = tmpFoodItem.sidesArray;
}
//==============================================================================
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	
	Cart = [CartSingleton getSingleton];
	tmpFoodItem = [Cart.foodItemsArray objectAtIndex:indxPthOfCallingCell.row];
	_sidesArr = tmpFoodItem.sidesArray;
	self.navigationItem.title = @"Sides";

	NSError *error;
	NSString *errorDesc = nil;
	NSData *plistXML;
	NSPropertyListFormat format;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistDocPath = [rootPath stringByAppendingPathComponent:@"myOrderDetail.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:plistDocPath]) 
	   {
		NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"myOrderDetail" ofType:@"plist"];
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
		myOrderSections = [[NSMutableArray alloc]initWithArray:temp];
	   }
}

//==============================================================================
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
//==============================================================================
#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
	//section 0 will have the itemname
	//section 1 will have the sides info
}
//==============================================================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
		
    //return numRows;
	return [_sidesArr count];
}

//==============================================================================
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *cellIdentifier = @"customTableCell2";
	myOrderCell = (customTableCell2*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (myOrderCell == nil) 
	   {
		NSLog(@"Cell created");
		
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"customTableCell2"
															owner:nil
														  options:nil];
		
		for(id currentObj in nibObjects)
		   {
			if ([currentObj isKindOfClass:[customTableCell2 class]] ) 
			   {
				myOrderCell = (customTableCell2 *)currentObj;
			   }
		   }	
	   }
    
	 SidesItem *itm = [_sidesArr objectAtIndex:indexPath.row];
	 
	myOrderCell.itemName.text = tmpFoodItem.foodName;
	myOrderCell.Total.text = @"Total";
	myOrderCell.itemName.hidden = TRUE;
	myOrderCell.Total.hidden = TRUE;
	
	myOrderCell.TotalEditable.text = [NSString stringWithFormat:@" %.2f", [itm.sidePrice floatValue]];
	myOrderCell.itemPrice.text = @" Item";
	myOrderCell.sides.text = @" Side";
	myOrderCell.leftSides.text = itm.sideName;
	myOrderCell.accessoryType = UITableViewCellAccessoryNone;
	myOrderCell.dollarTop.text = @":";
	myOrderCell.dollarTop.hidden = TRUE;
	myOrderCell.dollarMid.text = @":";
	
    return myOrderCell;
}
//==============================================================================
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
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
	/*
	@synthesize indxPthOfCallingCell;
	@synthesize tmpFoodItem;
	@synthesize _sidesArr;
	@synthesize myOrderSections;
	*/
	
	
    [super dealloc];
}


@end

