#import <UIKit/UIKit.h>
#import "CartSingleton.h"
#import "MyOrderViewController.h"
#import "chargesSummaryCell.h"

#import "customCellProtocol.h"
#import "AboutViewController.h"
#import "SendOrderViewController.h"

@interface myOrderSummary : UIViewController <UITableViewDelegate, UITableViewDataSource, customCellAddButnClicked, UIActionSheetDelegate>
{
	IBOutlet UITableView *tableView;
	NSMutableArray *myOrderRows;
	IBOutlet UIButton *proceedToOrderDetails;
	NSIndexPath *selectedCellIndex;
	BOOL shouldBeEmpty;
	float federalTax;
	float cityTax;
	float provinceTax;
	SendOrderViewController *sendOrderVC;
	//float otherCharges;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *myOrderRows;
@property (nonatomic, retain) IBOutlet UIButton *proceedToOrderDetails;
@property (nonatomic, retain) NSIndexPath *selectedCellIndex;
@property (nonatomic, assign) BOOL shouldBeEmpty;
@property (nonatomic, assign) float federalTax;
@property (nonatomic, assign) float cityTax;
@property (nonatomic, assign) float provinceTax;
@property (nonatomic, retain) SendOrderViewController *sendOrderVC;






-(void) EmptyCartButtonPressed;
-(void)SendOrderButtonPressed;
@end
