#import "DrinkItem.h"

@implementation DrinkItem

@synthesize drinkName;
@synthesize drinkDescription;
@synthesize drinkCalories;
@synthesize drinkPrice;
@synthesize pathToPhoto;
@synthesize drinkCategory;


-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			Calories:(NSString *)_calories
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_drinkCategory

{
	self.drinkName = _name;
	self.drinkDescription = _description;
	self.drinkCalories = _calories;
	self.drinkPrice = _price;
	self.pathToPhoto = _pathToPhoto;
	self.drinkCategory = _drinkCategory;
	return self;
}



@end
