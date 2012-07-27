#import <Foundation/Foundation.h>


@interface SpecialsItem : NSObject 
{
	NSString *specialsName;
	NSString *specialsDescription;
	
	NSString *specialsPrice;
	NSString *pathToPhoto;
	NSString *specialsCategory;

}


@property(nonatomic, retain)NSString *specialsName;
@property(nonatomic, retain)NSString *specialsDescription;

@property(nonatomic, retain)NSString *specialsPrice;
@property(nonatomic, retain)NSString *specialsCategory;
@property(nonatomic, retain)NSString *pathToPhoto;

-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_specialsCategory;



@end
