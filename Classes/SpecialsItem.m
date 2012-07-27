#import "SpecialsItem.h"

@implementation SpecialsItem

@synthesize specialsName;
@synthesize specialsDescription;

@synthesize specialsPrice;
@synthesize specialsCategory;
@synthesize pathToPhoto;

-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_specialsCategory

{
	self.specialsName = _name;
	self.specialsDescription = _description;
	
	self.specialsPrice = _price;
	self.pathToPhoto = _pathToPhoto;
	self.specialsCategory = _specialsCategory;
	
	return self;
}


@end
