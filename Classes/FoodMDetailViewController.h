#import <UIKit/UIKit.h>
#import "customCellProtocol.h"
#import "CartSingleton.h"

#import "SidesItem.h"
#import "SidesModel.h"
#import "FoodModel.h"

@interface FoodMDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, customCellAddButnClicked, UIAlertViewDelegate>
{
	IBOutlet UIImageView *itemImage;
	IBOutlet UITextView *itemDescription;
	IBOutlet UITableView *tableView;
	NSMutableDictionary *FoodSidesDict;
	NSMutableArray *FoodSidesSectionArray;
	
	SidesModel *_sideModel;
	SidesItem *_sidesItem;
	UIView *headerView;
}


@property (nonatomic, retain) IBOutlet UIImageView *itemImage;
@property (nonatomic, retain) IBOutlet UITextView *itemDescription;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *FoodSidesDict;
@property (nonatomic, retain) NSMutableArray *FoodSidesSectionArray;


@property (nonatomic, retain) SidesModel *_sideModel;
@property (nonatomic, retain) SidesItem *_sidesItem;


@end
