#import <Foundation/Foundation.h>


@interface customerInfoModel : NSObject 
{
	NSMutableString *Name;
	NSMutableString *AptNo;
	NSMutableString *Street1;
	NSMutableString *Street2;
	NSMutableString *City;
	NSMutableString *Tel;
	NSMutableString *Email;
}

@property (nonatomic, retain) NSMutableString *Name;
@property (nonatomic, retain) NSMutableString *AptNo;
@property (nonatomic, retain) NSMutableString *Street1;
@property (nonatomic, retain) NSMutableString *Street2;
@property (nonatomic, retain) NSMutableString *City;
@property (nonatomic, retain) NSMutableString *Tel;
@property (nonatomic, retain) NSMutableString *Email;


-(id)initWithObjects:(NSString *)_name 
			   AptNo:(NSString *)_aptNo
			 Street1:(NSString *)_street1
			 Street2:(NSString *)_street2
				City:(NSString *)_city
				 Tel:(NSString*)_tel
			   Email:(NSString*)_email;



@end
