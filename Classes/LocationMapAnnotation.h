#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationMapAnnotation : NSObject <MKAnnotation>
{
	NSString *title;
	NSString *subtitle;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end
