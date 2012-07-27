#import "FBLoginDialog.h"


@implementation FBLoginDialog
@synthesize webView;
@synthesize apiKey;
@synthesize requestedPermissions;
@synthesize delegate;

//=============================================================================//
- (id)initWithAppId:(NSString *)_apiKey requestedPermissions:(NSString *)_requestedPermissions 
										delegate:(id<FBLoginDialogDelegate>)_delegate 
{
    if ((self = [super initWithNibName:@"FBLoginDialog" bundle:[NSBundle mainBundle]])) 
	{
        self.apiKey = _apiKey;
        self.requestedPermissions = _requestedPermissions;
        self.delegate = _delegate;
    }
    return self;    
}
//=============================================================================//
- (void)login 
{
	
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
	
    NSString *urlString = [NSString stringWithFormat:authFormatString, apiKey, redirectUrlString, requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];	   
}

//=============================================================================//
-(void)logout 
{    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) 
	{
        [cookies deleteCookie:cookie];
    }
}
//=============================================================================//
-(void)checkForAccessToken:(NSString *)urlString 
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" 
								  options:0 error:&error];
    if (regex != nil) 
	   {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString 
											options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) 
		{
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [delegate accessTokenFound:accessToken];               
		}
    }
}
//=============================================================================//
-(void)checkLoginRequired:(NSString *)urlString 
{
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound) 
	{
        [delegate displayRequired];
    }
}
//=============================================================================//
- (IBAction)closeTapped:(id)sender 
{
    [delegate closeTapped];
}
//=============================================================================//
//UIWebview delegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
										navigationType:(UIWebViewNavigationType)navigationType 
{
	
    NSString *urlString = request.URL.absoluteString;
	
    [self checkForAccessToken:urlString];    
    [self checkLoginRequired:urlString];
	
    return TRUE;
}
//=============================================================================//
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
//=============================================================================//
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//=============================================================================//

- (void)dealloc {
    self.webView = nil;
    self.apiKey = nil;
    self.requestedPermissions = nil;
    [super dealloc];
}
@end