#import <Foundation/Foundation.h>
#import "SidesItem.h"

@interface FoodItem : NSObject 
{
	NSString *foodName;
	NSString *foodDescription;
	NSString *foodCalories;
	NSString *foodPrice;
	NSString *pathToPhoto;
	NSString *foodCategory;
	NSMutableArray *sidesArray;
	int serialNum;
	

}

@property(nonatomic, retain)NSString *foodName;
@property(nonatomic, retain)NSString *foodDescription;
@property(nonatomic, retain)NSString *foodCalories;
@property(nonatomic, retain)NSString *foodPrice;
@property(nonatomic, retain)NSString *foodCategory;
@property(nonatomic, retain)NSString *pathToPhoto;
@property(nonatomic, retain)NSMutableArray *sidesArray;
@property(nonatomic, assign) int serialNum;

-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			Calories:(NSString *)_calories
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_foodCategory;

@end
