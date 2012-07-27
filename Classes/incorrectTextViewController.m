#import "incorrectTextViewController.h"
@implementation incorrectTextViewController
@synthesize nameLabel;
@synthesize aptLabel;
@synthesize streetLabel1;
@synthesize streetLabel2;
@synthesize cityLabel;
@synthesize telephoneLabel;
@synthesize emailLabel;

@synthesize nameTopRight;
@synthesize nameBottomRight;
@synthesize aptTopRight;
@synthesize aptBottomRight;
@synthesize street1TopRight;
@synthesize street1BottomRight;
@synthesize street2TopRight;
@synthesize street2BottomRight;
@synthesize cityTopRight;
@synthesize cityBottomRight;
@synthesize telTopRight;
@synthesize telBottomRight;
@synthesize emailTopRight;
@synthesize emailBottomRight;
@synthesize doneButton;

//==============================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
	 NSLog(@"Inside incorrectTextViewController");
        // Custom initialization.
    }
    return self;
}

//==============================================================================

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	/*
	self.nameLabel.textColor = [UIColor whiteColor];
	self.aptLabel.textColor = [UIColor whiteColor];
	self.streetLabel1.textColor = [UIColor whiteColor];
	self.streetLabel2.textColor = [UIColor whiteColor];
	self.cityLabel.textColor = [UIColor whiteColor];
	self.telephoneLabel.textColor = [UIColor whiteColor];
	self.emailLabel.textColor = [UIColor whiteColor];
	 */
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
-(void)doneButtonPressed
{
	NSLog(@"dismissing incorrectTextVieewController");
	[self dismissModalViewControllerAnimated:YES];
	
}
//==============================================================================
-(void)processtextFieldStatusArray:(NSMutableArray*)UITextFieldInValidity
{
	NSMutableArray *_validArray = UITextFieldInValidity;
	NSLog(@"Entered ProcessFieldStatusArray method ");
	
	for(int i = 0; i< [_validArray count]; i++)
	   {
		NSLog(@"Array Index = %i", i);
		NSLog(@"Text Value Flag = %@", [_validArray objectAtIndex:i]);
	   }
	
	
	int len = [_validArray count];
	NSLog(@"TextField validity array is %d long", len);
	
	for (int i = 0; i< len; i++)
	   {
		switch (i)
		  {
			  case 0: //Name
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"Alert Message: Name has errors");
				  self.nameLabel.textColor = [UIColor redColor];
				  self.nameTopRight.textColor = [UIColor redColor];
				  self.nameBottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			  case 1: //AptNum
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"UIAlert Message: AptNum has errors");
				  self.aptTopRight.textColor = [UIColor redColor];
				  self.aptBottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			  case 2: //Street1
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"UIAlert Message: Street 1 has errors");
				  self.street1TopRight.textColor = [UIColor redColor];
				  self.street1BottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			  case 3: //Street2
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"UIAlert Message: Street 2 has errors");
				  self.street2TopRight.textColor = [UIColor redColor];
				  self.street2BottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			  case 4: //City
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"UIAlert Message: City has errors");
				  self.cityTopRight.textColor = [UIColor redColor];
				  self.cityBottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			  case 5: //Telephone
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"UIAlert Message: Tel has errors");
				  self.telTopRight.textColor = [UIColor redColor];
				  self.telBottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			  case 6: //Email
			 {
			  if([_validArray objectAtIndex:i] == [NSNumber numberWithBool:TRUE])
				 {
				  NSLog(@"UIAlert Message: Email has errors");
				  self.emailTopRight.textColor = [UIColor redColor];
				  self.emailBottomRight.textColor = [UIColor redColor];
				 }
			  break;
			 }
			   
			  default:
			   break;
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
    [super dealloc];
}


@end
