#import "AboutLocationDetailViewController.h"

@implementation AboutLocationDetailViewController

@synthesize detailtext;
@synthesize detailImage;
@synthesize doneButton;

//==============================================================================
- (void)viewDidLoad
{
	
	locationModel *detailDispLocMod = [locationModel getLocationModel];
	location *detailDispLoc = detailDispLocMod.detailDisplayLocation;
	self.detailtext.text = detailDispLoc.Description;
	
    [super viewDidLoad];
}
//==============================================================================
-(IBAction)doneButtonPressed
{
	[self dismissModalViewControllerAnimated:YES];
}

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

- (void)dealloc {
    [super dealloc];
}
//==============================================================================

@end
