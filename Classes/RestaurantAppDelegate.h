
#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "FoodMViewController.h"
#import "DrinksMViewController.h"
#import "SpecialsMViewController.h"

#import "myOrderSummary.h"


@interface RestaurantAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
    UIWindow *window;
    UITabBar *tabBar;
	UITabBarController *tabBarController;
	//Nav Controllers
	UINavigationController *AboutNavCon;
	UINavigationController *FoodMNavCon;
	UINavigationController *DrinksMNavCon;
	UINavigationController *SpecialsMNavCon;
	UINavigationController *MyOrderNavCon;
	//View Controllers
	AboutViewController *AboutViewCon;
	FoodMViewController *FoodMViewCon;
	DrinksMViewController *DrinksMViewCon;
	SpecialsMViewController *SpecialsMViewCon;
	
	myOrderSummary *myOrderSum;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UINavigationController *AboutNavCon;
@property (nonatomic, retain) IBOutlet UINavigationController *FoodMNavCon;
@property (nonatomic, retain) IBOutlet UINavigationController *DrinksMNavCon;
@property (nonatomic, retain) IBOutlet UINavigationController *SpecialsMNavCon;
@property (nonatomic, retain) IBOutlet UINavigationController *MyOrderNavCon;

@property (nonatomic, retain) IBOutlet AboutViewController *AboutViewCon;
@property (nonatomic, retain) IBOutlet FoodMViewController *FoodMViewCon;
@property (nonatomic, retain) IBOutlet DrinksMViewController *DrinksMViewCon;
@property (nonatomic, retain) IBOutlet SpecialsMViewController *SpecialsMViewCon;

@property (nonatomic, retain) IBOutlet myOrderSummary *myOrderSum;


@end
