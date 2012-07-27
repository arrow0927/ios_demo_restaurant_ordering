#import "FoodItem.h"


@implementation FoodItem
@synthesize foodName;
@synthesize foodDescription;
@synthesize foodCalories;
@synthesize foodPrice;
@synthesize pathToPhoto;
@synthesize sidesArray;
@synthesize foodCategory;
@synthesize serialNum;


-(id)initWithObjects:(NSString *)_name 
			Description:(NSString *)_description
		  Calories:(NSString *)_calories
		   Price:(NSString *)_price
		 photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_foodCategory
			
{
	self.foodName = _name;
	self.foodDescription = _description;
	self.foodCalories = _calories;
	self.foodPrice = _price;
	self.pathToPhoto = _pathToPhoto;
	self.foodCategory = _foodCategory;
	sidesArray = [[NSMutableArray alloc]initWithCapacity:0];
	
	return self;
}


@end
