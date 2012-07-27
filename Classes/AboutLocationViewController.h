#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSXMLParser.h>
#import "LocationMapAnnotation.h"
#import "AboutLocationDetailViewController.h"
#import "customTableCell1.h"
#import "customCellProtocol.h"
#import "CartSingleton.h"
#import "locationModel.h"
#import "location.h"

@interface AboutLocationViewController : UIViewController <UITableViewDelegate, customCellAddButnClicked,
UITableViewDataSource, UIActionSheetDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
	IBOutlet UITableView *locTable;
	IBOutlet MKMapView *mapView;
	
	NSString* ViewControllerIdentifier;
	locationModel *locModel;
	UIView *headerView;
	NSIndexPath *selectedCellIndex;
	UISegmentedControl *AboutLocSeg;
	NSArray *mapAnnotations;
	CLLocationManager *locationManager;
	location *selectedMapLocation;
}

@property (nonatomic, retain) IBOutlet UITableView *locTable;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) UISegmentedControl *AboutLocSeg;
@property (nonatomic, retain) NSString* ViewControllerIdentifier;
@property (nonatomic, retain) locationModel *locModel;
@property (nonatomic, retain) NSIndexPath *selectedCellIndex;
@property (nonatomic, retain) NSArray *mapAnnotations;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) location *selectedMapLocation;

-(void)displayCoordinates;
-(void)ClearLocationButtonPressed:(id)sender;


@end
