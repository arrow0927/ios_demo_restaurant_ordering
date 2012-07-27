
#import <Foundation/Foundation.h>

#import "location.h"
#import "FoodItem.h"
#import "DrinkItem.h"
#import "SpecialsItem.h"
#import "customerInfoModel.h"

@interface CartSingleton : NSObject 
{
	location *selectedLocation;
	NSMutableArray *foodItemsArray;
	NSMutableArray *drinkItemsArray;
	NSMutableArray *otherItemsArray;
	bool locationSelected;
	bool customerInfoObtained;
	int totalItemsInCart;
	customerInfoModel* customerInfo;
	int myOrderSummaryRow;	
	int numFoodItems;
	
	NSString *userLatitude;
	NSString *userLongitude;
	
	//Totals
	NSDictionary *taxDict;
	NSArray *taxDictKeys;
	float totalTaxPercent;
	float foodItemsTotalCost;
	float drinkItemsTotalCost;
	float otherItemTotalCost;
	float totalCostOfAllItems;
	float totalTaxesAmount;
	float totalChargesWithTaxes;
	float gratuity;
	float miscCharges;
	//serialization variables
	NSMutableDictionary *rootSerialDict;
	NSMutableDictionary *foodSerialDict; 
	NSMutableDictionary *drinkSerialDic;
	NSMutableDictionary *specialsSerialDic;
	NSMutableDictionary *customerInfoSerialDict;
	NSMutableDictionary *locationInfoSerialDict;
	NSMutableDictionary *miscItemSerialDict;
}

@property (nonatomic, retain) location *selectedLocation;
@property (nonatomic, retain) customerInfoModel* customerInfo;
@property (nonatomic, retain) NSMutableArray *foodItemsArray;
@property (nonatomic, retain) NSMutableArray *drinkItemsArray;
@property (nonatomic, retain) NSMutableArray *otherItemsArray;
@property (nonatomic, assign) int numFoodItems;

@property (nonatomic, assign) NSString *userLatitude;
@property (nonatomic, assign) NSString *userLongitude;

@property (nonatomic, assign) bool locationSelected;
@property (nonatomic, assign) bool customerInfoObtained;
@property (nonatomic, assign) int myOrderSummaryRow;
@property (nonatomic, retain) NSDictionary *taxDict;
@property (nonatomic, retain) NSArray *taxDictKeys;
@property (nonatomic, assign) float totalTaxPercent;
@property (nonatomic, assign) float foodItemsTotalCost;
@property (nonatomic, assign) float drinkItemsTotalCost;
@property (nonatomic, assign) float otherItemTotalCost;
@property (nonatomic, assign) float totalCostOfAllItems;
@property (nonatomic, assign) float totalTaxesAmount;
@property (nonatomic, assign) float totalChargesWithTaxes;
@property (nonatomic, assign) float gratuity;
@property (nonatomic, assign) float miscCharges;


@property (nonatomic, retain) NSMutableDictionary *rootSerialDict;
@property (nonatomic, retain) NSMutableDictionary *foodSerialDict;
@property (nonatomic, retain) NSMutableDictionary *drinkSerialDic;
@property (nonatomic, retain) NSMutableDictionary *specialsSerialDic;
@property (nonatomic, retain) NSMutableDictionary *customerInfoSerialDict;
@property (nonatomic, retain) NSMutableDictionary *locationInfoSerialDict;
@property (nonatomic, retain) NSMutableDictionary *miscItemSerialDict;

//==============================================================================

-(void)removeSelectedLocation;
-(int)getNumberOfItemsInCart;
//Interface Declaration of methods
+(CartSingleton *) getSingleton;

-(int)getNumberOfFoodItemsInCart;
-(int)getNumberOfDrinkItemsInCart;
-(int)getNumberOfOtherItemsInCart;

-(void)addFoodItemToCart:(FoodItem *)itm;
-(void)addDrinkItemToCart:(DrinkItem*) itm;
-(void)addSpecialsItemToCart:(SpecialsItem*) itm;
-(void)addLocation:(location *)loc;
-(void)addCustomerInfo:(customerInfoModel*)_info;
-(void)addGratuity:(float)_gratuity;
-(void)addMiscCharges:(float)_miscCharges;
-(void)calculateTaxPercents;

-(void)addCustomerLatitude:(NSString*)_lat;
-(NSString*)getCustomerLatitude;
-(void)addCustomerLongitude:(NSString*)_long;
-(NSString*)getCustomerLongitude;

-(float)getTotalAmountOfAllSidesForItemAtIndex:(NSInteger)_row;
-(float)getTotalCostOfFoodItemAtIndex:(NSInteger)_row;
-(float)getTotalCostOfAllFoodItems;
-(float)getTotalCostOfAllDrinkItems;
-(float)getTotalCostOfAllOtherItems;
-(void)printCart;
-(float)getTotalTaxPercent;
-(float)getTotalCostOfAllItems;
-(float)getTotalTaxAmountForAllItems;
-(float)getTotalChargesWithTaxes;
-(float)getTotalOtherCharges;
-(void)emptyCart;
-(void)ResetCartToNull;
-(void)serializeCart;

-(void)convertFoodArrayToDictionary;
-(void)convertDrinkArrayToDictionary;
-(void)convertSpecialsArrayToDictionary;
-(void)convertCustomerInfoToDictionary;
-(void)convertLocationInfoToDictionary;
-(void)createDictionaryOfMiscItems;
@end