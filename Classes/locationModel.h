/*
 Each Table row will have a corresponding location dataObject
 A location data object will be created by the LocationModel Object
 */

#import <Foundation/Foundation.h>
#import "location.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSXMLParser.h>
#import "LocationMapAnnotation.h"

@class location;

@interface locationModel : NSObject <NSXMLParserDelegate, CLLocationManagerDelegate>
{
	NSMutableArray *NamesOfCitiesDispOrder;
	NSMutableDictionary *dictOfDicts;
	
	
	NSString *PathToFileDocs;
	NSString *PathToFileBundle;
	NSMutableString *urlString;
	location *detailDisplayLocation;
	
	NSString *currentElement;  	
	NSMutableArray *mapAnnotations;
	
	NSString *characters;
	
	NSString *currLAT;
	NSString *currLONG;
	NSMutableString *addressReceived;
	NSMutableString *dataFromGoogle;
	CLLocationManager *locMgr;
	CLLocation *userLocation;
	
	//NSString *userLatitude;
	//NSString *userLongitude;
	
	CLLocation *defaultLocationIfError;
	CLLocationDistance shortestDistance;
	CLLocationDistance longestDistance;
	
	BOOL gotAllCoordinates;
	
}

@property (nonatomic, retain) NSMutableArray *NamesOfCitiesDispOrder;
@property (nonatomic, retain) NSMutableDictionary *dictOfDicts;
@property (nonatomic, retain) NSMutableString *urlString;
@property (nonatomic, retain) location *detailDisplayLocation;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, assign) BOOL gotAllCoordinates;
@property (nonatomic, assign) CLLocationDistance shortestDistance;
@property (nonatomic, assign) CLLocationDistance longestDistance;

//@property (nonatomic, retain) NSString *userLatitude;
//@property (nonatomic, retain) NSString *userLongitude;


@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain) CLLocation *defaultLocationIfError;

@property (nonatomic, retain) NSString *currentElement;

@property (nonatomic, retain) NSString *characters;
@property (nonatomic, retain) NSMutableString *dataFromGoogle;
@property (nonatomic, retain) NSString *currLAT;
@property (nonatomic, retain) NSString *currLONG;

+(locationModel *) getLocationModel;

-(NSInteger)getNumberOfCities;

-(NSInteger)getItemsInACityArrayForCityAtIndex:(NSInteger)section;

-(location*)getItemForIndexPath:(NSIndexPath *)indexPath;

-(NSString *)getHeaderForSection:(NSInteger)section;

-(void)updateLocationCoordinates;
- (id) initWithCoordinate:(CLLocationCoordinate2D) c;

-(void)initLocationManager;
-(void)calculateShortestDistanceBetweenUserAndBiz:(CLLocation *)_userLocation;
-(void)setDefaultLocation:(NSMutableArray*) mapAnnotationArray;
-(void)calculateDistanceToBeShownOnMap:(CLLocation *)_userLocation;

@end
