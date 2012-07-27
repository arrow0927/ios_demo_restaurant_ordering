#import "AboutViewController.h"
#import "bitMobileViewController.h"

@implementation AboutViewController
@synthesize promoBanner, AboutSeg, textView, backgroundImage, bizLogo;

//==============================================================================
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Home"
								   style:UIBarButtonItemStyleBordered
								   target:nil
								   action:nil];
	self.navigationItem.backBarButtonItem = backbutton;
	[backbutton release];
	//==========================================================================
	NSError *error;
	
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *promoImgDocPath = [rootPath stringByAppendingPathComponent:@"PizzaPromo.png"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:promoImgDocPath]) 
	   {
		NSString *plistBundlePath = [[NSBundle mainBundle] pathForResource:@"PizzaPromo" ofType:@"png"];
		[fileManager copyItemAtPath:plistBundlePath toPath:promoImgDocPath error:&error]; 
		if(![fileManager fileExistsAtPath:promoImgDocPath])
		   {
			NSLog(@"The copy function did not work, file was not copied from bundle to documents folder");
		   }
	   }
	
	self.promoBanner.image =[UIImage imageWithContentsOfFile:promoImgDocPath];
	
	if (!self.promoBanner.image) 
	   {
		NSLog(@"Error setting image on about view controller");
	   }
	
	//==========================================================================
	self.bizLogo.hidden = YES;	
	self.promoBanner.hidden = NO;
	self.textView.hidden = YES;
	self.backgroundImage.hidden = NO;
	
	AboutSeg = [[UISegmentedControl alloc] initWithItems:
				[NSArray arrayWithObjects: @"About Us", @"Promotions", nil]];
	AboutSeg.segmentedControlStyle = UISegmentedControlStyleBar;
	AboutSeg.selectedSegmentIndex = 1;
	[AboutSeg addTarget:self action:@selector(AboutSegPressed:) forControlEvents: UIControlEventValueChanged];
	[AboutSeg setWidth:90.0 forSegmentAtIndex:0];	
	[AboutSeg setWidth:90.0 forSegmentAtIndex:1];
	[AboutSeg setSegmentedControlStyle:UISegmentedControlStyleBar];
	self.navigationItem.titleView = AboutSeg;
	[AboutSeg release];
	//=================================
	/*This button launches the bitmobileviewcontroller*/
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
	[infoButton addTarget:self 
				   action:@selector(infoButtonAction) 
		 forControlEvents:UIControlEventTouchUpInside];
	//===================================
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setLeftBarButtonItem:modalButton animated:YES];
	[modalButton release];	
	//===================================
	/* This buttoon launches the view that displays the locatons of  the  restautants*/
	
	UIButton* locationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[locationButton addTarget:self 
				   action:@selector(locButtonPressed) 
		 forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *locButton = [[UIBarButtonItem alloc] initWithCustomView:locationButton];
	[self.navigationItem setRightBarButtonItem:locButton animated:YES];
	[locButton release];	
	
}
//==============================================================================
-(void)locButtonPressed
{
	AboutLocationViewController *LocViewController = [[AboutLocationViewController alloc] 
													  initWithNibName:@"AboutLocationViewController" 
													  bundle:nil];
	[self.navigationController pushViewController:LocViewController
										 animated:YES];
	[LocViewController release];
}
//==============================================================================
-(void)infoButtonAction
{
	bitMobileViewController *bitMobileVC = [[bitMobileViewController alloc] 
													  initWithNibName:@"bitMobileViewController" 
													  bundle:nil];
	[bitMobileVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	
	[self presentModalViewController:bitMobileVC 
							animated: YES ];
					
	[bitMobileVC release];
	
}
//==============================================================================
-(IBAction)promoBannerClicked
{
	//function not used
	NSLog(@"Promobanner pressed, show UIAlertViw");
}

//==============================================================================
-(void)AboutSegPressed:(id)sender
{
	if([sender selectedSegmentIndex] == 0)  //About Us
	   {
		self.bizLogo.hidden = NO;	
		self.promoBanner.hidden = YES;
		self.textView.hidden = NO;
		self.backgroundImage.hidden = NO;
	   }
	else //Promotions
	   {
		self.bizLogo.hidden = TRUE;	
		self.promoBanner.hidden = FALSE;
		self.textView.hidden = TRUE;
		self.backgroundImage.hidden = NO;
	   }
	
}
//==============================================================================
-(IBAction)beginOrderButtonPressed
{
	AboutLocationDetailViewController *infoAbout = [[AboutLocationDetailViewController alloc] 
													initWithNibName:@"AboutLocationdetailViewController"
													bundle:nil];
	[self.navigationController pushViewController: infoAbout 
										 animated:YES];
	[infoAbout release];
	
		
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
    [super dealloc];
}

//==============================================================================
@end
