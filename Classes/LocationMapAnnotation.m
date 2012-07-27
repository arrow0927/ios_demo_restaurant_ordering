#import "LocationMapAnnotation.h"


@implementation LocationMapAnnotation
@synthesize coordinate;
@synthesize title, subtitle;

//==============================================================================
-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	if (self = [super init])
	   {
		coordinate = c;
	   }
	return self;
}
//==============================================================================
-(void)dealloc
{
	[self.title release];
	[self.subtitle release];
	[super dealloc];
}

@end