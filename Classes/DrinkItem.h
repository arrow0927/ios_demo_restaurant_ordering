#import <Foundation/Foundation.h>


@interface DrinkItem : NSObject 
{
	NSString *drinkName;
	NSString *drinkDescription;
	NSString *drinkCalories;
	NSString *drinkPrice;
	NSString *pathToPhoto;
	NSString *drinkCategory;
}
@property(nonatomic, retain)NSString *drinkName;
@property(nonatomic, retain)NSString *drinkDescription;
@property(nonatomic, retain)NSString *drinkCalories;
@property(nonatomic, retain)NSString *drinkPrice;
@property(nonatomic, retain)NSString *drinkCategory;
@property(nonatomic, retain)NSString *pathToPhoto;


-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			Calories:(NSString *)_calories
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_drinkCategory;


@end
