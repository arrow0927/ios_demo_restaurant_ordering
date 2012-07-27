#import <UIKit/UIKit.h>
#import "SpecialsDetailViewController.h"
#import "customTableCell1.h"
#import "customCellProtocol.h"
#import "CartSingleton.h"
#import "AboutLocationViewController.h"
#import "SpecialsModel.h"
#import "SpecialsItem.h"

@interface SpecialsMViewController : UITableViewController <customCellAddButnClicked, UIAlertViewDelegate>
{
	NSDictionary *SpecialsDict;
	NSMutableArray *SpecialsCategoryArray;
	UITableView *Specialstable;
	
	SpecialsModel *specialsModel;
	SpecialsItem *selectedSpecialsItem;
	UIView *headerView;
}



@property(nonatomic, retain) NSDictionary *SpecialsDict;
@property (nonatomic, retain)  NSMutableArray *SpecialsCategoryArray;
@property (nonatomic, retain) IBOutlet UITableView *Specialstable;
@property (nonatomic, retain) NSString* ViewControllerIdentifier;

@property (nonatomic, retain) SpecialsModel *specialsModel;
@property (nonatomic, retain) SpecialsItem *selectedSpecialsItem;

-(void)EmptyCartButtonPressed;
-(void)RemoveLastButtonPressed;
@end
