#import <Foundation/Foundation.h>


@interface SidesItem : NSObject 
{
	NSString *sideName;
	NSString *sideDescription;
	NSString *sideCalories;
	NSString *sidePrice;
	NSString *pathToPhoto;
	NSString *sideCategory;

}

@property (nonatomic, retain) NSString *sideName;
@property (nonatomic, retain) NSString *sideDescription;
@property (nonatomic, retain) NSString *sideCalories;
@property (nonatomic, retain) NSString *sidePrice;
@property (nonatomic, retain) NSString *pathToPhoto;
@property (nonatomic, retain) NSString *sideCategory;

-(id)initWithObjects:(NSString *)_name 
		 Description:(NSString *)_description
			Calories:(NSString *)_calories
			   Price:(NSString *)_price
		   photoPath:(NSString *)_pathToPhoto
			Category:(NSString*)_foodCategory;


@end
