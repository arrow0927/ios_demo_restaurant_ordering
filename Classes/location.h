/*
 Each Table row will have a corresponding location dataObject
 A location data object will be created by the LocationModel Object
 */

#import <Foundation/Foundation.h>


@interface location : NSObject 
{
	
	NSString *Address;
	NSString *CityName;
	NSString *State;
	NSString *PostalCode;
	NSString *Telephone;
	NSString *Description;
	NSNumber *latitude;
	NSNumber *longitude;
	
}


@property(nonatomic, retain)  NSString *Address;
@property(nonatomic, retain)  NSString *CityName;
@property(nonatomic, retain)  NSString *State;
@property(nonatomic, retain)  NSString *PostalCode;
@property(nonatomic, retain)  NSString *Telephone;
@property(nonatomic, retain)  NSString *Description;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;


-(id)initWithObjects:(NSString *)_Address 
			cityName:(NSString *)_City
			   State:(NSString *)_State
		  postalCode:(NSString *)_PostalCode
		   telePhone:(NSString *)_telePhone
		 Description:(NSString *)_description;




@end
