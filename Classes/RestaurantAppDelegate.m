#import "RestaurantAppDelegate.h"
@implementation RestaurantAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize tabBar;
@synthesize AboutNavCon;
@synthesize FoodMNavCon;
@synthesize DrinksMNavCon;
@synthesize SpecialsMNavCon;
@synthesize MyOrderNavCon;

@synthesize AboutViewCon;
@synthesize FoodMViewCon;
@synthesize DrinksMViewCon;
@synthesize SpecialsMViewCon;

@synthesize myOrderSum;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    //TO DO after application launch:
	//1) Check the version number of this app's files with the version numbers online
	//If the version numbers are not the same throw a modalview to the user
	//app cannot be used until all the datasources are updated
	
	
	// Override point for customization after application launch.
	AboutViewCon = [[AboutViewController alloc] initWithNibName:@"AboutViewController"
														 bundle:nil];
	FoodMViewCon = [[FoodMViewController alloc] initWithNibName:@"FoodMViewController"
														 bundle:nil];
	DrinksMViewCon = [[DrinksMViewController alloc] initWithNibName:@"DrinksMViewController"
															 bundle:nil];
	SpecialsMViewCon = [[SpecialsMViewController alloc] initWithNibName:@"SpecialsMViewController"
																 bundle:nil];
	
	myOrderSum = [[myOrderSummary alloc] initWithNibName:@"myOrderSummary"
													  bundle:nil];
	
	/*
	locationModel *loc = [locationModel getLocationModel];
	//update coordinates inside a new thread
	
	[NSThread detachNewThreadSelector:@selector(updateLocationCoordinates) 
							 toTarget:loc 
						   withObject:nil];
	*/
	// Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController 
{
	if ([viewController isMemberOfClass:MyOrderViewController])
	{
		 
	}
}

*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

