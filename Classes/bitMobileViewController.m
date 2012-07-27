#import "bitMobileViewController.h"

@implementation bitMobileViewController

@synthesize backgroundImage;
@synthesize scrollView;
@synthesize descriptionText;
@synthesize emailFeedback;
@synthesize backButton;

//FB Vars
@synthesize loginStatusLabel;
@synthesize faceBookLike;
@synthesize loginDialog;
@synthesize loginDialogView;

//=============================================================================//
- (void)viewWillAppear:(BOOL)animated 
{
    [self refresh];
}
//=============================================================================//
//FB features
- (void)refresh 
{
    if (loginState == LoginStateStartup || loginState == LoginStateLoggedOut) 
	{
        loginStatusLabel.text = @"Not connected to Facebook";
        //[_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        faceBookLike.hidden = NO;
    } 
	else if (loginState == LoginStateLoggingIn) 
	{
        loginStatusLabel.text = @"Connecting to Facebook...";
        faceBookLike.hidden = YES;
    } 
	else if (loginState == LoginStateLoggedIn) 
	{
        loginStatusLabel.text = @"Connected to Facebook";
        //[_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        faceBookLike.hidden = NO;
    }   
}

//=============================================================================//
-(IBAction)faceBookLikePressed:(id)sender
{
	NSLog(@"Facebook like button pressed");
	NSString *appId = @"191383214275573";
    NSString *permissions = @"publish_stream";
	
    if (loginDialog == nil) 
	{
        self.loginDialog = [[[FBLoginDialog alloc] initWithAppId:appId requestedPermissions:permissions delegate:self] autorelease];
        self.loginDialogView = loginDialog.view;
    }
	
    if (loginState == LoginStateStartup || loginState == LoginStateLoggedOut) 
	{
        loginState = LoginStateLoggingIn;
        [loginDialog login];
    } 
	else if (loginState == LoginStateLoggedIn) 
	{
        loginState = LoginStateLoggedOut;        
        [loginDialog logout];
    }
	
    [self refresh];

}
//=============================================================================//
- (void)accessTokenFound:(NSString *)accessToken 
{
    NSLog(@"Access token found: %@", accessToken);
    loginState = LoginStateLoggedIn;
    [self dismissModalViewControllerAnimated:YES];
    [self refresh];
}
//=============================================================================//
- (void)displayRequired 
{
    [self presentModalViewController:loginDialog animated:YES];
}
//=============================================================================//
- (void)closeTapped 
{
    [self dismissModalViewControllerAnimated:YES];
    loginState = LoginStateLoggedOut;        
    [loginDialog logout];
    [self refresh];
}
//=============================================================================//
-(IBAction)backButtonPressed
{
	[self dismissModalViewControllerAnimated:YES];
}

//=============================================================================//
-(IBAction)emailFeedbackButtonPressed;
{
	NSLog(@"Love to hear from you button pressed");
}
//=============================================================================//
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//=============================================================================//
- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//=============================================================================//
- (void)dealloc 
{
    [super dealloc];
}


@end
