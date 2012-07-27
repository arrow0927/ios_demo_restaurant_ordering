#import "SidesItem.h"

@implementation SidesItem

@synthesize sideName;
@synthesize sideDescription;
@synthesize sideCalories;
@synthesize sidePrice;
@synthesize pathToPhoto;
@synthesize sideCategory;


-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			Calories:(NSString *)_calories
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_foodCategory

{
	self.sideName = _name;
	self.sideDescription = _description;
	self.sideCalories = _calories;
	self.sidePrice = _price;
	self.pathToPhoto = _pathToPhoto;
	self.sideCategory = _foodCategory;
	
	return self;
}



@end
