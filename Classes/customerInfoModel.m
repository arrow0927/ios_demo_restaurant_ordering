#import "customerInfoModel.h"

@implementation customerInfoModel

@synthesize Name;
@synthesize AptNo;
@synthesize Street1;
@synthesize Street2;
@synthesize City;
@synthesize Tel;
@synthesize Email;


-(id)initWithObjects:(NSMutableString *)_name 
		 AptNo:(NSMutableString *)_aptNo
			Street1:(NSMutableString *)_street1
			   Street2:(NSMutableString *)_street2
		   City:(NSMutableString *)_city
			Tel:(NSMutableString*)_tel
		Email:(NSMutableString*)_email
{
	self.Name = _name;
	self.AptNo = _aptNo;
	self.Street1 = _street1;
	self.Street2 = _street2;
	self.City = _city;
	self.Tel = _tel;
	self.Email = _email;
	return self;
}

-(void)dealloc
{
	[self.Name release];
	[self.AptNo release];
	[self.Street1 release];
	[self.Street2 release];
	[self.City release];
	[self.Tel release];
	[self.Email release];
	[super dealloc];
}



@end
