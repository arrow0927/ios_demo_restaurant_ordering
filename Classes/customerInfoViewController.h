#import <UIKit/UIKit.h>
#import "customerInfoModel.h"
#import "CartSingleton.h"
#import "incorrectTextViewController.h"

@interface customerInfoViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
	customerInfoModel* infoModel;
	IBOutlet UITextField *Name;
	IBOutlet UITextField *AptNum;
	IBOutlet UITextField *Street1;
	IBOutlet UITextField *Street2;
	IBOutlet UITextField *City;
	IBOutlet UITextField *Telephone;
	IBOutlet UITextField *Email1;
	IBOutlet UIButton *doneButton; 
	IBOutlet UIButton *ClearAllButton;
	IBOutlet UIButton *SaveAllButton;
	
	IBOutlet UIScrollView *scrollView;
	
	UITextField *textFieldBeingEdited;
	BOOL moveViewUp;
	CGFloat scrollAmount;
}

@property (nonatomic, retain) customerInfoModel* infoModel;
@property (nonatomic, retain) IBOutlet UITextField *Name;
@property (nonatomic, retain) IBOutlet UITextField *AptNum;
@property (nonatomic, retain) IBOutlet UITextField *Street1;
@property (nonatomic, retain) IBOutlet UITextField *Street2;
@property (nonatomic, retain) IBOutlet UITextField *City;
@property (nonatomic, retain) IBOutlet UITextField *Telephone;
@property (nonatomic, retain) IBOutlet UITextField *Email1;
@property (nonatomic, retain) IBOutlet UIButton *ClearAllButton;

@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *doneButton; 
@property (nonatomic, retain) IBOutlet UIButton *SaveAllButton;

-(IBAction)doneButtonPressed;

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
-(IBAction)textFieldDoneEditing:(id)sender;
-(void)scrollTheView:(BOOL)movedUp;
-(IBAction)ClearAllButtonPressed;
-(IBAction)saveAllButtonPressed;
-(IBAction)cancelAllButtonPressed;
@end
