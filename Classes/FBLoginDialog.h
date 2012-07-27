//Credit to: http://www.raywenderlich.com/1488/how-to-use-facebooks-new-graph-api-from-your-iphone-app

#import <UIKit/UIKit.h>

//FBLoginDialogueDelegate Protocol to be implemented by View Controller
@protocol FBLoginDialogDelegate
- (void)accessTokenFound:(NSString *)accessToken;
- (void)displayRequired;
- (void)closeTapped;
@end

//=============================================================================//
@interface FBLoginDialog : UIViewController <UIWebViewDelegate>
{
	IBOutlet UIWebView *webView;
    NSString *apiKey;
    NSString *requestedPermissions;
    id <FBLoginDialogDelegate> delegate;
}
	
@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *apiKey;
@property (copy) NSString *requestedPermissions;
@property (assign) id <FBLoginDialogDelegate> delegate;	


- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions 
		   delegate:(id<FBLoginDialogDelegate>)delegate;

- (IBAction)closeTapped:(id)sender;
- (void)login;
- (void)logout;

-(void)checkForAccessToken:(NSString *)urlString;
-(void)checkLoginRequired:(NSString *)urlString;



@end
