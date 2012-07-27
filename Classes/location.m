#import "location.h"

@implementation location

@synthesize Address;
@synthesize CityName;
@synthesize State;
@synthesize PostalCode;
@synthesize Telephone;
@synthesize Description;
@synthesize latitude;
@synthesize longitude;



-(id)initWithObjects:(NSString *)_Address 
			cityName:(NSString *)_City
			   State:(NSString *)_State
		  postalCode:(NSString *)_PostalCode
		   telePhone:(NSString *)_telePhone
		 Description:(NSString *)_description
{
	NSLog(@"inside Init for location");
	self.Address = _Address;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.CityName = _City;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.State = _State;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.PostalCode = _PostalCode;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.Telephone = _telePhone;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.Description = _description;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.latitude = nil;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	self.longitude = nil;
	//NSLog(@"%s %d ", __FILE__, __LINE__);
	return self;
}







@end

