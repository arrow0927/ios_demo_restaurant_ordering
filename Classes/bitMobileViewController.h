#import <UIKit/UIKit.h>
#import "FBLoginDialog.h"

typedef enum 
{
    LoginStateStartup,
    LoginStateLoggingIn,
    LoginStateLoggedIn,
    LoginStateLoggedOut
} LoginState;


@interface bitMobileViewController : UIViewController <FBLoginDialogDelegate>
{
	IBOutlet UIImageView *backgroundImage;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UITextView *descriptionText;
	IBOutlet UIButton *emailFeedback;
	IBOutlet UIButton *backButton;
	
	//FB vars
	IBOutlet UILabel *loginStatusLabel;
    IBOutlet UIButton *faceBookLike;
    LoginState loginState;
    FBLoginDialog *loginDialog;
    IBOutlet UIView *loginDialogView;
	
}

@property(nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UITextView *descriptionText;
@property(nonatomic, retain) IBOutlet UIButton *emailFeedback;
@property(nonatomic, retain) IBOutlet UIButton *backButton;
//FB vars
@property (retain) IBOutlet UILabel *loginStatusLabel;
@property(nonatomic, retain) IBOutlet UIButton *faceBookLike;
@property (retain) FBLoginDialog *loginDialog;
@property (retain) IBOutlet UIView *loginDialogView;


-(IBAction)backButtonPressed;
-(IBAction)emailFeedbackButtonPressed;

//FB vars
-(IBAction)faceBookLikePressed:(id)sender;
- (void)refresh;
@end
